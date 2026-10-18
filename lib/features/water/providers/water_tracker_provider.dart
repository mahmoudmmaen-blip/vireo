import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/sync_engine.dart';
import 'package:vireo/features/water/providers/water_cup_size_provider.dart';
import 'package:vireo/features/water/providers/water_daily_goal_provider.dart';

const _waterTrackerKey = 'water_tracker';

String _todayDateKey() {
  final now = DateTime.now();
  final m = now.month.toString().padLeft(2, '0');
  final d = now.day.toString().padLeft(2, '0');
  return '${now.year}-$m-$d';
}

class WaterTrackerNotifier extends Notifier<int> {
  int? _lastAddedMl;

  @override
  int build() {
    ref.watch(waterDailyGoalMlProvider);
    ref.watch(waterCupSizeProvider);
    return _loadForToday();
  }

  int get goalMl => ref.read(waterDailyGoalMlProvider);

  int get cupMl => ref.read(waterCupSizeProvider);

  int get glassCount => ref.read(waterGlassCountProvider);

  int get filledGlasses =>
      (state / cupMl).floor().clamp(0, glassCount);

  double get progress => goalMl > 0 ? (state / goalMl).clamp(0.0, 1.0) : 0;

  int? get lastAddedMl => _lastAddedMl;

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
    final targetMl = (index + 1) * cupMl;
    if (state >= targetMl) {
      state = index * cupMl;
    } else {
      state = targetMl.clamp(0, goalMl);
    }
    await _persistAsync(state);
  }

  Future<bool> addGlass() => addMl(cupMl);

  Future<bool> addMl(int ml) async {
    if (state >= goalMl || ml <= 0) return false;
    final before = state;
    state = (state + ml).clamp(0, goalMl);
    _lastAddedMl = state - before;
    await _persistAsync(state);
    return _lastAddedMl! > 0;
  }

  Future<void> removeGlass() => undoLastOrCup();

  Future<void> undoLastOrCup() async {
    if (state <= 0) return;
    final remove = _lastAddedMl ?? cupMl;
    state = (state - remove).clamp(0, goalMl);
    _lastAddedMl = null;
    await _persistAsync(state);
  }

  Future<void> _persistAsync(int ml) async {
    if (!HiveService.isInitialized) return;
    try {
      final day = _todayDateKey();
      await HiveService.cacheBox.put(_waterTrackerKey, {
        'date': day,
        'ml': ml,
      });
      await ref.read(syncEngineProvider).enqueueChange(
            table: 'water_logs',
            id: 'water_$day',
            operation: SyncOperation.update,
            data: {
              'day': day,
              'amount_ml': ml,
              'goal_ml': goalMl,
            },
          );
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
