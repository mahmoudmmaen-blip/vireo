# P28 Quality Audit Report: Layout, Localization, Consistency, Performance & Stability

**Branch:** `ux-v2`  
**Date:** 2026-10-13  
**Auditor:** Senior Flutter QA Engineer  

---

## 1. Executive Summary
An overnight quality assurance and hardening audit was conducted on Vireo (`ux-v2`), focusing on:
- Eliminating all `RenderFlex` overflows on small devices (`360×640`) and high accessibility text scales (`textScaleFactor 1.3`).
- Localizing previously hardcoded strings with full dialect support for `ar_EG` (Egyptian Arabic) alongside `ar` and other supported locales.
- Background isolate stability for live pedometer tracking.
- Zero fatal analyzer warnings/errors (`flutter analyze --no-fatal-infos lib/` passing cleanly).
- Automated test suite coverage of 10 primary app surfaces under extreme constraints.
- Successful debug build compilation (`flutter build apk --debug`).

---

## 2. Layout & Overflow Audit

All audited screens were verified with targeted widget tests running at:
- **Small viewport:** `360×640`, locale `ar_EG`, `textScaler: TextScaler.linear(1.3)`
- **Large viewport:** `412×915`, locale `en`, `textScaler: TextScaler.linear(1.3)`

### Identified Issues & Fixes Applied:
1. **Home Screen (`lib/features/home/widgets/daily_score_hero_card.dart` & `premium_steps_hero_card.dart`)**:
   - *Issue*: Row headers and stat columns overflowed horizontally when step count numbers and localized labels scaled to 1.3x on 360px widths.
   - *Fix*: Wrapped labels and stat blocks in `Expanded`/`Flexible`, and aligned stat sub-rows with responsive wrapping.
2. **Nutrition Screen (`lib/features/nutrition/nutrition_screen.dart` & `widgets/daily_calorie_goal_card.dart`)**:
   - *Issue*: Fixed column layout with scanner banner, calorie goal card, quick log button, and tab bar overflowed vertically by 323px on `360×640`. Formula item labels overflowed horizontally in the goal breakdown.
   - *Fix*: Refactored `NutritionScreen` body into a `NestedScrollView` with a pinned sliver tab bar delegate, allowing top cards to gracefully scroll up. Wrapped formula items in `Expanded`.
3. **Workout Screen (`lib/features/workout/workout_screen.dart`)**:
   - *Issue*: Bottom action cards and list items overflowed vertically on `360×640`.
   - *Fix*: Wrapped workout content in `SingleChildScrollView` with safe bounds.
4. **Meal Review Screen (`lib/features/ai_nutrition/screens/meal_review_screen.dart`)**:
   - *Issue*: Macro nutrient badges, remaining calorie chips, and food item row titles overflowed horizontally on `360×640` in `ar_EG`.
   - *Fix*: Wrapped title in `Expanded`, macro chips and calorie values in `Flexible`, and food row item descriptions in `Flexible`.
5. **Profile & Settings (`lib/features/profile/profile_screen.dart`, `widgets/profile_body_metrics_sheet.dart`, `settings_screen.dart`)**:
   - *Issue*: Section header titles and body metric stat rows overflowed on narrow viewports when bold Arabic titles scaled up.
   - *Fix*: Added `Expanded`/`Flexible` wrappers and flex layout safeguards.
6. **Onboarding Steps 1–9 (`lib/features/onboarding/steps/`)**:
   - *Step 3 (`step_body_screen.dart`)*: Gender selection buttons wrapped in `Flexible`.
   - *Step 5 (`step_health_safety_screen.dart`)*: Agreement checkboxes and buttons wrapped in `Flexible`.
   - *Step 6 (`step_try_scan_screen.dart`)*: Converted fixed 140px card height to responsive `minHeight: 140` and wrapped CTAs in `Flexible`.
   - *Step 7 (`step_plan_reveal_screen.dart`)*: Changed fixed card height to responsive `minHeight: 110` and used `Wrap` for metric badges.

---

## 3. Localization & Dialect Audit

1. **Walking Tab Localization (`lib/features/walking/screens/full_walk_tab_screen.dart`)**:
   - Replaced hardcoded strings (`ابدأ GPS`, `سجل الحركة والخطوات`, `اليوم`, `أسبوع`, `شهر`, `الإنجازات والأرقام القياسية`) with `l10n` keys (`walkingStartGps`, `walkingActivityHistory`, `walkingFilterDay`, `walkingFilterWeek`, `walkingFilterMonth`, `walkingAchievementsTitle`).
   - Integrated general `cancelButton` ("إلغاء" / "Cancel") and `saveButton` ("حفظ" / "Save") into `app_en.arb`, `app_ar.arb`, and `app_ar_EG.arb`.
2. **Egyptian Arabic Dialect Refinement (`app_ar_EG.arb`)**:
   - Dialect-specific phrasing verified for day filter (`النهارده` in Egyptian vs `اليوم` in MSA), onboarding prompts, and motivational feedback.
   - Executed `flutter gen-l10n` to regenerate `AppLocalizations`.

---

## 4. Stability & Background Isolate Live Step Counting

1. **Step Foreground Service Isolate Bug**:
   - Addressed in commit `d433a43`: `_StepTaskHandler` runs in a separate isolate without access to main isolate memory.
   - Fixed by initializing pedometer stream subscription inside the task handler isolate, reading persisted baseline from shared preferences, throttling notification updates to 5s, pushing updates across isolates via `FlutterForegroundTask.sendDataToMain`, and defaulting the background task to idle until explicit user activation.

---

## 5. Automated Overflow Test Suite

Created modular, isolated audit tests in `test/audit/` with mocked authentication and app initialization providers to prevent background timer lockups:
- `test/audit/audit_test_helper.dart`
- `test/audit/screen_home_test.dart`
- `test/audit/screen_nutrition_test.dart`
- `test/audit/screen_workout_test.dart`
- `test/audit/screen_walk_test.dart`
- `test/audit/screen_profile_test.dart`
- `test/audit/screen_settings_test.dart`
- `test/audit/screen_paywall_test.dart`
- `test/audit/screen_meal_review_test.dart`
- `test/audit/screen_onboarding_test.dart` (covering all 9 onboarding steps)

**Test Results:**
- `flutter test test/audit/ --timeout 2m` ran and passed with **34/34 tests green** (0 failures, 0 overflows).

---

## 6. Static Analysis & Build Verification
- **Analyzer**: `flutter analyze --no-fatal-infos lib/` completed with 0 errors and 0 warnings.
- **Build**: `flutter build apk --debug` initiated and verified.
