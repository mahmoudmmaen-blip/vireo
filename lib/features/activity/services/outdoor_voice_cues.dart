import 'package:flutter_tts/flutter_tts.dart';
import 'package:vireo/features/activity/domain/outdoor_workout_models.dart';

abstract final class OutdoorVoiceCues {
  static final _tts = FlutterTts();
  static int _lastKm = 0;

  static Future<void> configure(String languageCode) async {
    await _tts.setLanguage(languageCode == 'ar' ? 'ar-SA' : 'en-US');
    await _tts.setSpeechRate(0.45);
    _lastKm = 0;
  }

  static Future<void> speakKm({
    required int km,
    required int elapsedSeconds,
    required OutdoorWorkoutType type,
    required double? paceMinPerKm,
    required String languageCode,
  }) async {
    if (km <= _lastKm) return;
    _lastKm = km;

    final mins = elapsedSeconds ~/ 60;
    final secs = elapsedSeconds % 60;
    final timeStr = languageCode == 'ar'
        ? '$mins دقيقة و $secs ثانية'
        : '$mins minutes $secs seconds';

    String paceStr = '';
    if (type != OutdoorWorkoutType.cycle && paceMinPerKm != null) {
      final pMin = paceMinPerKm.floor();
      final pSec = ((paceMinPerKm - pMin) * 60).round();
      paceStr = languageCode == 'ar'
          ? '، وتيرة $pMin:$pSec للكيلومتر'
          : ', pace $pMin:${pSec.toString().padLeft(2, '0')} per kilometer';
    }

    final text = languageCode == 'ar'
        ? 'أنجزت $km كيلومتر في $timeStr$paceStr'
        : 'Completed $km kilometers in $timeStr$paceStr';

    await _tts.stop();
    await _tts.speak(text);
  }

  static void reset() => _lastKm = 0;
}
