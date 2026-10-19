import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:vireo/core/services/health_steps_service.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/sync_engine.dart';
import 'package:vireo/core/utils/merciful_streak.dart';
import 'package:vireo/data/models/daily_step_count.dart';
import 'package:vireo/features/walking/data/pedometer_stream_stub.dart'
    if (dart.library.io) 'package:vireo/features/walking/data/pedometer_stream_io.dart';
import 'package:vireo/features/walking/domain/step_fusion.dart';

/// Live step snapshot used across Home and Walking.
@immutable
class LiveStepsSnapshot {
  const LiveStepsSnapshot({
    required this.todaySteps,
    required this.source,
    required this.permissionGranted,
    required this.sensorAvailable,
    this.healthConnectDenied = false,
    this.last7Days = const [],
  });

  final int todaySteps;
  final StepSource source;
  final bool permissionGranted;
  final bool sensorAvailable;

  /// True when Health Connect/HealthKit is available but not granted — pedometer fallback.
  final bool healthConnectDenied;
  final List<DailyStepCount> last7Days;

  static const empty = LiveStepsSnapshot(
    todaySteps: 0,
    source: StepSource.none,
    permissionGranted: false,
    sensorAvailable: false,
  );
}

enum StepSource { pedometer, health, manual, none }

/// On-device pedometer with day baseline / reboot offset, Health fallback,
/// and Hive history.
abstract final class StepCounterService {
  static const _stateKey = 'step_counter_state';
  static const _historyKey = 'step_history';
  static const _workoutDaysKey = 'workout_completion_days';

  static StreamSubscription<int>? _sub;
  static Timer? _foregroundRefreshTimer;
  static final _controller = StreamController<LiveStepsSnapshot>.broadcast();
  static LiveStepsSnapshot _latest = LiveStepsSnapshot.empty;
  static bool _started = false;
  static DateTime? _healthFetchedAt;
  static int _cachedHealthSteps = 0;
  static bool _cachedHealthOk = false;
  static DateTime? _lastRemoteStepSync;

  static LiveStepsSnapshot get latest => _latest;

  static Stream<LiveStepsSnapshot> get stream async* {
    yield _latest;
    yield* _controller.stream;
  }

  static String dateKey([DateTime? dt]) {
    final d = dt ?? DateTime.now();
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$m-$day';
  }

  static Map<String, dynamic> readRawState() => _readState();

  static Future<void> resetBaseline() async {
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.delete(_stateKey);
    await refresh();
  }

  static Map<String, dynamic> _readState() {
    if (!HiveService.isInitialized) return {};
    final raw = HiveService.settingsBox.get(_stateKey);
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return {};
  }

  static Future<void> _writeState(Map<String, dynamic> state) async {
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.put(_stateKey, state);
  }

  static Map<String, int> readHistory() {
    if (!HiveService.isInitialized) return {};
    final raw = HiveService.settingsBox.get(_historyKey);
    if (raw is! Map) return {};
    final out = <String, int>{};
    raw.forEach((k, v) {
      if (v is num) out[k.toString()] = v.toInt();
    });
    return out;
  }

  static Future<void> _writeHistory(Map<String, int> history) async {
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.put(_historyKey, history);
  }

  static Future<void> saveTodayToHistory(int steps) async {
    final day = dateKey();
    final history = readHistory();
    history[day] = steps;
    // Keep ~60 days.
    if (history.length > 60) {
      final keys = history.keys.toList()..sort();
      for (final k in keys.take(history.length - 60)) {
        history.remove(k);
      }
    }
    await _writeHistory(history);
    final now = DateTime.now();
    if (_lastRemoteStepSync != null &&
        now.difference(_lastRemoteStepSync!) < const Duration(seconds: 30)) {
      return;
    }
    _lastRemoteStepSync = now;
    try {
      await SyncEngine().enqueueChange(
        table: 'daily_steps_history',
        id: 'steps_$day',
        operation: SyncOperation.update,
        data: {
          'day': day,
          'steps': steps,
        },
      );
    } catch (_) {}
  }

  static List<DailyStepCount> last7DaysFromHistory({int todaySteps = 0}) {
    final history = readHistory();
    final today = DateTime.now();
    return List.generate(7, (i) {
      final day = DateTime(today.year, today.month, today.day)
          .subtract(Duration(days: 6 - i));
      final key = dateKey(day);
      final isToday = i == 6;
      final steps = isToday ? todaySteps : (history[key] ?? 0);
      return DailyStepCount(date: day, steps: steps);
    });
  }

  /// Apply a cumulative boot-counter reading → today's steps.
  static Future<int> applyCumulative(int cumulative) async {
    final today = dateKey();
    var state = _readState();
    var baseline = (state['baseline'] as num?)?.toInt();
    var offset = (state['offset'] as num?)?.toInt() ?? 0;
    var lastCumulative = (state['lastCumulative'] as num?)?.toInt() ?? 0;
    final storedDate = state['date'] as String?;

    if (storedDate != today || baseline == null) {
      // Roll previous day into history before resetting.
      if (storedDate != null && storedDate != today && baseline != null) {
        final prevSteps = offset + (lastCumulative - baseline).clamp(0, 200000);
        final history = readHistory();
        history[storedDate] = prevSteps.clamp(0, 200000);
        await _writeHistory(history);
      }
      baseline = cumulative;
      offset = 0;
      lastCumulative = cumulative;
    } else if (cumulative < lastCumulative || cumulative < baseline) {
      // Device reboot (counter reset).
      final stepsBeforeReboot =
          offset + (lastCumulative - baseline).clamp(0, 200000);
      offset = stepsBeforeReboot;
      baseline = cumulative;
      lastCumulative = cumulative;
    } else {
      lastCumulative = cumulative;
    }

    final todaySteps =
        (offset + (cumulative - baseline).clamp(0, 200000)).clamp(0, 200000);

    await _writeState({
      'date': today,
      'baseline': baseline,
      'offset': offset,
      'lastCumulative': lastCumulative,
    });
    try {
      await FlutterForegroundTask.saveData(key: 'step_date', value: today);
      await FlutterForegroundTask.saveData(key: 'step_baseline', value: baseline);
      await FlutterForegroundTask.saveData(key: 'step_offset', value: offset);
      await FlutterForegroundTask.saveData(key: 'step_last_cumulative', value: lastCumulative);
    } catch (_) {}
    await saveTodayToHistory(todaySteps);
    return todaySteps;
  }

  static Future<void> startListening() async {
    if (_started || kIsWeb || !pedometerHardwareSupported) return;
    _started = true;
    _sub?.cancel();
    _sub = pedometerCumulativeStream().listen(
      (cumulative) {
        unawaited(_onPedometerStep(cumulative));
      },
      onError: (_) {
        unawaited(_emitMerged(pedoSteps: null, sensorError: true));
      },
    );

    // P51: Health Connect poll ≤2s so Home and Walk stay in sync.
    _foregroundRefreshTimer?.cancel();
    _foregroundRefreshTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      unawaited(refresh());
    });
  }

  static Future<void> _onPedometerStep(int cumulative) async {
    try {
      final pedoSteps = await applyCumulative(cumulative);
      await _emitMerged(pedoSteps: pedoSteps, allowHealthFetch: false);
    } catch (_) {}
  }

  static Future<void> stopListening() async {
    await _sub?.cancel();
    _sub = null;
    _foregroundRefreshTimer?.cancel();
    _foregroundRefreshTimer = null;
    _started = false;
  }

  static Future<LiveStepsSnapshot> refresh({
    int? pedoSteps,
    bool sensorError = false,
  }) =>
      _emitMerged(pedoSteps: pedoSteps, sensorError: sensorError);

  static Future<void> _refreshHealthCache() async {
    final fetchedAt = _healthFetchedAt;
    if (fetchedAt != null &&
        DateTime.now().difference(fetchedAt) < const Duration(seconds: 2)) {
      return;
    }
    try {
      if (!HealthStepsService.isSupported) return;
      // Never prompt on background poll — only read if already granted.
      final snap = await HealthStepsService.fetchIfPermitted();
      _healthFetchedAt = DateTime.now();
      if (snap.status == HealthStepsStatus.granted) {
        _cachedHealthSteps = snap.todaySteps;
        _cachedHealthOk = true;
      } else {
        _cachedHealthOk = false;
      }
    } catch (_) {
      _healthFetchedAt = DateTime.now();
    }
  }

  /// Manual / web entry — same stream Home and Walk consume (P51).
  static Future<void> applyManualTodaySteps(int steps) async {
    final clamped = steps.clamp(0, 200000);
    await saveTodayToHistory(clamped);
    _latest = LiveStepsSnapshot(
      todaySteps: clamped,
      source: StepSource.manual,
      permissionGranted: _latest.permissionGranted,
      sensorAvailable: _latest.sensorAvailable,
      healthConnectDenied: _latest.healthConnectDenied,
      last7Days: last7DaysFromHistory(todaySteps: clamped),
    );
    if (!_controller.isClosed) _controller.add(_latest);
  }

  static Future<LiveStepsSnapshot> _emitMerged({
    int? pedoSteps,
    bool sensorError = false,
    bool allowHealthFetch = true,
  }) async {
    if (allowHealthFetch) {
      await _refreshHealthCache();
    }
    final healthSteps = _cachedHealthSteps;
    final healthOk = _cachedHealthOk;

    final state = _readState();
    final baseline = (state['baseline'] as num?)?.toInt();
    final offset = (state['offset'] as num?)?.toInt() ?? 0;
    final last = (state['lastCumulative'] as num?)?.toInt() ?? 0;
    final storedDate = state['date'] as String?;
    final fromState = (storedDate == dateKey() && baseline != null)
        ? (offset + (last - baseline).clamp(0, 200000)).clamp(0, 200000)
        : 0;

    final sensorSteps = pedoSteps ?? fromState;
    final sensorAvailable = pedometerHardwareSupported && !sensorError && !kIsWeb;

    // P48: prefer Health Connect when granted; else pedometer. Never sum both.
    int todaySteps;
    StepSource source;
    if (healthOk && healthSteps > 0) {
      todaySteps = healthSteps;
      source = StepSource.health;
      if (sensorAvailable && sensorSteps > healthSteps) {
        // Pedometer ahead early in the day before HC syncs — take the fuller total.
        todaySteps = sensorSteps;
        source = StepSource.pedometer;
      }
    } else if (sensorAvailable && healthOk) {
      final fused = StepFusion.fuseDay(
        pedometerHours: const [],
        healthHours: const [],
        pedometerDayTotal: sensorSteps,
        healthDayTotal: healthSteps,
      );
      todaySteps = fused.totalSteps;
      source = fused.source;
    } else if (sensorAvailable && sensorSteps > 0) {
      todaySteps = sensorSteps;
      source = StepSource.pedometer;
    } else if (healthOk) {
      todaySteps = healthSteps;
      source = StepSource.health;
    } else {
      todaySteps = sensorSteps;
      source = sensorAvailable ? StepSource.pedometer : StepSource.none;
    }

    await saveTodayToHistory(todaySteps);

    _latest = LiveStepsSnapshot(
      todaySteps: todaySteps,
      source: source,
      permissionGranted: sensorAvailable || healthOk,
      sensorAvailable: sensorAvailable,
      healthConnectDenied: !healthOk && HealthStepsService.isSupported,
      last7Days: last7DaysFromHistory(todaySteps: todaySteps),
    );
    if (!_controller.isClosed) _controller.add(_latest);
    return _latest;
  }

  // ── Workout / streak history ──────────────────────────────────────

  static Set<String> readWorkoutDays() {
    if (!HiveService.isInitialized) return {};
    final raw = HiveService.settingsBox.get(_workoutDaysKey);
    if (raw is! List) return {};
    return raw.map((e) => e.toString()).toSet();
  }

  static Future<void> markWorkoutCompleted([DateTime? day]) async {
    final days = readWorkoutDays()..add(dateKey(day));
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.put(_workoutDaysKey, days.toList());
  }

  /// Merciful streak (P40): consecutive days with workout completed OR
  /// steps ≥ goal. Today is "pending" until it is hit, and ONE isolated missed
  /// day is forgiven with a "يوم راحة" token (see [MercifulStreakEngine]).
  static MercifulStreak computeStreakDetails({
    required int stepsGoal,
    DateTime? today,
  }) {
    final workoutDays = readWorkoutDays();
    final history = readHistory();
    return MercifulStreakEngine.compute(
      today: today,
      hit: (day) {
        final key = dateKey(day);
        final steps = history[key] ?? 0;
        return workoutDays.contains(key) ||
            (stepsGoal > 0 && steps >= stepsGoal);
      },
    );
  }

  /// Streak length with the rest-day token applied.
  static int computeStreakDays({required int stepsGoal}) =>
      computeStreakDetails(stepsGoal: stepsGoal).days;

  /// Days in the last 7 (including today) with workout or steps goal hit.
  static int computeWeeklyCompletedDays({required int stepsGoal}) {
    final workoutDays = readWorkoutDays();
    final history = readHistory();
    final today = DateTime.now();
    var count = 0;
    for (var i = 0; i < 7; i++) {
      final day = DateTime(today.year, today.month, today.day)
          .subtract(Duration(days: i));
      final key = dateKey(day);
      final steps = history[key] ?? 0;
      if (workoutDays.contains(key) || (stepsGoal > 0 && steps >= stepsGoal)) {
        count++;
      }
    }
    return count;
  }
}
