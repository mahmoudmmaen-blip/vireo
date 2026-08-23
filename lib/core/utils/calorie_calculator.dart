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

/// Mifflin-St Jeor TDEE with goal-specific calorie adjustment and macro splits.
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
    final calories = _caloriesForGoal(tdee, goal);

    return switch (goal) {
      FitnessGoal.weightLoss => _macrosFromRatios(
          calories: calories,
          proteinG: (weightKg * 2.0).round().clamp(90, 240),
          carbRatio: 0.30,
          fatRatio: 0.25,
        ),
      FitnessGoal.muscleGain => _macrosFromRatios(
          calories: calories,
          proteinG: (weightKg * 2.2).round().clamp(110, 260),
          carbRatio: 0.45,
          fatRatio: 0.20,
        ),
      FitnessGoal.generalVitality => _macrosFromRatios(
          calories: calories,
          proteinRatio: 0.20,
          carbRatio: 0.50,
          fatRatio: 0.30,
        ),
      FitnessGoal.allOfAbove => _macrosFromRatios(
          calories: calories,
          proteinRatio: 0.25,
          carbRatio: 0.45,
          fatRatio: 0.30,
        ),
    };
  }

  static CalorieTarget _macrosFromRatios({
    required int calories,
    int? proteinG,
    double? proteinRatio,
    double? carbRatio,
    double? fatRatio,
  }) {
    final protein = proteinG ??
        ((calories * (proteinRatio ?? 0.25)) / 4).round().clamp(60, 260);
    final fat = ((calories * (fatRatio ?? 0.30)) / 9).round().clamp(40, 120);
    var carbs = ((calories - protein * 4 - fat * 9) / 4).round();
    if (carbRatio != null) {
      carbs = ((calories * carbRatio) / 4).round();
    }
    carbs = carbs.clamp(80, 500);

    return CalorieTarget(
      calories: calories,
      proteinG: protein,
      carbsG: carbs,
      fatG: fat,
    );
  }

  static double _activityMultiplier(ActivityLevel level) {
    return switch (level) {
      ActivityLevel.sedentary => 1.2,
      ActivityLevel.moderatelyActive => 1.55,
      ActivityLevel.veryActive => 1.725,
    };
  }

  static int _caloriesForGoal(int tdee, FitnessGoal goal) {
    return switch (goal) {
      FitnessGoal.weightLoss => (tdee - 400).clamp(1200, 4000),
      FitnessGoal.muscleGain => (tdee + 300).clamp(1500, 4500),
      FitnessGoal.generalVitality => tdee.clamp(1400, 4000),
      FitnessGoal.allOfAbove => tdee.clamp(1400, 4000),
    };
  }
}
