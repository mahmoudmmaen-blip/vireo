import 'dart:async';

import 'package:flutter/foundation.dart';

/// Boot-time diagnostic logging for startup hangs (Windows desktop, etc.).
abstract final class BootLog {
  static void step(String message) {
    debugPrint('[BOOT] $message');
  }

  static void ok(String message) {
    debugPrint('[BOOT] $message done');
  }

  static void warn(String message, [Object? error]) {
    if (error != null) {
      debugPrint('[BOOT] $message — $error');
    } else {
      debugPrint('[BOOT] $message');
    }
  }
}

/// Default timeout for optional external services at startup.
const bootServiceTimeout = Duration(seconds: 5);

Future<T> bootWithTimeout<T>(
  String label,
  Future<T> Function() action, {
  Duration timeout = bootServiceTimeout,
  required T onTimeout,
}) async {
  BootLog.step('Starting $label...');
  try {
    final result = await action().timeout(timeout);
    BootLog.ok(label);
    return result;
  } on TimeoutException catch (e) {
    BootLog.warn('$label timed out after ${timeout.inSeconds}s', e);
    return onTimeout;
  } catch (e, st) {
    BootLog.warn('$label failed', e);
    if (kDebugMode) {
      debugPrint('[BOOT] $label stack: $st');
    }
    rethrow;
  }
}
