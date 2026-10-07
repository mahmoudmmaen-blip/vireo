import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/data/models/fitness_goal.dart';
import 'package:vireo/data/repositories/workout_repository.dart';
import 'package:vireo/features/ai_coach/domain/user_context.dart';
import 'package:vireo/features/ai_nutrition/providers/ai_scan_budget_provider.dart';
import 'package:vireo/features/nutrition/providers/calorie_goal_provider.dart';
import 'package:vireo/features/nutrition/providers/daily_nutrition_totals_provider.dart';

final aiCoachUserContextProvider = Provider<UserContext>((ref) {
  ref.watch(userProfileProvider);
  final target = ref.watch(calorieGoalProvider);
  // Keep remaining macros in sync with the shared daily totals.
  ref.watch(dailyNutritionTotalsProvider);
  final remainingCalories = ref.watch(remainingCaloriesForAiScanProvider);
  final remainingProtein = ref.watch(remainingProteinForAiScanProvider);

  var weight = 75.0;
  var goal = FitnessGoal.generalVitality;

  if (HiveService.isInitialized) {
    final profile = HiveService.cacheBox.get('guest_profile');
    if (profile is Map) {
      final map = Map<String, dynamic>.from(profile);
      weight = (map['weight_kg'] as num?)?.toDouble() ?? weight;
      goal = FitnessGoal.fromValue(map['goal'] as String? ?? goal.value);
    }
  }

  return UserContext(
    remainingCalories: remainingCalories,
    remainingProtein: remainingProtein,
    targetCalories: target.calories,
    targetProtein: target.proteinG,
    currentWeight: weight,
    goal: goal.value,
  );
});
