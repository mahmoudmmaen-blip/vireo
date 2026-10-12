import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Text-to-speech engine providing voice cues during workout sessions.
class WorkoutTtsService {
  WorkoutTtsService._();
  static final WorkoutTtsService instance = WorkoutTtsService._();

  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;
  bool isMuted = false;

  Future<void> _init() async {
    if (_initialized) return;
    try {
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        await _tts.setSpeechRate(0.5);
        await _tts.setVolume(1.0);
        await _tts.setPitch(1.0);
      }
      _initialized = true;
    } catch (e) {
      debugPrint('[WorkoutTtsService] Init error: $e');
    }
  }

  /// Speaks cue in language [languageCode] (e.g. 'ar' or 'en').
  Future<void> speak(String text, {required String languageCode}) async {
    if (isMuted) return;
    await _init();
    try {
      final targetLang = languageCode.startsWith('ar') ? 'ar' : 'en-US';
      await _tts.setLanguage(targetLang);
      await _tts.speak(text);
    } catch (e) {
      // Fallback silently if TTS language not supported on emulator
      debugPrint('[WorkoutTtsService] speak failed: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }
}
