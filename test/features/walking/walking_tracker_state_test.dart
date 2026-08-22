import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/data/models/daily_step_count.dart';
import 'package:vireo/features/walking/providers/walking_tracker_provider.dart';

void main() {
  group('WalkingTrackerState §2.5 progress ring data', () {
    test('progress clamps steps to daily goal ratio', () {
      const state = WalkingTrackerState(
        status: HealthStepsStatus.granted,
        todaySteps: 3750,
        dailyGoal: 7500,
      );
      expect(state.progress, 0.5);
    });

    test('progress caps at 1.0 when steps exceed goal', () {
      const state = WalkingTrackerState(
        status: HealthStepsStatus.granted,
        todaySteps: 12000,
        dailyGoal: 7500,
      );
      expect(state.progress, 1.0);
    });

    test('last7Days holds daily step entries for weekly chart', () {
      final days = List.generate(
        7,
        (i) => DailyStepCount(
          date: DateTime(2026, 8, 16 + i),
          steps: 1000 * (i + 1),
        ),
      );

      const state = WalkingTrackerState(
        status: HealthStepsStatus.granted,
        last7Days: [],
      );

      expect(days.length, 7);
      expect(state.copyWith(last7Days: days).last7Days.length, 7);
    });
  });

  group('HealthStepsStatus §2.5 HealthKit / Health Connect states', () {
    test('covers granted, denied, and unavailable flows', () {
      expect(HealthStepsStatus.values, containsAll([
        HealthStepsStatus.granted,
        HealthStepsStatus.denied,
        HealthStepsStatus.unavailable,
      ]));
    });
  });
}
