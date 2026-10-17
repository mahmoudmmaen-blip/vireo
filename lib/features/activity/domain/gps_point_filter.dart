import 'dart:math' as math;

/// GPS quality filter + EMA smoother for outdoor sessions.
abstract final class GpsPointFilter {
  static const double maxAccuracyM = 25.0;
  static const double maxWalkSpeedMps = 7.0;
  static const double maxRunSpeedMps = 12.0;
  static const double autoPauseSpeedMps = 0.5;
  static const int autoPauseSeconds = 10;
  static const double emaAlpha = 0.35;

  @Deprecated('Use maxAccuracyM')
  static const double accuracyThreshold = maxAccuracyM;

  static bool acceptPoint({
    required double accuracyM,
    required double impliedSpeedMps,
    required bool isRunning,
  }) {
    if (accuracyM > maxAccuracyM) return false;
    final cap = isRunning ? maxRunSpeedMps : maxWalkSpeedMps;
    if (impliedSpeedMps > cap) return false;
    if (impliedSpeedMps < 0) return false;
    return true;
  }

  /// EMA smooth of speed (m/s).
  static double smoothSpeed({
    required double previous,
    required double measured,
    double alpha = emaAlpha,
  }) {
    if (previous <= 0) return measured;
    return alpha * measured + (1 - alpha) * previous;
  }

  /// Grade from altitude change over horizontal distance. Returns 0 if noisy.
  static double gradeFromAltitude({
    required double deltaAltM,
    required double horizontalM,
    double maxAbsGrade = 0.25,
  }) {
    if (horizontalM < 5) return 0;
    final g = deltaAltM / horizontalM;
    if (g.abs() > maxAbsGrade) return 0; // noisy / GPS jump
    return g.clamp(-maxAbsGrade, maxAbsGrade);
  }

  /// Simple 1D Kalman-ish update (constant-velocity EMA of altitude).
  static double smoothAltitude({
    required double previous,
    required double measured,
    double alpha = 0.25,
  }) {
    if (!previous.isFinite) return measured;
    return alpha * measured + (1 - alpha) * previous;
  }

  static double haversineMeters({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    const r = 6371000.0;
    final dLat = _rad(lat2 - lat1);
    final dLon = _rad(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_rad(lat1)) *
            math.cos(_rad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    return 2 * r * math.asin(math.sqrt(a));
  }

  static double _rad(double deg) => deg * math.pi / 180.0;
}
