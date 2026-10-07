import 'package:freezed_annotation/freezed_annotation.dart';

part 'body_measurement.freezed.dart';

@freezed
class BodyMeasurement with _$BodyMeasurement {
  const factory BodyMeasurement({
    required String id,
    required DateTime date,
    required double weightKg,
    double? waistCm,
    double? chestCm,
    double? armsCm,
    double? thighsCm,
    double? bodyFatPercent,
    String? notes,
  }) = _BodyMeasurement;

  const BodyMeasurement._();

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'weight_kg': weightKg,
        'waist_cm': waistCm,
        'chest_cm': chestCm,
        'arms_cm': armsCm,
        'thighs_cm': thighsCm,
        'body_fat_percent': bodyFatPercent,
        'notes': notes,
      };

  factory BodyMeasurement.fromJson(Map<String, dynamic> json) {
    return BodyMeasurement(
      id: json['id'] as String? ?? '',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      weightKg: (json['weight_kg'] as num?)?.toDouble() ?? 0,
      waistCm: (json['waist_cm'] as num?)?.toDouble(),
      chestCm: (json['chest_cm'] as num?)?.toDouble(),
      armsCm: (json['arms_cm'] as num?)?.toDouble(),
      thighsCm: (json['thighs_cm'] as num?)?.toDouble(),
      bodyFatPercent: (json['body_fat_percent'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
    );
  }
}
