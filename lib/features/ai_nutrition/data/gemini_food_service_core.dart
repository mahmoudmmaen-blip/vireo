import 'dart:convert';
import 'dart:typed_data';

import 'package:vireo/core/config/app_config.dart';
import 'package:vireo/core/services/supabase_service.dart';
import 'package:vireo/features/ai_nutrition/domain/food_analysis_result.dart';
import 'package:vireo/features/ai_nutrition/domain/i_food_vision_service.dart';
import 'package:vireo/features/ai_nutrition/utils/image_compressor.dart';

abstract final class GeminiFoodServiceCore {
  static Future<FoodAnalysisResult> analyzeBytes(
    Uint8List imageBytes,
    int remainingCalories,
    double remainingProtein, {
    String language = 'ar',
  }) async {
    if (!SupabaseService.isInitialized) {
      throw const FoodVisionOfflineException();
    }

    try {
      final bytes = await MealImageCompressor.compress(imageBytes);
      final response = await SupabaseService.client.functions.invoke(
        AppConfig.analyzeMealFunctionName,
        body: {
          'image_base64': base64Encode(bytes),
          'mime_type': 'image/jpeg',
          'remaining_calories': remainingCalories,
          'remaining_protein': remainingProtein,
          'language': language,
        },
      );

      final data = response.data;
      final errorCode = data is Map ? data['error']?.toString() : null;

      if (response.status == 429 || errorCode == 'DAILY_LIMIT') {
        throw const FoodVisionDailyLimitException();
      }
      if (response.status == 401) {
        throw const FoodVisionConfigException();
      }
      if (response.status >= 400) {
        if (errorCode == 'GEMINI_NOT_CONFIGURED') {
          throw const FoodVisionConfigException();
        }
        throw FoodVisionApiException(errorCode ?? 'API_ERROR');
      }

      if (data is! Map) {
        throw const FoodVisionParseException();
      }
      return FoodAnalysisResult.fromJson(Map<String, dynamic>.from(data));
    } on FoodVisionException {
      rethrow;
    } catch (e) {
      final text = e.toString().toLowerCase();
      if (text.contains('socket') ||
          text.contains('network') ||
          text.contains('connection') ||
          text.contains('failed host lookup') ||
          text.contains('offline') ||
          text.contains('not initialized')) {
        throw const FoodVisionOfflineException();
      }
      throw FoodVisionApiException(e.toString());
    }
  }
}
