import 'package:vireo/data/models/activity_level.dart';
import 'package:vireo/data/models/fitness_goal.dart';

class CalorieTarget {
  const CalorieTarget({
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });

  final int calories;
  final int proteinG;
  final int carbsG;
  final int fatG;
}

/// Mifflin-St Jeor BMR + activity multiplier + goal adjustment.
abstract final class CalorieCalculator {
  static CalorieTarget compute({
    required double weightKg,
    required double heightCm,
    required int age,
    required ActivityLevel activityLevel,
    required FitnessGoal goal,
  }) {
    final bmr = 10 * weightKg + 6.25 * heightCm - 5 * age + 5;
    final tdee = (bmr * _activityMultiplier(activityLevel)).round();
    final calories = _applyGoal(tdee, goal);

    final proteinG = (weightKg * 1.6).round().clamp(80, 220);
    final fatG = (calories * 0.25 / 9).round();
    final carbsG = ((calories - proteinG * 4 - fatG * 9) / 4).round().clamp(100, 400);

    return CalorieTarget(
      calories: calories,
      proteinG: proteinG,
      carbsG: carbsG,
      fatG: fatG,
    );
  }

  static double _activityMultiplier(ActivityLevel level) {
    return switch (level) {
      ActivityLevel.sedentary => 1.2,
      ActivityLevel.moderatelyActive => 1.55,
      ActivityLevel.veryActive => 1.725,
    };
  }

  static int _applyGoal(int tdee, FitnessGoal goal) {
    return switch (goal) {
      FitnessGoal.weightLoss => (tdee - 500).clamp(1200, 4000),
      FitnessGoal.muscleGain => (tdee + 300).clamp(1500, 4500),
      FitnessGoal.generalVitality => tdee.clamp(1400, 4000),
      FitnessGoal.allOfAbove => tdee.clamp(1400, 4000),
    };
  }
}
