import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:pedometer/pedometer.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/utils/platform_utils.dart';
import 'package:vireo/features/walking/data/step_counter_service.dart';

@pragma('vm:entry-point')
void startForegroundCallback() {
  FlutterForegroundTask.setTaskHandler(_StepTaskHandler());
}

class _StepTaskHandler extends TaskHandler {
  StreamSubscription<StepCount>? _stepSub;
  DateTime _lastNotificationTime = DateTime.fromMillisecondsSinceEpoch(0);
  int _lastKnownTodaySteps = 0;

  static String _todayKey([DateTime? dt]) {
    final d = dt ?? DateTime.now();
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$m-$day';
  }

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    // Read persisted baseline & date from foreground storage
    final today = _todayKey();
    var storedDate = await FlutterForegroundTask.getData<String>(key: 'step_date');
    var baseline = await FlutterForegroundTask.getData<int>(key: 'step_baseline');
    var offset = await FlutterForegroundTask.getData<int>(key: 'step_offset') ?? 0;
    var lastCumulative = await FlutterForegroundTask.getData<int>(key: 'step_last_cumulative') ?? 0;

    if (storedDate == today && baseline != null) {
      _lastKnownTodaySteps = (offset + (lastCumulative - baseline).clamp(0, 200000)).clamp(0, 200000);
    }

    try {
      _stepSub = Pedometer.stepCountStream.listen((event) async {
        final cumulative = event.steps;
        final currentToday = _todayKey();

        if (storedDate != currentToday || baseline == null) {
          baseline = cumulative;
          offset = 0;
          lastCumulative = cumulative;
          storedDate = currentToday;
        } else if (cumulative < lastCumulative || cumulative < baseline!) {
          // Device reboot / counter reset
          final stepsBeforeReboot = offset + (lastCumulative - baseline!).clamp(0, 200000);
          offset = stepsBeforeReboot;
          baseline = cumulative;
          lastCumulative = cumulative;
        } else {
          lastCumulative = cumulative;
        }

        final todaySteps = (offset + (cumulative - baseline!).clamp(0, 200000)).clamp(0, 200000);
        _lastKnownTodaySteps = todaySteps;

        // Persist updated values so both isolates remain in sync
        await FlutterForegroundTask.saveData(key: 'step_date', value: currentToday);
        await FlutterForegroundTask.saveData(key: 'step_baseline', value: baseline!);
        await FlutterForegroundTask.saveData(key: 'step_offset', value: offset);
        await FlutterForegroundTask.saveData(key: 'step_last_cumulative', value: lastCumulative);

        // Send updated steps to the main isolate
        FlutterForegroundTask.sendDataToMain({
          'type': 'step_update',
          'cumulative': cumulative,
        });

        // Throttle notification updates to at least 5 seconds
        final now = DateTime.now();
        if (now.difference(_lastNotificationTime) >= const Duration(seconds: 5)) {
          _lastNotificationTime = now;
          await FlutterForegroundTask.updateService(
            notificationTitle: 'Vireo · عداد الخطوات شغال',
            notificationText: '$todaySteps خطوة اليوم',
          );
        }
      }, onError: (_) {});
    } catch (_) {}
  }

  @override
  Future<void> onRepeatEvent(DateTime timestamp) async {
    final now = DateTime.now();
    if (now.difference(_lastNotificationTime) >= const Duration(seconds: 5)) {
      _lastNotificationTime = now;
      await FlutterForegroundTask.updateService(
        notificationTitle: 'Vireo · عداد الخطوات شغال',
        notificationText: '$_lastKnownTodaySteps خطوة اليوم',
      );
    }
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isDestroyed) async {
    await _stepSub?.cancel();
    _stepSub = null;
  }
}

abstract final class StepForegroundService {
  static const _activeKey = 'step_service_active';
  static bool _isActive = false;
  static bool _commPortInitialized = false;

  static bool get isActive => _isActive;

  static Future<void> init() async {
    if (!PlatformUtils.isMobileNative || kIsWeb) return;

    if (HiveService.isInitialized) {
      // Default to OFF (false) until user taps ▶
      _isActive = HiveService.settingsBox.get(_activeKey, defaultValue: false) == true;
    }

    if (!_commPortInitialized) {
      _commPortInitialized = true;
      FlutterForegroundTask.initCommunicationPort();
      FlutterForegroundTask.addTaskDataCallback(_handleTaskData);
    }

    // Resync actual running state
    await syncRunningState();

    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'vireo_steps_channel',
        channelName: 'Vireo Steps Tracker',
        channelDescription: 'Ongoing notification for real-time live step counting',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        enableVibration: false,
        playSound: false,
        showWhen: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(15000),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: true,
        allowWifiLock: false,
      ),
    );

    if (_isActive) {
      await start();
    }
  }

  static void Function(bool isRunning)? onRunningStateChanged;

  static Future<bool> syncRunningState() async {
    if (!PlatformUtils.isMobileNative || kIsWeb) return _isActive;
    try {
      final isRunning = await FlutterForegroundTask.isRunningService
          .timeout(const Duration(seconds: 3), onTimeout: () => _isActive);
      _isActive = isRunning;
      if (HiveService.isInitialized) {
        await HiveService.settingsBox.put(_activeKey, isRunning);
      }
      onRunningStateChanged?.call(isRunning);
      return isRunning;
    } catch (_) {
      return _isActive;
    }
  }

  static void _handleTaskData(Object data) {
    if (data is Map) {
      final type = data['type'];
      if (type == 'step_update') {
        final cumulative = (data['cumulative'] as num?)?.toInt();
        if (cumulative != null) {
          unawaited(() async {
            final steps = await StepCounterService.applyCumulative(cumulative);
            await StepCounterService.refresh(pedoSteps: steps);
          }());
        }
        if (!_isActive) {
          _isActive = true;
          onRunningStateChanged?.call(true);
        }
      }
    }
  }

  static Future<void> start() async {
    _isActive = true;
    onRunningStateChanged?.call(true);
    if (HiveService.isInitialized) {
      await HiveService.settingsBox.put(_activeKey, true);
    }
    // The foreground isolate is the only pedometer subscriber while the
    // service is running. The main isolate applies those readings.
    await StepCounterService.stopListening();

    if (!PlatformUtils.isMobileNative || kIsWeb) {
      await StepCounterService.startListening();
      return;
    }

    if (!_commPortInitialized) {
      _commPortInitialized = true;
      FlutterForegroundTask.initCommunicationPort();
      FlutterForegroundTask.addTaskDataCallback(_handleTaskData);
    }

    final steps = StepCounterService.latest.todaySteps;
    try {
      final isRunning = await FlutterForegroundTask.isRunningService
          .timeout(const Duration(seconds: 3), onTimeout: () => false);
      if (isRunning) {
        await FlutterForegroundTask.updateService(
          notificationTitle: 'Vireo · عداد الخطوات شغال',
          notificationText: '$steps خطوة اليوم',
        ).timeout(
          const Duration(seconds: 5),
          onTimeout: () => throw TimeoutException('updateService timeout'),
        );
      } else {
        await FlutterForegroundTask.startService(
          serviceTypes: [ForegroundServiceTypes.health, ForegroundServiceTypes.dataSync],
          notificationTitle: 'Vireo · عداد الخطوات شغال',
          notificationText: '$steps خطوة اليوم',
          callback: startForegroundCallback,
        ).timeout(
          const Duration(seconds: 5),
          onTimeout: () => throw TimeoutException('startService timeout'),
        );
      }
    } catch (e) {
      debugPrint('[StepForegroundService] start error: $e');
      await StepCounterService.startListening();
      rethrow;
    }
  }

  static Future<void> stop() async {
    _isActive = false;
    onRunningStateChanged?.call(false);
    if (HiveService.isInitialized) {
      await HiveService.settingsBox.put(_activeKey, false);
    }
    await StepCounterService.stopListening();

    if (!PlatformUtils.isMobileNative || kIsWeb) return;

    try {
      final isRunning = await FlutterForegroundTask.isRunningService
          .timeout(const Duration(seconds: 3), onTimeout: () => false);
      if (isRunning) {
        await FlutterForegroundTask.stopService().timeout(
          const Duration(seconds: 5),
          onTimeout: () => throw TimeoutException('stopService timeout'),
        );
      }
    } catch (e) {
      debugPrint('[StepForegroundService] stop error: $e');
      await StepCounterService.startListening();
      rethrow;
    }
    await StepCounterService.startListening();
  }

  static Future<void> toggle() async {
    if (_isActive) {
      await stop();
    } else {
      await start();
    }
  }

  static Future<void> updateNotification(int steps) async {
    if (!_isActive || !PlatformUtils.isMobileNative || kIsWeb) return;
    try {
      final isRunning = await FlutterForegroundTask.isRunningService
          .timeout(const Duration(seconds: 2), onTimeout: () => false);
      if (isRunning) {
        await FlutterForegroundTask.updateService(
          notificationTitle: 'Vireo · عداد الخطوات شغال',
          notificationText: '$steps خطوة اليوم',
        ).timeout(
          const Duration(seconds: 3),
          onTimeout: () => throw TimeoutException('updateNotification timeout'),
        );
      }
    } catch (_) {}
  }
}
