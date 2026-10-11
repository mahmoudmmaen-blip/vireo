import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class ConfidenceValue<T> {
  const ConfidenceValue({this.value, this.confidence = 0});

  final T? value;
  final double confidence;

  bool get isLowConfidence => value != null && confidence < 0.6;
  bool get hasValue => value != null;

  Map<String, dynamic> toJson() => {
        'value': value is DateTime
            ? (value as DateTime).toIso8601String().split('T').first
            : value,
        'confidence': confidence,
      };
}

@immutable
class SegmentalPart {
  const SegmentalPart({this.kg, this.percent});

  final ConfidenceValue<double>? kg;
  final ConfidenceValue<double>? percent;

  Map<String, dynamic> toJson() => {
        'kg': kg?.toJson(),
        'percent': percent?.toJson(),
      };

  factory SegmentalPart.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const SegmentalPart();
    return SegmentalPart(
      kg: _numField(json['kg']),
      percent: _numField(json['percent']),
    );
  }
}

@immutable
class SegmentalMap {
  const SegmentalMap({
    this.rightArm = const SegmentalPart(),
    this.leftArm = const SegmentalPart(),
    this.trunk = const SegmentalPart(),
    this.rightLeg = const SegmentalPart(),
    this.leftLeg = const SegmentalPart(),
  });

  final SegmentalPart rightArm;
  final SegmentalPart leftArm;
  final SegmentalPart trunk;
  final SegmentalPart rightLeg;
  final SegmentalPart leftLeg;

  Map<String, dynamic> toJson() => {
        'right_arm': rightArm.toJson(),
        'left_arm': leftArm.toJson(),
        'trunk': trunk.toJson(),
        'right_leg': rightLeg.toJson(),
        'left_leg': leftLeg.toJson(),
      };

  factory SegmentalMap.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const SegmentalMap();
    return SegmentalMap(
      rightArm: SegmentalPart.fromJson(_asMap(json['right_arm'])),
      leftArm: SegmentalPart.fromJson(_asMap(json['left_arm'])),
      trunk: SegmentalPart.fromJson(_asMap(json['trunk'])),
      rightLeg: SegmentalPart.fromJson(_asMap(json['right_leg'])),
      leftLeg: SegmentalPart.fromJson(_asMap(json['left_leg'])),
    );
  }
}

enum BodyCompositionSource { inbodyScan, healthConnect, manual }

@immutable
class BodyCompositionReport {
  const BodyCompositionReport({
    required this.id,
    required this.testDate,
    this.deviceModel,
    this.source = BodyCompositionSource.inbodyScan,
    this.weightKg,
    this.skeletalMuscleMassKg,
    this.bodyFatMassKg,
    this.percentBodyFat,
    this.bmi,
    this.visceralFatLevel,
    this.bmrKcal,
    this.totalBodyWaterL,
    this.proteinKg,
    this.mineralsKg,
    this.inbodyScore,
    this.waistHipRatio,
    this.segmentalLean = const SegmentalMap(),
    this.segmentalFat = const SegmentalMap(),
    this.fieldConfidence = const {},
    this.syncedFromHealth = false,
  });

  final String id;
  final DateTime testDate;
  final String? deviceModel;
  final BodyCompositionSource source;
  final double? weightKg;
  final double? skeletalMuscleMassKg;
  final double? bodyFatMassKg;
  final double? percentBodyFat;
  final double? bmi;
  final double? visceralFatLevel;
  final double? bmrKcal;
  final double? totalBodyWaterL;
  final double? proteinKg;
  final double? mineralsKg;
  final double? inbodyScore;
  final double? waistHipRatio;
  final SegmentalMap segmentalLean;
  final SegmentalMap segmentalFat;
  final Map<String, double> fieldConfidence;
  final bool syncedFromHealth;

  /// Lean mass for Katch-McArdle: prefer SMM + fat mass derived, else weight×(1−BF%).
  double? get leanMassKg {
    if (skeletalMuscleMassKg != null && bodyFatMassKg != null && weightKg != null) {
      final lean = weightKg! - bodyFatMassKg!;
      if (lean > 0) return lean;
    }
    if (weightKg != null && percentBodyFat != null) {
      return weightKg! * (1 - percentBodyFat! / 100);
    }
    if (skeletalMuscleMassKg != null) return skeletalMuscleMassKg;
    return null;
  }

  BodyCompositionReport copyWith({
    DateTime? testDate,
    String? deviceModel,
    double? weightKg,
    double? skeletalMuscleMassKg,
    double? bodyFatMassKg,
    double? percentBodyFat,
    double? bmi,
    double? visceralFatLevel,
    double? bmrKcal,
    double? totalBodyWaterL,
    double? proteinKg,
    double? mineralsKg,
    double? inbodyScore,
    double? waistHipRatio,
    SegmentalMap? segmentalLean,
    SegmentalMap? segmentalFat,
    Map<String, double>? fieldConfidence,
  }) {
    return BodyCompositionReport(
      id: id,
      testDate: testDate ?? this.testDate,
      deviceModel: deviceModel ?? this.deviceModel,
      source: source,
      weightKg: weightKg ?? this.weightKg,
      skeletalMuscleMassKg: skeletalMuscleMassKg ?? this.skeletalMuscleMassKg,
      bodyFatMassKg: bodyFatMassKg ?? this.bodyFatMassKg,
      percentBodyFat: percentBodyFat ?? this.percentBodyFat,
      bmi: bmi ?? this.bmi,
      visceralFatLevel: visceralFatLevel ?? this.visceralFatLevel,
      bmrKcal: bmrKcal ?? this.bmrKcal,
      totalBodyWaterL: totalBodyWaterL ?? this.totalBodyWaterL,
      proteinKg: proteinKg ?? this.proteinKg,
      mineralsKg: mineralsKg ?? this.mineralsKg,
      inbodyScore: inbodyScore ?? this.inbodyScore,
      waistHipRatio: waistHipRatio ?? this.waistHipRatio,
      segmentalLean: segmentalLean ?? this.segmentalLean,
      segmentalFat: segmentalFat ?? this.segmentalFat,
      fieldConfidence: fieldConfidence ?? this.fieldConfidence,
      syncedFromHealth: syncedFromHealth,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'test_date': testDate.toIso8601String().split('T').first,
        'device_model': deviceModel,
        'source': switch (source) {
          BodyCompositionSource.inbodyScan => 'inbody_scan',
          BodyCompositionSource.healthConnect => 'health_connect',
          BodyCompositionSource.manual => 'manual',
        },
        'weight_kg': weightKg,
        'skeletal_muscle_mass_kg': skeletalMuscleMassKg,
        'body_fat_mass_kg': bodyFatMassKg,
        'percent_body_fat': percentBodyFat,
        'bmi': bmi,
        'visceral_fat_level': visceralFatLevel,
        'bmr_kcal': bmrKcal,
        'total_body_water_l': totalBodyWaterL,
        'protein_kg': proteinKg,
        'minerals_kg': mineralsKg,
        'inbody_score': inbodyScore,
        'waist_hip_ratio': waistHipRatio,
        'segmental_lean': segmentalLean.toJson(),
        'segmental_fat': segmentalFat.toJson(),
        'field_confidence': fieldConfidence,
      };

  factory BodyCompositionReport.fromJson(Map<String, dynamic> json) {
    final sourceRaw = json['source']?.toString() ?? 'inbody_scan';
    return BodyCompositionReport(
      id: json['id']?.toString() ??
          'bc_${DateTime.now().millisecondsSinceEpoch}',
      testDate: DateTime.tryParse(json['test_date']?.toString() ?? '') ??
          DateTime.now(),
      deviceModel: json['device_model']?.toString(),
      source: switch (sourceRaw) {
        'health_connect' => BodyCompositionSource.healthConnect,
        'manual' => BodyCompositionSource.manual,
        _ => BodyCompositionSource.inbodyScan,
      },
      weightKg: (json['weight_kg'] as num?)?.toDouble(),
      skeletalMuscleMassKg:
          (json['skeletal_muscle_mass_kg'] as num?)?.toDouble(),
      bodyFatMassKg: (json['body_fat_mass_kg'] as num?)?.toDouble(),
      percentBodyFat: (json['percent_body_fat'] as num?)?.toDouble(),
      bmi: (json['bmi'] as num?)?.toDouble(),
      visceralFatLevel: (json['visceral_fat_level'] as num?)?.toDouble(),
      bmrKcal: (json['bmr_kcal'] as num?)?.toDouble(),
      totalBodyWaterL: (json['total_body_water_l'] as num?)?.toDouble(),
      proteinKg: (json['protein_kg'] as num?)?.toDouble(),
      mineralsKg: (json['minerals_kg'] as num?)?.toDouble(),
      inbodyScore: (json['inbody_score'] as num?)?.toDouble(),
      waistHipRatio: (json['waist_hip_ratio'] as num?)?.toDouble(),
      segmentalLean: SegmentalMap.fromJson(_asMap(json['segmental_lean'])),
      segmentalFat: SegmentalMap.fromJson(_asMap(json['segmental_fat'])),
      fieldConfidence: _confidenceMap(json['field_confidence']),
      syncedFromHealth: sourceRaw == 'health_connect',
    );
  }

  Map<String, dynamic> toSupabaseRow(String userId) => {
        ...toJson(),
        'user_id': userId,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }..remove('id');
}

ConfidenceValue<double>? _numField(Object? raw) {
  if (raw is Map) {
    final m = Map<String, dynamic>.from(raw);
    final v = m['value'];
    if (v == null) return ConfidenceValue(confidence: (m['confidence'] as num?)?.toDouble() ?? 0);
    return ConfidenceValue(
      value: (v as num).toDouble(),
      confidence: (m['confidence'] as num?)?.toDouble() ?? 0.5,
    );
  }
  if (raw is num) return ConfidenceValue(value: raw.toDouble(), confidence: 1);
  return null;
}

Map<String, dynamic>? _asMap(Object? raw) {
  if (raw is Map) return Map<String, dynamic>.from(raw);
  return null;
}

Map<String, double> _confidenceMap(Object? raw) {
  if (raw is! Map) return {};
  final out = <String, double>{};
  for (final e in raw.entries) {
    final v = e.value;
    if (v is num) out[e.key.toString()] = v.toDouble();
  }
  return out;
}

/// Pure parser for Gemini / Edge Function JSON (testable).
class BodyCompositionParser {
  static BodyCompositionReport? parse(Object? data) {
    if (data is String) {
      try {
        final decoded = jsonDecode(data);
        return parse(decoded);
      } catch (_) {
        return null;
      }
    }
    if (data is! Map) return null;
    final map = Map<String, dynamic>.from(data);
    if (map['readable'] == false || map['error'] == 'UNREADABLE') {
      return null;
    }

    final conf = <String, double>{};
    T? take<T>(String key, T? Function(Object?) cast) {
      final raw = map[key];
      if (raw is Map) {
        final m = Map<String, dynamic>.from(raw);
        conf[key] = (m['confidence'] as num?)?.toDouble() ?? 0;
        final v = m['value'];
        if (v == null) return null;
        return cast(v);
      }
      if (raw != null) {
        conf[key] = 1;
        return cast(raw);
      }
      return null;
    }

    final dateStr = take<String>('test_date', (v) => v.toString());
    final testDate = DateTime.tryParse(dateStr ?? '') ?? DateTime.now();

    return BodyCompositionReport(
      id: 'bc_${DateTime.now().millisecondsSinceEpoch}',
      testDate: testDate,
      deviceModel: take<String>('device_model', (v) => v.toString()),
      weightKg: take<double>('weight_kg', (v) => (v as num).toDouble()),
      skeletalMuscleMassKg: take<double>(
        'skeletal_muscle_mass_kg',
        (v) => (v as num).toDouble(),
      ),
      bodyFatMassKg:
          take<double>('body_fat_mass_kg', (v) => (v as num).toDouble()),
      percentBodyFat:
          take<double>('percent_body_fat', (v) => (v as num).toDouble()),
      bmi: take<double>('bmi', (v) => (v as num).toDouble()),
      visceralFatLevel:
          take<double>('visceral_fat_level', (v) => (v as num).toDouble()),
      bmrKcal: take<double>('bmr_kcal', (v) => (v as num).toDouble()),
      totalBodyWaterL:
          take<double>('total_body_water_l', (v) => (v as num).toDouble()),
      proteinKg: take<double>('protein_kg', (v) => (v as num).toDouble()),
      mineralsKg: take<double>('minerals_kg', (v) => (v as num).toDouble()),
      inbodyScore: take<double>('inbody_score', (v) => (v as num).toDouble()),
      waistHipRatio:
          take<double>('waist_hip_ratio', (v) => (v as num).toDouble()),
      segmentalLean: SegmentalMap.fromJson(_asMap(map['segmental_lean'])),
      segmentalFat: SegmentalMap.fromJson(_asMap(map['segmental_fat'])),
      fieldConfidence: conf,
    );
  }
}

/// Katch-McArdle BMR and comparison helpers (pure).
abstract final class BodyCompositionMath {
  /// BMR = 370 + 21.6 × lean mass (kg).
  static double katchMcArdleBmr(double leanMassKg) => 370 + 21.6 * leanMassKg;

  static int maintenanceFromLean({
    required double leanMassKg,
    required double activityMultiplier,
  }) {
    return (katchMcArdleBmr(leanMassKg) * activityMultiplier).round();
  }

  static int proteinFromLeanKg(double leanMassKg, {double gPerKg = 2.2}) =>
      (leanMassKg * gPerKg).round().clamp(80, 280);

  static BodyCompositionDelta compare(
    BodyCompositionReport newer,
    BodyCompositionReport older,
  ) {
    return BodyCompositionDelta(
      weightKg: _d(newer.weightKg, older.weightKg),
      skeletalMuscleMassKg:
          _d(newer.skeletalMuscleMassKg, older.skeletalMuscleMassKg),
      bodyFatMassKg: _d(newer.bodyFatMassKg, older.bodyFatMassKg),
      percentBodyFat: _d(newer.percentBodyFat, older.percentBodyFat),
      visceralFatLevel: _d(newer.visceralFatLevel, older.visceralFatLevel),
    );
  }

  static double? _d(double? a, double? b) {
    if (a == null || b == null) return null;
    return a - b;
  }
}

@immutable
class BodyCompositionDelta {
  const BodyCompositionDelta({
    this.weightKg,
    this.skeletalMuscleMassKg,
    this.bodyFatMassKg,
    this.percentBodyFat,
    this.visceralFatLevel,
  });

  final double? weightKg;
  final double? skeletalMuscleMassKg;
  final double? bodyFatMassKg;
  final double? percentBodyFat;
  final double? visceralFatLevel;

  bool get muscleUp => (skeletalMuscleMassKg ?? 0) > 0;
  bool get fatDown => (bodyFatMassKg ?? 0) < 0 || (percentBodyFat ?? 0) < 0;
}
