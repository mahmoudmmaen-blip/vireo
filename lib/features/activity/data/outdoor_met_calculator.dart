import 'package:vireo/features/activity/domain/outdoor_workout_models.dart';

/// MET estimates from speed (km/h) — Compendium-style approximations.
abstract final class OutdoorMetCalculator {
  static double metFor({
    required OutdoorWorkoutType type,
    required double speedKmh,
  }) {
    final v = speedKmh.clamp(0.5, 45.0);
    return switch (type) {
      OutdoorWorkoutType.walk => _walkMet(v),
      OutdoorWorkoutType.run => _runMet(v),
      OutdoorWorkoutType.cycle => _cycleMet(v),
    };
  }

  static int calories({
    required OutdoorWorkoutType type,
    required double weightKg,
    required int durationSeconds,
    required double speedKmh,
  }) {
    if (durationSeconds <= 0) return 0;
    final met = metFor(type: type, speedKmh: speedKmh);
    final hours = durationSeconds / 3600;
    return (met * weightKg.clamp(40, 200) * hours).round().clamp(0, 5000);
  }

  static double _walkMet(double kmh) {
    if (kmh < 3.2) return 2.0;
    if (kmh < 4.8) return 2.8;
    if (kmh < 5.6) return 3.5;
    if (kmh < 6.4) return 4.3;
    return 5.0;
  }

  static double _runMet(double kmh) {
    if (kmh < 6) return 6.0;
    if (kmh < 8) return 8.3;
    if (kmh < 9.7) return 9.8;
    if (kmh < 11.3) return 11.0;
    return 12.5;
  }

  static double _cycleMet(double kmh) {
    if (kmh < 16) return 4.0;
    if (kmh < 19) return 6.8;
    if (kmh < 22) return 8.0;
    if (kmh < 26) return 10.0;
    return 12.0;
  }
}
