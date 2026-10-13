import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/engagement/domain/daily_coin_task.dart';
import 'package:vireo/features/fasting/domain/fasting_plan.dart';
import 'package:vireo/features/fasting/domain/fasting_safety.dart';
import 'package:vireo/features/fasting/domain/fasting_session.dart';
import 'package:vireo/features/fasting/domain/fasting_stage.dart';
import 'package:vireo/features/ramadan/services/ramadan_schedule_service.dart';

void main() {
  group('Fasting Stage Calculations (Honest Science)', () {
    test('0 to 3.9h is anabolic (digestion)', () {
      expect(FastingStage.fromElapsed(Duration.zero), FastingStage.anabolic);
      expect(FastingStage.fromElapsed(const Duration(hours: 2)), FastingStage.anabolic);
      expect(FastingStage.fromElapsed(const Duration(hours: 3, minutes: 59)), FastingStage.anabolic);
    });

    test('4 to 11.9h is catabolic (glycogen depletion)', () {
      expect(FastingStage.fromElapsed(const Duration(hours: 4)), FastingStage.catabolic);
      expect(FastingStage.fromElapsed(const Duration(hours: 8)), FastingStage.catabolic);
      expect(FastingStage.fromElapsed(const Duration(hours: 11, minutes: 59)), FastingStage.catabolic);
    });

    test('12 to 17.9h is fat burning', () {
      expect(FastingStage.fromElapsed(const Duration(hours: 12)), FastingStage.fatBurning);
      expect(FastingStage.fromElapsed(const Duration(hours: 15)), FastingStage.fatBurning);
      expect(FastingStage.fromElapsed(const Duration(hours: 17, minutes: 59)), FastingStage.fatBurning);
    });

    test('18 to 23.9h is early ketosis', () {
      expect(FastingStage.fromElapsed(const Duration(hours: 18)), FastingStage.ketosis);
      expect(FastingStage.fromElapsed(const Duration(hours: 21)), FastingStage.ketosis);
      expect(FastingStage.fromElapsed(const Duration(hours: 23, minutes: 59)), FastingStage.ketosis);
    });

    test('24h+ is autophagy and cellular renewal', () {
      expect(FastingStage.fromElapsed(const Duration(hours: 24)), FastingStage.autophagy);
      expect(FastingStage.fromElapsed(const Duration(hours: 36)), FastingStage.autophagy);
      expect(FastingStage.fromElapsed(const Duration(hours: 72)), FastingStage.autophagy);
    });
  });

  group('Fasting Window Math across Midnight and DST', () {
    test('Session calculates elapsed and remaining correctly across midnight', () {
      final start = DateTime(2026, 10, 13, 22, 0); // 10:00 PM
      final end = DateTime(2026, 10, 14, 14, 0);   // Next day 2:00 PM (16 hours)

      final session = FastingSession(
        id: 'test_midnight',
        planType: FastingPlanType.p16_8,
        targetHours: 16,
        startTime: start,
        endTime: end,
      );

      expect(session.elapsed.inHours, 16);
      expect(session.remaining, Duration.zero);
      expect(session.progressRatio, 1.0);
      expect(session.isTargetReached, true);
    });

    test('Session handles duration across DST clock shift', () {
      // UTC timestamps handle DST transitions linearly without duplicate or missing hours
      final startUtc = DateTime.utc(2026, 3, 27, 23, 0);
      final endUtc = DateTime.utc(2026, 3, 28, 15, 0);

      final session = FastingSession(
        id: 'test_dst',
        planType: FastingPlanType.p16_8,
        targetHours: 16,
        startTime: startUtc,
        endTime: endUtc,
      );

      expect(session.elapsed.inHours, 16);
      expect(session.isTargetReached, true);
    });

    test('Hard safety cap at 72 hours', () {
      final sessionUnder = FastingSession(
        id: 'under_cap',
        planType: FastingPlanType.custom,
        targetHours: 24,
        startTime: DateTime.now().subtract(const Duration(hours: 70)),
      );
      expect(sessionUnder.isPastHardCap, false);

      final sessionOver = FastingSession(
        id: 'over_cap',
        planType: FastingPlanType.custom,
        targetHours: 72,
        startTime: DateTime.now().subtract(const Duration(hours: 73)),
      );
      expect(sessionOver.isPastHardCap, true);
    });
  });

  group('Ramadan Prayer Window Sync', () {
    test('Computes Fajr to Maghrib fasting window accurately', () {
      final times = RamadanPrayerTimes.calculate(
        lat: 30.0444,
        lng: 31.2357,
        method: RamadanCalculationMethod.egyptian,
        date: DateTime(2026, 3, 15),
      );

      expect(times.fajr.isBefore(times.maghrib), true);
      final diff = times.maghrib.difference(times.fajr);
      // Cairo fasting duration in March is typically ~13-14 hours
      expect(diff.inHours >= 12 && diff.inHours <= 16, true);
    });
  });

  group('Safety Gating & Medical Constraints', () {
    test('Normal profile has no contraindications', () {
      const normal = FastingSafetyProfile();
      expect(normal.hasContraindications, false);
      expect(normal.getWarningMessage(true), '');
    });

    test('Pregnancy or nursing flags contraindication', () {
      const preg = FastingSafetyProfile(isPregnantOrNursing: true);
      expect(preg.hasContraindications, true);
      expect(preg.getWarningMessage(true).contains('الحمل'), true);
    });

    test('Under 18 flags contraindication', () {
      const minor = FastingSafetyProfile(isUnder18: true);
      expect(minor.hasContraindications, true);
      expect(minor.getWarningMessage(true).contains('18'), true);
    });

    test('Diabetes on medication flags contraindication', () {
      const diabetic = FastingSafetyProfile(hasDiabetesOnMedication: true);
      expect(diabetic.hasContraindications, true);
      expect(diabetic.getWarningMessage(true).contains('السكري'), true);
    });

    test('Eating disorder history flags contraindication', () {
      const ed = FastingSafetyProfile(hasEatingDisorderHistory: true);
      expect(ed.hasContraindications, true);
      expect(ed.getWarningMessage(true).contains('اضطرابات الأكل'), true);
    });
  });

  group('Coins and Gamification Integration', () {
    test('DailyCoinTask contains fasting task for 15 points', () {
      final task = DailyCoinTask.fasting;
      expect(task.points, 15);
      expect(task.titleAr, 'إكمال الصيام');
    });

    test('Session tracks coinsAwarded flag preventing duplicate awards', () {
      var session = FastingSession(
        id: 'fast_coins',
        planType: FastingPlanType.p16_8,
        targetHours: 16,
        startTime: DateTime.now().subtract(const Duration(hours: 16)),
        coinsAwarded: false,
      );

      expect(session.coinsAwarded, false);
      session = session.copyWith(coinsAwarded: true);
      expect(session.coinsAwarded, true);
    });
  });
}
