import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/progress/domain/rebalance_engine.dart';

void main() {
  group('RebalanceEngine', () {
    test('surplus ≤ 150 → safe message, no auto options required', () {
      final r = RebalanceEngine.evaluate(
        intakeKcal: 2100,
        targetKcal: 2000,
        proteinG: 100,
        proteinTargetG: 120,
        steps: 6000,
        stepGoal: 8000,
        weightKg: 75,
        strideMeters: 0.72,
        isFemale: false,
        isPregnancy: false,
        isUnder18: false,
        hourOfDay: 15,
        isRamadan: false,
      );
      expect(r.kind, RebalanceKind.safeSurplus);
      expect(r.requiresUserTap, isTrue);
    });

    test('surplus options include walk/spread and never auto-apply', () {
      final r = RebalanceEngine.evaluate(
        intakeKcal: 2400,
        targetKcal: 2000,
        proteinG: 100,
        proteinTargetG: 120,
        steps: 6000,
        stepGoal: 8000,
        weightKg: 75,
        strideMeters: 0.72,
        isFemale: false,
        isPregnancy: false,
        isUnder18: false,
        hourOfDay: 14,
        isRamadan: false,
        lighterMealSwaps: [(nameAr: 'شوفان', saveKcal: 120)],
      );
      expect(r.kind, RebalanceKind.surplusOptions);
      expect(r.options.length, inInclusiveRange(2, 3));
      expect(r.requiresUserTap, isTrue);
      expect(r.options.any((o) => o.id == RebalanceOptionId.walkOff), isTrue);
    });

    test('huge surplus > 1000 is exceptional and never shames', () {
      final r = RebalanceEngine.evaluate(
        intakeKcal: 3500,
        targetKcal: 2000,
        proteinG: 100,
        proteinTargetG: 120,
        steps: 6000,
        stepGoal: 8000,
        weightKg: 75,
        strideMeters: 0.72,
        isFemale: false,
        isPregnancy: false,
        isUnder18: false,
        hourOfDay: 14,
        isRamadan: false,
      );
      expect(r.kind, RebalanceKind.exceptionalDay);
      expect(r.messageAr.contains('استثنائي'), isTrue);
      expect(r.messageAr.contains('عقاب'), isFalse);
      expect(r.messageAr.contains('فشلت'), isFalse);
    });

    test('spread respects floor and ≤250/day', () {
      final r = RebalanceEngine.evaluate(
        intakeKcal: 2600,
        targetKcal: 2000,
        proteinG: 100,
        proteinTargetG: 120,
        steps: 6000,
        stepGoal: 8000,
        weightKg: 75,
        strideMeters: 0.72,
        isFemale: true,
        isPregnancy: false,
        isUnder18: false,
        hourOfDay: 14,
        isRamadan: false,
      );
      final spread = r.options.firstWhere((o) => o.id == RebalanceOptionId.spread);
      expect(spread.payload['per_day']!, lessThanOrEqualTo(250));
      expect(spread.payload['day_1']!, greaterThanOrEqualTo(1200));
    });

    test('Ramadan shifts steps-behind window', () {
      final hours = RebalanceEngine.scheduleHours(isRamadan: true);
      expect(hours.stepsBehindHour, greaterThanOrEqualTo(20));
      final r = RebalanceEngine.evaluate(
        intakeKcal: 1800,
        targetKcal: 2000,
        proteinG: 90,
        proteinTargetG: 120,
        steps: 1000,
        stepGoal: 8000,
        weightKg: 75,
        strideMeters: 0.72,
        isFemale: false,
        isPregnancy: false,
        isUnder18: false,
        hourOfDay: 21,
        isRamadan: true,
      );
      expect(r.kind, RebalanceKind.stepsBehind);
    });

    test('large deficit by 8pm suggests protein snack', () {
      final r = RebalanceEngine.evaluate(
        intakeKcal: 1400,
        targetKcal: 2000,
        proteinG: 90,
        proteinTargetG: 120,
        steps: 7000,
        stepGoal: 8000,
        weightKg: 75,
        strideMeters: 0.72,
        isFemale: false,
        isPregnancy: false,
        isUnder18: false,
        hourOfDay: 20,
        isRamadan: false,
      );
      expect(r.kind, RebalanceKind.largeDeficitSnack);
    });
  });
}
