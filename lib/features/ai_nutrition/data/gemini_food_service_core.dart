import 'dart:convert';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vireo/core/boot/boot_log.dart';
import 'package:vireo/core/config/app_config.dart';
import 'package:vireo/core/services/supabase_service.dart';
import 'package:vireo/features/ai_nutrition/application/ai_scan_stage.dart';
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
    this.imagesBytes = const [],
    this.originalScanned = const [],
    this.fromCache = false,
    this.cachedAt,
    this.language = 'ar',
    this.userHint,
  });

  final List<ResolvedMealLine> lines;
  final Uint8List imageBytes;
  final List<Uint8List> imagesBytes;
  final List<ScannedFoodItem> originalScanned;

  /// True when analyze-meal returned its 24 h cached result for this photo
  /// (the review screen then offers "حلّل تاني").
  final bool fromCache;
  final DateTime? cachedAt;

  /// Request context, kept so "حلّل تاني" can re-send the same request.
  final String language;
  final String? userHint;

  List<Uint8List> get allImages =>
      imagesBytes.isNotEmpty ? imagesBytes : (imageBytes.isNotEmpty ? [imageBytes] : []);

  FoodAnalysisResult toAnalysisResult({String language = 'ar'}) {
    final kcal = lines.fold<double>(0, (s, l) => s + l.kcal).round();
    final protein = lines.fold<double>(0, (s, l) => s + l.protein);
    final carbs = lines.fold<double>(0, (s, l) => s + l.carbs);
    final fats = lines.fold<double>(0, (s, l) => s + l.fat);
    final isArabic = language.startsWith('ar');
    final name = lines
        .map((l) => isArabic ? l.nameAr : (l.nameEn.isNotEmpty ? l.nameEn : l.nameAr))
        .where((n) => n.isNotEmpty)
        .join(' + ');
    final defaultName = isArabic ? 'وجبة' : 'Meal';
    return FoodAnalysisResult(
      foodName: name.isEmpty ? defaultName : name,
      calories: kcal,
      protein: protein,
      carbs: carbs,
      fats: fats,
      portionEstimate: lines
          .map((l) => '${l.grams.round()}g ${isArabic ? l.nameAr : l.nameEn}')
          .join(', '),
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
  }) =>
      analyzeImagesToDraft(
        [imageBytes],
        remainingCalories,
        remainingProtein,
        language: language,
        userHint: userHint,
      );

  static Future<MealScanDraft> analyzeImagesToDraft(
    List<Uint8List> images,
    int remainingCalories,
    double remainingProtein, {
    String language = 'ar',
    String? userHint,
    bool forceReanalyze = false,
    bool alreadyCompressed = false,
    void Function(AiScanStage stage)? onStage,
  }) async {
    if (!SupabaseService.isInitialized) {
      throw const FoodVisionOfflineException();
    }

    try {
      onStage?.call(AiScanStage.readingPlate);
      final compressedImages = <Uint8List>[];
      for (final img in images.take(5)) {
        // Re-sending the exact same bytes keeps the server image hash stable,
        // so "حلّل تاني" refreshes the same 24 h cache entry.
        compressedImages.add(
          alreadyCompressed ? img : await MealImageCompressor.compress(img),
        );
      }
      if (compressedImages.isEmpty) {
        throw const FoodVisionParseException();
      }

      onStage?.call(AiScanStage.identifyingIngredients);
      final payload = <String, dynamic>{
        'images': compressedImages.map(base64Encode).toList(),
        // Keep image_base64 for backward compatibility with existing server
        'image_base64': base64Encode(compressedImages.first),
        'mime_type': MealImageCompressor.mimeType,
        'remaining_calories': remainingCalories,
        'remaining_protein': remainingProtein,
        'language': language,
        if (userHint != null && userHint.trim().isNotEmpty)
          'user_hint': userHint.trim(),
        // "حلّل تاني": skip the server's 24 h image-hash cache.
        if (forceReanalyze) 'forceReanalyze': true,
      };

      final response = await SupabaseService.client.functions.invoke(
        AppConfig.analyzeMealFunctionName,
        body: payload,
      ).timeout(
        const Duration(seconds: 25),
        onTimeout: () => throw const FoodVisionTimeoutException(),
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
        throw const FoodVisionNoFoodException();
      }
      onStage?.call(AiScanStage.estimatingOil);
      final fromCache = data is Map && data['cached'] == true;
      final cachedAt = data is Map && data['cached_at'] is String
          ? DateTime.tryParse(data['cached_at'] as String)
          : null;
      try {
        final lines =
            await _resolver.resolveItems(scanned, language: language);
        BootLog.step('analyze-meal resolved=${lines.length}');
        return MealScanDraft(
          lines: lines,
          imageBytes: compressedImages.first,
          imagesBytes: compressedImages,
          fromCache: fromCache,
          cachedAt: cachedAt,
          language: language,
          userHint: userHint,
        );
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
        return MealScanDraft(
          lines: fallback,
          imageBytes: compressedImages.first,
          imagesBytes: compressedImages,
          fromCache: fromCache,
          cachedAt: cachedAt,
          language: language,
          userHint: userHint,
        );
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
