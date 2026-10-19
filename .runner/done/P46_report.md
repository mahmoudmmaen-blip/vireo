# P46 — Repeat-meal logging (recent / frequent / same-as-yesterday)
Status: DONE

## What changed
- `lib/features/nutrition/providers/food_log_stats.dart`: aggregate recent/frequent `food_id`s from local meal history
- `lib/features/nutrition/providers/meal_relog_service.dart`: one-tap `quickConfirm` (no review screen)
- `lib/features/nutrition/screens/food_search_screen.dart`: sections أكلتها قريب / بتسجلها كتير (+ search-viewed)
- `lib/features/home/widgets/meal_capture_hero_card.dart`: نفس فطار/غدا/عشا إمبارح؟ + one-tap re-log
- `lib/features/nutrition/widgets/meal_quick_relog_row.dart`: same slot-specific copy + one-tap
- `lib/features/ai_nutrition/screens/meal_review_screen.dart`: احفظ كوجبة name dialog
- `lib/features/nutrition/providers/meal_favorites_provider.dart`: `addNamed`
- `lib/features/nutrition/providers/repeat_meal_service.dart`: export `loadSlotMealHistory`
- `test/features/nutrition/food_log_stats_test.dart` + audit P40 string updates
- `docs/P46_CHANGES.md`

## Gate results
- analyze: pass (0 errors; 1 warning + 32 infos)
- test: pass (`food_log_stats_test`, `repeat_meal_service_test`, `audit_p40_repeat_meals_test`)
- build:aab: skipped (not in task gates)
- package: `com.vireofit.app` ✓

## Manual steps for the user
- None required for Play upload from this task
- On device: log a meal today → tomorrow tap **نفس فطار إمبارح؟** and confirm it lands in the day log without opening review

## Follow-ups suggested
- P47_water_tracker
- P48_health_connect
- P44 inbox still has uncommitted package-revert commit if needed
