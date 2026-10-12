import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/home/providers/daily_score_provider.dart';

void main() {
  group('calculateDailyScore Unit Tests', () {
    test('Perfect score returns 100 with correct breakdown', () {
      final breakdown = calculateDailyScore(
        stepsCurrent: 10000,
        stepsGoal: 10000,
        proteinCurrent: 150.0,
        proteinGoal: 150.0,
        caloriesCurrent: 2000,
        caloriesGoal: 2000,
        waterMlCurrent: 3000,
        waterMlGoal: 3000,
        workoutCompleted: true,
        sleepHours: 8.0,
        isArabic: false,
      );

      expect(breakdown.stepsScore, 25.0);
      expect(breakdown.proteinScore, 20.0);
      expect(breakdown.caloriesScore, 15.0);
      expect(breakdown.waterScore, 15.0);
      expect(breakdown.workoutScore, 15.0);
      expect(breakdown.sleepScore, 10.0);
      expect(breakdown.totalScore, 100);
      expect(breakdown.tips.isEmpty, isTrue);
    });

    test('Zero activity returns 0 with all tips populated', () {
      final breakdown = calculateDailyScore(
        stepsCurrent: 0,
        stepsGoal: 10000,
        proteinCurrent: 0,
        proteinGoal: 120,
        caloriesCurrent: 0,
        caloriesGoal: 2000,
        waterMlCurrent: 0,
        waterMlGoal: 2500,
        workoutCompleted: false,
        sleepHours: 0,
        isArabic: true,
      );

      expect(breakdown.stepsScore, 0.0);
      expect(breakdown.proteinScore, 0.0);
      expect(breakdown.caloriesScore, 0.0);
      expect(breakdown.waterScore, 0.0);
      expect(breakdown.workoutScore, 0.0);
      expect(breakdown.sleepScore, 0.0);
      expect(breakdown.totalScore, 0);
      expect(breakdown.tips.length, 6);
    });

    test('Calories within ±10% gets full 15 points, beyond ±10% scales down', () {
      // 5% difference
      final within10 = calculateDailyScore(
        stepsCurrent: 0,
        stepsGoal: 10000,
        proteinCurrent: 0,
        proteinGoal: 100,
        caloriesCurrent: 2050,
        caloriesGoal: 2000,
        waterMlCurrent: 0,
        waterMlGoal: 2000,
        workoutCompleted: false,
        sleepHours: 0,
        isArabic: false,
      );
      expect(within10.caloriesScore, 15.0);

      // 15% difference (between 10% and 20%)
      final within20 = calculateDailyScore(
        stepsCurrent: 0,
        stepsGoal: 10000,
        proteinCurrent: 0,
        proteinGoal: 100,
        caloriesCurrent: 2300,
        caloriesGoal: 2000,
        waterMlCurrent: 0,
        waterMlGoal: 2000,
        workoutCompleted: false,
        sleepHours: 0,
        isArabic: false,
      );
      expect(within20.caloriesScore, 10.0);

      // 25% difference (between 20% and 30%)
      final within30 = calculateDailyScore(
        stepsCurrent: 0,
        stepsGoal: 10000,
        proteinCurrent: 0,
        proteinGoal: 100,
        caloriesCurrent: 2500,
        caloriesGoal: 2000,
        waterMlCurrent: 0,
        waterMlGoal: 2000,
        workoutCompleted: false,
        sleepHours: 0,
        isArabic: false,
      );
      expect(within30.caloriesScore, 5.0);

      // 35% difference
      final beyond30 = calculateDailyScore(
        stepsCurrent: 0,
        stepsGoal: 10000,
        proteinCurrent: 0,
        proteinGoal: 100,
        caloriesCurrent: 2800,
        caloriesGoal: 2000,
        waterMlCurrent: 0,
        waterMlGoal: 2000,
        workoutCompleted: false,
        sleepHours: 0,
        isArabic: false,
      );
      expect(beyond30.caloriesScore, 0.0);
    });

    test('Sleep >= 7h gets full 10 points, proportional below 7h', () {
      final sleep7 = calculateDailyScore(
        stepsCurrent: 0,
        stepsGoal: 10000,
        proteinCurrent: 0,
        proteinGoal: 100,
        caloriesCurrent: 0,
        caloriesGoal: 2000,
        waterMlCurrent: 0,
        waterMlGoal: 2000,
        workoutCompleted: false,
        sleepHours: 7.0,
        isArabic: false,
      );
      expect(sleep7.sleepScore, 10.0);

      final sleep3Half = calculateDailyScore(
        stepsCurrent: 0,
        stepsGoal: 10000,
        proteinCurrent: 0,
        proteinGoal: 100,
        caloriesCurrent: 0,
        caloriesGoal: 2000,
        waterMlCurrent: 0,
        waterMlGoal: 2000,
        workoutCompleted: false,
        sleepHours: 3.5,
        isArabic: false,
      );
      expect(sleep3Half.sleepScore, 5.0);
    });

    test('Score bands map to appropriate colors and labels', () {
      final low = calculateDailyScore(
        stepsCurrent: 5000, // 12.5
        stepsGoal: 10000,
        proteinCurrent: 0,
        proteinGoal: 100,
        caloriesCurrent: 0,
        caloriesGoal: 2000,
        waterMlCurrent: 0,
        waterMlGoal: 2000,
        workoutCompleted: false,
        sleepHours: 0,
        isArabic: true,
      );
      expect(low.totalScore, lessThan(40));
      expect(low.scoreTierLabel, 'يحتاج اهتمام 🎯');

      final mid = calculateDailyScore(
        stepsCurrent: 10000, // 25
        stepsGoal: 10000,
        proteinCurrent: 100, // 20
        proteinGoal: 100,
        caloriesCurrent: 0,
        caloriesGoal: 2000,
        waterMlCurrent: 0,
        waterMlGoal: 2000,
        workoutCompleted: false,
        sleepHours: 0,
        isArabic: true,
      );
      expect(mid.totalScore, inInclusiveRange(40, 69));
      expect(mid.scoreTierLabel, 'مقبول ⚡');

      final high = calculateDailyScore(
        stepsCurrent: 10000, // 25
        stepsGoal: 10000,
        proteinCurrent: 100, // 20
        proteinGoal: 100,
        caloriesCurrent: 2000, // 15
        caloriesGoal: 2000,
        waterMlCurrent: 2000, // 15
        waterMlGoal: 2000,
        workoutCompleted: true, // 15
        sleepHours: 0,
        isArabic: true,
      );
      expect(high.totalScore, greaterThanOrEqualTo(70));
      expect(high.scoreTierLabel, 'ممتاز 🔥');
    });
  });
}
