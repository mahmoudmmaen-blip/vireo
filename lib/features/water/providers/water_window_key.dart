import 'package:vireo/features/ramadan/services/ramadan_schedule_service.dart';

/// Storage day key for water logs.
///
/// Outside Ramadan: calendar day (`yyyy-MM-dd`).
/// In Ramadan: the **iftar→suhoor** drinking window, keyed by the Maghrib
/// (iftar) calendar day — so intake overnight before Fajr stays on the same
/// window that started at iftar.
abstract final class WaterWindowKey {
  static String calendarDay(DateTime d) {
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$m-$day';
  }

  /// [prayer] must be for [now]'s local calendar day (same as
  /// [RamadanPrayerTimes.calculate]).
  static String resolve({
    required DateTime now,
    required bool ramadanEnabled,
    RamadanPrayerTimes? prayer,
  }) {
    if (!ramadanEnabled || prayer == null) {
      return calendarDay(now);
    }

    final today = DateTime(now.year, now.month, now.day);
    // Drinking window: after Maghrib, or after midnight until Fajr.
    if (!now.isBefore(prayer.maghrib) || now.isBefore(prayer.fajr)) {
      final iftarDay =
          now.isBefore(prayer.fajr) ? today.subtract(const Duration(days: 1)) : today;
      return calendarDay(iftarDay);
    }

    // Daytime fast: still show the previous night's drinking window.
    return calendarDay(today.subtract(const Duration(days: 1)));
  }
}
