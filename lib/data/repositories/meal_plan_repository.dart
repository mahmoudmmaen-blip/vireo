import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/config/app_config.dart';
import 'package:vireo/core/services/analytics_service.dart';
import 'package:vireo/core/services/supabase_service.dart';
import 'package:vireo/core/utils/date_utils.dart';
import 'package:vireo/core/utils/meal_diversity.dart';
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

  /// Swaps a planned meal for an alternative respecting 14-day diversity (§8).
  Future<MealPlanEntry?> swapMeal(MealPlanEntry current) async {
    try {
      if (!SupabaseService.isInitialized) return null;
      final userId = SupabaseService.auth.currentUser?.id;
      if (userId == null) return null;

      final historyRows = await SupabaseService.client
          .from('user_recipe_history')
          .select('recipe_id, served_at')
          .eq('user_id', userId)
          .gte(
            'served_at',
            DateTime.now()
                .subtract(const Duration(days: MealDiversity.defaultHistoryDays))
                .toUtc()
                .toIso8601String(),
          );

      final history = (historyRows as List).map((row) {
        final map = Map<String, dynamic>.from(row);
        return (
          recipeId: map['recipe_id'] as String,
          servedAt: DateTime.parse(map['served_at'] as String),
        );
      });

      final blocked = MealDiversity.recentRecipeIds(
        history: history,
        reference: DateTime.now(),
        withinDays: MealDiversity.defaultHistoryDays,
      )..add(current.recipe.id);

      final recipeRows = await SupabaseService.client
          .from('recipes')
          .select()
          .eq('meal_type', current.mealType.value);

      final candidates = (recipeRows as List)
          .map((r) => Recipe.fromJson(Map<String, dynamic>.from(r)))
          .toList();

      final picked = MealDiversity.pickAlternative(
        candidates: candidates.map((r) => r.id).toList(),
        blockedIds: blocked,
      );
      if (picked == null) return null;

      final replacement = candidates.firstWhere((r) => r.id == picked);

      await SupabaseService.client
          .from('meal_plans')
          .update({'recipe_id': replacement.id})
          .eq('id', current.id);

      await SupabaseService.client.from('user_recipe_history').insert({
        'user_id': userId,
        'recipe_id': replacement.id,
        'meal_plan_id': current.id,
        'served_at': DateTime.now().toUtc().toIso8601String(),
      });

      await AnalyticsService.mealSwapped(
        fromRecipeId: current.recipe.id,
        toRecipeId: replacement.id,
        mealType: current.mealType.value,
        dayIndex: current.dayIndex,
        cuisineFrom: current.recipe.cuisineTag,
        cuisineTo: replacement.cuisineTag,
      );

      return MealPlanEntry(
        id: current.id,
        mealType: current.mealType,
        dayIndex: current.dayIndex,
        weekNumber: current.weekNumber,
        recipe: replacement,
      );
    } catch (_) {
      return null;
    }
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
