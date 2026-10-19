import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/boot/boot_log.dart';
import 'package:vireo/core/services/analytics_service.dart';
import 'package:vireo/features/ai_nutrition/application/ai_scan_state.dart';
import 'package:vireo/features/ai_nutrition/data/gemini_food_service.dart';
import 'package:vireo/features/ai_nutrition/data/gemini_food_service_core.dart';
import 'package:vireo/features/ai_nutrition/data/pending_meal_scan_queue.dart';
import 'package:vireo/features/ai_nutrition/domain/i_food_vision_service.dart';
import 'package:vireo/features/ai_nutrition/providers/ai_scan_budget_provider.dart';
import 'package:vireo/features/ai_nutrition/utils/image_compressor.dart';
import 'package:vireo/features/subscription/meal_scan_quota.dart';

final foodVisionServiceProvider = Provider<IFoodVisionService>(
  (ref) => GeminiFoodService(),
);

class AiScanNotifier extends AsyncNotifier<AiScanState> {
  @override
  FutureOr<AiScanState> build() => const AiScanIdle();

  void reset() {
    state = const AsyncValue.data(AiScanIdle());
  }

  void _setScanning(Uint8List? preview, AiScanStage stage) {
    state = AsyncValue.data(
      AiScanScanning(previewBytes: preview, stage: stage),
    );
  }

  Future<void> scanMeal(
    Object image, {
    String language = 'ar',
    String? userHint,
  }) async {
    Uint8List? preview;
    try {
      preview = await mealImageToBytes(image);
    } catch (_) {
      preview = image is Uint8List ? image : null;
    }
    final bytes = preview ?? await mealImageToBytes(image);
    await scanMealMulti([bytes], language: language, userHint: userHint);
  }

  Future<void> scanMealMulti(
    List<Uint8List> images, {
    String language = 'ar',
    String? userHint,
  }) async {
    final preview = images.isNotEmpty ? images.first : null;
    _setScanning(preview, AiScanStage.readingPlate);
    unawaited(AnalyticsService.scanStarted(mode: 'photo'));
    final sw = Stopwatch()..start();

    try {
      final compressed = <Uint8List>[];
      for (final img in images.take(5)) {
        compressed.add(await MealImageCompressor.compress(img));
      }

      final draft = await GeminiFoodServiceCore.analyzeImagesToDraft(
        compressed,
        ref.read(remainingCaloriesForAiScanProvider),
        ref.read(remainingProteinForAiScanProvider),
        language: language,
        userHint: userHint,
        alreadyCompressed: true,
        onStage: (stage) {
          _setScanning(
            preview ?? (compressed.isNotEmpty ? compressed.first : null),
            stage,
          );
        },
      );
      await MealScanQuota.recordScanConsumed();
      sw.stop();
      BootLog.step('ai scan ok duration_ms=${sw.elapsedMilliseconds}');
      if (sw.elapsedMilliseconds > 8000) {
        BootLog.warn(
          'ai scan slower than 8s target: ${sw.elapsedMilliseconds}ms',
        );
      }
      unawaited(
        AnalyticsService.scanSucceeded(
          itemsCount: draft.lines.length,
          durationMs: sw.elapsedMilliseconds,
        ),
      );
      state = AsyncValue.data(AiScanSuccess(draft));
    } on FoodVisionOfflineException {
      sw.stop();
      unawaited(AnalyticsService.scanFailed(errorType: 'offline'));
      // Queue compressed images for when connectivity returns.
      try {
        final toQueue = <Uint8List>[];
        for (final img in images.take(5)) {
          toQueue.add(await MealImageCompressor.compress(img));
        }
        await PendingMealScanQueue.enqueue(
          images: toQueue,
          language: language,
          userHint: userHint,
        );
      } catch (e) {
        BootLog.warn('pending meal scan enqueue failed', e);
      }
      state = AsyncValue.data(
        AiScanError(AiScanErrorKind.offline, previewBytes: preview),
      );
    } on FoodVisionNoFoodException {
      sw.stop();
      unawaited(AnalyticsService.scanFailed(errorType: 'no_food'));
      state = AsyncValue.data(
        AiScanError(AiScanErrorKind.noFood, previewBytes: preview),
      );
    } on FoodVisionParseException {
      sw.stop();
      unawaited(AnalyticsService.scanFailed(errorType: 'parse'));
      state = AsyncValue.data(
        AiScanError(AiScanErrorKind.parse, previewBytes: preview),
      );
    } on FoodVisionConfigException {
      sw.stop();
      unawaited(AnalyticsService.scanFailed(errorType: 'config'));
      state = AsyncValue.data(
        AiScanError(AiScanErrorKind.config, previewBytes: preview),
      );
    } on FoodVisionDailyLimitException {
      sw.stop();
      unawaited(AnalyticsService.scanFailed(errorType: 'daily_limit'));
      state = AsyncValue.data(
        AiScanError(AiScanErrorKind.dailyLimit, previewBytes: preview),
      );
    } on FoodVisionTimeoutException {
      sw.stop();
      unawaited(AnalyticsService.scanFailed(errorType: 'timeout'));
      state = AsyncValue.data(
        AiScanError(AiScanErrorKind.timeout, previewBytes: preview),
      );
    } on FoodVisionException catch (e) {
      sw.stop();
      BootLog.warn('ai scan FoodVisionException', e);
      unawaited(AnalyticsService.scanFailed(errorType: 'api'));
      state = AsyncValue.data(
        AiScanError(AiScanErrorKind.api, previewBytes: preview),
      );
    } catch (e) {
      sw.stop();
      BootLog.warn('ai scan unexpected', e);
      unawaited(AnalyticsService.scanFailed(errorType: 'unexpected'));
      state = AsyncValue.data(
        AiScanError(AiScanErrorKind.api, previewBytes: preview),
      );
    }
  }
}

final aiScanProvider =
    AsyncNotifierProvider<AiScanNotifier, AiScanState>(AiScanNotifier.new);

final aiScanPhaseProvider = Provider<AiScanState>((ref) {
  return ref.watch(aiScanProvider).valueOrNull ?? const AiScanIdle();
});
