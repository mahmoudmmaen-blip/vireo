import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

/// Haptic and audio cues for the rest timer.
abstract final class RestAlertService {
  static final AudioPlayer _player = AudioPlayer();
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
      await _player.play(AssetSource('sounds/rest_beep.mp3'), volume: 0.35);
    } catch (_) {
      // Asset or platform may be unavailable — haptic still fired.
      try {
        await SystemSound.play(SystemSoundType.click);
      } catch (_) {}
    }
  }

  static Future<void> dispose() async {
    await _player.dispose();
  }
}
