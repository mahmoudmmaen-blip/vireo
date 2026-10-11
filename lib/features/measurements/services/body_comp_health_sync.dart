import 'package:health/health.dart';
import 'package:vireo/core/boot/boot_log.dart';
import 'package:vireo/core/utils/platform_utils.dart';
import 'package:vireo/features/measurements/data/body_composition_repository.dart';
import 'package:vireo/features/measurements/domain/body_composition_report.dart';

/// Android Health Connect → body composition (skip iOS).
abstract final class BodyCompHealthSync {
  static final Health _health = Health();

  static final _types = <HealthDataType>[
    HealthDataType.WEIGHT,
    HealthDataType.BODY_MASS_INDEX,
    HealthDataType.BODY_FAT_PERCENTAGE,
    HealthDataType.LEAN_BODY_MASS,
  ];

  static Future<int> syncFromHealthConnect(
    BodyCompositionRepository repo,
  ) async {
    if (!PlatformUtils.isAndroid) return 0;
    try {
      await _health.configure();
      final ok = await _health.requestAuthorization(
        _types,
        permissions: List.filled(_types.length, HealthDataAccess.READ),
      );
      if (!ok) return 0;

      final now = DateTime.now();
      final start = now.subtract(const Duration(days: 30));
      final data = await _health.getHealthDataFromTypes(
        types: _types,
        startTime: start,
        endTime: now,
      );

      double? weight;
      double? bmi;
      double? pbf;
      double? lean;
      DateTime? at;

      for (final p in data) {
        final v = p.value;
        num? n;
        if (v is NumericHealthValue) n = v.numericValue;
        if (n == null) continue;
        at = p.dateTo;
        switch (p.type) {
          case HealthDataType.WEIGHT:
            weight = n.toDouble();
          case HealthDataType.BODY_MASS_INDEX:
            bmi = n.toDouble();
          case HealthDataType.BODY_FAT_PERCENTAGE:
            pbf = n.toDouble();
          case HealthDataType.LEAN_BODY_MASS:
            lean = n.toDouble();
          default:
            break;
        }
      }

      if (weight == null && pbf == null && lean == null) return 0;

      final fatMass = (weight != null && pbf != null)
          ? weight * pbf / 100
          : null;

      final report = BodyCompositionReport(
        id: 'hc_${(at ?? now).millisecondsSinceEpoch}',
        testDate: at ?? now,
        deviceModel: 'Health Connect',
        source: BodyCompositionSource.healthConnect,
        weightKg: weight,
        percentBodyFat: pbf,
        bmi: bmi,
        skeletalMuscleMassKg: lean,
        bodyFatMassKg: fatMass,
        fieldConfidence: {
          if (weight != null) 'weight_kg': 1,
          if (pbf != null) 'percent_body_fat': 1,
          if (bmi != null) 'bmi': 1,
          if (lean != null) 'skeletal_muscle_mass_kg': 0.9,
        },
        syncedFromHealth: true,
      );
      await repo.save(report);
      return 1;
    } catch (e) {
      BootLog.warn('Health Connect body sync failed', e);
      return 0;
    }
  }
}
