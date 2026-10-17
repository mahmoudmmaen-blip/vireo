import 'package:flutter/foundation.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/features/activity/domain/acsm_net_energy.dart';
import 'package:vireo/features/activity/domain/stride_calibration.dart';

/// Accurate walking metrics — NET kcal (ACSM), personal stride, fat ≈ kcal/7.7.
@immutable
class WalkingMetricsResult {
  const WalkingMetricsResult({
    required this.steps,
    required this.strideMeters,
    required this.distanceKm,
    required this.caloriesKcal,
    required this.activeMinutes,
    required this.fatBurnedGrams,
    this.isStrideCalibrated = false,
  });

  final int steps;
  final double strideMeters;
  final double distanceKm;
  final int caloriesKcal;
  final int activeMinutes;
  final double fatBurnedGrams;
  final bool isStrideCalibrated;
}

abstract final class WalkingCalculations {
  /// Legacy gross factor kept for backward-compat tests; prefer [computeCaloriesNet].
  static const double walkingFactor = 1.0;

  /// Stride length in meters (height × 0.415 men / 0.413 women).
  static double computeStrideMeters({
    required double heightCm,
    bool isFemale = false,
    double? calibratedStrideM,
  }) {
    if (calibratedStrideM != null) {
      return calibratedStrideM.clamp(0.5, 1.3);
    }
    return AcsmNetEnergy.defaultWalkingStrideMeters(
      heightCm: heightCm,
      isFemale: isFemale,
    );
  }

  /// Distance in kilometers.
  static double computeDistanceKm({
    required int steps,
    required double strideMeters,
  }) {
    if (steps <= 0) return 0.0;
    return (steps * strideMeters) / 1000.0;
  }

  /// Legacy gross estimate (kept for older call sites). Prefer [computeCaloriesNet].
  static int computeCalories({
    required double weightKg,
    required double distanceKm,
    double factor = walkingFactor,
  }) {
    if (distanceKm <= 0 || weightKg <= 0) return 0;
    final clampedWeight = weightKg.clamp(30.0, 250.0);
    final kcal = 0.57 * clampedWeight * distanceKm * factor;
    return kcal.round().clamp(0, 10000);
  }

  /// NET walking kcal from steps (ACSM via cadence×stride, else kcal/step fallback).
  static int computeCaloriesNet({
    required int steps,
    required double weightKg,
    required double strideMeters,
    double? cadenceSpm,
  }) {
    return AcsmNetEnergy.stepsNetKcal(
      steps: steps,
      weightKg: weightKg,
      strideMeters: strideMeters,
      cadenceSpm: cadenceSpm,
    ).round().clamp(0, 10000);
  }

  /// Active walking minutes (≈ steps / 100).
  static int computeActiveMinutes(int steps) {
    if (steps <= 0) return 0;
    return (steps / 100.0).round();
  }

  /// Fat-equivalent grams burned: kcal / 7.7.
  static double computeFatBurnedGrams(int caloriesKcal) {
    if (caloriesKcal <= 0) return 0.0;
    return caloriesKcal / 7.7;
  }

  /// Complete computation helper (NET kcal).
  static WalkingMetricsResult compute({
    required int steps,
    required double heightCm,
    required double weightKg,
    bool isFemale = false,
    double? cadenceSpm,
    bool useCalibratedStride = true,
  }) {
    final safeSteps = steps.clamp(0, 200000);
    var calibrated = false;
    double? calStride;
    if (useCalibratedStride) {
      final state = StrideCalibrationState.load(
        heightCm: heightCm,
        isFemale: isFemale,
      );
      if (state.isCalibrated) {
        calStride = state.strideMeters;
        calibrated = true;
      }
    }
    final stride = computeStrideMeters(
      heightCm: heightCm,
      isFemale: isFemale,
      calibratedStrideM: calStride,
    );
    final distKm = computeDistanceKm(steps: safeSteps, strideMeters: stride);
    final kcal = computeCaloriesNet(
      steps: safeSteps,
      weightKg: weightKg,
      strideMeters: stride,
      cadenceSpm: cadenceSpm,
    );
    final activeMin = computeActiveMinutes(safeSteps);
    final fatG = computeFatBurnedGrams(kcal);

    return WalkingMetricsResult(
      steps: safeSteps,
      strideMeters: stride,
      distanceKm: distKm,
      caloriesKcal: kcal,
      activeMinutes: activeMin,
      fatBurnedGrams: fatG,
      isStrideCalibrated: calibrated,
    );
  }

  /// Helper to read profile height, weight, sex from Hive.
  static ({double heightCm, double weightKg, bool isFemale}) readProfileMetrics() {
    var height = 170.0;
    var weight = 75.0;
    var isFemale = false;
    if (HiveService.isInitialized) {
      final profile = HiveService.cacheBox.get('guest_profile');
      if (profile is Map) {
        height = (profile['height_cm'] as num?)?.toDouble() ?? height;
        weight = (profile['weight_kg'] as num?)?.toDouble() ?? weight;
        final gender = (profile['sex'] as String? ?? profile['gender'] as String?)?.toLowerCase();
        if (gender == 'female' || gender == 'f') isFemale = true;
      }
    }
    return (heightCm: height, weightKg: weight, isFemale: isFemale);
  }
}
