import 'package:vireo/core/services/hive_service.dart';

/// Single place that knows where the install / first-open date lives in Hive
/// (settings box). `app_install_date` is the canonical key (written by
/// AdService / userJourneyDayProvider); `first_open_at` is accepted as an alias.
abstract final class InstallDate {
  static const keys = <String>['app_install_date', 'first_open_at'];

  /// The install date, or null when unknown / Hive is not ready.
  static DateTime? read() {
    if (!HiveService.isInitialized) return null;
    try {
      for (final key in keys) {
        final raw = HiveService.settingsBox.get(key);
        final parsed = raw is String ? DateTime.tryParse(raw) : null;
        if (parsed != null) return parsed;
      }
    } catch (_) {
      // Box not open (tests / early boot).
    }
    return null;
  }

  /// Whole local calendar days between [installDate] and [now]
  /// (install day = 0, the next day = 1, ...). Negative clock skew → 0.
  static int dayAge(DateTime installDate, DateTime now) {
    // UTC midnights so a DST day (23 h / 25 h) never shifts the count.
    final start = DateTime.utc(installDate.year, installDate.month, installDate.day);
    final today = DateTime.utc(now.year, now.month, now.day);
    final days = today.difference(start).inDays;
    return days < 0 ? 0 : days;
  }
}
