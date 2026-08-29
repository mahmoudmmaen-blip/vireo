import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';

const _waterTrackerKey = 'water_tracker';
const waterDailyGoalMl = 2500;
const waterGlassMl = 250;
const waterGlassCount = 10;

String _todayDateKey() {
  final now = DateTime.now();
  final m = now.month.toString().padLeft(2, '0');
  final d = now.day.toString().padLeft(2, '0');
  return '${now.year}-$m-$d';
}

class WaterTrackerNotifier extends StateNotifier<int> {
  WaterTrackerNotifier() : super(0) {
    _loadForToday();
  }

  int get filledGlasses => (state / waterGlassMl).floor().clamp(0, waterGlassCount);

  double get progress =>
      waterDailyGoalMl > 0 ? (state / waterDailyGoalMl).clamp(0.0, 1.0) : 0;

  void _loadForToday() {
    if (!HiveService.isInitialized) return;
    try {
      final raw = HiveService.cacheBox.get(_waterTrackerKey);
      if (raw is Map) {
        final map = Map<String, dynamic>.from(raw);
        final storedDate = map['date'] as String?;
        final ml = (map['ml'] as num?)?.toInt() ?? 0;
        if (storedDate == _todayDateKey()) {
          state = ml.clamp(0, waterDailyGoalMl);
          return;
        }
      }
      state = 0;
      _persistAsync(0);
    } catch (_) {
      state = 0;
    }
  }

  /// Tap glass [index] (0–9): fill up to (index+1)×250 ml or empty back.
  Future<void> toggleGlass(int index) async {
    if (index < 0 || index >= waterGlassCount) return;
    final targetMl = (index + 1) * waterGlassMl;
    if (state >= targetMl) {
      state = index * waterGlassMl;
    } else {
      state = targetMl.clamp(0, waterDailyGoalMl);
    }
    await _persistAsync(state);
  }

  Future<void> _persistAsync(int ml) async {
    if (!HiveService.isInitialized) return;
    try {
      await HiveService.cacheBox.put(_waterTrackerKey, {
        'date': _todayDateKey(),
        'ml': ml,
      });
    } catch (_) {
      // Non-fatal — in-memory state still valid for the session.
    }
  }
}

final waterTrackerProvider =
    StateNotifierProvider<WaterTrackerNotifier, int>(
  (ref) => WaterTrackerNotifier(),
);

final waterTrackerFilledGlassesProvider = Provider<int>((ref) {
  ref.watch(waterTrackerProvider);
  return ref.read(waterTrackerProvider.notifier).filledGlasses;
});

final waterTrackerProgressProvider = Provider<double>((ref) {
  ref.watch(waterTrackerProvider);
  return ref.read(waterTrackerProvider.notifier).progress;
});
