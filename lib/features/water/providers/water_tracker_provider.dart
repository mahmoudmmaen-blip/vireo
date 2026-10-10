import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/features/water/providers/water_daily_goal_provider.dart';

const _waterTrackerKey = 'water_tracker';

String _todayDateKey() {
  final now = DateTime.now();
  final m = now.month.toString().padLeft(2, '0');
  final d = now.day.toString().padLeft(2, '0');
  return '${now.year}-$m-$d';
}

class WaterTrackerNotifier extends Notifier<int> {
  @override
  int build() {
    ref.watch(waterDailyGoalMlProvider);
    return _loadForToday();
  }

  int get goalMl => ref.read(waterDailyGoalMlProvider);

  int get glassCount => ref.read(waterGlassCountProvider);

  int get filledGlasses =>
      (state / waterGlassMl).floor().clamp(0, glassCount);

  double get progress => goalMl > 0 ? (state / goalMl).clamp(0.0, 1.0) : 0;

  int _loadForToday() {
    if (!HiveService.isInitialized) return 0;
    try {
      final raw = HiveService.cacheBox.get(_waterTrackerKey);
      if (raw is Map) {
        final map = Map<String, dynamic>.from(raw);
        final storedDate = map['date'] as String?;
        final ml = (map['ml'] as num?)?.toInt() ?? 0;
        if (storedDate == _todayDateKey()) {
          return ml.clamp(0, goalMl);
        }
      }
      _persistAsync(0);
      return 0;
    } catch (_) {
      return 0;
    }
  }

  Future<void> toggleGlass(int index) async {
    if (index < 0 || index >= glassCount) return;
    final targetMl = (index + 1) * waterGlassMl;
    if (state >= targetMl) {
      state = index * waterGlassMl;
    } else {
      state = targetMl.clamp(0, goalMl);
    }
    await _persistAsync(state);
  }

  Future<bool> addGlass() async {
    if (state >= goalMl) return false;
    state = (state + waterGlassMl).clamp(0, goalMl);
    await _persistAsync(state);
    return true;
  }

  Future<void> removeGlass() async {
    if (state <= 0) return;
    state = (state - waterGlassMl).clamp(0, goalMl);
    await _persistAsync(state);
  }

  Future<void> _persistAsync(int ml) async {
    if (!HiveService.isInitialized) return;
    try {
      await HiveService.cacheBox.put(_waterTrackerKey, {
        'date': _todayDateKey(),
        'ml': ml,
      });
    } catch (_) {}
  }
}

final waterTrackerProvider =
    NotifierProvider<WaterTrackerNotifier, int>(WaterTrackerNotifier.new);

final waterTrackerFilledGlassesProvider = Provider<int>((ref) {
  ref.watch(waterTrackerProvider);
  return ref.read(waterTrackerProvider.notifier).filledGlasses;
});

final waterTrackerProgressProvider = Provider<double>((ref) {
  ref.watch(waterTrackerProvider);
  return ref.read(waterTrackerProvider.notifier).progress;
});
