import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/progress/domain/pattern_detector.dart';

void main() {
  test('detects weekend overeating from 2 weeks', () {
    final now = DateTime(2026, 10, 17);
    final days = List.generate(14, (i) {
      final d = now.subtract(Duration(days: 13 - i));
      final weekend = d.weekday == DateTime.friday || d.weekday == DateTime.saturday;
      return DayNutritionSample(
        date: d,
        intakeKcal: weekend ? 2600 : 2000,
        targetKcal: 2000,
        breakfastProteinG: 25,
        proteinTargetG: 120,
        lateNightKcal: 0,
        steps: 6000,
        stepGoal: 8000,
        hasLog: true,
      );
    });
    final insight = PatternDetector.detect(
      days: days,
      trendSlopeKgPerDay: -0.02,
      adherenceRatio: 0.85,
    );
    expect(insight?.kind, PatternKind.weekendOvereating);
  });

  test('notification budget respects max 3 and quiet hours', () {
    expect(
      NotificationBudget.canSend(sentToday: 3, hour: 12, ignoredCountForType: 0),
      isFalse,
    );
    expect(
      NotificationBudget.canSend(sentToday: 1, hour: 23, ignoredCountForType: 0),
      isFalse,
    );
    expect(
      NotificationBudget.canSend(sentToday: 1, hour: 12, ignoredCountForType: 3),
      isFalse,
    );
    expect(
      NotificationBudget.canSend(sentToday: 1, hour: 12, ignoredCountForType: 0),
      isTrue,
    );
  });
}
