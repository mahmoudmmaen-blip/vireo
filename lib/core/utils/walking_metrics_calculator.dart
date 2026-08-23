/// Walking metrics derived from step count, cadence, and body weight.
class WalkingMetrics {
  const WalkingMetrics({
    required this.steps,
    required this.distanceKm,
    required this.speedKmh,
    required this.paceMinPerKm,
    required this.caloriesBurned,
    required this.estimatedWeightLossKg,
    required this.cadenceSpm,
  });

  final int steps;
  final double distanceKm;
  final double speedKmh;
  final double paceMinPerKm;
  final int caloriesBurned;
  final double estimatedWeightLossKg;
  final double cadenceSpm;
}

abstract final class WalkingMetricsCalculator {
  /// Average adult step length ≈ 0.78 m.
  static const stepLengthMeters = 0.78;

  /// MET-ish calorie factor: kcal ≈ steps × weightKg × 0.0005.
  static WalkingMetrics compute({
    required int steps,
    required double weightKg,
    double walkMinutes = 45,
  }) {
    final safeSteps = steps.clamp(0, 100000);
    final safeMinutes = walkMinutes.clamp(5.0, 300.0);
    final distanceKm = (safeSteps * stepLengthMeters) / 1000.0;
    final hours = safeMinutes / 60.0;
    final speedKmh = hours > 0 ? distanceKm / hours : 0.0;
    final paceMinPerKm = distanceKm > 0.01 ? safeMinutes / distanceKm : 0.0;
    final cadenceSpm = safeMinutes > 0 ? safeSteps / safeMinutes : 0.0;
    final calories = (safeSteps * weightKg * 0.0005).round().clamp(0, 5000);
    final weightLossKg = calories / 7700.0;

    return WalkingMetrics(
      steps: safeSteps,
      distanceKm: distanceKm,
      speedKmh: speedKmh,
      paceMinPerKm: paceMinPerKm,
      caloriesBurned: calories,
      estimatedWeightLossKg: weightLossKg,
      cadenceSpm: cadenceSpm,
    );
  }
}
