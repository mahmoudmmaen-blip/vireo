Act as a Senior Flutter engineer + product designer on Vireo (branch ux-v2). The owner tested build fix(device) on a real Android phone (ar_EG locale). Fix everything below for real. Read the relevant files under lib/features/** first. Work autonomously.

1. MEAL SCAN — let the user choose the source. Today, tapping scan opens the camera directly.
   - Show a bottom sheet with: "صوّر بالكاميرا" (ImagePicker camera), "اختار من الاستوديو" (ImagePicker gallery), and the existing "اكتب الأكل" text option if it exists.
   - Apply this everywhere a meal or fridge photo is taken (meal scan, fridge scan, body report upload where relevant).
   - Localize all 10 locales.

2. MONTHLY CHECK-IN ("متابعة شهرية") opens EVERY time the app comes back from background. That's wrong.
   - Show it at most once per 30 days after the last completed check-in.
   - "لاحقاً" snoozes it for 3 days.
   - Never show it during the first 7 days after onboarding.
   - Persist the dates in Hive.
   - Remove any resume/lifecycle trigger that pushes it.
   - Add unit tests for the scheduling rule.

3. TODAY PLAN (خطة اليوم) is unusable. It shows 13 separate "تذكير ماء X من 13" rows, items can't be completed, and some rows are English ("Quality sleep", "Morning light", "Hit protein" with broken text "teinالبروتين").
   Redesign it:
   - Collapse ALL water reminders into ONE water row with a progress ring (e.g. 0.5 / 3.3 L) and +250 ml quick button. Reminders still fire as notifications; they are not shown as rows.
   - Group items into صباحاً / الظهر / المساء sections. At most ~8 meaningful items per day: meals, workout, steps goal, protein goal, sleep, supplements/vitality protocol (Pro), morning light, breathing.
   - Every row must be tappable and completable. Tap the circle → done (haptic + strike/animate). Tap the row → opens the related screen (meal log, workout, steps, sleep log, breathing). Persist completion per day and sync it.
   - "Quality sleep" must work. Tapping it opens a simple sleep log: bed time and wake time pickers plus quality 1–5. Show hours slept, mark done when ≥7 h. Store it in vitality/sleep logs. Read sleep from Health Connect if permission is granted (SLEEP_SESSION read; add the permission and update docs/store/HEALTH_CONNECT_DECLARATION.md).
   - Personalize the plan from the onboarding data: age, goal, activity level, training place, chosen diet program. Meal times and meal names come from the active diet program and the user's cuisine. Workout comes from today's program day.
   - Localize every string (all 10 locales). Fix the broken mixed-direction text.

4. STEPS / WALKING shows 0. It must be accurate, like Samsung Health / the "Steps – Pedometer" apps.
   - Request ACTIVITY_RECOGNITION at runtime (Android 10+) with a clear explanation screen. Add the manifest permission.
   - Source priority:
     a) Health Connect STEPS (aggregate today, deduplicated) when available + permission granted;
     b) otherwise the device step-counter sensor via `pedometer`. It's cumulative since boot, so store a daily baseline in Hive at midnight / first reading of the day, and handle reboot (counter reset).
     c) GPS walks add distance but must NOT double-count steps.
   - Refresh on app open/resume and every 60 s while foregrounded.
   - Compute from the user's height/weight/sex: stride length (height × 0.415 male / 0.413 female), distance km, kcal (≈ 0.57 × weight_kg × km × walking factor; document the formula), active minutes, and fat-equivalent grams (kcal / 7.7).
   - HOME: make steps a prominent hero card near the top: big ring with steps / goal, km, kcal, ≈ g fat, active minutes, and a 7-day mini bar chart. Tap opens a Steps detail screen (today hourly bars, week, month, best day, streak). Distinct accent color.
   - If the permission is denied, show an inline "فعّل عدّ الخطوات" button instead of 0.
   - Unit tests for baseline/reboot logic and the formulas.

Rules:
- flutter gen-l10n.
- flutter analyze → 0 errors.
- Run the affected tests with --timeout 2m; no unbounded pumpAndSettle.
- Never write providers inside initState/build.
- git add -A && git commit -m "fix(ux): scan source picker, check-in schedule, today plan redesign, accurate steps". Do not push.
- When finished, immediately continue with docs/prompts/P22b_polish.md in this same conversation.
