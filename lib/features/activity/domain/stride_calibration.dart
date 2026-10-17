import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/features/activity/domain/acsm_net_energy.dart';

/// GPS outdoor walk/run ≥ 500 m with accuracy < 20 m → learn stride.
/// EMA of last 5 calibrations, clamped to 0.5–1.3 m.
@immutable
class StrideCalibrationSample {
  const StrideCalibrationSample({
    required this.strideMeters,
    required this.gpsDistanceM,
    required this.steps,
    required this.at,
  });

  final double strideMeters;
  final double gpsDistanceM;
  final int steps;
  final DateTime at;

  Map<String, dynamic> toJson() => {
        'stride_m': strideMeters,
        'gps_m': gpsDistanceM,
        'steps': steps,
        'at': at.toIso8601String(),
      };

  factory StrideCalibrationSample.fromJson(Map<String, dynamic> j) {
    return StrideCalibrationSample(
      strideMeters: (j['stride_m'] as num).toDouble(),
      gpsDistanceM: (j['gps_m'] as num).toDouble(),
      steps: (j['steps'] as num).toInt(),
      at: DateTime.tryParse(j['at']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}

@immutable
class StrideCalibrationState {
  const StrideCalibrationState({
    required this.strideMeters,
    required this.samples,
    required this.isCalibrated,
  });

  final double strideMeters;
  final List<StrideCalibrationSample> samples;
  final bool isCalibrated;

  static const hiveKey = 'stride_calibration_v1';
  static const minDistanceM = 500.0;
  static const maxAccuracyM = 20.0;
  static const maxSamples = 5;
  static const minStrideM = 0.5;
  static const maxStrideM = 1.3;

  /// Attempt calibration from a finished outdoor session.
  static StrideCalibrationState? tryCalibrate({
    required double gpsDistanceM,
    required double meanAccuracyM,
    required int steps,
    required double currentStrideM,
    required List<StrideCalibrationSample> prior,
    DateTime? now,
  }) {
    if (gpsDistanceM < minDistanceM) return null;
    if (meanAccuracyM >= maxAccuracyM) return null;
    if (steps < 100) return null;

    final raw = gpsDistanceM / steps;
    if (raw < minStrideM || raw > maxStrideM) return null;

    final sample = StrideCalibrationSample(
      strideMeters: raw,
      gpsDistanceM: gpsDistanceM,
      steps: steps,
      at: now ?? DateTime.now(),
    );
    final samples = [...prior, sample];
    while (samples.length > maxSamples) {
      samples.removeAt(0);
    }

    // EMA of last ≤5: start with first, α = 2/(n+1) style or equal-weight EMA α=0.4
    double ema = samples.first.strideMeters;
    const alpha = 0.4;
    for (var i = 1; i < samples.length; i++) {
      ema = alpha * samples[i].strideMeters + (1 - alpha) * ema;
    }
    final clamped = ema.clamp(minStrideM, maxStrideM);

    return StrideCalibrationState(
      strideMeters: clamped,
      samples: List.unmodifiable(samples),
      isCalibrated: true,
    );
  }

  static StrideCalibrationState defaults({
    required double heightCm,
    required bool isFemale,
  }) {
    return StrideCalibrationState(
      strideMeters: AcsmNetEnergy.defaultWalkingStrideMeters(
        heightCm: heightCm,
        isFemale: isFemale,
      ),
      samples: const [],
      isCalibrated: false,
    );
  }

  static StrideCalibrationState load({
    required double heightCm,
    required bool isFemale,
  }) {
    final fallback = defaults(heightCm: heightCm, isFemale: isFemale);
    if (!HiveService.isInitialized) return fallback;
    final raw = HiveService.settingsBox.get(hiveKey);
    if (raw is! String || raw.isEmpty) return fallback;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final samples = (map['samples'] as List? ?? [])
          .whereType<Map>()
          .map((e) => StrideCalibrationSample.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      final stride = (map['stride_m'] as num?)?.toDouble() ?? fallback.strideMeters;
      return StrideCalibrationState(
        strideMeters: stride.clamp(minStrideM, maxStrideM),
        samples: samples,
        isCalibrated: samples.isNotEmpty || (map['calibrated'] == true),
      );
    } catch (_) {
      return fallback;
    }
  }

  Future<void> save() async {
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.put(
      hiveKey,
      jsonEncode({
        'stride_m': strideMeters,
        'calibrated': isCalibrated,
        'samples': samples.map((s) => s.toJson()).toList(),
      }),
    );
  }
}
