/// Walking metrics derived from step count, stature, and body weight.
class WalkingMetrics {
  const WalkingMetrics({
    required this.steps,
    required this.distanceKm,
    required this.speedKmh,
    required this.paceMinPerKm,
    required this.caloriesBurned,
    required this.estimatedWeightLossKg,
    required this.cadenceSpm,
    required this.activeMinutes,
    required this.strideMeters,
  });

  final int steps;
  final double distanceKm;
  final double speedKmh;
  final double paceMinPerKm;
  final int caloriesBurned;
  final double estimatedWeightLossKg;
  final double cadenceSpm;
  final double activeMinutes;
  final double strideMeters;
}

abstract final class WalkingMetricsCalculator {
  /// stride (m) = height_cm × 0.415 / 100
  static double strideMetersFromHeight(double heightCm) =>
      (heightCm.clamp(120.0, 230.0) * 0.415) / 100.0;

  /// calories ≈ weight_kg × distance_km × 0.72
  /// active minutes ≈ steps / 100
  static WalkingMetrics compute({
    required int steps,
    required double weightKg,
    double heightCm = 170,
    double? walkMinutes,
  }) {
    final safeSteps = steps.clamp(0, 100000);
    final stride = strideMetersFromHeight(heightCm);
    final distanceKm = (safeSteps * stride) / 1000.0;
    final activeMinutes = safeSteps / 100.0;
    final minutes = (walkMinutes ?? activeMinutes).clamp(5.0, 300.0);
    final hours = minutes / 60.0;
    final speedKmh = hours > 0 ? distanceKm / hours : 0.0;
    final paceMinPerKm = distanceKm > 0.01 ? minutes / distanceKm : 0.0;
    final cadenceSpm = minutes > 0 ? safeSteps / minutes : 0.0;
    final calories =
        (weightKg.clamp(30.0, 250.0) * distanceKm * 0.72).round().clamp(0, 5000);
    final weightLossKg = calories / 7700.0;

    return WalkingMetrics(
      steps: safeSteps,
      distanceKm: distanceKm,
      speedKmh: speedKmh,
      paceMinPerKm: paceMinPerKm,
      caloriesBurned: calories,
      estimatedWeightLossKg: weightLossKg,
      cadenceSpm: cadenceSpm,
      activeMinutes: activeMinutes,
      strideMeters: stride,
    );
  }

  static ({double heightCm, double weightKg}) profileBodyMetrics() {
    // Imported lazily via callers that read Hive — keep calculator pure.
    return (heightCm: 170, weightKg: 75);
  }
}
