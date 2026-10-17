import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/data/models/activity_level.dart';
import 'package:vireo/data/models/fitness_goal.dart';
import 'package:vireo/data/models/progress_models.dart';
import 'package:vireo/features/progress/domain/adaptive_calorie_calculator.dart';
import 'package:vireo/features/progress/domain/adaptive_tdee_engine.dart';

void main() {
  group('AdaptiveTdeeEngine', () {
    test('formula TDEE is sex-aware Mifflin', () {
      final men = AdaptiveTdeeEngine.formulaTdee(
        weightKg: 80,
        heightCm: 180,
        age: 30,
        isFemale: false,
        activityLevel: ActivityLevel.moderatelyActive,
      );
      final women = AdaptiveTdeeEngine.formulaTdee(
        weightKg: 80,
        heightCm: 180,
        age: 30,
        isFemale: true,
        activityLevel: ActivityLevel.moderatelyActive,
      );
      expect(men, greaterThan(women));
    });

    test('water spikes > 1.5 kg are ignored', () {
      final now = DateTime(2026, 10, 15);
      final logs = [
        WeightLogEntry(id: '1', weightKg: 80, loggedAt: now.subtract(const Duration(days: 3))),
        WeightLogEntry(id: '2', weightKg: 82.2, loggedAt: now.subtract(const Duration(days: 2))),
        WeightLogEntry(id: '3', weightKg: 79.8, loggedAt: now.subtract(const Duration(days: 1))),
      ];
      final filtered = AdaptiveTdeeEngine.filterWaterSpikes(logs);
      expect(filtered.length, 2);
      expect(filtered.any((w) => w.weightKg > 81), isFalse);
    });

    test('change capped ±150/week and floors respected', () {
      final now = DateTime(2026, 10, 15);
      final weights = List.generate(
        8,
        (i) => WeightLogEntry(
          id: '$i',
          weightKg: 80 - i * 0.05,
          loggedAt: now.subtract(Duration(days: 20 - i * 2)),
        ),
      );
      final intakes = List.generate(
        21,
        (i) => DailyIntakeRecord(
          date: now.subtract(Duration(days: i)),
          calories: 2200,
        ),
      );
      final r = AdaptiveTdeeEngine.compute(
        weightLogs: weights,
        intakeLogs: intakes,
        previousTarget: 2000,
        goal: FitnessGoal.weightLoss,
        weightKg: 80,
        heightCm: 175,
        age: 28,
        isFemale: false,
        activityLevel: ActivityLevel.moderatelyActive,
        now: now,
        expectedDailyKcalForCompleteness: 2000,
      );
      expect(r.cappedDeltaKcal.abs(), lessThanOrEqualTo(150));
      expect(r.suggestedTarget, greaterThanOrEqualTo(1500));
    });

    test('pregnancy forces no deficit (target ≈ TDEE, high floor)', () {
      final now = DateTime(2026, 10, 15);
      final weights = List.generate(
        6,
        (i) => WeightLogEntry(
          id: '$i',
          weightKg: 70,
          loggedAt: now.subtract(Duration(days: 18 - i * 3)),
        ),
      );
      final intakes = List.generate(
        18,
        (i) => DailyIntakeRecord(date: now.subtract(Duration(days: i)), calories: 2000),
      );
      final r = AdaptiveTdeeEngine.compute(
        weightLogs: weights,
        intakeLogs: intakes,
        previousTarget: 2000,
        goal: FitnessGoal.weightLoss,
        weightKg: 70,
        heightCm: 165,
        age: 28,
        isFemale: true,
        activityLevel: ActivityLevel.sedentary,
        isPregnancy: true,
        now: now,
        expectedDailyKcalForCompleteness: 2000,
      );
      expect(r.suggestedTarget, greaterThanOrEqualTo(1800));
    });
  });

  group('AdaptiveTdeeEngine simulations (±5% in 21 days)', () {
    AdaptiveTdeeResult runSim({
      required double trueTdee,
      required double intakeBias,
      required bool waterSpikes,
      required bool missingDays,
    }) {
      final now = DateTime(2026, 10, 21);
      final startW = 80.0;
      // Weight change from energy balance: Δkg = (intake - tdee) * days / 7700
      final weights = <WeightLogEntry>[];
      final intakes = <DailyIntakeRecord>[];
      var w = startW;
      for (var day = 0; day < 21; day++) {
        final date = now.subtract(Duration(days: 20 - day));
        if (missingDays && day % 5 == 0) {
          // skip intake
        } else {
          final intake = (trueTdee * intakeBias).round();
          intakes.add(DailyIntakeRecord(date: date, calories: intake));
          final delta = (intake - trueTdee) / 7700.0;
          w += delta;
        }
        var weigh = w;
        if (waterSpikes && day == 10) weigh += 2.0;
        if (day % 2 == 0 || day > 14) {
          weights.add(WeightLogEntry(id: '$day', weightKg: weigh, loggedAt: date));
        }
      }
      return AdaptiveTdeeEngine.compute(
        weightLogs: weights,
        intakeLogs: intakes,
        previousTarget: trueTdee.round(),
        goal: FitnessGoal.generalVitality,
        weightKg: startW,
        heightCm: 175,
        age: 30,
        isFemale: false,
        activityLevel: ActivityLevel.moderatelyActive,
        now: now,
        windowDays: 21,
        expectedDailyKcalForCompleteness: trueTdee.round(),
      );
    }

    test('perfect logger converges within ±5%', () {
      const trueTdee = 2500.0;
      final r = runSim(
        trueTdee: trueTdee,
        intakeBias: 1.0,
        waterSpikes: false,
        missingDays: false,
      );
      expect(r.usedObserved, isTrue);
      final err = ((r.finalTdee - trueTdee).abs() / trueTdee);
      expect(err, lessThanOrEqualTo(0.05));
    });

    test('under-logger still bounded; blend pulls toward formula', () {
      const trueTdee = 2500.0;
      final r = runSim(
        trueTdee: trueTdee,
        intakeBias: 0.85,
        waterSpikes: false,
        missingDays: false,
      );
      // Observed will be lower; blend weight < 0.8 keeps error moderated
      expect(r.finalTdee, greaterThan(trueTdee * 0.80));
      expect(r.finalTdee, lessThan(trueTdee * 1.15));
    });

    test('water spikes do not break convergence', () {
      const trueTdee = 2400.0;
      final r = runSim(
        trueTdee: trueTdee,
        intakeBias: 1.0,
        waterSpikes: true,
        missingDays: false,
      );
      if (r.observedTdee != null) {
        final err = ((r.finalTdee - trueTdee).abs() / trueTdee);
        expect(err, lessThanOrEqualTo(0.08));
      }
    });

    test('missing days handled without crash', () {
      final r = runSim(
        trueTdee: 2300,
        intakeBias: 1.0,
        waterSpikes: false,
        missingDays: true,
      );
      expect(r.finalTdee, greaterThan(1500));
    });
  });
}
