import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/fingerprint/domain/vireo_fingerprint.dart';
import 'package:vireo/features/progress/domain/pattern_detector.dart';

List<DayNutritionSample> _days({
  required int n,
  required int stepsBase,
  required int surplusWeekend,
}) {
  final now = DateTime(2026, 10, 17);
  return List.generate(n, (i) {
    final d = now.subtract(Duration(days: n - 1 - i));
    final weekend = d.weekday == DateTime.friday || d.weekday == DateTime.saturday;
    return DayNutritionSample(
      date: d,
      intakeKcal: 2000 + (weekend ? surplusWeekend : 0),
      targetKcal: 2000,
      breakfastProteinG: 15,
      proteinTargetG: 120,
      lateNightKcal: 0,
      steps: stepsBase + (i % 3) * 200,
      stepGoal: stepsBase + 1000,
      hasLog: true,
    );
  });
}

void main() {
  group('FingerprintLearner', () {
    test('sedentary profile stays bounded', () {
      final fp = FingerprintLearner.learn(
        days: _days(n: 21, stepsBase: 2500, surplusWeekend: 0),
        hourlyStepTotals: List.filled(24, 100)..[8] = 800,
        favoriteFoodIds: ['ful', 'eggs'],
        deficitHistory: [(deficit: 300, nextDayRebound: false)],
      );
      expect(fp.ready, isTrue);
      expect(fp.activity.comfortableSteps, lessThan(6000));
      expect(fp.activity.stepGoal(currentGoal: 3000, weeksProgressing: 1), lessThanOrEqualTo(10000));
    });

    test('active walker has higher comfortable + peak', () {
      final fp = FingerprintLearner.learn(
        days: _days(n: 21, stepsBase: 12000, surplusWeekend: 0),
        hourlyStepTotals: List.filled(24, 200)..[18] = 3000,
        favoriteFoodIds: const [],
        deficitHistory: [(deficit: 500, nextDayRebound: false)],
      );
      expect(fp.activity.comfortableSteps, greaterThan(8000));
      expect(fp.activity.peakSteps, greaterThan(fp.activity.comfortableSteps));
    });

    test('weekend overeater hard day is weekend', () {
      final fp = FingerprintLearner.learn(
        days: _days(n: 21, stepsBase: 5000, surplusWeekend: 600),
        hourlyStepTotals: List.filled(24, 100),
        favoriteFoodIds: const [],
        deficitHistory: const [],
      );
      expect(
        fp.nutrition.hardWeekday == DateTime.friday ||
            fp.nutrition.hardWeekday == DateTime.saturday,
        isTrue,
      );
    });

    test('shift worker chronotype uses log hours', () {
      final fp = FingerprintLearner.learn(
        days: _days(n: 14, stepsBase: 4000, surplusWeekend: 0),
        hourlyStepTotals: List.filled(24, 50)..[22] = 900,
        favoriteFoodIds: const [],
        deficitHistory: const [],
        mealLogHours: [22, 23, 22, 21],
      );
      expect(fp.chronotype.typicalLogHour, greaterThanOrEqualTo(20));
    });

    test('step goal progressive +500/week max, never above peak+15%', () {
      final fp = FingerprintLearner.learn(
        days: _days(n: 21, stepsBase: 5000, surplusWeekend: 0),
        hourlyStepTotals: List.filled(24, 100),
        favoriteFoodIds: const [],
        deficitHistory: const [],
      );
      final g0 = fp.activity.stepGoal(currentGoal: 5000, weeksProgressing: 0);
      final g2 = fp.activity.stepGoal(currentGoal: 5000, weeksProgressing: 2);
      expect(g2 - 5000, lessThanOrEqualTo(1000));
      expect(g0, lessThanOrEqualTo((fp.activity.peakSteps * 1.15).round()));
    });

    test('tolerance capped by safety floors', () {
      final fp = FingerprintLearner.learn(
        days: _days(n: 14, stepsBase: 5000, surplusWeekend: 0),
        hourlyStepTotals: List.filled(24, 100),
        favoriteFoodIds: const [],
        deficitHistory: [(deficit: 2000, nextDayRebound: false)],
      );
      final capped = fp.tolerance.cappedDeficit(
        weightKg: 70,
        isFemale: true,
        isPregnancy: false,
        isUnder18: false,
      );
      expect(capped, lessThanOrEqualTo(1200));
      expect(
        fp.tolerance.cappedDeficit(
          weightKg: 70,
          isFemale: true,
          isPregnancy: true,
          isUnder18: false,
        ),
        0,
      );
    });
  });
}
