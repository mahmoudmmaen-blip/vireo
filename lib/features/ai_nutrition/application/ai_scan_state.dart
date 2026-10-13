import 'dart:typed_data';

import 'package:vireo/features/ai_nutrition/data/gemini_food_service_core.dart';
import 'package:vireo/features/ai_nutrition/domain/food_analysis_result.dart';

enum AiScanErrorKind { offline, api, parse, config, dailyLimit, timeout, noFood }

/// Meal scan state machine: idle → scanning → success | error.
sealed class AiScanState {
  const AiScanState();
}

final class AiScanIdle extends AiScanState {
  const AiScanIdle();
}

final class AiScanScanning extends AiScanState {
  const AiScanScanning({this.previewBytes, this.hint});

  final Uint8List? previewBytes;
  final String? hint;
}

final class AiScanSuccess extends AiScanState {
  const AiScanSuccess(this.draft);

  final MealScanDraft draft;

  FoodAnalysisResult get result => draft.toAnalysisResult();
}

final class AiScanError extends AiScanState {
  const AiScanError(this.kind, {this.previewBytes});

  final AiScanErrorKind kind;
  final Uint8List? previewBytes;
}

extension AiScanStateX on AiScanState {
  bool get isIdle => this is AiScanIdle;
  bool get isScanning => this is AiScanScanning;
  bool get isSuccess => this is AiScanSuccess;
  bool get isError => this is AiScanError;

  FoodAnalysisResult? get resultOrNull =>
      this is AiScanSuccess ? (this as AiScanSuccess).result : null;

  MealScanDraft? get draftOrNull =>
      this is AiScanSuccess ? (this as AiScanSuccess).draft : null;

  AiScanErrorKind? get errorKindOrNull =>
      this is AiScanError ? (this as AiScanError).kind : null;

  Uint8List? get previewBytes => switch (this) {
        AiScanScanning(:final previewBytes) => previewBytes,
        AiScanError(:final previewBytes) => previewBytes,
        _ => null,
      };
}
