import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/utils/platform_utils.dart';
import 'package:vireo/features/walking/data/step_counter_service.dart';

@pragma('vm:entry-point')
void startForegroundCallback() {
  FlutterForegroundTask.setTaskHandler(_StepTaskHandler());
}

class _StepTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {}

  @override
  Future<void> onRepeatEvent(DateTime timestamp) async {
    final steps = StepCounterService.latest.todaySteps;
    await FlutterForegroundTask.updateService(
      notificationTitle: 'Vireo · عداد الخطوات شغال',
      notificationText: '$steps خطوة اليوم',
    );
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isDestroyed) async {}
}

abstract final class StepForegroundService {
  static const _activeKey = 'step_service_active';
  static bool _isActive = false;

  static bool get isActive => _isActive;

  static Future<void> init() async {
    if (!PlatformUtils.isMobileNative || kIsWeb) return;

    if (HiveService.isInitialized) {
      _isActive = HiveService.settingsBox.get(_activeKey, defaultValue: true) == true;
    }

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

  static Future<void> start() async {
    _isActive = true;
    if (HiveService.isInitialized) {
      await HiveService.settingsBox.put(_activeKey, true);
    }
    await StepCounterService.startListening();

    if (!PlatformUtils.isMobileNative || kIsWeb) return;

    final steps = StepCounterService.latest.todaySteps;
    try {
      if (await FlutterForegroundTask.isRunningService) {
        await FlutterForegroundTask.updateService(
          notificationTitle: 'Vireo · عداد الخطوات شغال',
          notificationText: '$steps خطوة اليوم',
        );
      } else {
        await FlutterForegroundTask.startService(
          serviceTypes: [ForegroundServiceTypes.health, ForegroundServiceTypes.dataSync],
          notificationTitle: 'Vireo · عداد الخطوات شغال',
          notificationText: '$steps خطوة اليوم',
          callback: startForegroundCallback,
        );
      }
    } catch (_) {}
  }

  static Future<void> stop() async {
    _isActive = false;
    if (HiveService.isInitialized) {
      await HiveService.settingsBox.put(_activeKey, false);
    }
    await StepCounterService.stopListening();

    if (!PlatformUtils.isMobileNative || kIsWeb) return;

    try {
      if (await FlutterForegroundTask.isRunningService) {
        await FlutterForegroundTask.stopService();
      }
    } catch (_) {}
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
      if (await FlutterForegroundTask.isRunningService) {
        await FlutterForegroundTask.updateService(
          notificationTitle: 'Vireo · عداد الخطوات شغال',
          notificationText: '$steps خطوة اليوم',
        );
      }
    } catch (_) {}
  }
}
