import 'package:vireo/features/activity/domain/acsm_net_energy.dart';
import 'package:vireo/features/activity/domain/outdoor_workout_models.dart';

/// Outdoor session calories — NET only (ACSM walking/running, Compendium MET−1 for cycle).
abstract final class OutdoorMetCalculator {
  static double metFor({
    required OutdoorWorkoutType type,
    required double speedKmh,
  }) {
    final isRunning = type == OutdoorWorkoutType.run;
    if (type == OutdoorWorkoutType.cycle) {
      final v = speedKmh.clamp(0.5, 45.0);
      if (v < 16) return 4.0;
      if (v < 19) return 6.8;
      if (v < 22) return 8.0;
      if (v < 26) return 10.0;
      return 12.0;
    }
    return AcsmNetEnergy.compendiumMetForSpeed(
      isRunning: isRunning,
      speedKmh: speedKmh,
    );
  }

  /// Net kcal for the active duration. Prefer ACSM for walk/run; Compendium net for cycle.
  static int calories({
    required OutdoorWorkoutType type,
    required double weightKg,
    required int durationSeconds,
    required double speedKmh,
    double grade = 0,
    double? heartRateBpm,
    int age = 30,
    bool isFemale = false,
  }) {
    if (durationSeconds <= 0) return 0;
    final minutes = durationSeconds / 60.0;
    final speedMPerMin = (speedKmh.clamp(0.5, 45.0) * 1000) / 60.0;

    double acsm;
    if (type == OutdoorWorkoutType.cycle) {
      acsm = AcsmNetEnergy.workoutNetKcal(
        met: metFor(type: type, speedKmh: speedKmh),
        weightKg: weightKg,
        durationMinutes: minutes,
      );
    } else if (type == OutdoorWorkoutType.run) {
      acsm = AcsmNetEnergy.runningNetKcal(
        weightKg: weightKg,
        speedMPerMin: speedMPerMin,
        minutes: minutes,
        grade: grade,
      );
    } else {
      acsm = AcsmNetEnergy.walkingNetKcal(
        weightKg: weightKg,
        speedMPerMin: speedMPerMin,
        minutes: minutes,
        grade: grade,
      );
    }

    if (heartRateBpm != null && heartRateBpm >= 60) {
      final blended = AcsmNetEnergy.blendHrAndAcsm(
        acsmNetKcal: acsm,
        heartRateBpm: heartRateBpm,
        weightKg: weightKg,
        age: age,
        isFemale: isFemale,
        minutes: minutes,
      );
      return blended.netKcal.round().clamp(0, 5000);
    }
    return acsm.round().clamp(0, 5000);
  }
}
