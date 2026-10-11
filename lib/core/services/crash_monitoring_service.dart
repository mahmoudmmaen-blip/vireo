import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:vireo/core/config/app_config.dart';

/// Crash and error monitoring abstraction.
/// When Sentry DSN is provided via `--dart-define=SENTRY_DSN=...`, errors are reported.
/// When empty, monitoring is completely disabled without overhead.
abstract final class CrashMonitoringService {
  static bool get isEnabled => AppConfig.sentryDsn.trim().isNotEmpty;

  static Future<void> initialize() async {
    if (!isEnabled) {
      if (kDebugMode) {
        debugPrint('[CrashMonitoring] Disabled (no SENTRY_DSN provided)');
      }
      return;
    }

    if (kDebugMode) {
      debugPrint(
        '[CrashMonitoring] Initialized for env: ${AppConfig.appEnvironment}, release: ${AppConfig.appRelease}',
      );
    }
  }

  /// Records an uncaught error or exception without attaching sensitive health/personal data.
  static Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    if (!isEnabled) return;

    if (kDebugMode) {
      debugPrint('[CrashMonitoring ERROR] reason: $reason, fatal: $fatal, err: $error');
    }

    try {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
        withScope: (scope) {
          if (reason != null) {
            scope.setTag('reason', reason);
          }
          scope.setTag('environment', AppConfig.appEnvironment);
          scope.setTag('fatal', fatal.toString());
        },
      );
    } catch (_) {}
  }

  /// Breadcrumbs for app flow (no health data allowed).
  static void addBreadcrumb(String message, {String category = 'navigation'}) {
    if (!isEnabled) return;
    if (kDebugMode) {
      debugPrint('[CrashMonitoring Breadcrumb] ($category) $message');
    }
    try {
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: message,
          category: category,
          level: SentryLevel.info,
        ),
      );
    } catch (_) {}
  }
}
