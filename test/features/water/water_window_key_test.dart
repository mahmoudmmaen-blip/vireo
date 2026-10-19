import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/ramadan/services/ramadan_schedule_service.dart';
import 'package:vireo/features/water/providers/water_window_key.dart';

void main() {
  final fajr = DateTime(2026, 3, 15, 4, 45);
  final maghrib = DateTime(2026, 3, 15, 18, 10);

  RamadanPrayerTimes prayerAt(DateTime now) => RamadanPrayerTimes(
        fajr: fajr,
        maghrib: maghrib,
        now: now,
      );

  group('WaterWindowKey', () {
    test('calendar day when Ramadan off', () {
      final now = DateTime(2026, 3, 15, 12);
      expect(
        WaterWindowKey.resolve(
          now: now,
          ramadanEnabled: false,
          prayer: prayerAt(now),
        ),
        '2026-03-15',
      );
    });

    test('after iftar uses today as window key', () {
      final now = DateTime(2026, 3, 15, 20, 0);
      expect(
        WaterWindowKey.resolve(
          now: now,
          ramadanEnabled: true,
          prayer: prayerAt(now),
        ),
        '2026-03-15',
      );
    });

    test('after midnight before fajr stays on yesterday iftar window', () {
      final now = DateTime(2026, 3, 16, 2, 0);
      // Prayer times for "today" Mar 16 — approximate same clock times
      final prayer = RamadanPrayerTimes(
        fajr: DateTime(2026, 3, 16, 4, 45),
        maghrib: DateTime(2026, 3, 16, 18, 10),
        now: now,
      );
      expect(
        WaterWindowKey.resolve(
          now: now,
          ramadanEnabled: true,
          prayer: prayer,
        ),
        '2026-03-15',
      );
    });

    test('daytime fast still shows previous iftar window', () {
      final now = DateTime(2026, 3, 15, 13, 0);
      expect(
        WaterWindowKey.resolve(
          now: now,
          ramadanEnabled: true,
          prayer: prayerAt(now),
        ),
        '2026-03-14',
      );
    });
  });
}
