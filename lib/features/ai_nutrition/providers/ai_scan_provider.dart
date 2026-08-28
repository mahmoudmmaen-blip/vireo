import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/features/ai_nutrition/application/ai_scan_state.dart';
import 'package:vireo/features/ai_nutrition/data/gemini_food_service.dart';
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

  /// Scan meal from native [File] or web [Uint8List] (via [analyzeImageFile]).
  Future<void> scanMeal(Object image) async {
    Uint8List? preview;
    try {
      preview = await mealImageToBytes(image);
    } catch (_) {
      preview = image is Uint8List ? image : null;
    }

    state = AsyncValue.data(AiScanScanning(previewBytes: preview));

    try {
      final result = await analyzeImageFile(
        ref.read(foodVisionServiceProvider),
        image,
        ref.read(remainingCaloriesForAiScanProvider),
        ref.read(remainingProteinForAiScanProvider),
      );
      state = AsyncValue.data(AiScanSuccess(result));
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
    } on FoodVisionException {
      state = AsyncValue.data(
        AiScanError(AiScanErrorKind.api, previewBytes: preview),
      );
    } catch (_) {
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
