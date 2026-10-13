import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/features/women_health/models/cycle_data.dart';

class WomenHealthService {
  static const _boxName = 'women_health_local_box';
  static const _entriesKey = 'cycle_log_entries';
  static const _modeKey = 'women_health_mode';
  static const _trimesterKey = 'women_pregnancy_trimester';
  static const _cycleLengthKey = 'women_cycle_length_default';
  static const _periodLengthKey = 'women_period_length_default';

  /// Predicts the cycle phase based on [lastPeriodStart], [cycleLength], [periodLength], and [targetDate].
  static CyclePhase predictPhase({
    required DateTime lastPeriodStart,
    int cycleLength = 28,
    int periodLength = 5,
    DateTime? targetDate,
  }) {
    final now = targetDate ?? DateTime.now();
    final startNormalized = DateTime(lastPeriodStart.year, lastPeriodStart.month, lastPeriodStart.day);
    final targetNormalized = DateTime(now.year, now.month, now.day);

    final diff = targetNormalized.difference(startNormalized).inDays;
    if (diff < 0) return CyclePhase.luteal;

    final effectiveCycle = cycleLength.clamp(20, 50);
    final effectivePeriod = periodLength.clamp(2, 10);
    final dayInCycle = diff % effectiveCycle; // 0-based day index

    // Menstrual phase: days 0 to (periodLength - 1)
    if (dayInCycle < effectivePeriod) {
      return CyclePhase.menstrual;
    }

    // Ovulation typically occurs 14 days before the end of the cycle
    final ovulationDay = (effectiveCycle - 14).clamp(effectivePeriod + 1, effectiveCycle - 3);

    // Follicular phase: after period until 2 days before ovulation
    if (dayInCycle < ovulationDay - 1) {
      return CyclePhase.follicular;
    }

    // Ovulatory phase: ovulation day +/- 1 day
    if (dayInCycle <= ovulationDay + 1) {
      return CyclePhase.ovulatory;
    }

    // Luteal phase: remainder of cycle until next period
    return CyclePhase.luteal;
  }

  /// Predicts the start of the next period.
  static DateTime predictNextPeriod({
    required DateTime lastPeriodStart,
    int cycleLength = 28,
    DateTime? fromDate,
  }) {
    final now = fromDate ?? DateTime.now();
    final effectiveCycle = cycleLength.clamp(20, 50);
    var candidate = DateTime(lastPeriodStart.year, lastPeriodStart.month, lastPeriodStart.day);

    while (candidate.isBefore(DateTime(now.year, now.month, now.day))) {
      candidate = candidate.add(Duration(days: effectiveCycle));
    }
    return candidate;
  }

  /// Returns days until the next predicted period.
  static int daysUntilNextPeriod({
    required DateTime lastPeriodStart,
    int cycleLength = 28,
    DateTime? fromDate,
  }) {
    final now = fromDate ?? DateTime.now();
    final next = predictNextPeriod(
      lastPeriodStart: lastPeriodStart,
      cycleLength: cycleLength,
      fromDate: now,
    );
    final targetNormalized = DateTime(now.year, now.month, now.day);
    return next.difference(targetNormalized).inDays;
  }

  /// Reads all saved cycle entries (sorted descending by start date).
  static List<CycleLogEntry> readEntries() {
    if (!HiveService.isInitialized) return [];
    final raw = HiveService.settingsBox.get('$_boxName:$_entriesKey');
    if (raw is List) {
      final list = raw
          .whereType<Map>()
          .map((m) => CycleLogEntry.fromJson(m))
          .toList();
      list.sort((a, b) => b.startDate.compareTo(a.startDate));
      return list;
    }
    return [];
  }

  /// Saves or updates a cycle entry.
  static Future<void> saveEntry(CycleLogEntry entry) async {
    if (!HiveService.isInitialized) return;
    final current = readEntries();
    // Replace if same start date, else add
    final sameDateIdx = current.indexWhere((e) =>
        e.startDate.year == entry.startDate.year &&
        e.startDate.month == entry.startDate.month &&
        e.startDate.day == entry.startDate.day);

    if (sameDateIdx >= 0) {
      current[sameDateIdx] = entry;
    } else {
      current.insert(0, entry);
    }
    current.sort((a, b) => b.startDate.compareTo(a.startDate));

    final serialized = current.map((e) => e.toJson()).toList();
    await HiveService.settingsBox.put('$_boxName:$_entriesKey', serialized);
  }

  /// Reads current women health mode (standard, pregnant, breastfeeding).
  static WomenMode readMode() {
    if (!HiveService.isInitialized) return WomenMode.standard;
    final val = HiveService.settingsBox.get('$_boxName:$_modeKey') as String?;
    return switch (val) {
      'pregnant' => WomenMode.pregnant,
      'breastfeeding' => WomenMode.breastfeeding,
      _ => WomenMode.standard,
    };
  }

  /// Saves current women health mode.
  static Future<void> saveMode(WomenMode mode) async {
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.put('$_boxName:$_modeKey', mode.name);
  }

  /// Reads current pregnancy trimester.
  static PregnancyTrimester readTrimester() {
    if (!HiveService.isInitialized) return PregnancyTrimester.first;
    final val = HiveService.settingsBox.get('$_boxName:$_trimesterKey') as String?;
    return switch (val) {
      'second' => PregnancyTrimester.second,
      'third' => PregnancyTrimester.third,
      _ => PregnancyTrimester.first,
    };
  }

  /// Saves pregnancy trimester.
  static Future<void> saveTrimester(PregnancyTrimester trimester) async {
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.put('$_boxName:$_trimesterKey', trimester.name);
  }

  /// Reads user default cycle length (in days).
  static int readDefaultCycleLength() {
    if (!HiveService.isInitialized) return 28;
    return HiveService.settingsBox.get('$_boxName:$_cycleLengthKey') as int? ?? 28;
  }

  /// Saves user default cycle length.
  static Future<void> saveDefaultCycleLength(int length) async {
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.put('$_boxName:$_cycleLengthKey', length.clamp(20, 50));
  }

  /// Permanently clears all cycle and symptom data locally.
  static Future<void> clearAllCycleData() async {
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.delete('$_boxName:$_entriesKey');
    await HiveService.settingsBox.delete('$_boxName:$_modeKey');
    await HiveService.settingsBox.delete('$_boxName:$_trimesterKey');
    await HiveService.settingsBox.delete('$_boxName:$_cycleLengthKey');
    await HiveService.settingsBox.delete('$_boxName:$_periodLengthKey');
  }
}
