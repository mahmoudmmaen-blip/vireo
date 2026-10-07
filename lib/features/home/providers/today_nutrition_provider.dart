import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/features/ai_nutrition/providers/ai_meal_log_provider.dart';
import 'package:vireo/features/cardio/providers/cardio_log_provider.dart';
import 'package:vireo/features/nutrition/providers/calorie_goal_provider.dart';
import 'package:vireo/features/nutrition/providers/confirmed_meals_provider.dart';
import 'package:vireo/features/nutrition/providers/demo_meal_overrides_provider.dart';

/// A single item in today's food log (plan meal or AI-scanned meal).
class TodayLogItem {
  const TodayLogItem({
    required this.id,
    required this.title,
    required this.calories,
    required this.protein,
    required this.loggedAt,
    this.mealType,
    this.isAi = false,
  });

  final String id;
  final String title;
  final int calories;
  final double protein;
  final DateTime? loggedAt;
  final MealType? mealType;
  final bool isAi;
}

/// Everything the "Today" hero needs, computed in one place.
class TodayNutrition {
  const TodayNutrition({
    required this.goalKcal,
    required this.eatenKcal,
    required this.burnedKcal,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.proteinTarget,
    required this.carbsTarget,
    required this.fatTarget,
    required this.items,
  });

  final int goalKcal;
  final int eatenKcal;
  final int burnedKcal;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final int proteinTarget;
  final int carbsTarget;
  final int fatTarget;
  final List<TodayLogItem> items;

  /// Goal − food + exercise (the convention users know from MyFitnessPal).
  int get remainingKcal => goalKcal - eatenKcal + burnedKcal;

  bool get isOver => remainingKcal < 0;

  /// 0..1+ share of the (goal + burned) budget already eaten.
  double get progress {
    final budget = goalKcal + burnedKcal;
    return budget <= 0 ? 0 : eatenKcal / budget;
  }
}

final todayNutritionProvider = Provider.family<TodayNutrition, String>((
  ref,
  languageCode,
) {
  final target = ref.watch(calorieGoalProvider);
  final meals = ref.watch(effectiveTodayMealsProvider).valueOrNull ?? const [];
  final confirmed = ref.watch(confirmedMealsProvider);
  ref.watch(aiMealLogProvider);
  final aiToday = ref.read(aiMealLogProvider.notifier).todayEntries;
  final burned = ref.watch(todayCardioCaloriesProvider);

  var kcal = 0;
  var p = 0.0;
  var c = 0.0;
  var f = 0.0;
  final items = <TodayLogItem>[];

  for (final meal in meals) {
    if (!confirmed.contains(meal.mealType)) continue;
    final r = meal.recipe;
    kcal += r.calories;
    p += r.proteinG;
    c += r.carbsG;
    f += r.fatG;
    items.add(
      TodayLogItem(
        id: 'plan_${meal.mealType.value}',
        title: r.localizedTitle(languageCode),
        calories: r.calories,
        protein: r.proteinG.toDouble(),
        loggedAt: null,
        mealType: meal.mealType,
      ),
    );
  }

  for (final e in aiToday) {
    final r = e.result;
    kcal += r.calories;
    p += r.protein;
    c += r.carbs;
    f += r.fats;
    items.add(
      TodayLogItem(
        id: e.id,
        title: r.foodName,
        calories: r.calories,
        protein: r.protein,
        loggedAt: e.loggedAt,
        isAi: true,
      ),
    );
  }

  // Most recent AI scans first, then plan meals in meal order.
  items.sort((a, b) {
    if (a.isAi && b.isAi) return b.loggedAt!.compareTo(a.loggedAt!);
    if (a.isAi) return -1;
    if (b.isAi) return 1;
    return a.mealType!.index.compareTo(b.mealType!.index);
  });

  return TodayNutrition(
    goalKcal: target.calories,
    eatenKcal: kcal,
    burnedKcal: burned,
    proteinG: p,
    carbsG: c,
    fatG: f,
    proteinTarget: target.proteinG,
    carbsTarget: target.carbsG,
    fatTarget: target.fatG,
    items: items,
  );
});
