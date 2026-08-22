import 'dart:async';

import 'package:flutter/services.dart';

/// Haptic and system-sound cues for the rest timer (§2.4).
abstract final class RestAlertService {
  static bool _fiveSecondAlertFired = false;

  static Future<void> resetAlerts() async {
    _fiveSecondAlertFired = false;
  }

  static Future<void> onTick(int secondsRemaining) async {
    if (secondsRemaining == 5 && !_fiveSecondAlertFired) {
      _fiveSecondAlertFired = true;
      await _pulse();
    }
    if (secondsRemaining == 0) {
      await _pulse(stronger: true);
    }
  }

  static Future<void> _pulse({bool stronger = false}) async {
    try {
      if (stronger) {
        await HapticFeedback.mediumImpact();
      } else {
        await HapticFeedback.lightImpact();
      }
      await SystemSound.play(SystemSoundType.click);
    } catch (_) {
      // Platform may not support haptics in tests or on web.
    }
  }
}
