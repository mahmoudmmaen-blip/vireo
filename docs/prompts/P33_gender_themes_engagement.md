Act as a senior Flutter engineer + senior product designer on Vireo (branch ux-v2). Start only after P32 is committed. Work autonomously. No stubs. Never wait more than 3 minutes on a hanging command. Do NOT read pub-cache files.

Goal: Vireo becomes great for BOTH men and women, with optional themes and stickier daily engagement. Reference: Viwell app (dark charcoal + warm gold, white pill buttons, pastel pillar icons, "لماذا نسأل" boxes, ruler pickers, daily journey with points).

## 1. SEX-AWARE EXPERIENCE (uses the sex already chosen in onboarding; editable in Settings)
**Shared for everyone:** weight loss / fitness / general health stays the core.

**Men module ("صحة الرجل"):** a Home card + section in Insights. Habits that support healthy testosterone and vitality:
- sleep 7–9 h;
- resistance training 3×/week;
- waist/body-fat trend;
- protein, zinc and vitamin D foods from our food DB;
- sun exposure;
- alcohol/smoking-free days (optional).

Show a weekly "vitality habits" score. Wording is coaching only: no medical claims, no "boosts testosterone by X%", no supplements selling. Add a disclaimer line.

**Women module ("صحتك"):**
- **Optional cycle tracking.** Log period start/end, cycle length and symptoms, and predict the next period and the current phase (menstrual / follicular / ovulatory / luteal).
- **Phase-aware tips.** Luteal phase: appetite +100–300 kcal is normal, so show a softer message instead of "over budget". Menstrual phase: lighter workouts suggested, plus iron-rich foods. Scale weight fluctuations during the luteal/period phases are flagged as "احتباس سوائل طبيعي" so a jump doesn't discourage the user.
- **Pregnancy / breastfeeding mode** (toggle). Disable all calorie deficits and weight-loss predictions. Breastfeeding: +330–400 kcal. Pregnancy: trimester-based guidance. Safety notes: "استشيري طبيبتك".
- **Nutrients to watch:** iron, calcium and folate chips, using food DB suggestions.
- **Privacy:** cycle data is stored locally only (encrypted Hive box) and is never synced, unless the user explicitly opts in. No ads targeting. Add a "امسحي بيانات الدورة" button. Update docs/RELEASE.md with the Play Data-safety note for "Health info – menstrual" in case sync is ever enabled.

**Copy:** all strings are gender-aware in Arabic (Egyptian feminine forms for women: "سجّلي، ابدئي، هدفك"…). Use ICU select in the ARB files on the user's sex. Update every place that currently says "يا بطل" / male-only copy so it says "يا بطلة" for women. Grep for masculine imperative strings and convert them.

**Ads:** keep the strict G-rated filter for everyone (no change).

## 2. THEMES (Settings → المظهر)
Add 4 themes built on one token system (VireoColors). Each theme needs a dark and a light variant:
1. **Ember** (current orange). Default for men.
2. **Calm Gold**: charcoal background, warm gold/olive accents, white pill primary buttons, pastel pillar icons (Viwell-like but our own). Default for women.
3. **Ocean**: deep navy + teal.
4. **Rose**: soft plum + rose. A refined look, not childish.

The user can change themes anytime, with a live preview. Persist the choice in Hive. Pillar accent colors stay consistent within a theme. Make sure all screens use tokens (no hard-coded colors). Grep and fix them.

## 3. ONBOARDING POLISH
- Add a **"ليه بنسأل؟"** small info box under each onboarding question explaining why we need it (weight → calorie targets, etc.).
- **Ruler / wheel pickers** for weight (kg/lb), height (cm/ft) and goal weight, with haptic ticks, instead of text fields.
- A **"عايز تركز على إيه؟"** step with goal chips (multi-select, max 3):
  - خسارة دهون
  - بناء عضل
  - لياقة
  - نوم أفضل
  - أكل صحي
  - طاقة أعلى
  - صحة الرجل / صحتك

  These chips weight the Today Plan and the tips.

## 4. ENGAGEMENT: DAILY JOURNEY + COINS
- Today Plan becomes a "رحلة اليوم" with numbered steps. Each task shows points:
  - log a meal: +10
  - walk goal: +25
  - water: +5
  - workout: +25
  - weigh-in: +5
  - mood check: +5
- Coins accumulate. 500 coins unlock 1 day of Pro (local grant, using the same mechanism as the rewarded-ad unlocks). Show a coin counter in the Home header (replace the current flame chip, or put it next to it).
- Daily streak continues.
- Anti-abuse: each task awards points once per day. Points are stored locally and synced if logged in.

## 5. PAYWALL CLARITY
On the paywall, add a clear "التجربة المجانية تشمل / لا تشمل" box. Show the trial length and the exact renewal price per period with local currency, plus "تقدر تلغي في أي وقت". This matches Play policy and reduces refunds.

## 6. VERIFY & DELIVER
- Run `flutter gen-l10n` (10 locales; feminine/masculine selects in ar and ar_EG).
- Run `flutter analyze` (0 errors).
- Unit tests:
  - cycle phase prediction (regular and irregular);
  - pregnancy mode disables the deficit;
  - luteal message logic;
  - the coins award-once-per-day rule;
  - the theme token switch.
- Audit overflow tests: the women module, the men module, the paywall, onboarding pickers, and the Home screen in Calm Gold light and dark, all at 360×640 ar_EG with textScale 1.3.
- Run `flutter build apk --debug`. Poll until done.
- Write docs/P33_CHANGES.md.
- `git add -A && git commit -m "feat(personal): men & women modules, themes, onboarding pickers, daily journey coins"`. Do not push.
