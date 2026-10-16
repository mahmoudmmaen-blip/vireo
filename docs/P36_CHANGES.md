# P36 — Calorie mascot wave, meal insights, plan/program fixes

**Branch:** ux-v2  
**Commit message:** `feat(home+meals): calorie mascot wave, meal health score & swaps, plan/program fixes`

## Shipped

### 1. Calorie mascot ("رفيقك")
- Original flat CustomPainter companions: باندا / قطة / جمل صغير / بومة (no brand look-alikes).
- Body filled with 2-phase sine liquid wave; fill = consumed/target; gentle 1.8 s bob.
- Optional macro layers (P/C/F bands) via Settings → المظهر.
- Color states: calm (accent) / تمام (green) / زيادة شوية (amber). Never alarming red.
- Expressions: hungry / happy / satisfied / full / sleepy (after 23:00).
- Egyptian caption with gender select.
- Home card **سعراتك النهارده** (hero #4); tap → Score & Insights; long-press → سجّل وجبة.
- Toggle **الدايرة العادية** + companion picker in Appearance.
- `RepaintBoundary`, pause off-screen / background / reduce-motion, semantics with numbers.

### 2. Meal result upgrades
- Deterministic meal health score 1–10 (`MealHealthScorer`) from protein density, fiber, sugar, sodium, oil/fried, veg share.
- Micro chips: sodium / sugar / fiber (تقدير when estimated).
- One rule-based smart swap tip with computed kcal/fat savings (`MealSmartSwap`).
- **عدّل النتيجة** free-text → Step B re-resolve (`MealCorrectionText` + `MealResolutionService`); feeds P34 calibration when grams given.
- Arabic primary meal name when locale is Arabic; English secondary.
- analyze-meal cache TTL → **24 h**; `forceReanalyze` for **حلّل تاني**.

### 3. Screenshot / owner fixes
- Today Plan water already collapsed to one progress row (verified + audit).
- Arabic localization cleanup (Vitality protocol → بروتوكول الحيوية, measurement strings, etc.).
- Diet programs: distinct `deficitFactor`s so kcal/protein/fat-loss lines differ per program.
- Single calorie SoT via `calorieGoalProvider` / active diet; calories card shows "الهدف من: …".
- Progress tab hardcoded greens → `vireoColors` tokens.
- Locale label: **العربية (مصري)**; EG devices resolve to `ar_EG`.
- Morning score: before 12 PM or &lt;200 kcal logged → **يومك لسه بيبدأ ☀️** (no red محتاج اهتمام).

### 3b. Home order
1. Ramadan → 2. Steps → 3. Meal capture → 4. Calories (mascot) → 5. Daily Score → 6. Weekly check-in → 7. Pillars / Today Plan → ad → المزيد (InBody, vitality, diet, health hub, week, log).

Daily Score no longer duplicates remaining P/C/F rectangles (those live on سعراتك النهارده).

### 3c. Device review
- Workout feedback rebuilt: RPE 1–10, feeling chips, note, save, smart comment; maps to existing difficulty API; stores `last_workout_rpe`.
- Program meal library ≥15 options per program×slot (breakfast/lunch/dinner/snack) with DB macros, filters, browser screen.
- InBody: Home card kept visible; Profile **جسمي** card with scan/tape + latest values; Progress body-composition chart.

## Tests
- Unit: mascot fill/expression/night, meal health score, smart swaps, correction parser, program library counts, deficitFactors, workout RPE.
- Audit: Home order + mascot × 4 themes, programs list, water collapsed, Latin guard (Today Plan), meal library.

## Verify notes (this machine)
- `flutter analyze --no-fatal-infos`: **0 errors** (infos only).
- Unit/audit passed: mascot math/wave/themes×4, programs+water, workout RPE, meal health/swaps, home order.
- `flutter build apk --debug`: **OK** (`build/app/outputs/flutter-apk/app-debug.apk`).
- `npx supabase functions deploy analyze-meal --use-api`: **failed** (Bun CLI stack overflow). Retry from a healthy shell.

## Owner must do
1. Redeploy `analyze-meal`: `npx supabase functions deploy analyze-meal --use-api` and check one real request in the logs.
2. Spot-check meal-review at 360×640 if sticky summary still overflows.
3. Push when ready (agent never pushes).
