import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/features/ai_nutrition/providers/ai_meal_log_provider.dart';
import 'package:vireo/features/nutrition/providers/calorie_goal_provider.dart';

final remainingCaloriesForAiScanProvider = Provider<int>((ref) {
  final target = ref.watch(calorieGoalProvider).calories;
  final planConsumed = ref.watch(dailyCaloriesConsumedProvider);
  final aiConsumed = ref.watch(dailyAiMealCaloriesProvider);
  return (target - planConsumed - aiConsumed).clamp(0, target);
});

final remainingProteinForAiScanProvider = Provider<double>((ref) {
  final target = ref.watch(calorieGoalProvider).proteinG.toDouble();
  final aiConsumed = ref.watch(dailyAiMealProteinProvider);
  return (target - aiConsumed).clamp(0, target);
});
