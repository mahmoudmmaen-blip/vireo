import 'package:vireo/data/models/activity_level.dart';

/// Computes daily step goals that ramp every 2 weeks based on activity level.
abstract final class WalkingGoalCalculator {
  static const goalStartKey = 'walking_goal_start_date';
  static const goalPeriodDays = 14;
  static const incrementPerPeriod = 500;
  static const maxGoal = 15000;

  static int baseGoalFor(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.sedentary:
        return 5000;
      case ActivityLevel.moderatelyActive:
        return 7500;
      case ActivityLevel.veryActive:
        return 10000;
    }
  }

  static int dailyGoal({
    required ActivityLevel activityLevel,
    required DateTime goalStartDate,
    DateTime? referenceDate,
  }) {
    final now = referenceDate ?? DateTime.now();
    final start = DateTime(goalStartDate.year, goalStartDate.month, goalStartDate.day);
    final today = DateTime(now.year, now.month, now.day);
    final daysSinceStart = today.difference(start).inDays;
    final periods = daysSinceStart < 0 ? 0 : daysSinceStart ~/ goalPeriodDays;
    final base = baseGoalFor(activityLevel);
    final goal = base + (periods * incrementPerPeriod);
    return goal.clamp(base, maxGoal);
  }
}
