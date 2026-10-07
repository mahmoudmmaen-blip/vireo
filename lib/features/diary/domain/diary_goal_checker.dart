import 'package:vireo/data/models/fitness_goal.dart';

abstract final class DiaryGoalChecker {
  static bool isGoalMet({
    required int proteinTotal,
    required int proteinTarget,
    required int netBalance,
    required FitnessGoal goal,
  }) {
    if (proteinTarget <= 0 || proteinTotal < proteinTarget) return false;

    return switch (goal) {
      FitnessGoal.weightLoss => netBalance >= 150 && netBalance <= 750,
      FitnessGoal.muscleGain => netBalance >= -250 && netBalance <= 350,
      FitnessGoal.generalVitality => netBalance >= -150 && netBalance <= 250,
      FitnessGoal.allOfAbove => netBalance >= -100 && netBalance <= 300,
    };
  }
}
