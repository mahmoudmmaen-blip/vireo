import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/measurements/domain/body_composition_report.dart';
import 'package:vireo/features/measurements/domain/navy_tape_calculator.dart';

void main() {
  group('NavyTapeMeasureCalculator', () {
    test('computes male body fat against known reference values', () {
      // Reference male:
      // Height: 180 cm (~70.866 in)
      // Neck: 38 cm (~14.961 in)
      // Waist: 86 cm (~33.858 in)
      // Weight: 80 kg, Age: 28
      // Expected US Navy BF%: ~16.9%
      final res = NavyTapeMeasureCalculator.compute(
        waistCm: 86.0,
        neckCm: 38.0,
        heightCm: 180.0,
        weightKg: 80.0,
        isFemale: false,
        age: 28,
      );

      expect(res, isNotNull);
      expect(res!.bodyFatPercent, closeTo(16.9, 0.3));
      expect(res.category, equals(BodyFatCategory.fit));
      expect(res.bmi, closeTo(24.7, 0.2));
      // Fat mass: 80 * 0.169 = ~13.5 kg
      expect(res.fatMassKg, closeTo(13.5, 0.3));
      // Lean mass: 80 - 13.5 = ~66.5 kg
      expect(res.leanMassKg, closeTo(66.5, 0.3));
      // Katch-McArdle BMR = 370 + 21.6 * leanMass (~1806 kcal)
      expect(res.bmrKcal, closeTo(1806.0, 5.0));
    });

    test('computes female body fat against known reference values', () {
      // Reference female:
      // Height: 165 cm (~64.96 in)
      // Neck: 34 cm (~13.386 in)
      // Waist: 72 cm (~28.346 in)
      // Hip: 98 cm (~38.583 in)
      // Weight: 62 kg, Age: 28
      // Expected US Navy BF%: ~26.7%
      final res = NavyTapeMeasureCalculator.compute(
        waistCm: 72.0,
        neckCm: 34.0,
        heightCm: 165.0,
        weightKg: 62.0,
        isFemale: true,
        hipCm: 98.0,
        age: 28,
      );

      expect(res, isNotNull);
      expect(res!.bodyFatPercent, closeTo(26.7, 0.3));
      expect(res.category, equals(BodyFatCategory.average));
      expect(res.bmi, closeTo(22.8, 0.2));
      // Fat mass: 62 * 0.267 = ~16.5 kg
      expect(res.fatMassKg, closeTo(16.5, 0.3));
      // Lean mass: 62 - 16.5 = ~45.5 kg
      expect(res.leanMassKg, closeTo(45.5, 0.3));
      // Katch-McArdle BMR = 370 + 21.6 * 45.5 = ~1352 kcal
      expect(res.bmrKcal, closeTo(1352.0, 5.0));
    });

    test('returns null when inputs are invalid or incomplete', () {
      expect(
        NavyTapeMeasureCalculator.compute(
          waistCm: 0,
          neckCm: 38,
          heightCm: 180,
          weightKg: 80,
          isFemale: false,
        ),
        isNull,
      );

      expect(
        NavyTapeMeasureCalculator.compute(
          waistCm: 80,
          neckCm: 85, // waist <= neck impossible
          heightCm: 180,
          weightKg: 80,
          isFemale: false,
        ),
        isNull,
      );
    });

    test('toReport produces valid BodyCompositionReport with navyTape source', () {
      final res = NavyTapeMeasureCalculator.compute(
        waistCm: 86.0,
        neckCm: 38.0,
        heightCm: 180.0,
        weightKg: 80.0,
        isFemale: false,
      )!;

      final report = res.toReport(weightKg: 80.0);
      expect(report.source, equals(BodyCompositionSource.navyTape));
      expect(report.weightKg, equals(80.0));
      expect(report.percentBodyFat, equals(res.bodyFatPercent));
      expect(report.skeletalMuscleMassKg, equals(res.leanMassKg));
      expect(report.bmrKcal, equals(res.bmrKcal));
    });
  });

  group('Katch-McArdle Formula', () {
    test('calculates BMR accurately from lean mass', () {
      // 370 + 21.6 * 60 = 370 + 1296 = 1666 kcal
      expect(BodyCompositionMath.katchMcArdleBmr(60.0), closeTo(1666.0, 0.01));
      // 370 + 21.6 * 70 = 370 + 1512 = 1882 kcal
      expect(BodyCompositionMath.katchMcArdleBmr(70.0), closeTo(1882.0, 0.01));
    });
  });
}
