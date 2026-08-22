import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/data/models/recipe.dart';
import 'package:vireo/data/repositories/meal_plan_repository.dart';

/// Session-only demo swaps applied when Supabase is offline.
final demoMealOverridesProvider =
    StateProvider<Map<MealType, Recipe>>((ref) => {});

final effectiveTodayMealsProvider =
    FutureProvider<List<MealPlanEntry>>((ref) async {
  final meals = await ref.watch(todayMealsProvider.future);
  final overrides = ref.watch(demoMealOverridesProvider);
  if (overrides.isEmpty) return meals;

  return meals
      .map((entry) {
        final override = overrides[entry.mealType];
        if (override == null) return entry;
        return MealPlanEntry(
          id: entry.id,
          mealType: entry.mealType,
          dayIndex: entry.dayIndex,
          weekNumber: entry.weekNumber,
          recipe: override,
        );
      })
      .toList();
});
