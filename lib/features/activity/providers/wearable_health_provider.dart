import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/features/activity/services/wearable_health_service.dart';

enum StressLevel { low, medium, high }

class StressSnapshot {
  const StressSnapshot({this.level, this.todayHrvMs, this.baselineHrvMs});
  final StressLevel? level;
  final double? todayHrvMs;
  final double? baselineHrvMs;
}

const _manualSleepKey = 'manual_sleep_logs';

final wearableHealthProvider = FutureProvider<HealthHubSnapshot>((ref) async {
  return WearableHealthService.fetch();
});

final stressFromHrvProvider = FutureProvider<StressSnapshot>((ref) async {
  final series = await WearableHealthService.fetchHrvDaily(14);
  final baselineVals = series.map((e) => e.value).where((v) => v > 0).toList();
  if (baselineVals.length < 5) return const StressSnapshot();
  final today = series.isNotEmpty ? series.last.value : 0.0;
  if (today <= 0) return const StressSnapshot();
  if (baselineVals.length < 5) return const StressSnapshot();
  final baseline = baselineVals.reduce((a, b) => a + b) / baselineVals.length;
  final ratio = today / baseline;
  StressLevel level;
  if (ratio >= 0.95) {
    level = StressLevel.low;
  } else if (ratio >= 0.85) {
    level = StressLevel.medium;
  } else {
    level = StressLevel.high;
  }
  return StressSnapshot(level: level, todayHrvMs: today, baselineHrvMs: baseline);
});

class ManualSleepEntry {
  ManualSleepEntry({
    required this.dateKey,
    required this.bedtime,
    required this.wakeTime,
    required this.quality,
  });

  final String dateKey;
  final DateTime bedtime;
  final DateTime wakeTime;
  final int quality;

  double get hours => wakeTime.difference(bedtime).inMinutes / 60.0;

  int get score {
    final durationScore = (hours / 8 * 60).clamp(0, 60).round();
    final qualityScore = (quality / 5 * 40).round();
    return (durationScore + qualityScore).clamp(0, 100);
  }

  Map<String, dynamic> toJson() => {
        'date': dateKey,
        'bed': bedtime.toIso8601String(),
        'wake': wakeTime.toIso8601String(),
        'quality': quality,
      };

  factory ManualSleepEntry.fromJson(Map<String, dynamic> json) {
    return ManualSleepEntry(
      dateKey: json['date'] as String? ?? '',
      bedtime: DateTime.parse(json['bed'] as String),
      wakeTime: DateTime.parse(json['wake'] as String),
      quality: json['quality'] as int? ?? 3,
    );
  }
}

ManualSleepEntry? readManualSleepToday() {
  if (!HiveService.isInitialized) return null;
  final raw = HiveService.cacheBox.get(_manualSleepKey);
  if (raw is! List) return null;
  final today = DateTime.now();
  final key =
      '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
  for (final item in raw) {
    if (item is Map && item['date'] == key) {
      return ManualSleepEntry.fromJson(Map<String, dynamic>.from(item));
    }
  }
  return null;
}

Future<void> saveManualSleep(ManualSleepEntry entry) async {
  if (!HiveService.isInitialized) return;
  final raw = HiveService.cacheBox.get(_manualSleepKey);
  final list = raw is List ? List<Map<String, dynamic>>.from(raw) : <Map<String, dynamic>>[];
  list.removeWhere((e) => e['date'] == entry.dateKey);
  list.add(entry.toJson());
  await HiveService.cacheBox.put(_manualSleepKey, list);
}

final manualSleepTodayProvider = Provider<ManualSleepEntry?>((ref) {
  ref.watch(manualSleepRevisionProvider);
  return readManualSleepToday();
});

final manualSleepRevisionProvider = StateProvider<int>((ref) => 0);
