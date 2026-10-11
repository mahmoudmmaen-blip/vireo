import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/data/models/fitness_goal.dart';
import 'package:vireo/data/models/progress_models.dart';
import 'package:vireo/features/progress/domain/adaptive_calorie_calculator.dart';

void main() {
  group('AdaptiveCalorieCalculator — data sufficiency', () {
    final now = DateTime(2026, 10, 15);

    test('not enough days (< 14 days) -> no suggestion (isEligible == false)', () {
      final weights = [
        WeightLogEntry(id: '1', weightKg: 80.0, loggedAt: now.subtract(const Duration(days: 7))),
        WeightLogEntry(id: '2', weightKg: 79.8, loggedAt: now.subtract(const Duration(days: 5))),
        WeightLogEntry(id: '3', weightKg: 79.5, loggedAt: now.subtract(const Duration(days: 3))),
        WeightLogEntry(id: '4', weightKg: 79.2, loggedAt: now.subtract(const Duration(days: 1))),
      ];
      final intakes = List.generate(
        10,
        (i) => DailyIntakeRecord(date: now.subtract(Duration(days: i)), calories: 2000),
      );

      final result = AdaptiveCalorieCalculator.calculate(
        weightLogs: weights,
        intakeLogs: intakes,
        currentCalorieTarget: 2200,
        goal: FitnessGoal.weightLoss,
        now: now,
      );

      expect(result.isEligible, isFalse);
      expect(result.suggestedCalorieTarget, equals(2200));
      expect(result.appliedDeltaKcal, equals(0));
      expect(result.ineligibilityReason, contains('14 days'));
    });

    test('not enough food logs (< 10 logged days) -> no suggestion', () {
      final weights = [
        WeightLogEntry(id: '1', weightKg: 80.0, loggedAt: now.subtract(const Duration(days: 16))),
        WeightLogEntry(id: '2', weightKg: 79.5, loggedAt: now.subtract(const Duration(days: 11))),
        WeightLogEntry(id: '3', weightKg: 79.0, loggedAt: now.subtract(const Duration(days: 6))),
        WeightLogEntry(id: '4', weightKg: 78.5, loggedAt: now.subtract(const Duration(days: 1))),
      ];
      final intakes = List.generate(
        8, // only 8 food logs
        (i) => DailyIntakeRecord(date: now.subtract(Duration(days: i * 2)), calories: 2000),
      );

      final result = AdaptiveCalorieCalculator.calculate(
        weightLogs: weights,
        intakeLogs: intakes,
        currentCalorieTarget: 2200,
        goal: FitnessGoal.weightLoss,
        now: now,
      );

      expect(result.isEligible, isFalse);
      expect(result.ineligibilityReason, contains('10 logged food days'));
    });

    test('not enough weigh-ins (< 4 weigh-ins) -> no suggestion', () {
      final weights = [
        WeightLogEntry(id: '1', weightKg: 80.0, loggedAt: now.subtract(const Duration(days: 16))),
        WeightLogEntry(id: '2', weightKg: 79.5, loggedAt: now.subtract(const Duration(days: 10))),
        WeightLogEntry(id: '3', weightKg: 79.0, loggedAt: now.subtract(const Duration(days: 1))),
      ]; // only 3 weigh-ins
      final intakes = List.generate(
        14,
        (i) => DailyIntakeRecord(date: now.subtract(Duration(days: i)), calories: 2000),
      );

      final result = AdaptiveCalorieCalculator.calculate(
        weightLogs: weights,
        intakeLogs: intakes,
        currentCalorieTarget: 2200,
        goal: FitnessGoal.weightLoss,
        now: now,
      );

      expect(result.isEligible, isFalse);
      expect(result.ineligibilityReason, contains('4 weigh-ins'));
    });
  });

  group('AdaptiveCalorieCalculator — math, ±150 cap, floor', () {
    final now = DateTime(2026, 10, 20);

    test('weekly change is capped at +150 kcal max', () {
      // User intake was 2800 kcal, but lost 2.0 kg over 16 days
      // Energy surplus/deficit = -2.0 kg * 7700 / 16 = -962.5 kcal/day
      // Maintenance = 2800 - (-962.5) = 3762 kcal
      // Ideal target for weight loss = ~3262 kcal
      // Current target is 2000 kcal -> ideal delta is +1262 kcal!
      // Must cap at +150 kcal -> 2150 kcal
      final weights = [
        WeightLogEntry(id: '1', weightKg: 82.0, loggedAt: now.subtract(const Duration(days: 16))),
        WeightLogEntry(id: '2', weightKg: 81.2, loggedAt: now.subtract(const Duration(days: 11))),
        WeightLogEntry(id: '3', weightKg: 80.6, loggedAt: now.subtract(const Duration(days: 6))),
        WeightLogEntry(id: '4', weightKg: 80.0, loggedAt: now.subtract(const Duration(days: 1))),
      ];
      final intakes = List.generate(
        14,
        (i) => DailyIntakeRecord(date: now.subtract(Duration(days: i + 1)), calories: 2800),
      );

      final result = AdaptiveCalorieCalculator.calculate(
        weightLogs: weights,
        intakeLogs: intakes,
        currentCalorieTarget: 2000,
        goal: FitnessGoal.weightLoss,
        now: now,
      );

      expect(result.isEligible, isTrue);
      expect(result.cappedDeltaKcal, equals(150));
      expect(result.appliedDeltaKcal, equals(150));
      expect(result.suggestedCalorieTarget, equals(2150));
    });

    test('weekly change is capped at -150 kcal max', () {
      // User intake 2400 kcal, weight gained +2.5 kg over 16 days
      // Trend weight change is positive -> maintenance is much lower
      // Current target 2400, ideal target 1700 -> raw delta -700 kcal
      // Must cap at -150 kcal -> 2250 kcal
      final weights = [
        WeightLogEntry(id: '1', weightKg: 75.0, loggedAt: now.subtract(const Duration(days: 16))),
        WeightLogEntry(id: '2', weightKg: 76.0, loggedAt: now.subtract(const Duration(days: 11))),
        WeightLogEntry(id: '3', weightKg: 76.8, loggedAt: now.subtract(const Duration(days: 6))),
        WeightLogEntry(id: '4', weightKg: 77.5, loggedAt: now.subtract(const Duration(days: 1))),
      ];
      final intakes = List.generate(
        14,
        (i) => DailyIntakeRecord(date: now.subtract(Duration(days: i + 1)), calories: 2400),
      );

      final result = AdaptiveCalorieCalculator.calculate(
        weightLogs: weights,
        intakeLogs: intakes,
        currentCalorieTarget: 2400,
        goal: FitnessGoal.weightLoss,
        now: now,
      );

      expect(result.isEligible, isTrue);
      expect(result.cappedDeltaKcal, equals(-150));
      expect(result.appliedDeltaKcal, equals(-150));
      expect(result.suggestedCalorieTarget, equals(2250));
    });

    test('calorie floor at 1500 kcal is strictly enforced (never below 1500)', () {
      // Current target is 1550 kcal. A -150 reduction would take it to 1400 kcal.
      // Floor must clamp suggested target to 1500 kcal, appliedDelta = -50 kcal.
      final weights = [
        WeightLogEntry(id: '1', weightKg: 70.0, loggedAt: now.subtract(const Duration(days: 16))),
        WeightLogEntry(id: '2', weightKg: 70.8, loggedAt: now.subtract(const Duration(days: 11))),
        WeightLogEntry(id: '3', weightKg: 71.5, loggedAt: now.subtract(const Duration(days: 6))),
        WeightLogEntry(id: '4', weightKg: 72.0, loggedAt: now.subtract(const Duration(days: 1))),
      ];
      final intakes = List.generate(
        14,
        (i) => DailyIntakeRecord(date: now.subtract(Duration(days: i + 1)), calories: 1800),
      );

      final result = AdaptiveCalorieCalculator.calculate(
        weightLogs: weights,
        intakeLogs: intakes,
        currentCalorieTarget: 1550,
        goal: FitnessGoal.weightLoss,
        now: now,
      );

      expect(result.isEligible, isTrue);
      expect(result.floorApplied, isTrue);
      expect(result.suggestedCalorieTarget, equals(1500));
      expect(result.appliedDeltaKcal, equals(-50));
    });

    test('maintenance formula: avg intake - (trend change kg * 7700 / days)', () {
      // 0 kg change over 15 days, 2200 avg intake
      // real maintenance = 2200 - 0 = 2200 kcal
      final weights = [
        WeightLogEntry(id: '1', weightKg: 75.0, loggedAt: now.subtract(const Duration(days: 15))),
        WeightLogEntry(id: '2', weightKg: 75.0, loggedAt: now.subtract(const Duration(days: 10))),
        WeightLogEntry(id: '3', weightKg: 75.0, loggedAt: now.subtract(const Duration(days: 5))),
        WeightLogEntry(id: '4', weightKg: 75.0, loggedAt: now.subtract(const Duration(days: 1))),
      ];
      final intakes = List.generate(
        14,
        (i) => DailyIntakeRecord(date: now.subtract(Duration(days: i + 1)), calories: 2200),
      );

      final result = AdaptiveCalorieCalculator.calculate(
        weightLogs: weights,
        intakeLogs: intakes,
        currentCalorieTarget: 2200,
        goal: FitnessGoal.generalVitality, // maintenance
        now: now,
      );

      expect(result.isEligible, isTrue);
      expect(result.estimatedMaintenanceKcal, equals(2200));
      expect(result.suggestedCalorieTarget, equals(2200));
      expect(result.appliedDeltaKcal, equals(0));
      expect(result.explanationFormula, contains('Maintenance = Avg Intake'));
    });
  });
}
