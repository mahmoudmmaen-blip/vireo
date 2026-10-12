# P27 Changes & Improvements Summary

This document details all implementations, architectural improvements, and bug fixes delivered in accordance with `docs/prompts/P27_mfp_level.md` on branch `ux-v2`.

---

## 1. Meal Analysis Speed & Experience
- **Client Compression Optimization** (`lib/features/ai_nutrition/utils/image_compressor.dart`):
  - Replaced legacy 1 MB loop with fast proportional scaling down to `max 768 px` on the longest side and `JPEG quality 70`.
  - Produces payloads around 80–150 KB for instant network uploads even on constrained 4G connections.
- **Edge Function Tuning** (`supabase/functions/analyze-meal/index.ts` & `_shared/gemini-client.ts`):
  - Configured fast vision model fallback override (`gemini-2.5-flash`).
  - Added strict JSON schema, `thinkingBudget: 0`, and `maxOutputTokens: 1200`.
  - Added performance execution timers and server-side log timing.
  - Deployed to Supabase project via `npx supabase functions deploy analyze-meal --use-api`.
- **Scan Screen & Feedback** (`lib/features/ai_nutrition/widgets/meal_scan_loading_overlay.dart`, `screens/ai_scan_screen.dart`):
  - Added animated vertical laser scan line over the captured photo.
  - Added rotating contextual nutrition tips during processing.
  - Added 25-second timeout safeguard with instant retry action.

---

## 2. MyFitnessPal-Style Meal Review & Food Diary
- **Top Sticky Summary Card** (`lib/features/ai_nutrition/screens/meal_review_screen.dart`):
  - Always visible header card featuring AI-suggested meal title (e.g. "رز + فراخ مشوية + خضار").
  - Prominent calorie count and macro donut chart with Protein, Carbs, Fat grams & percentages.
  - Health score badge (1–10) with one-line verdict.
  - Fat equivalent indicator (`≈ X جم دهون`).
  - "المتبقي من يومك" (Remaining daily calorie budget after this meal).
  - Primary "حفظ" (one tap) and secondary "عدّل التفاصيل" buttons.
- **Compact Items List & Contextual Editor**:
  - Compact rows (`name · grams · kcal`) that expand into inline food editors.
  - Per-food unit tables (Rice: كوب/ملعقة/جم; Chicken: قطعة/صدر/جم; Bread: رغيف/نصف/توست) rather than generic units.
  - Cooking method chips displayed strictly where relevant (poultry, meat, fish, eggs, potatoes).
  - "إزاي حسبناها" calculation explanation collapsed cleanly at the bottom.
  - Removed plate size interrupt popup from review screen (moved to settings: `lib/features/profile/settings_screen.dart`).
  - Default meal type slot inferred by time of day (Breakfast before 11:00, Lunch before 16:00, Dinner before 21:00, else Snack).
- **Diary / Food Tab Enhancements** (`lib/features/nutrition/widgets/daily_calorie_goal_card.dart`, `widgets/meal_quick_relog_row.dart`, `nutrition_screen.dart`):
  - Added MyFitnessPal formula row: `الهدف − الأكل + التمرين = الباقي` with colored breakdown.
  - Added quick-relog row supporting "كرر وجبة امبارح" and saved favourites with one-tap entry.

---

## 3. Leap-Style One-Tap Steps Counter & Real Daily Total
- **Foreground Service Integration** (`lib/features/walking/data/step_foreground_service.dart`, `android/app/src/main/AndroidManifest.xml`, `pubspec.yaml`):
  - Integrated `flutter_foreground_task` 10.0.0.
  - Configured Android permissions (`FOREGROUND_SERVICE_HEALTH`, `FOREGROUND_SERVICE_DATA_SYNC`, `ACTIVITY_RECOGNITION`).
  - Background counting persists with phone locked and app terminated; notification displays live step tally.
- **Shared Live Provider** (`lib/features/walking/providers/live_steps_provider.dart`):
  - Unified `liveStepsProvider` and `isStepCounterRunningProvider` shared directly between Home and Walk tabs.
  - Real daily total calculated as `max(Health Connect today's steps, pedometer today steps)` to include Samsung Health / Google Fit steps accrued before opening the app.
- **Leap UI Redesign** (`lib/features/home/widgets/premium_steps_hero_card.dart`, `lib/features/walking/screens/full_walk_tab_screen.dart`):
  - Dark card aesthetic with big white step numbers, `/7000 خطوة` target, and thick progress bar.
  - 3 metric columns (Distance in km, Calories in kcal, Active time).
  - 7-day stars tracker with star badges for met goals + daily average.
  - Large ▶️/⏸ circular button for one-tap start/stop toggle.

---

## 4. Bug Fixes & Polishing
- **Walk Tab Overflow & Charts** (`lib/features/walking/screens/full_walk_tab_screen.dart`):
  - Fixed 45-pixel overflow in chart header by using flexible layout and compact segmented control.
  - Removed broken overlapping miniature ring; replaced with clean Leap-style presentation.
  - Implemented real step bar visualizations for Day (hourly), Week, and Month views.
- **Home "اليوم" Pillars Grid** (`lib/features/home/widgets/today_pillars_grid.dart`):
  - Adjusted aspect ratio (1.18) and minimum card height (90px) to prevent workout title clipping.
  - Populated with live progress indicators and metrics.
- **Localization Fixes** (`lib/core/l10n/app_ar.arb`, `lib/features/profile/profile_screen.dart`, `lib/features/onboarding/steps/step_plan_reveal_screen.dart`):
  - Translated quick log sleep prompts ("Sleep / How did you sleep").
  - Localized "Cloud Sync: Offline-Ready" -> "المزامنة السحابية: جاهز دون اتصال".
  - Localized diet program titles dynamically from catalog locale rather than hardcoded English strings.
- **AdMob Debugger**:
  - Disabled native ad debugger popup in debug mode via Android manifest metadata.
