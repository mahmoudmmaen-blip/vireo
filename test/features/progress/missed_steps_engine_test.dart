import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/progress/domain/missed_steps_engine.dart';

void main() {
  group('MissedStepsEngine', () {
    test('spreading caps at +1500/day and peak+15%', () {
      final offer = MissedStepsEngine.evaluate(
        stepGoal: 4000,
        stepsWalked: 1200,
        weightKg: 75,
        strideMeters: 0.72,
        comfortableSteps: 3500,
        peakCapacity: 6000,
        consecutiveMissedDays: 1,
        calorieTarget: 2000,
        isFemale: false,
        isPregnancy: false,
        isUnder18: false,
      );
      expect(offer, isNotNull);
      final makeUp = offer!.options.firstWhere(
        (o) => o.choice == MissedStepsChoice.makeUpGradually,
      );
      expect(makeUp.payload['per_day']!, lessThanOrEqualTo(1500));
      expect(makeUp.payload['day_1']!, lessThanOrEqualTo((6000 * 1.15).round()));
    });

    test('food balance ≤ 200 and respects floors', () {
      final offer = MissedStepsEngine.evaluate(
        stepGoal: 8000,
        stepsWalked: 1000,
        weightKg: 70,
        strideMeters: 0.7,
        comfortableSteps: 5000,
        peakCapacity: 10000,
        consecutiveMissedDays: 0,
        calorieTarget: 1600,
        isFemale: true,
        isPregnancy: false,
        isUnder18: false,
      )!;
      final food = offer.options.firstWhere(
        (o) => o.choice == MissedStepsChoice.balanceWithFood,
      );
      expect(food.payload['kcal_cut']!, lessThanOrEqualTo(200));
      expect(food.payload['new_target']!, greaterThanOrEqualTo(1200));
    });

    test('3 missed days suggests lowering goal to بصمتك comfort', () {
      final offer = MissedStepsEngine.evaluate(
        stepGoal: 10000,
        stepsWalked: 2000,
        weightKg: 75,
        strideMeters: 0.72,
        comfortableSteps: 4500,
        peakCapacity: 9000,
        consecutiveMissedDays: 3,
        calorieTarget: 2000,
        isFemale: false,
        isPregnancy: false,
        isUnder18: false,
      )!;
      expect(offer.suggestLowerGoal, isTrue);
      expect(offer.suggestedLowerGoal, 4500);
    });

    test('start fresh option never auto-changes plan', () {
      final offer = MissedStepsEngine.evaluate(
        stepGoal: 5000,
        stepsWalked: 1000,
        weightKg: 75,
        strideMeters: 0.72,
        comfortableSteps: 4000,
        peakCapacity: 8000,
        consecutiveMissedDays: 0,
        calorieTarget: 2000,
        isFemale: false,
        isPregnancy: false,
        isUnder18: false,
      )!;
      final fresh = offer.options.firstWhere(
        (o) => o.choice == MissedStepsChoice.startFresh,
      );
      expect(fresh.payload.isEmpty, isTrue);
    });
  });
}
