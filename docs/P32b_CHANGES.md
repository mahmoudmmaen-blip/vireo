# P32b Implementation Summary: Fair Scan Quota, Next-Meal Suggestions & Household Measures

**Branch:** `ux-v2`  
**Date:** 2026-10-13  
**Status:** Completed & Verified  

---

## 1. Fair AI Scan Quota & `pro_grants` Fixes

### Edge Function (`supabase/functions/_shared/ai-usage.ts` & `analyze-meal/index.ts`)
- **Pro Grants Recognition:**
  - `hasPremiumEntitlement` now looks up active grants in the `pro_grants` table by user email (case-insensitive, unexpired) using the Supabase Service Role client, in addition to checking RevenueCat subscriptions and the `users.subscription_tier` column.
- **Fair Consumption Order:**
  - Fixed premature quota deduction: Quota is now checked up front (`checkDailyQuota`), but is only consumed (`consumeDailyQuota`) **after** Gemini AI returns $\ge 1$ parsed meal line (`items.length > 0 || items_unsure.length > 0`).
  - If analysis fails or yields 0 items, quota is preserved.
- **Duplicate Photo Cache:**
  - Added in-memory SHA-256 deduplication cache with a 10-minute TTL per user. Rescanning the exact same photo within 10 minutes serves cached results without consuming an extra scan quota.
- **Fair Daily Limits:**
  - Meal vision scans: Free tier = 3/day (anonymous = 2/day), rewarded ads allow +2 bonus scans per ad (capped at 2 ads/day for a maximum of 4 bonus scans), Pro tier = 50/day.
  - Body composition reports: Free = 1/day, Pro = 50/day.
- **Redeployment:**
  - Redeployed `analyze-meal` to Supabase edge runtime via `npx supabase functions deploy analyze-meal --use-api`.
  - Documented SQL queries in `docs/RELEASE.md` for granting owner and reviewer Pro entitlements.

---

## 2. Friendly Scan Limit Modal Sheet (`AiScanLimitSheet`)

- Created `AiScanLimitSheet` (`lib/features/ai_nutrition/widgets/ai_scan_limit_sheet.dart`) triggered whenever the scan limit is encountered:
  - **Option 1: Watch Short Ad (+2 Scans)**: Calls `AdService.showRewardedAd()`, grants 2 scans upon completion via `FeatureGates.grantRewardedMealScans()`. Disabled with informative message when the daily ad limit is reached.
  - **Option 2: Upgrade to Vireo Pro**: Navigates to `PaywallScreen` highlighting 50 scans/day and zero ads.
  - **Option 3: Manual Log & Food DB Search**: Always free and unlimited, navigating to `MealLogTextScreen`.
- Displayed remaining daily scans badge ("فاضلك X تحليلات النهارده") in `MealCaptureHeroCard` on Home for free-tier users.

---

## 3. Bundled Food DB Household Measures System ("مقاييس البيت")

- Created `HouseholdMeasures` domain utility (`lib/features/nutrition/domain/household_measures.dart`):
  - Supported units: `cup`, `half_cup`, `tbsp`, `tsp`, `palm` (كف الإيد), `fist` (قبضة), `cupped_hand` (غرفة كفين), `thumb` (عقلة الإبهام), `baladi_loaf` (رغيف بلدي), `koshary` (علبة كشري), `piece` (قطعة), and `grams` (جرام).
  - Categorization for Egyptian staples: cooked rice, pasta, koshary, molokhia, cooked vegetables, meats, poultry, fish, cheeses, baladi bread, and oils.
  - Custom cup calibration scaling (supporting 200 ml, 240 ml, and 300 ml).
  - Fraction steps formatting (¼, ½, ¾, 1, 1½, 2...).
- Extended `FoodItem` schema with `householdUnits` in `food_db_models.dart` and updated `assets/food_db/foods.json`.
- Implemented `PortionPickerSheet` (`lib/features/nutrition/widgets/portion_picker_sheet.dart`) with quick unit chips and quantity stepper, fully integrated into `MealReviewScreen`.
- Added "مقاييس بيتك (كوبايتي)" calibration setting in `SettingsScreen` with visual hand-portion reference guide.

---

## 4. Deterministic Next-Meal Suggester ("اقترح وجبة")

- Created `MealSuggester` (`lib/features/insights/domain/meal_suggester.dart`):
  - Pure deterministic algorithm (no external AI call) using bundled food database.
  - Evaluates remaining kcal, protein, carbs, and fat for the day.
  - If over calorie target: suggests light, high-satiety option ($\le 300$ kcal).
  - If $< 150$ kcal remaining: suggests a light healthy snack ($\le 120$ kcal).
  - Large protein gap: prioritizes lean protein staples.
  - Ramadan mode: respects Iftar vs Suhoor meal slots.
  - Pregnancy / under-18 safety: never forces extreme deficits or fasting suggestions.
- Built `NextMealSuggestionCard` (`lib/features/insights/widgets/next_meal_suggestion_card.dart`):
  - Integrated into Home `DailyScoreHeroCard` and `ScoreInsightsScreen`.
  - 1-tap log directly into `MealReviewScreen`.
  - "اقتراح تاني" cycles through alternate recommendations.
  - Favorite heart toggle persists meal combination to favorites.

---

## 5. Verification & Tests

- `test/food_db_integrity_test.dart`: Passed.
- `test/features/insights/meal_suggester_test.dart`: 8 unit tests passed.
- `test/audit/audit_p32b_overflow_test.dart`: 3 tests passed with zero RenderFlex overflow at 360x640 `ar_EG` font scale 1.3.
- `flutter analyze`: 0 errors, 0 warnings.
- `flutter build apk --debug`: Succeeded.
