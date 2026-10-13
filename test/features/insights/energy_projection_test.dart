import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/insights/domain/energy_projection.dart';

void main() {
  group('EnergyProjectionCalculator', () {
    test('calculateBmr applies Mifflin-St Jeor accurately', () {
      // 80kg, 180cm, 30yo male: 10*80 + 6.25*180 - 5*30 + 5 = 800 + 1125 - 150 + 5 = 1780
      final bmrMale = EnergyProjectionCalculator.calculateBmr(
        weightKg: 80,
        heightCm: 180,
        age: 30,
        isFemale: false,
      );
      expect(bmrMale, equals(1780.0));

      // 60kg, 165cm, 28yo female: 10*60 + 6.25*165 - 5*28 - 161 = 600 + 1031.25 - 140 - 161 = 1330.25
      final bmrFemale = EnergyProjectionCalculator.calculateBmr(
        weightKg: 60,
        heightCm: 165,
        age: 28,
        isFemale: true,
      );
      expect(bmrFemale, equals(1330.25));
    });

    test('deficitToFatGrams maps kcal to grams using 7.7 kcal/g', () {
      expect(EnergyProjectionCalculator.deficitToFatGrams(7700), closeTo(1000.0, 0.01));
      expect(EnergyProjectionCalculator.deficitToFatGrams(3850), closeTo(500.0, 0.01));
      expect(EnergyProjectionCalculator.deficitToFatGrams(0), equals(0.0));
      expect(EnergyProjectionCalculator.deficitToFatGrams(-500), equals(0.0));
    });

    test('guard against insufficient data (< 3 days)', () {
      final res = EnergyProjectionCalculator.compute(
        dailyRecords: [
          (eatenKcal: 1800, burnedKcal: 400),
          (eatenKcal: 1700, burnedKcal: 450),
        ],
        currentWeightKg: 85.0,
        heightCm: 175.0,
        age: 25,
        isFemale: false,
      );

      expect(res.hasSufficientData, isFalse);
      expect(res.dataDaysCount, equals(2));
      expect(res.projectedWeight2Weeks, equals(85.0));
    });

    test('projects weight loss and weeks to goal with >= 3 days', () {
      // BMR ~1800, burned ~400 -> TDEE 2200. Eaten 1700 -> Deficit 500/day.
      final res = EnergyProjectionCalculator.compute(
        dailyRecords: [
          (eatenKcal: 1700, burnedKcal: 400),
          (eatenKcal: 1700, burnedKcal: 400),
          (eatenKcal: 1700, burnedKcal: 400),
          (eatenKcal: 1700, burnedKcal: 400),
        ],
        currentWeightKg: 80.0,
        goalWeightKg: 76.0,
        heightCm: 180.0,
        age: 30,
        isFemale: false,
      );

      expect(res.hasSufficientData, isTrue);
      expect(res.averageDailyDeficit, closeTo(480.0, 20.0));
      // 500 kcal/day * 7 / 7700 = 0.45 kg/week loss -> 80 - 0.9 = 79.1 at 2 weeks
      expect(res.projectedWeight2Weeks, closeTo(79.1, 0.3));
      expect(res.weeksToGoalWeight, isNotNull);
      // 4 kg / ~0.45 kg/week ≈ 8.8 weeks
      expect(res.weeksToGoalWeight!, closeTo(9.0, 1.5));
    });

    test('clamps aggressive deficit to ≤ 1.0% body weight per week', () {
      // 70kg user -> 1% is 0.7kg/week = 0.7 * 7700 / 7 = 770 kcal/day max safe deficit
      // Simulating extreme deficit of 1500 kcal/day
      final res = EnergyProjectionCalculator.compute(
        dailyRecords: [
          (eatenKcal: 1000, burnedKcal: 800), // Day TDEE ~2500 - 1000 = 1500 deficit
          (eatenKcal: 1000, burnedKcal: 800),
          (eatenKcal: 1000, burnedKcal: 800),
        ],
        currentWeightKg: 70.0,
        heightCm: 170.0,
        age: 30,
        isFemale: false,
      );

      expect(res.hasSufficientData, isTrue);
      expect(res.isDeficitTooAggressive, isTrue);
      expect(res.isClampedToSafeLimit, isTrue);
      expect(res.averageDailyDeficit, closeTo(770.0, 1.0));
    });
  });
}
