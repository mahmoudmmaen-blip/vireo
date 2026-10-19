import 'package:health/health.dart';
import 'package:vireo/core/utils/platform_utils.dart';

/// Best-effort writes to Health Connect (Android) / HealthKit (iOS).
///
/// Never throws to callers — logging/sync must stay offline-first even when
/// Health Connect is missing or the user denied write access.
abstract final class HealthConnectWriteService {
  static final Health _health = Health();
  static bool _configured = false;

  static bool get isSupported => PlatformUtils.isHealthStepsSupported;

  static Future<void> _ensureConfigured() async {
    if (_configured) return;
    await _health.configure();
    _configured = true;
  }

  /// Requests READ+WRITE for Steps, Weight, and Exercise (workout) sessions.
  static Future<bool> requestReadWritePermissions() async {
    if (!isSupported) return false;
    try {
      await _ensureConfigured();
      const types = [
        HealthDataType.STEPS,
        HealthDataType.WEIGHT,
        HealthDataType.WORKOUT,
      ];
      const permissions = [
        HealthDataAccess.READ_WRITE,
        HealthDataAccess.READ_WRITE,
        HealthDataAccess.READ_WRITE,
      ];
      return await _health.requestAuthorization(
        types,
        permissions: permissions,
      );
    } catch (_) {
      return false;
    }
  }

  /// Writes a body-weight sample in kilograms.
  static Future<bool> writeWeightKg(
    double weightKg, {
    DateTime? at,
  }) async {
    if (!isSupported || weightKg <= 0) return false;
    try {
      await _ensureConfigured();
      final granted = await _health.requestAuthorization(
        [HealthDataType.WEIGHT],
        permissions: [HealthDataAccess.READ_WRITE],
      );
      if (!granted) return false;
      final when = at ?? DateTime.now();
      return await _health.writeHealthData(
        value: weightKg,
        type: HealthDataType.WEIGHT,
        startTime: when,
        endTime: when,
        recordingMethod: RecordingMethod.manual,
      );
    } catch (_) {
      return false;
    }
  }

  /// Writes a walk/run exercise session.
  static Future<bool> writeExerciseSession({
    required DateTime start,
    required DateTime end,
    required bool isRun,
    int? energyKcal,
    int? distanceMeters,
  }) async {
    if (!isSupported || !end.isAfter(start)) return false;
    try {
      await _ensureConfigured();
      final granted = await _health.requestAuthorization(
        [HealthDataType.WORKOUT],
        permissions: [HealthDataAccess.READ_WRITE],
      );
      if (!granted) return false;
      return await _health.writeWorkoutData(
        activityType: isRun
            ? HealthWorkoutActivityType.RUNNING
            : HealthWorkoutActivityType.WALKING,
        start: start,
        end: end,
        totalEnergyBurned: energyKcal,
        totalDistance: distanceMeters,
        recordingMethod: RecordingMethod.manual,
      );
    } catch (_) {
      return false;
    }
  }
}
