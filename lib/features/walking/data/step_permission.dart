import 'package:permission_handler/permission_handler.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/utils/platform_utils.dart';

/// Activity Recognition (Android) / Motion sensors (iOS).
abstract final class StepPermission {
  static const _acceptedKey = 'step_counting_accepted';

  static bool get isSupported => PlatformUtils.isMobileNative;

  static bool _localAccepted() {
    if (!HiveService.isInitialized) return false;
    return HiveService.settingsBox.get(_acceptedKey, defaultValue: false) ==
        true;
  }

  static Future<void> _markAccepted() async {
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.put(_acceptedKey, true);
  }

  static Future<bool> isGranted() async {
    if (!isSupported) return false;
    if (PlatformUtils.isAndroid) {
      return Permission.activityRecognition.isGranted;
    }
    // iOS: Core Motion dialog is tied to starting the pedometer stream.
    if (_localAccepted()) return true;
    final sensors = await Permission.sensors.status;
    return sensors.isGranted || sensors.isLimited;
  }

  static Future<bool> request() async {
    if (!isSupported) return false;
    if (PlatformUtils.isAndroid) {
      final status = await Permission.activityRecognition.request();
      if (status.isGranted) await _markAccepted();
      return status.isGranted;
    }
    // Prefer sensors permission; always mark accepted after the in-app CTA so
    // startListening can surface the Core Motion system dialog.
    final status = await Permission.sensors.request();
    await _markAccepted();
    return !status.isPermanentlyDenied;
  }

  static Future<void> openSettings() => openAppSettings();
}
