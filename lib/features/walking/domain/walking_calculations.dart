import 'package:flutter/foundation.dart';
import 'package:vireo/core/services/hive_service.dart';

/// Accurate walking metrics calculation based on stature, weight, and sex.
///
/// Formulas:
/// - Stride length: `height_cm * (isFemale ? 0.413 : 0.415) / 100` (in meters).
/// - Distance: `(steps * stride) / 1000` (in kilometers).
/// - Energy: `0.57 * weight_kg * distance_km * walking_factor` (ACSM energy estimation).
///   where walking_factor = 1.0 (standard walking speed ~4.5 km/h).
/// - Active minutes: `(steps / 100).round()`.
/// - Fat equivalent: `kcal / 7.7` (1 g adipose tissue ≈ 7.7 kcal).
@immutable
class WalkingMetricsResult {
  const WalkingMetricsResult({
    required this.steps,
    required this.strideMeters,
    required this.distanceKm,
    required this.caloriesKcal,
    required this.activeMinutes,
    required this.fatBurnedGrams,
  });

  final int steps;
  final double strideMeters;
  final double distanceKm;
  final int caloriesKcal;
  final int activeMinutes;
  final double fatBurnedGrams;
}

abstract final class WalkingCalculations {
  /// Standard walking energy factor (ACSM metabolic model for normal pace).
  static const double walkingFactor = 1.0;

  /// Stride length in meters.
  /// Male: height_cm * 0.415 / 100
  /// Female: height_cm * 0.413 / 100
  static double computeStrideMeters({
    required double heightCm,
    bool isFemale = false,
  }) {
    final clampedHeight = heightCm.clamp(100.0, 240.0);
    final ratio = isFemale ? 0.413 : 0.415;
    return (clampedHeight * ratio) / 100.0;
  }

  /// Distance in kilometers.
  static double computeDistanceKm({
    required int steps,
    required double strideMeters,
  }) {
    if (steps <= 0) return 0.0;
    return (steps * strideMeters) / 1000.0;
  }

  /// Kcal expenditure based on ACSM formula:
  /// kcal ≈ 0.57 * weight_kg * distance_km * walking_factor
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

  /// Complete computation helper.
  static WalkingMetricsResult compute({
    required int steps,
    required double heightCm,
    required double weightKg,
    bool isFemale = false,
  }) {
    final safeSteps = steps.clamp(0, 200000);
    final stride = computeStrideMeters(heightCm: heightCm, isFemale: isFemale);
    final distKm = computeDistanceKm(steps: safeSteps, strideMeters: stride);
    final kcal = computeCalories(weightKg: weightKg, distanceKm: distKm);
    final activeMin = computeActiveMinutes(safeSteps);
    final fatG = computeFatBurnedGrams(kcal);

    return WalkingMetricsResult(
      steps: safeSteps,
      strideMeters: stride,
      distanceKm: distKm,
      caloriesKcal: kcal,
      activeMinutes: activeMin,
      fatBurnedGrams: fatG,
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
