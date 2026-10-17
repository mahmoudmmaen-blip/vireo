import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/walking/domain/walking_calculations.dart';

void main() {
  group('WalkingCalculations', () {
    test('computes stride length correctly for male and female', () {
      // 180 cm male: 180 * 0.415 / 100 = 0.747 m
      final maleStride = WalkingCalculations.computeStrideMeters(
        heightCm: 180,
        isFemale: false,
      );
      expect(maleStride, closeTo(0.747, 0.001));

      // 160 cm female: 160 * 0.413 / 100 = 0.6608 m
      final femaleStride = WalkingCalculations.computeStrideMeters(
        heightCm: 160,
        isFemale: true,
      );
      expect(femaleStride, closeTo(0.6608, 0.001));
    });

    test('computes distance in km correctly', () {
      // 10,000 steps with 0.75m stride = 7.5 km
      final dist = WalkingCalculations.computeDistanceKm(
        steps: 10000,
        strideMeters: 0.75,
      );
      expect(dist, closeTo(7.5, 0.001));

      // 0 steps = 0 km
      expect(WalkingCalculations.computeDistanceKm(steps: 0, strideMeters: 0.75), 0.0);
    });

    test('computes kcal with ACSM formula: 0.57 * weight_kg * distance_km', () {
      // 70 kg, 5 km = 0.57 * 70 * 5 = 199.5 ≈ 200 kcal
      final kcal = WalkingCalculations.computeCalories(
        weightKg: 70,
        distanceKm: 5.0,
      );
      expect(kcal, 200);

      // 0 distance = 0 kcal
      expect(WalkingCalculations.computeCalories(weightKg: 70, distanceKm: 0.0), 0);
    });

    test('computes active minutes and fat burned grams', () {
      // 6,000 steps = 60 active minutes
      expect(WalkingCalculations.computeActiveMinutes(6000), 60);

      // 385 kcal / 7.7 = 50.0 grams fat
      final fatGrams = WalkingCalculations.computeFatBurnedGrams(385);
      expect(fatGrams, closeTo(50.0, 0.01));
    });

    test('full computation returns coherent result bundle', () {
      final res = WalkingCalculations.compute(
        steps: 8000,
        heightCm: 175,
        weightKg: 80,
        isFemale: false,
      );
      expect(res.steps, 8000);
      expect(res.strideMeters, closeTo(0.72625, 0.001));
      expect(res.distanceKm, closeTo(5.81, 0.02));
      // NET ACSM/fallback ≈ 0.0005·80·0.72625·8000 ≈ 232 kcal (not gross 0.57·kg·km).
      expect(res.caloriesKcal, greaterThan(200));
      expect(res.caloriesKcal, lessThan(300));
      expect(res.activeMinutes, 80);
      expect(res.fatBurnedGrams, greaterThan(25.0));
    });
  });
}
