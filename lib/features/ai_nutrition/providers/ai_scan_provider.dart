import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/boot/boot_log.dart';
import 'package:vireo/features/ai_nutrition/application/ai_scan_state.dart';
import 'package:vireo/features/ai_nutrition/data/gemini_food_service.dart';
import 'package:vireo/features/ai_nutrition/data/gemini_food_service_core.dart';
import 'package:vireo/features/ai_nutrition/domain/i_food_vision_service.dart';
import 'package:vireo/features/ai_nutrition/providers/ai_scan_budget_provider.dart';

final foodVisionServiceProvider = Provider<IFoodVisionService>(
  (ref) => GeminiFoodService(),
);

class AiScanNotifier extends AsyncNotifier<AiScanState> {
  @override
  Future<AiScanState> build() async => const AiScanIdle();

  void reset() {
    state = const AsyncValue.data(AiScanIdle());
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

    state = AsyncValue.data(
      AiScanScanning(previewBytes: preview, hint: 'rice…'),
    );

    try {
      final bytes = preview ?? await mealImageToBytes(image);
      final draft = await GeminiFoodServiceCore.analyzeBytesToDraft(
        bytes,
        ref.read(remainingCaloriesForAiScanProvider),
        ref.read(remainingProteinForAiScanProvider),
        language: language,
        userHint: userHint,
      );
      state = AsyncValue.data(AiScanSuccess(draft));
    } on FoodVisionOfflineException {
      state = AsyncValue.data(
        AiScanError(AiScanErrorKind.offline, previewBytes: preview),
      );
    } on FoodVisionParseException {
      state = AsyncValue.data(
        AiScanError(AiScanErrorKind.parse, previewBytes: preview),
      );
    } on FoodVisionConfigException {
      state = AsyncValue.data(
        AiScanError(AiScanErrorKind.config, previewBytes: preview),
      );
    } on FoodVisionDailyLimitException {
      state = AsyncValue.data(
        AiScanError(AiScanErrorKind.dailyLimit, previewBytes: preview),
      );
    } on FoodVisionException catch (e) {
      BootLog.warn('ai scan FoodVisionException', e);
      state = AsyncValue.data(
        AiScanError(AiScanErrorKind.api, previewBytes: preview),
      );
    } catch (e) {
      BootLog.warn('ai scan unexpected', e);
      state = AsyncValue.data(
        AiScanError(AiScanErrorKind.api, previewBytes: preview),
      );
    }
  }

  Future<void> scanMealMulti(
    List<Uint8List> images, {
    String language = 'ar',
    String? userHint,
  }) async {
    final preview = images.isNotEmpty ? images.first : null;
    state = AsyncValue.data(
      AiScanScanning(previewBytes: preview, hint: 'rice…'),
    );

    try {
      final draft = await GeminiFoodServiceCore.analyzeImagesToDraft(
        images,
        ref.read(remainingCaloriesForAiScanProvider),
        ref.read(remainingProteinForAiScanProvider),
        language: language,
        userHint: userHint,
      );
      state = AsyncValue.data(AiScanSuccess(draft));
    } on FoodVisionOfflineException {
      state = AsyncValue.data(
        AiScanError(AiScanErrorKind.offline, previewBytes: preview),
      );
    } on FoodVisionParseException {
      state = AsyncValue.data(
        AiScanError(AiScanErrorKind.parse, previewBytes: preview),
      );
    } on FoodVisionConfigException {
      state = AsyncValue.data(
        AiScanError(AiScanErrorKind.config, previewBytes: preview),
      );
    } on FoodVisionDailyLimitException {
      state = AsyncValue.data(
        AiScanError(AiScanErrorKind.dailyLimit, previewBytes: preview),
      );
    } on FoodVisionException catch (e) {
      BootLog.warn('ai scan FoodVisionException', e);
      state = AsyncValue.data(
        AiScanError(AiScanErrorKind.api, previewBytes: preview),
      );
    } catch (e) {
      BootLog.warn('ai scan unexpected', e);
      state = AsyncValue.data(
        AiScanError(AiScanErrorKind.api, previewBytes: preview),
      );
    }
  }
}

final aiScanProvider =
    AsyncNotifierProvider<AiScanNotifier, AiScanState>(AiScanNotifier.new);

final aiScanPhaseProvider = Provider<AiScanState>((ref) {
  return ref.watch(aiScanProvider).value ?? const AiScanIdle();
});
