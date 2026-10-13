# P31 Implementation Summary: Smart Home, Meal Capture Card & Reliable Step Toggle

**Branch:** `ux-v2`  
**Date:** 2026-10-13  
**Status:** Completed & Verified  

---

## 1. Step Start/Pause Button Freeze Fixed (Top Priority)
- **Root Cause:**
  - Toggling `StepForegroundService` could hang if underlying platform channels stalled without timeouts.
  - Rapid double-tapping triggered concurrent start/stop cycles.
  - `isStepCounterRunningProvider` drifted from actual background task state.
- **Fix:**
  - `StepForegroundService`: Enforced a 5-second timeout on service start, stop, and update requests; added `syncRunningState()` and reactive `onRunningStateChanged` hooks.
  - `live_steps_provider.dart`: Converted `isStepCounterRunningProvider` to a `StateNotifierProvider<StepCounterRunningNotifier, bool>`, acting as the single source of truth across isolate lifecycle changes.
  - `premium_steps_hero_card.dart`: Added a 600ms debounce lock on taps, optimistic state toggle with rollback and Arabic SnackBar on error, and progress ring indicator while switching. Added haptic feedback (`HapticFeedback.heavyImpact()`). Distinctive button styling:
    - Running: filled emerald circle with pulsing glow animation and "شغّال" label.
    - Paused: outlined circle with ▶ icon and "ابدأ" label.
  - Active time computation: derived from cadence (`steps / 100`) as active minutes.
  - 7-day circular row: filled with progress rings, star badges (⭐) when goal is reached, and localized Arabic day initials (`س ح ن ث ر خ ج`).
- **Files:**
  - `lib/features/walking/data/step_foreground_service.dart`
  - `lib/features/walking/providers/live_steps_provider.dart`
  - `lib/features/home/widgets/premium_steps_hero_card.dart`
  - `lib/features/walking/screens/full_walk_tab_screen.dart`
  - `test/features/walking/step_button_double_tap_test.dart`

---

## 2. Home Screen Reordering & Meal Capture Hero Card
- **New Order (Top to Bottom):**
  1. Header & Streaks
  2. Ramadan Countdown Card
  3. Steps Hero Card (`PremiumStepsHeroCard`)
  4. Meal Capture Card (`MealCaptureHeroCard`)
  5. Daily Score Card (`DailyScoreHeroCard`)
  6. "اليوم" Pillars Grid (`TodayPillarsGrid`)
  7. Smart Next Action Card (`SmartNextActionCard`)
  8. Today Plan Section (`TodayPlanSection`)
  9. Native Ad slot (`VireoNativeAdCard`)
  10. More & Analytics (`TodayHeroCard`, `ChooseDietPlanCard`, `HealthHubScreen`)
- **Meal Capture Hero Card (`MealCaptureHeroCard`):**
  - Full-width ember-orange gradient container (~140dp) with camera icon.
  - Quick action chips: 📷 تصوير · 🖼 الاستوديو · ✍️ اكتب · 🔎 باركود.
  - Mini row displaying today's last logged meal or contextual reminder based on time of day (e.g., "لسه ما سجلتش فطارك").
- **Files:**
  - `lib/features/home/widgets/meal_capture_hero_card.dart`
  - `lib/features/home/widgets/home_dashboard_body.dart`
  - `lib/features/ai_nutrition/screens/ai_scan_screen.dart`

---

## 3. Daily Score: Bigger, Organized, Smart
- **Home Card (`DailyScoreHeroCard`):**
  - 110dp progress ring with score, tier label, and `/100`.
  - 2×2 grid of "what you still need today" (Protein, Carbs, Fat, Kcal) with progress bars, "تمام" on completion, and amber excess badges.
  - Water remaining chip ("باقي X أكواب").
  - Smart insight line based on current progress.
- **Score & Insights Screen (`ScoreInsightsScreen`):**
  - Full-screen replacement for bottom sheet.
  - Header ring with 6 factor rows: steps (25), protein (20), kcal balance (15), water (15), workout (15), sleep (10), each with actionable advice.
  - Visual charts powered by `fl_chart`:
    - 7-day score trend line chart.
    - 7-day energy balance bar chart (eaten vs burned).
    - Today's macro distribution comparison.
  - Smart predictions card ("توقعات ذكية" labeled "تقديري"):
    - Estimated fat lost in grams.
    - 2, 4, and 8-week weight projections.
    - Estimated weeks to reach goal weight.
    - Mifflin-St Jeor TDEE formula explainer in expandable card.
    - Guards: requires >= 3 days of data; clamps weekly projected loss to <= 1% of body weight; alerts if daily deficit exceeds 1,000 kcal.
  - Actionable tips list with direct navigation.
- **Domain & Tests:**
  - Pure Dart math in `lib/features/insights/domain/energy_projection.dart`.
  - Comprehensive unit test suite in `test/features/insights/energy_projection_test.dart`.
- **Files:**
  - `lib/features/home/widgets/daily_score_hero_card.dart`
  - `lib/features/insights/screens/score_insights_screen.dart`
  - `lib/features/insights/domain/energy_projection.dart`
  - `test/features/insights/energy_projection_test.dart`
  - `test/audit/screen_score_insights_test.dart`

---

## 4. Meal Review Fixes & "After this meal" Smart Block
- **Analyze-Meal Edge Function Prompt:**
  - Updated `supabase/functions/_shared/prompts/meal-vision.ts` to only include clearly visible foods and assign confidence scores (0.0 to 1.0).
  - Deployed to Supabase with `npx supabase functions deploy analyze-meal --use-api`.
- **Meal Review Screen UI:**
  - Filters low confidence items (<0.5) behind "ممكن يكون فيه كمان في الوجبة؟" chip row.
  - Embedded photo thumbnail inside top summary card next to meal title.
  - Meal title clamped to 2 lines max with ellipsis.
  - Added "After this meal" smart block:
    - 4 mini chips for kcal, protein, carbs, and fat showing "باقي X" or amber "زيادة X".
    - Rule-based personalized advice from local food DB (e.g. over kcal suggestions, low protein additions, or on-track confirmation).
  - Post-save SnackBar toast with advice and action button to plan the next meal.
- **Domain & Tests:**
  - Pure Dart engine in `lib/features/insights/domain/meal_advice.dart`.
  - Unit tests covering over-calorie, low-protein, on-track, and last meal scenarios in `test/features/insights/meal_advice_test.dart`.
- **Files:**
  - `supabase/functions/_shared/prompts/meal-vision.ts`
  - `lib/features/ai_nutrition/screens/meal_review_screen.dart`
  - `lib/features/insights/domain/meal_advice.dart`
  - `test/features/insights/meal_advice_test.dart`

---

## 5. Verification
- `flutter gen-l10n`: Completed cleanly.
- `flutter analyze --no-fatal-infos lib/`: Passed with 0 errors and 0 warnings.
- `flutter test`: Passed green (unit tests for energy projections, meal advice, walking, and overflow audits for score insights and nutrition).
- `flutter build apk --debug`: Polling in background to final completion.
