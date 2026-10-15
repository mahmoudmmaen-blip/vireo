Act as a senior Flutter + Supabase engineer and a sports-nutrition scientist on Vireo (branch ux-v2). Start after P36 is committed. Work autonomously. No stubs. Never wait more than 3 minutes on a hanging command. Do NOT read pub-cache files. Never push. Never put API keys in the app: all AI calls go through Supabase Edge Functions with server secrets.

Goal: Vireo should be the smartest, most accurate calorie/steps/fitness coach on the market. It adapts to what the user ACTUALLY does, not to the plan.
Principle: **deterministic science first** (formulas, rules, user data); the LLM is used only to explain, phrase and chat, never to invent numbers.

## 1. ACTIVITY ACCURACY (walking & running)

### 1.1 Steps
- Fuse the phone step sensor and Health Connect.
  - De-duplicate by time window.
  - Prefer the source with the most complete coverage per hour.
  - Never double count.
  - Show the source.

### 1.2 Distance
Personal stride length:
- **Default.** Height × 0.415 (men) / 0.413 (women) for walking; ×0.65 for running cadence > 140 spm.
- **Auto-calibration.** During any GPS outdoor walk/run of 500 m or more with good accuracy (< 20 m), learn the stride = GPS distance / steps. Use the EMA of the last 5 calibrations, clamped to 0.5–1.3 m.
- Show "مُعايَر على مشيك ✓" once calibrated.

### 1.3 Activity calories: NET, not gross
- **Walking:** ACSM walking equation, VO2 = 0.1·speed(m/min) + 1.8·speed·grade + 3.5. Net = (VO2 − 3.5) × kg / 200 per minute.
- **Running:** ACSM running equation, VO2 = 0.2·speed + 0.9·speed·grade + 3.5.
- **Grade** comes from GPS altitude, smoothed; use grade 0 if the signal is noisy.
- **Steps without GPS:** speed = cadence × stride. If cadence is unknown, fall back to a net kcal/step from the body weight (≈ 0.0005 × kg × stride_m × 1000 / 1.0, validated against ACSM within ±10%).
- **Heart rate** (Health Connect), when present for the session: use the Keytel 2005 HR equation (sex/age/weight). Blend 70% HR / 30% ACSM, and flag the source.
- **Workouts:** use MET values from the 2024 Compendium of Physical Activities, net (MET − 1).
- **NEVER add BMR again.** The daily budget = adaptive TDEE baseline (section 2) + net exercise beyond the baseline activity level. This avoids the classic double-counting that inflates "eat-back" calories.
- **Eat-back policy** (setting):
  - default 50% of the logged net exercise kcal;
  - 100% if the goal is maintain/gain;
  - 0% if the user chooses.

### 1.4 Run/walk session screen
- Live pace, distance, net kcal and cadence. Splits per km.
- **Auto-pause** when speed < 0.5 m/s for 10 s.
- **GPS filter:** drop points with accuracy > 25 m or implied speed > 7 m/s (walk) / 12 m/s (run). Smooth with a Kalman or EMA filter.

## 2. ADAPTIVE TDEE ENGINE (the core differentiator)
- Each day, compute: intake (logged), trend weight, and the expected change.
- **Trend weight:** EMA with alpha 0.1 on the daily weigh-ins. Handle missing days. Ignore single-day spikes > 1.5 kg as water. If the cycle module is on: down-weight luteal/period days (P33).
- **Observed TDEE** over a rolling 14–21-day window:
  - TDEE = avg_intake − (Δtrend_weight_kg × 7700 / days).
  - Use it only if ≥ 10 logged days, ≥ 4 weigh-ins and logging completeness ≥ 70%. Otherwise use the formula TDEE (Mifflin-St Jeor, or Katch-McArdle when body-fat is known from InBody/Navy tape).
- **Blend:** TDEE_final = w·observed + (1−w)·formula, with w rising from 0 → 0.8 as the data quality rises.
- **Change limits:** at most ±150 kcal/week. Never below the safety floors (women 1200, men 1500; none in pregnancy or under 18; ≤ 1% bodyweight/week loss).
- **Weekly check-in:** show "خطتك اتعدلت: 2,157 ← 2,080 لأن وزنك نزل أبطأ من المتوقع", with an explanation and an undo.
- **Unit tests:** synthetic users (perfect logger, under-logger, water spikes, missing days, cycle) must converge to the true TDEE within ±5% in 21 days.

## 3. REAL-TIME REBALANCING (the user won't follow the plan 100%)
A deterministic **Rebalance engine**. It runs after every log and at 6 PM / 9 PM.

### 3.1 Over budget today (surplus S)
- **If S ≤ 150:** "عادي — يومك لسه في الأمان".
- **Otherwise offer up to 3 options** (the user picks one; nothing changes automatically):
  - (a) **Walk it off:** minutes of brisk walking needed, computed from the user's weight and stride (net kcal, section 1.3). Example: "مشي 35 دقيقة ≈ 4,200 خطوة يعوّض 180 سعرة". Add it to the plan/steps goal.
  - (b) **Spread it:** reduce the next 2–3 days by S/2 or S/3. Each day ≤ 250 kcal less, never below the floor. Show the new targets.
  - (c) **Lighter next meal:** concrete swaps from the food DB and P32b suggestions, using household measures.
- **Huge surplus** (> 1000, e.g. a wedding or Eid): "يوم استثنائي — استمتع، وبكرة نكمّل عادي 💪". Spread at most 500 over a week, and never shame. Adherence ≠ perfection. COPY RULE: never use words like عقاب/عقوبة/غلطت/فشلت/ذنب anywhere in the app; always positive, forward-looking wording (add a unit test that greps all ARB files for these words).

### 3.2 Under budget (deficit too large, D > 400 by 8 PM)
- Suggest a protein-first snack to close the gap. Warn if the user has done 3+ days below 80% of the target ("الحرمان بيبطّأ الحرق ويضيّع العضل").
- If the protein is below 70% of the target by 6 PM, show a protein-gap card with 2 quick options.

### 3.3 Steps behind
- At 5 PM, if steps < 50% of the goal: "فاضلك 3,800 خطوة ≈ 30 دقيقة مشي — تمشي بعد العصر؟" with a reminder action.
- In Ramadan, the time windows shift (after iftar/taraweeh).

### 3.4 Weekly view
- A "ميزان الأسبوع" chart: daily surplus/deficit bars + cumulative line. Show whether the week is still on track ("لسه في الهدف: عجز أسبوعي 3,200 من 3,500").

### 3.5 Tests
- Surplus/deficit thresholds, floors respected, spreading math, walking minutes from weight/stride, Ramadan windows, and no auto-change without the user's tap.

## 4. SMART FOLLOW-UP (proactive, not annoying)
- **Patterns detector** (local, deterministic):
  - weekend overeating;
  - late-night snacking;
  - low protein at breakfast;
  - step dips on workdays;
  - logging gaps.
  
  Each pattern: detect from ≥ 2 weeks of data, show one insight card per day max, and give one concrete fix + an "اعملها تذكير" action.
- **Notifications budget:** max 3/day, quiet hours, adaptive (stop a type the user ignores 3×).
- **Plateau detection:** trend weight flat 14+ days with adherence ≥ 80% → offer:
  - a diet break; or
  - −100 kcal; or
  - +2k steps.
  
  Explain why.


## 4b. CUMULATIVE ENERGY LEDGER ("رصيد حرقك")
- Track, from the install date, the totals for today, this week, this month and all-time:
  - **Burned (net activity):** walking, running and workouts, net kcal (section 1.3).
  - **Energy balance:** intake vs. the adaptive TDEE (section 2). Cumulative deficit/surplus in kcal and the **fat equivalent in kg** (kcal / 7700, 2 decimals, "≈").
  - **Distance and steps totals.**
- **Incremental and cumulative:** keep a running ledger table (local Hive + sync), updated after every log and session. Never recompute history from scratch on the UI thread. Do a nightly reconcile job that fixes edits and deletions.
- **UI:** a "رصيد حرقك" card on Insights, with tabs اليوم / الأسبوع / الشهر / من أول يوم:
  - big numbers: "حرقت 48,300 سعرة ≈ 6.3 كجم دهون من أول يوم";
  - a sparkline per period;
  - milestones every 10,000 kcal ("وصلت 1 كجم دهون محروقة 🎉"), with coins (P33).
- **Honesty:** label activity kcal and the balance-based fat estimate separately, plus a small "تقديري" note. Never claim weight loss that the trend weight doesn't show; if they diverge, explain (water, logging gaps).
- Tests: incremental vs. full recompute equality, edits/deletes reconcile, timezone/midnight boundaries, Ramadan days.

## 4c. "بصمتك" — PERSONAL CAPACITY PROFILE (the hyper-personal system)
Name the system **"بصمتك — نظام Vireo الذكي"** (EN: "Vireo Fingerprint"). After 14 days of data (with confidence shown), learn the user's real profile and build the plan around it, not around averages.

### Activity capacity
- Comfortable daily steps: the median of the best 70% of days.
- Peak capacity: the 90th-percentile day.
- Usual walking windows: the hours with the most steps.
- Typical pace/cadence, and the longest continuous walk.

**Use:** the step goal = comfortable + 10%, progressive (+500/week max, never above peak + 15%). Reminders fall in their real windows.

### Nutrition profile
- Typical meal times and meal count.
- Calorie distribution per meal.
- Protein habits.
- Favorite foods: the top 20 logged.
- Hard days: the weekday with the most surplus.
- Real adherence range: the days within ±10% of the target.

**Use:**
- Build the target per meal from their real pattern (e.g. a big lunch, a small dinner).
- Suggestions come from THEIR favorite foods first.
- Pre-plan a +300 buffer on their known hard day, balanced across the week.

### Tolerance
- Learn the deficit size the user actually sustains without bingeing: rebound days after a big deficit.
- Cap the plan's deficit at that level (within the safety floors).

### Chronotype & consistency
- Logging time patterns and sleep (if available) set the notification timing.

### UI
- A "بصمتك" screen with 4 cards (نشاطك، أكلك، تحمّلك، مواعيدك). Each has the learned value, a confidence bar, and "عدّلها" for manual override.
- A weekly "بصمتك اتحدثت" summary.

### Rules
- All learned values are local-first, explainable ("ليه؟"), and resettable.
- Use no cycle data unless the module is on.

### Tests
Synthetic users (a sedentary person, an active walker, a weekend overeater, a shift worker) produce sensible, bounded profiles and goals.

## 5. AI LAYER (premium reasoning)
- Support BOTH providers (owner may set either or both secrets: GEMINI_API_KEY, ANTHROPIC_API_KEY). Health-check endpoint reports which are active (never the key values).
- Add a model router in supabase/functions/_shared/ai-router.ts:
  - vision (meal/body reports) stays on Gemini;
  - coach chat, the weekly review narrative and the rebalance explanation use **Anthropic Claude via the API** when the secret ANTHROPIC_API_KEY is set (model from env CLAUDE_MODEL), else fall back to Gemini.
  - The owner adds the key himself in Supabase secrets. Do NOT add or print any key.
- **The LLM receives ONLY computed numbers + a minimal context** (no names/emails; cycle data only if the user opted in), and must not invent numbers. Validate its output: any number in the reply must match the provided facts, else fall back to the template text.
- **Weekly review** (Pro): a 5-bullet Egyptian Arabic summary with the TDEE change, the best/worst day, one pattern, and next week's 1 focus. Free users get the template version.
- **Cost guard:** cache per user per week; coach_chat quota already exists; log tokens.

## 6. VERIFY & DELIVER
- Run `flutter gen-l10n` (10 locales) and `flutter analyze` (0 errors).
- Unit tests for every formula. Keep a table in docs/SCIENCE.md with each formula, its source (ACSM Guidelines, Keytel 2005, Compendium 2024, Mifflin-St Jeor, Katch-McArdle), and its test.
- Simulation tests for the adaptive TDEE (section 2) and the rebalance engine (section 3).
- Audit tests: rebalance card, weekly balance chart, run screen at 360×640 ar_EG with textScale 1.3, each with `--timeout 2m`, using pump(Duration). Bound any hanging tearDownAll.
- Deploy the changed edge functions.
- Run `flutter build apk --debug`. Poll until done.
- Write docs/P38_CHANGES.md and docs/SCIENCE.md (plain Arabic summary at the top; this becomes store/marketing material).
- `git add -A && git commit -m "feat(coach): adaptive TDEE, real-time rebalancing, accurate walk/run energy, smart follow-up"`. Do not push.
