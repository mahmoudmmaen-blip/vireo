import 'package:flutter/foundation.dart';

/// Web-safe platform checks — never use `dart:io` `Platform` in UI or services.
abstract final class PlatformUtils {
  static bool get isWeb => kIsWeb;

  static bool get isIOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  static bool get isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  static bool get isMacOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;

  static bool get isApplePlatform => isIOS || isMacOS;

  static bool get isMobileNative => isIOS || isAndroid;

  static bool get isHealthStepsSupported => isMobileNative;
}
