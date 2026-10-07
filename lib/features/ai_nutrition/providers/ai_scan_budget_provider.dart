import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/features/nutrition/providers/calorie_goal_provider.dart';
import 'package:vireo/features/nutrition/providers/daily_nutrition_totals_provider.dart';

final remainingCaloriesForAiScanProvider = Provider<int>((ref) {
  final target = ref.watch(calorieGoalProvider).calories;
  final totals = ref.watch(dailyNutritionTotalsProvider);
  final remaining = target - totals.calories + totals.burnedKcal;
  return remaining.clamp(0, target + totals.burnedKcal);
});

final remainingProteinForAiScanProvider = Provider<double>((ref) {
  final target = ref.watch(calorieGoalProvider).proteinG.toDouble();
  final totals = ref.watch(dailyNutritionTotalsProvider);
  return (target - totals.protein).clamp(0, target);
});
