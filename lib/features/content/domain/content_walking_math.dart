/// Walking time equivalent for food-fact cards (reference person, flat ground).
///
/// Matches [WalkingCalculations]: kcal ≈ 0.57 × weightKg × distanceKm at ~4.5 km/h.
/// Reference weight is fixed so cards stay comparable across users.
abstract final class ContentWalkingMath {
  static const double referenceWeightKg = 70;
  static const double walkingSpeedKmh = 4.5;
  static const double kcalPerKmFactor = 0.57;

  /// Minutes of brisk walking (~4.5 km/h) to expend [foodKcal] for [weightKg].
  static int walkingMinutesForKcal(double foodKcal, {double weightKg = referenceWeightKg}) {
    if (foodKcal <= 0 || weightKg <= 0) return 0;
    final w = weightKg.clamp(40.0, 200.0);
    final km = foodKcal / (kcalPerKmFactor * w);
    final hours = km / walkingSpeedKmh;
    return (hours * 60).round().clamp(1, 24 * 60);
  }

  /// Egyptian Arabic duration for myth-busting cards.
  static String formatDurationAr(int totalMinutes) {
    if (totalMinutes < 60) return '$totalMinutes دقيقة';
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    if (m == 0) return h == 1 ? 'ساعة' : '$h ساعات';
    if (h == 1) return 'ساعة و $m دقيقة';
    return '$h ساعات و $m دقيقة';
  }
}
