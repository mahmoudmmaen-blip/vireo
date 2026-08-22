import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/utils/walking_goal_calculator.dart';
import 'package:vireo/data/models/activity_level.dart';

void main() {
  group('WalkingGoalCalculator §2.5 daily goals', () {
    final start = DateTime(2026, 1, 1);

    test('baseGoalFor maps activity levels', () {
      expect(WalkingGoalCalculator.baseGoalFor(ActivityLevel.sedentary), 5000);
      expect(
        WalkingGoalCalculator.baseGoalFor(ActivityLevel.moderatelyActive),
        7500,
      );
      expect(
        WalkingGoalCalculator.baseGoalFor(ActivityLevel.veryActive),
        10000,
      );
    });

    test('dailyGoal returns base on day 0', () {
      expect(
        WalkingGoalCalculator.dailyGoal(
          activityLevel: ActivityLevel.moderatelyActive,
          goalStartDate: start,
          referenceDate: start,
        ),
        7500,
      );
    });

    test('dailyGoal increases by 500 every 14 days', () {
      expect(
        WalkingGoalCalculator.dailyGoal(
          activityLevel: ActivityLevel.moderatelyActive,
          goalStartDate: start,
          referenceDate: start.add(const Duration(days: 14)),
        ),
        8000,
      );
      expect(
        WalkingGoalCalculator.dailyGoal(
          activityLevel: ActivityLevel.moderatelyActive,
          goalStartDate: start,
          referenceDate: start.add(const Duration(days: 28)),
        ),
        8500,
      );
    });

    test('dailyGoal is capped at maxGoal', () {
      expect(
        WalkingGoalCalculator.dailyGoal(
          activityLevel: ActivityLevel.veryActive,
          goalStartDate: start,
          referenceDate: start.add(const Duration(days: 365)),
        ),
        WalkingGoalCalculator.maxGoal,
      );
    });
  });
}
