import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/onboarding_calorie_sync.dart';
import 'package:vireo/core/utils/calorie_calculator.dart';
import 'package:vireo/data/models/activity_level.dart';
import 'package:vireo/data/models/fitness_goal.dart';
import 'package:vireo/features/nutrition/providers/confirmed_meals_provider.dart';
import 'package:vireo/features/nutrition/providers/demo_meal_overrides_provider.dart';

const _manualCalorieKey = 'manual_calorie_goal';

final calorieGoalProvider = Provider<CalorieTarget>((ref) {
  final profile = HiveService.isInitialized
      ? HiveService.cacheBox.get('guest_profile')
      : null;
  var weight = 75.0;
  var height = 170.0;
  var age = 30;
  var activity = ActivityLevel.moderatelyActive;
  var goal = FitnessGoal.generalVitality;

  if (profile is Map) {
    final map = Map<String, dynamic>.from(profile);
    weight = (map['weight_kg'] as num?)?.toDouble() ?? weight;
    height = (map['height_cm'] as num?)?.toDouble() ?? height;
    age = map['age'] as int? ?? age;
    activity = ActivityLevel.fromValue(
      map['activity_level'] as String? ?? activity.value,
    );
    goal = FitnessGoal.fromValue(map['goal'] as String? ?? goal.value);
  }

  final computed = CalorieCalculator.compute(
    weightKg: weight,
    heightCm: height,
    age: age,
    activityLevel: activity,
    goal: goal,
  );

  // Prefer fully persisted onboarding macros when present.
  final cached = OnboardingCalorieSync.readCached();
  if (cached != null && cached.calories > 0) {
    return cached;
  }

  final manual = HiveService.isInitialized
      ? HiveService.settingsBox.get(_manualCalorieKey) as int?
      : null;

  if (manual != null && manual > 0) {
    final ratio = manual / computed.calories;
    return CalorieTarget(
      calories: manual,
      proteinG: (computed.proteinG * ratio).round(),
      carbsG: (computed.carbsG * ratio).round(),
      fatG: (computed.fatG * ratio).round(),
    );
  }
  return computed;
});

final dailyCaloriesConsumedProvider = Provider<int>((ref) {
  final meals = ref.watch(effectiveTodayMealsProvider).valueOrNull ?? [];
  final confirmed = ref.watch(confirmedMealsProvider);
  var total = 0;
  for (final meal in meals) {
    if (confirmed.contains(meal.mealType)) {
      total += meal.recipe.calories;
    }
  }
  return total;
});

Future<void> setManualCalorieGoal(int? calories) async {
  if (calories == null || calories <= 0) {
    await HiveService.settingsBox.delete(_manualCalorieKey);
  } else {
    await HiveService.settingsBox.put(_manualCalorieKey, calories);
  }
}
