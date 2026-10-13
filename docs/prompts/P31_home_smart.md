Act as a senior Flutter engineer + senior product designer on Vireo (branch ux-v2). The owner tested build feat(engage) on a real phone this morning. Screenshots are in docs/refs/p31_home_now.jpg, p31_score_sheet_now.jpg and p31_meal_review_now.jpg. Open them first. Fix everything below for real and verify it in code. No stubs. Never wait more than 3 minutes on a hanging command. Do NOT read pub-cache source files; fix from analyzer errors.

## 1. STEP START/PAUSE BUTTON SOMETIMES FREEZES (bug, highest priority)
Root-cause it in premium_steps_hero_card.dart, step_foreground_service.dart and live_steps_provider.dart. Likely causes:
- `await StepForegroundService.toggle()` blocks the UI;
- double taps start or stop twice;
- `isStepCounterRunningProvider` is a StateProvider that drifts from the real service state.

Fix:
- Make the running state a Notifier that is the single source of truth. Initialize it from `FlutterForegroundTask.isRunningService`, and resync it on app resume and on every `sendDataToMain` message.
- Update the UI optimistically on tap, with a 600 ms debounce or lock (ignore taps while a toggle is in flight). Show a small progress ring inside the button while it is switching. Roll the state back with a friendly Arabic SnackBar if the toggle fails.
- Start and stop must never block the main isolate. Use timeouts of 5 s on the service calls.
- Make the button distinctive without hurting the layout. Keep it the same size, but:
  - when running: a filled teal circle with a pulsing ring animation and the label "شغّال";
  - when paused: an outlined circle with ▶ and the label "ابدأ".
  - Add haptics.
- Also fix two things on the same card:
  - the "الوقت" stat shows "0س 0د" while steps are counted. Compute active minutes from step cadence (≈100 steps ≈ 1 active minute) or from the service runtime.
  - the 7 day circles are all empty. Fill each with that day's progress ring and a ⭐ when the goal is reached, and localize the day letters (س ح ن ث ر خ ج in Arabic).
- Add a unit or widget test that rapid double-taps the button: it must end in one consistent state with no exception.

## 2. HOME ORDER AND THE MEAL CAPTURE CARD
The owner can't find meal capture on Home. Make it a first-class, beautiful card.

New Home order, top to bottom:
1. Steps hero (existing, fixed above).
2. **Meal capture card ("سجّل وجبتك")**, full width:
   - an ember-orange gradient card about 140 dp tall, with a big camera icon in a soft circle, the title "صوّر وجبتك" and the subtitle "تحليل في ثواني • سعرات وبروتين";
   - a row of 4 quick chips: 📷 تصوير · 🖼 الاستوديو · ✍️ اكتب · 🔎 باركود. Each opens the existing capture flow directly in that mode;
   - under it, today's last logged meal as a mini row (thumbnail · name · kcal), or, if none, "لسه ما سجلتش فطارك" using the time-based meal type;
   - this replaces the small or hidden scanner tile. Remove duplicates.
3. **Daily Score, redesigned** (section 3).
4. "اليوم" grid (water, sleep, weight, workout). Fix the empty cards in the screenshot: they must show values and progress and never render empty.

## 3. DAILY SCORE: BIGGER, ORGANIZED, SMART
Replace the current small score card and the plain list sheet.

**Home card** (full width, about 260 dp):
- Left: a big score ring, 120 dp, with the score number in large bold type, "/100", and a colored state label (ممتاز / كويس / محتاج اهتمام).
- Right or below: a 2×2 grid of **"what you still need today" rectangles**. Each one is a rounded rectangle with an icon, a label, a big remaining value and a thin progress bar:
  - بروتين: "باقي 113 جم"
  - كارب: "باقي 140 جم"
  - دهون: "باقي 35 جم"
  - سعرات: "باقي 1,250"
  - Optional fifth chip under the grid: مية "باقي 6 أكواب".
  - When a target is reached, the rectangle shows ✓ "تمام". If one is exceeded, show it in amber: "زيادة 20 جم".
- One smart insight line at the bottom, generated from the data, e.g. "لو مشيت 3,000 خطوة كمان وأكلت 40 جم بروتين هتوصل 75/100".
- Tap opens the Score & Insights screen.

**Score & Insights screen** (replaces the bottom sheet):
1. The header ring, plus a breakdown with a colored bar for each component: steps 25, protein 20, kcal balance 15, water 15, workout 15, sleep 10. Each row has its points and a one-line "how to get more".
2. **Charts** (fl_chart, already in the project; keep the existing style tokens):
   - 7-day score trend line;
   - 7-day energy balance bars: eaten vs burned (BMR+activity) per day, with a deficit or surplus label;
   - macros today: a stacked bar of target vs eaten for P/C/F.
3. **Smart predictions ("توقعات ذكية")**, honest and labeled "تقديري":
   - fat lost this week ≈ Σ(daily deficit) / 7700 kg, shown in grams;
   - projected weight in 2/4/8 weeks: current weight − (average 7-day deficit × days / 7700). Draw a line chart from the user's logged weights plus the dotted projection;
   - "هتوصل لهدفك في ≈ X أسبوع" when a goal weight exists;
   - TDEE = BMR (Mifflin-St Jeor from the profile) + activity kcal from steps/workouts. Show the formula in an "إزاي حسبناها" expandable.
   - Guard against nonsense: fewer than 3 days of data → show "محتاجين 3 أيام بيانات عشان التوقع يبقى دقيق". Clamp the projected loss to ≤1% of body weight per week, and show a safety note if the deficit is greater than 1000 kcal/day.
4. Tips list (the existing one), rewritten as tappable action rows (e.g. "سجّل وجبة بروتين" opens capture, "ابدأ مشي" starts the counter).
- Put all prediction math in a pure Dart class `lib/features/insights/domain/energy_projection.dart` with unit tests (deficit → fat grams, the projection, the clamp, the low-data guard).

## 4. MEAL REVIEW SMALL FIXES (see p31_meal_review_now.jpg)
- The photo shows only rice and grilled chicken, but the AI added "بط مطبوخ 60 جم". Tighten the analyze-meal prompt: list only foods clearly visible; for each item return a confidence 0–1. The client hides items with confidence < 0.5 behind a "ممكن يكون فيه كمان؟" suggestion row instead of adding them. Redeploy with `npx supabase functions deploy analyze-meal --use-api`.
- Show the photo carousel inside the top summary card (a small thumbnail on the left of the title), not as a separate floating block, so the layout is tighter.
- Make the title not truncate awkwardly: use 2 lines max, then ellipsis.

## 5. VERIFY & DELIVER
- Run `flutter gen-l10n` (all new strings in all 10 ARB files, Egyptian dialect in ar_EG).
- Run `flutter analyze` (0 errors).
- Run the new tests plus test/audit with `--timeout 2m`, adding Home and Score & Insights to the audit overflow tests at 360×640 ar_EG with textScale 1.3.
- Run `flutter build apk --debug`. It MUST finish; poll it, do not kill it.
- Write docs/P31_CHANGES.md with file paths per item.
- `git add -A && git commit -m "feat(home): smart score & insights, meal capture card, reliable step toggle"`. Do not push.
