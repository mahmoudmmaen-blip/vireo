# P46 — Repeat-meal logging

## What changed
- Food search: **أكلتها قريب** / **بتسجلها كتير** chips from local slot history + recents (`FoodLogStats`)
- Home: slot-specific **نفس فطار إمبارح؟** (and lunch/dinner/snack variants); **one-tap re-log** via `MealRelogService.quickConfirm` (no review screen)
- Meal review: star → **احفظ كوجبة** dialog with user-chosen name (`MealFavoritesNotifier.addNamed`)
- Offline-only Hive persistence unchanged (`meal_favorites_v1`, `meal_recent_v1`, `meal_slot_history_v1`)

## Files
- `lib/features/nutrition/providers/food_log_stats.dart` (new)
- `lib/features/nutrition/providers/meal_relog_service.dart` (new)
- `lib/features/nutrition/screens/food_search_screen.dart`
- `lib/features/home/widgets/meal_capture_hero_card.dart`
- `lib/features/ai_nutrition/screens/meal_review_screen.dart`
- `lib/features/nutrition/providers/meal_favorites_provider.dart`
- `lib/features/nutrition/providers/repeat_meal_service.dart`
- `test/features/nutrition/food_log_stats_test.dart` (new)
