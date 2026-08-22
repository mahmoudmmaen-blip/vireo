import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/config/app_config.dart';
import 'package:vireo/core/services/supabase_service.dart';
import 'package:vireo/core/utils/date_utils.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/data/models/recipe.dart';

class MealPlanRepository {
  const MealPlanRepository();

  Future<List<MealPlanEntry>> fetchTodayMeals() async {
    final weekNumber = DateUtilsVireo.isoWeekNumber(DateTime.now());
    final dayIndex = DateUtilsVireo.todayDayIndex();

    try {
      if (SupabaseService.isInitialized) {
        final userId = SupabaseService.auth.currentUser?.id;
        if (userId != null) {
          final rows = await SupabaseService.client
              .from('meal_plans')
              .select('*, recipes(*)')
              .eq('week_number', weekNumber)
              .eq('day_index', dayIndex);

          if (rows.isNotEmpty) {
            return (rows as List)
                .map((r) => MealPlanEntry.fromJson(Map<String, dynamic>.from(r)))
                .toList();
          }

          await _generateWeekIfMissing(weekNumber);
          final retry = await SupabaseService.client
              .from('meal_plans')
              .select('*, recipes(*)')
              .eq('week_number', weekNumber)
              .eq('day_index', dayIndex);

          if (retry.isNotEmpty) {
            return (retry as List)
                .map((r) => MealPlanEntry.fromJson(Map<String, dynamic>.from(r)))
                .toList();
          }
        }
      }
    } catch (_) {
      // Demo fallback below.
    }

    return _demoTodayMeals(dayIndex);
  }

  Future<void> _generateWeekIfMissing(int weekNumber) async {
    try {
      await SupabaseService.client.functions.invoke(
        AppConfig.generateMealPlanFunctionName,
        body: {'week_number': weekNumber},
      );
    } catch (_) {
      rethrow;
    }
  }

  List<MealPlanEntry> _demoTodayMeals(int dayIndex) {
    final week = DateUtilsVireo.isoWeekNumber(DateTime.now());
    return [
      _demoEntry('demo-b', MealType.breakfast, week, dayIndex,
          'Protein Oats Bowl', 'شوفان بالبروtein', 10, 'high_protein'),
      _demoEntry('demo-l', MealType.lunch, week, dayIndex,
          'Grilled Chicken Plate', 'طبق دجاج مشوي', 25, 'high_protein'),
      _demoEntry('demo-d', MealType.dinner, week, dayIndex,
          'Chickpea Salad', 'سلطة حمص', 15, 'quick_easy'),
      _demoEntry('demo-s', MealType.snack, week, dayIndex,
          'Greek Yogurt & Fruit', 'زبادي وفاكهة', 5, 'quick_easy'),
    ];
  }

  MealPlanEntry _demoEntry(
    String id,
    MealType type,
    int week,
    int day,
    String titleEn,
    String titleAr,
    int prep,
    String goalTag,
  ) {
    return MealPlanEntry(
      id: id,
      mealType: type,
      dayIndex: day,
      weekNumber: week,
      recipe: Recipe(
        id: 'recipe-$id',
        titleEn: titleEn,
        titleAr: titleAr,
        prepTimeMinutes: prep,
        goalTag: RecipeGoalTag.fromValue(goalTag),
        mealType: type,
      ),
    );
  }
}

final mealPlanRepositoryProvider = Provider<MealPlanRepository>(
  (ref) => const MealPlanRepository(),
);

final todayMealsProvider = FutureProvider<List<MealPlanEntry>>((ref) async {
  return ref.read(mealPlanRepositoryProvider).fetchTodayMeals();
});

final todayMealsByTypeProvider = Provider<Map<MealType, MealPlanEntry?>>((ref) {
  final meals = ref.watch(todayMealsProvider).valueOrNull ?? const [];
  MealPlanEntry? forType(MealType type) {
    for (final meal in meals) {
      if (meal.mealType == type) return meal;
    }
    return null;
  }

  return {for (final type in MealType.values) type: forType(type)};
});
