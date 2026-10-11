import 'dart:convert';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vireo/core/boot/boot_log.dart';
import 'package:vireo/core/config/app_config.dart';
import 'package:vireo/core/services/supabase_service.dart';
import 'package:vireo/features/ai_nutrition/domain/food_analysis_result.dart';
import 'package:vireo/features/ai_nutrition/domain/i_food_vision_service.dart';
import 'package:vireo/features/ai_nutrition/utils/image_compressor.dart';
import 'package:vireo/features/nutrition/data/food_db_models.dart';
import 'package:vireo/features/nutrition/data/food_db_repository.dart';
import 'package:vireo/features/nutrition/data/meal_resolution_service.dart';

class MealScanDraft {
  const MealScanDraft({
    required this.lines,
    required this.imageBytes,
  });

  final List<ResolvedMealLine> lines;
  final Uint8List imageBytes;

  FoodAnalysisResult toAnalysisResult() {
    final kcal = lines.fold<double>(0, (s, l) => s + l.kcal).round();
    final protein = lines.fold<double>(0, (s, l) => s + l.protein);
    final carbs = lines.fold<double>(0, (s, l) => s + l.carbs);
    final fats = lines.fold<double>(0, (s, l) => s + l.fat);
    final name = lines.map((l) => l.nameAr).where((n) => n.isNotEmpty).join(' + ');
    return FoodAnalysisResult(
      foodName: name.isEmpty ? 'وجبة' : name,
      calories: kcal,
      protein: protein,
      carbs: carbs,
      fats: fats,
      portionEstimate: lines.map((l) => '${l.grams.round()}g ${l.nameEn}').join(', '),
      isHighCalorie: kcal > 600,
      smartSwaps: const [],
    );
  }
}

abstract final class GeminiFoodServiceCore {
  static final _resolver = MealResolutionService(FoodDbRepository.instance);

  static Future<MealScanDraft> analyzeBytesToDraft(
    Uint8List imageBytes,
    int remainingCalories,
    double remainingProtein, {
    String language = 'ar',
    String? userHint,
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
          if (userHint != null && userHint.trim().isNotEmpty)
            'user_hint': userHint.trim(),
        },
      );

      final data = response.data;
      final errorCode = data is Map ? data['error']?.toString() : null;
      BootLog.step(
        'analyze-meal status=${response.status} error=$errorCode',
      );

      if (response.status == 429 || errorCode == 'DAILY_LIMIT') {
        throw const FoodVisionDailyLimitException();
      }
      if (response.status == 401) {
        throw const FoodVisionConfigException();
      }
      if (response.status >= 400) {
        BootLog.warn('analyze-meal failed', errorCode ?? data);
        if (errorCode == 'GEMINI_NOT_CONFIGURED') {
          throw const FoodVisionConfigException();
        }
        throw FoodVisionApiException(errorCode ?? 'API_ERROR');
      }

      final scanned = parseScannedItems(data);
      BootLog.step('analyze-meal items=${scanned.length}');
      if (scanned.isEmpty) {
        throw const FoodVisionParseException();
      }
      try {
        final lines =
            await _resolver.resolveItems(scanned, language: language);
        BootLog.step('analyze-meal resolved=${lines.length}');
        return MealScanDraft(lines: lines, imageBytes: bytes);
      } catch (e) {
        // Never lose a successful vision response to local DB issues.
        BootLog.warn('analyze-meal resolve failed — using estimates', e);
        final fallback = [
          for (final item in scanned)
            resolveLine(
              scanned: item,
              estimatedPer100g: const FoodMacros100g(
                kcal: 150,
                protein: 5,
                carbs: 15,
                fat: 6,
                fiber: 1,
              ),
            ),
        ];
        return MealScanDraft(lines: fallback, imageBytes: bytes);
      }
    } on FunctionException catch (e) {
      BootLog.warn(
        'analyze-meal FunctionException status=${e.status} body=${e.details}',
      );
      if (e.status == 429) throw const FoodVisionDailyLimitException();
      if (e.status == 401) throw const FoodVisionConfigException();
      throw FoodVisionApiException(e.details?.toString() ?? 'API_ERROR');
    } on FoodVisionException {
      rethrow;
    } catch (e) {
      final text = e.toString().toLowerCase();
      if (text.contains('socket') ||
          text.contains('network') ||
          text.contains('connection') ||
          text.contains('failed host lookup') ||
          text.contains('failed to fetch') ||
          text.contains('offline') ||
          text.contains('not initialized')) {
        throw const FoodVisionOfflineException();
      }
      BootLog.warn('analyze-meal unexpected', e);
      throw FoodVisionApiException(e.toString());
    }
  }

  /// Backward-compatible wrapper used by older callers.
  static Future<FoodAnalysisResult> analyzeBytes(
    Uint8List imageBytes,
    int remainingCalories,
    double remainingProtein, {
    String language = 'ar',
  }) async {
    final draft = await analyzeBytesToDraft(
      imageBytes,
      remainingCalories,
      remainingProtein,
      language: language,
    );
    return draft.toAnalysisResult();
  }

  static Future<MealScanDraft> parseTextToDraft(
    String text, {
    String language = 'ar',
  }) async {
    if (!SupabaseService.isInitialized) {
      throw const FoodVisionOfflineException();
    }
    try {
      final response = await SupabaseService.client.functions.invoke(
        AppConfig.parseMealTextFunctionName,
        body: {'text': text, 'language': language},
      );
      final data = response.data;
      final errorCode = data is Map ? data['error']?.toString() : null;
      BootLog.step('parse-meal-text status=${response.status} error=$errorCode');
      if (response.status == 429 || errorCode == 'DAILY_LIMIT') {
        throw const FoodVisionDailyLimitException();
      }
      if (response.status >= 400) {
        throw FoodVisionApiException(errorCode ?? 'API_ERROR');
      }
      final scanned = parseScannedItems(data);
      if (scanned.isEmpty) throw const FoodVisionParseException();
      final lines = await _resolver.resolveItems(scanned, language: language);
      return MealScanDraft(lines: lines, imageBytes: Uint8List(0));
    } on FunctionException catch (e) {
      BootLog.warn('parse-meal-text FunctionException ${e.status} ${e.details}');
      if (e.status == 429) throw const FoodVisionDailyLimitException();
      throw FoodVisionApiException(e.details?.toString() ?? 'API_ERROR');
    } on FoodVisionException {
      rethrow;
    } catch (e) {
      BootLog.warn('parse-meal-text unexpected', e);
      throw FoodVisionApiException(e.toString());
    }
  }
}
