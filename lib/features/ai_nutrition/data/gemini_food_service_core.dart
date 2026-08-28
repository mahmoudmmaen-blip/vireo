import 'dart:convert';
import 'dart:typed_data';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:vireo/core/config/app_config.dart';
import 'package:vireo/core/config/vireo_ai_prompts.dart';
import 'package:vireo/features/ai_nutrition/domain/food_analysis_result.dart';
import 'package:vireo/features/ai_nutrition/domain/i_food_vision_service.dart';
import 'package:vireo/features/ai_nutrition/utils/image_compressor.dart';

abstract final class GeminiFoodServiceCore {
  static const modelName = 'gemini-1.5-flash';

  static Future<FoodAnalysisResult> analyzeBytes(
    Uint8List imageBytes,
    int remainingCalories,
    double remainingProtein, {
    String? apiKey,
  }) async {
    final key = apiKey ?? AppConfig.geminiApiKey;
    if (key.isEmpty) {
      throw const FoodVisionConfigException();
    }

    try {
      final bytes = await MealImageCompressor.compress(imageBytes);

      final model = GenerativeModel(
        model: modelName,
        apiKey: key,
        generationConfig: GenerationConfig(
          temperature: 0.2,
          responseMimeType: 'application/json',
        ),
      );

      final prompt = VireoAiPrompts.mealVisionPrompt(
        remainingCalories: remainingCalories,
        remainingProtein: remainingProtein,
      );

      final response = await model.generateContent([
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', bytes),
        ]),
      ]);

      final text = response.text;
      if (text == null || text.trim().isEmpty) {
        throw const FoodVisionApiException('EMPTY_RESPONSE');
      }

      return _parseResponse(text);
    } on FoodVisionException {
      rethrow;
    } on GenerativeAIException catch (e) {
      final msg = e.message.toLowerCase();
      if (msg.contains('network') ||
          msg.contains('connection') ||
          msg.contains('offline') ||
          msg.contains('fetch')) {
        throw const FoodVisionOfflineException();
      }
      throw FoodVisionApiException(e.message);
    } catch (e) {
      if (e is FoodVisionException) rethrow;
      final text = e.toString().toLowerCase();
      if (text.contains('socket') ||
          text.contains('network') ||
          text.contains('connection') ||
          text.contains('failed host lookup')) {
        throw const FoodVisionOfflineException();
      }
      throw FoodVisionApiException(e.toString());
    }
  }

  static FoodAnalysisResult _parseResponse(String raw) {
    try {
      final jsonText = _extractJson(raw);
      final decoded = jsonDecode(jsonText);
      if (decoded is! Map<String, dynamic>) {
        throw const FoodVisionParseException();
      }
      return FoodAnalysisResult.fromJson(decoded);
    } on FoodVisionException {
      rethrow;
    } catch (_) {
      throw const FoodVisionParseException();
    }
  }

  static String _extractJson(String raw) {
    var text = raw.trim();
    if (text.startsWith('```')) {
      text = text.replaceFirst(RegExp(r'^```(?:json)?\s*'), '');
      text = text.replaceFirst(RegExp(r'\s*```$'), '');
    }
    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');
    if (start >= 0 && end > start) {
      return text.substring(start, end + 1);
    }
    return text;
  }
}
