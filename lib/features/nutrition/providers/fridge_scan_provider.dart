import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/data/repositories/fridge_scan_repository.dart';
import 'package:vireo/data/repositories/nutrition_repository.dart';
import 'package:vireo/core/services/analytics_service.dart';
import 'package:vireo/features/subscription/providers/subscription_provider.dart';

class FridgeScanFlowState {
  const FridgeScanFlowState({
    this.isScanning = false,
    this.scanId,
    this.ingredients = const [],
    this.remainingScans,
    this.errorMessage,
  });

  final bool isScanning;
  final String? scanId;
  final List<String> ingredients;
  final int? remainingScans;
  final String? errorMessage;

  FridgeScanFlowState copyWith({
    bool? isScanning,
    String? scanId,
    List<String>? ingredients,
    int? remainingScans,
    String? errorMessage,
  }) {
    return FridgeScanFlowState(
      isScanning: isScanning ?? this.isScanning,
      scanId: scanId ?? this.scanId,
      ingredients: ingredients ?? this.ingredients,
      remainingScans: remainingScans ?? this.remainingScans,
      errorMessage: errorMessage,
    );
  }
}

class FridgeScanFlowNotifier extends Notifier<FridgeScanFlowState> {
  @override
  FridgeScanFlowState build() => const FridgeScanFlowState();

  void reset() {
    state = const FridgeScanFlowState();
  }

  void setIngredients(List<String> items) {
    state = state.copyWith(ingredients: items, errorMessage: null);
  }

  void addIngredient(String item) {
    final trimmed = item.trim();
    if (trimmed.isEmpty) return;
    if (state.ingredients.any((i) => i.toLowerCase() == trimmed.toLowerCase())) {
      return;
    }
    state = state.copyWith(ingredients: [...state.ingredients, trimmed]);
  }

  void removeIngredient(String item) {
    state = state.copyWith(
      ingredients: state.ingredients.where((i) => i != item).toList(),
    );
  }

  Future<bool> scanFile(File file) async {
    state = state.copyWith(isScanning: true, errorMessage: null);
    try {
      final bytes = await file.readAsBytes();
      final base64 = base64Encode(bytes);
      final result = await ref.read(fridgeScanRepositoryProvider).scanImage(
            imageBase64: base64,
          );
      state = state.copyWith(
        isScanning: false,
        scanId: result.scanId,
        ingredients: result.ingredients,
        remainingScans: result.remainingScans,
      );
      ref.invalidate(remainingFridgeScansProvider);

      final isPremium = ref.read(subscriptionProvider).valueOrNull?.hasPremiumAccess ?? false;
      await AnalyticsService.fridgeScanUsed(
        itemsDetectedCount: result.ingredients.length,
        scanId: result.scanId,
        remainingScans: result.remainingScans,
        isPremium: isPremium,
      );

      return true;
    } on FridgeScanLimitException {
      state = state.copyWith(
        isScanning: false,
        errorMessage: 'SCAN_LIMIT_REACHED',
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isScanning: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }
}

final fridgeScanRepositoryProvider = Provider<FridgeScanRepository>(
  (ref) => const FridgeScanRepository(),
);

final fridgeScanFlowProvider =
    NotifierProvider<FridgeScanFlowNotifier, FridgeScanFlowState>(
  FridgeScanFlowNotifier.new,
);
