import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/features/ai_nutrition/providers/ai_meal_log_provider.dart';
import 'package:vireo/features/cardio/providers/cardio_log_provider.dart';
import 'package:vireo/features/nutrition/providers/confirmed_meals_provider.dart';
import 'package:vireo/features/nutrition/providers/demo_meal_overrides_provider.dart';

/// Immutable daily nutrition totals shared by Home, Nutrition, AI Coach, and
/// AI scan budget. Food sources: confirmed plan meals + AI-scanned meals
/// (Diary food entries are persisted via [aiMealLogProvider], so they are
/// already included).
@immutable
class DailyNutritionTotals {
  const DailyNutritionTotals({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.burnedKcal,
  });

  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final int burnedKcal;

  static const empty = DailyNutritionTotals(
    calories: 0,
    protein: 0,
    carbs: 0,
    fat: 0,
    burnedKcal: 0,
  );
}

/// Single source of truth for today's eaten macros + cardio burn.
final dailyNutritionTotalsProvider = Provider<DailyNutritionTotals>((ref) {
  final meals = ref.watch(effectiveTodayMealsProvider).valueOrNull ?? const [];
  final confirmed = ref.watch(confirmedMealsProvider);
  ref.watch(aiMealLogProvider);
  final aiToday = ref.read(aiMealLogProvider.notifier).todayEntries;
  final burned = ref.watch(todayCardioCaloriesProvider);

  var calories = 0;
  var protein = 0.0;
  var carbs = 0.0;
  var fat = 0.0;

  for (final meal in meals) {
    if (!confirmed.contains(meal.mealType)) continue;
    final r = meal.recipe;
    calories += r.calories;
    protein += r.proteinG;
    carbs += r.carbsG;
    fat += r.fatG;
  }

  for (final e in aiToday) {
    final r = e.result;
    calories += r.calories;
    protein += r.protein;
    carbs += r.carbs;
    fat += r.fats;
  }

  return DailyNutritionTotals(
    calories: calories,
    protein: protein,
    carbs: carbs,
    fat: fat,
    burnedKcal: burned,
  );
});
