import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/ramadan/services/ramadan_schedule_service.dart';

void main() {
  group('RamadanScheduleService - Macros and Water Distribution', () {
    test('splitMacros divides calories and protein correctly (35% Suhoor, 45% Iftar, 20% Snack)', () {
      final split = RamadanScheduleService.splitMacros(
        totalCalories: 2000,
        totalProteinG: 150,
      );

      expect(split['suhoor']!.calories, 700); // 2000 * 0.35
      expect(split['iftar']!.calories, 900);   // 2000 * 0.45
      expect(split['snack']!.calories, 400);   // 2000 * 0.20
      expect(
        split['suhoor']!.calories + split['iftar']!.calories + split['snack']!.calories,
        2000,
      );

      expect(split['suhoor']!.proteinG, 53); // round(150 * 0.35) = 53
      expect(split['iftar']!.proteinG, 60);  // round(150 * 0.40) = 60
      expect(split['snack']!.proteinG, 37);  // 150 - 53 - 60 = 37
      expect(
        split['suhoor']!.proteinG + split['iftar']!.proteinG + split['snack']!.proteinG,
        150,
      );
    });

    test('distributeWaterMl divides water between iftar and suhoor', () {
      // 8 cups * 250ml = 2000 ml
      final water = RamadanScheduleService.distributeWaterMl(2000);
      expect(water['iftar'], 500); // 25%
      expect(water['evening'], 1000); // 50%
      expect(water['suhoor'], 500); // 25%
      expect(water['iftar']! + water['evening']! + water['suhoor']!, 2000);
    });

    test('workoutTimingTip provides evidence-based guidance', () {
      final tipAr = RamadanScheduleService.workoutTimingTip(isArabic: true);
      final tipEn = RamadanScheduleService.workoutTimingTip(isArabic: false);

      expect(tipAr.contains('الإفطار'), isTrue);
      expect(tipAr.contains('المغرب'), isTrue);
      expect(tipEn.contains('60–90'), isTrue);
      expect(tipEn.contains('Iftar'), isTrue);
    });
  });

  group('RamadanPrayerTimes - Calculation and Countdown', () {
    test('computes prayer times locally for Cairo with Egyptian method', () {
      final date = DateTime(2026, 3, 15);
      final pt = RamadanPrayerTimes.calculate(
        lat: 30.0444,
        lng: 31.2357,
        method: RamadanCalculationMethod.egyptian,
        date: date,
      );

      expect(pt.fajr.isBefore(pt.maghrib), isTrue);
      // Known offline values (adhan + Egyptian method), 2026-03-15 Cairo.
      expect(pt.fajr, DateTime(2026, 3, 15, 5, 39));
      expect(pt.maghrib, DateTime(2026, 3, 15, 19, 3));
    });

    test('computes prayer times locally for Riyadh with Umm al-Qura method', () {
      final date = DateTime(2026, 3, 15);
      final pt = RamadanPrayerTimes.calculate(
        lat: 24.7136,
        lng: 46.6753,
        method: RamadanCalculationMethod.ummAlQura,
        date: date,
      );

      expect(pt.fajr.isBefore(pt.maghrib), isTrue);
      // Known offline values (adhan + Umm al-Qura), 2026-03-15 Riyadh.
      expect(pt.fajr, DateTime(2026, 3, 15, 4, 45));
      expect(pt.maghrib, DateTime(2026, 3, 15, 18, 2));
    });

    test('countdown and fasting state with mock clock', () {
      final fajr = DateTime(2026, 3, 15, 4, 30);
      final maghrib = DateTime(2026, 3, 15, 18, 0);

      // Fasting hour: 14:00 (Fasting, waiting for Iftar at 18:00 -> 4 hours)
      final ptFasting = RamadanPrayerTimes(
        fajr: fajr,
        maghrib: maghrib,
        now: DateTime(2026, 3, 15, 14, 0),
      );
      expect(ptFasting.isFasting, isTrue);
      expect(ptFasting.timeUntilIftar.inHours, 4);
      expect(ptFasting.formatCountdown(ptFasting.timeUntilIftar), '04:00');

      // Non-fasting hour: 22:00 (Night, waiting for Suhoor/Fajr next day at 04:30 -> 6h 30m)
      final ptNight = RamadanPrayerTimes(
        fajr: fajr,
        maghrib: maghrib,
        now: DateTime(2026, 3, 15, 22, 0),
      );
      expect(ptNight.isFasting, isFalse);
      expect(ptNight.timeUntilSuhoorEnd.inMinutes, 390);
      expect(ptNight.formatCountdown(ptNight.timeUntilSuhoorEnd), '06:30');

      // Morning before Fajr: 03:00 (Still time to eat Suhoor -> 1h 30m until Fajr)
      final ptMorning = RamadanPrayerTimes(
        fajr: fajr,
        maghrib: maghrib,
        now: DateTime(2026, 3, 15, 3, 0),
      );
      expect(ptMorning.isFasting, isFalse);
      expect(ptMorning.timeUntilSuhoorEnd.inMinutes, 90);
      expect(ptMorning.formatCountdown(ptMorning.timeUntilSuhoorEnd), '01:30');
    });
  });
}
