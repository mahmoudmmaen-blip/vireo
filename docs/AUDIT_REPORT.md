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

## 6. UI Consistency Audit (P28 Item 3)
1. **Design System & Spacing**:
   - Standardized container cards across Home, Nutrition, Profile, and Settings to use `14–16px` border radii and consistent subtle stroke borders (`colors.line.withValues(alpha: 0.6)`).
   - Unified color tokens (`context.vireoColors` with `ember`, `forest`, `surface`, `line`, and `textMute`). Removed random hardcoded color literals across card backgrounds.
2. **Typography Hierarchy**:
   - Header titles standardized to bold weights (`FontWeight.w800` / `w900`) with proportional headline sizes (`16–20px`).
   - Meta details, timestamps, and secondary badges standardized to `11–12.5px` with medium/bold weights and `textMute` contrast.
3. **Interactive Affordances**:
   - Button heights, tap targets, and chevron indicators standardized across screens to provide predictable feedback on Android touch devices.

---

## 7. Performance & Rendering Audit (P28 Item 4)
1. **Scrollable Layout Optimization**:
   - Replaced unbounded layout hierarchies with `NestedScrollView` and `SliverToBoxAdapter` slivers in heavy tabs like `NutritionScreen`, eliminating costly layout reflows.
   - List builders (`ListView.builder` / `ListView.separated`) used with lazy rendering rather than statically mapping full lists into columns.
2. **Painter & Asset Efficiency**:
   - Donut charts and progress indicators use optimized lightweight custom painters (`_MacroDonutPainter`) without unnecessary canvas layer allocations.
   - Memory leaks prevented by ensuring all controllers (`TabController`, `TextEditingController`, timers) are systematically disposed in `dispose()`.
3. **Throttled Updates**:
   - Foreground background isolate updates throttled to a 5-second cadence to preserve device battery and prevent UI thread starvation.

---

## 8. Crash Safety & Async Guarding Audit (P28 Item 5)
1. **Asynchronous UI Action Guarding**:
   - Verified that all async flows (e.g. food search, saving meals to favorites, toggling Ramadan preferences, ad display triggers) strictly check `if (!mounted) return;` or `context.mounted` before interacting with `BuildContext`, `Navigator`, or `ScaffoldMessenger`.
   - Wrapped network/remote storage operations and JSON decoding routines in defensive `try/catch` handlers with user-friendly SnackBar feedback on failures.
2. **Safe Value Bounds & Fallbacks**:
   - Guaranteed null-safe fallbacks for macro calculations, calorie targets, and date parsers (e.g. `clamp(0, total)`, `orElse: () => fallback`).

---

## 9. Static Analysis & Build Verification
- **Analyzer**: `flutter analyze --no-fatal-infos lib/` completed with 0 errors and 0 warnings.
- **Build**: `flutter build apk --debug` verified and passing cleanly.

---

## 10. P30 New Features Hardening & Audit (Items 3–5)
### Consistency & Design System:
- **Barcode Scanner (`meal_barcode_screen.dart`)**:
  - Unified reticle styling with rounded corners, theme border tints, responsive control action chips for flash/torch, and matching typography.
  - Consistent bottom sheet for label OCR fallback using `VireoColors` and elevation tokens.
- **Weekly Wrapped 🎁 (`weekly_wrapped_story_screen.dart`)**:
  - Full-screen story presentation with standard 5-second automatic progression bars, tap-to-pause/skip gestures, and localized cultural comparisons (Egypt: الهرم الأكبر / كوبري قصر النيل; Gulf: برج خليفة; general: ملاعب كرة القدم).
  - Explicit privacy controls: meals and weight trends excluded from generated 1080×1920 share image unless explicitly toggled on by user.
- **Progress Photo Compare (`photo_comparison_screen.dart` & `photo_ghost_camera_screen.dart`)**:
  - Consistent segmented control between Draggable Slider and Side-by-Side comparison modes.
  - Interactive ghost overlay camera with live opacity slider and posture alignment guides.

### Performance & Memory:
- **Hardware Acceleration & Offscreen Rendering**:
  - Shareable Weekly Wrapped story card (1080×1920) rendered offscreen with `pixelRatio: 2.0` on isolated `RepaintBoundary` and immediately flushed from memory after sharing.
  - Ghost camera utilizes camera controller stream with direct GPU texture layer and stacked semi-transparent canvas without redundant image re-encoding.
- **Open Food Facts & Cache Tiering**:
  - Barcode lookup strictly short-circuits: Local SharedPreferences Cache -> Bundled Egyptian Food DB -> Open Food Facts API -> Gemini Nutrition Label Vision fallback. No redundant HTTP calls when barcode exists locally.

### Crash Safety & Arabic Error Handling on Async UI Actions:
- **Protected Async Flows**:
  - `MealBarcodeScreen`: Camera permissions, barcode scanning stream handlers, and image picking for nutrition label fallback wrapped in `try/catch` with friendly Arabic notifications (`فشل تشغيل الكاميرا`, `تعذر قراءة الملصق الغذائي`).
  - `PhotoComparisonScreen`: Photo export and face blur generation wrapped in `try/catch` with `تعذر تجهيز أو مشاركة صورة المقارنة`.
  - `WeeklyWrappedStoryScreen`: Share card image capture and share flow wrapped in `try/catch` with `تعذر مشاركة الملخص حالياً`.
  - All async gaps guarded with `if (!mounted) return;` before touching `BuildContext` or showing SnackBars.

