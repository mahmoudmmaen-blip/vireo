import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/progress/domain/energy_ledger.dart';

void main() {
  group('EnergyLedger', () {
    Map<String, EnergyLedgerDay> sample() {
      return {
        '2026-10-15': const EnergyLedgerDay(
          dateKey: '2026-10-15',
          intakeKcal: 1800,
          adaptiveTdee: 2200,
          netActivityKcal: 300,
          steps: 8000,
          distanceMeters: 5600,
        ),
        '2026-10-16': const EnergyLedgerDay(
          dateKey: '2026-10-16',
          intakeKcal: 2000,
          adaptiveTdee: 2200,
          netActivityKcal: 250,
          steps: 7000,
          distanceMeters: 4900,
        ),
      };
    }

    test('incremental totals equal full recompute', () {
      final all = sample();
      final a = EnergyLedger.totalsFor(all, period: LedgerPeriod.allTime);
      final b = EnergyLedger.recomputeAll(all);
      expect(a.netActivityKcal, b.netActivityKcal);
      expect(a.balanceKcal, b.balanceKcal);
      expect(a.steps, b.steps);
    });

    test('fat equivalent uses 7700 kcal/kg', () {
      final t = EnergyLedger.totalsFor(sample(), period: LedgerPeriod.allTime);
      expect(t.activityFatKgEstimate, closeTo(550 / 7700, 0.0001));
    });

    test('milestones every 10,000 kcal', () {
      expect(EnergyLedger.milestonesReached(9999), 0);
      expect(EnergyLedger.milestonesReached(10000), 1);
      expect(EnergyLedger.milestonesReached(25000), 2);
    });

    test('timezone dateKey is calendar local', () {
      final key = EnergyLedger.dateKey(DateTime(2026, 10, 17, 23, 30));
      expect(key, '2026-10-17');
    });

    test('divergence note is honest when trend disagrees', () {
      final note = EnergyLedger.divergenceNoteAr(
        activityFatKgEstimate: 2.0,
        trendWeightChangeKg: 0.1,
      );
      expect(note.contains('تقديري'), isTrue);
    });
  });
}
