import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/onboarding_calorie_sync.dart';
import 'package:vireo/core/utils/calorie_calculator.dart';
import 'package:vireo/data/models/activity_level.dart';
import 'package:vireo/data/models/fitness_goal.dart';
import 'package:vireo/features/diet_programs/providers/diet_programs_provider.dart';
import 'package:vireo/features/measurements/providers/body_composition_provider.dart';
import 'package:vireo/features/nutrition/providers/daily_nutrition_totals_provider.dart';
import 'package:vireo/features/women_health/providers/women_health_provider.dart';

const _manualCalorieKey = 'manual_calorie_goal';
const _manualCalorieUserSetKey = 'manual_calorie_goal_user_set';

final calorieGoalProvider = Provider<CalorieTarget>((ref) {
  ref.watch(dietPlanRevisionProvider);
  final inbody = ref.watch(latestBodyCompositionProvider);

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

  if (inbody?.weightKg != null) {
    weight = inbody!.weightKg!;
  }

  final lean = inbody?.leanMassKg;
  final maintenance = CalorieCalculator.maintenanceKcal(
    weightKg: weight,
    heightCm: height,
    age: age,
    activityLevel: activity,
    leanMassKg: lean,
  );

  var computed = CalorieCalculator.compute(
    weightKg: weight,
    heightCm: height,
    age: age,
    activityLevel: activity,
    goal: goal,
  );

  // Rebuild macros on Katch-McArdle maintenance when lean mass is known.
  if (lean != null && lean > 0) {
    final protein = (lean * 2.2).round().clamp(80, 280);
    final ratio = maintenance / computed.calories.clamp(1, 10000);
    computed = CalorieTarget(
      calories: (computed.calories * ratio).round().clamp(1200, 4500),
      proteinG: protein,
      carbsG: computed.carbsG,
      fatG: computed.fatG,
    );
  }

  // Pregnancy / Breastfeeding mode: disable deficit and add appropriate surplus.
  final womenAdj = ref.watch(womenCalorieAdjustmentProvider);
  if (womenAdj.disableDeficit) {
    final baseKcal = maintenance + womenAdj.surplusKcal;
    computed = CalorieTarget(
      calories: baseKcal.round().clamp(1400, 4500),
      proteinG: computed.proteinG,
      carbsG: computed.carbsG,
      fatG: computed.fatG,
    );
    return computed;
  }

  final manual = HiveService.isInitialized
      ? HiveService.settingsBox.get(_manualCalorieKey) as int?
      : null;
  final userSet = HiveService.isInitialized &&
      HiveService.settingsBox.get(_manualCalorieUserSetKey, defaultValue: false) ==
          true;

  // Explicit user override (Nutrition edit) always wins.
  if (userSet && manual != null && manual > 0) {
    final ratio = manual / computed.calories;
    return CalorieTarget(
      calories: manual,
      proteinG: (computed.proteinG * ratio).round(),
      carbsG: (computed.carbsG * ratio).round(),
      fatG: (computed.fatG * ratio).round(),
    );
  }

  // Active diet program targets drive Home / Nutrition / AI.
  final dietTargets = ref.watch(activeDietTargetsProvider);
  if (dietTargets != null) {
    return CalorieTarget(
      calories: dietTargets.calories,
      proteinG: dietTargets.proteinG,
      carbsG: dietTargets.carbsG,
      fatG: dietTargets.fatG,
    );
  }

  // If InBody/body composition measurement is present, use newly computed targets directly
  if (inbody?.leanMassKg != null || inbody?.weightKg != null) {
    return computed;
  }

  // Prefer fully persisted onboarding macros when present.
  final cached = OnboardingCalorieSync.readCached();
  if (cached != null && cached.calories > 0) {
    return cached;
  }

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

/// Today's eaten calories from all food sources (plan + AI / diary).
final dailyCaloriesConsumedProvider = Provider<int>((ref) {
  return ref.watch(dailyNutritionTotalsProvider).calories;
});

Future<void> setManualCalorieGoal(int? calories) async {
  if (calories == null || calories <= 0) {
    await HiveService.settingsBox.delete(_manualCalorieKey);
    await HiveService.settingsBox.delete(_manualCalorieUserSetKey);
  } else {
    await HiveService.settingsBox.put(_manualCalorieKey, calories);
    await HiveService.settingsBox.put(_manualCalorieUserSetKey, true);
  }
}
