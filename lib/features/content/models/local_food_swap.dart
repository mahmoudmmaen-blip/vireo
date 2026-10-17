import 'package:flutter/foundation.dart';

@immutable
class LocalFoodSwap {
  const LocalFoodSwap({
    required this.id,
    required this.tipAr,
    required this.tipEn,
    required this.savedKcal,
    required this.fromFoodId,
    required this.toFoodId,
    required this.fromGrams,
    required this.toGrams,
  });

  final String id;
  final String tipAr;
  final String tipEn;
  final int savedKcal;
  final String fromFoodId;
  final String toFoodId;
  final double fromGrams;
  final double toGrams;

  factory LocalFoodSwap.fromJson(Map<String, dynamic> json) => LocalFoodSwap(
        id: json['id']?.toString() ?? '',
        tipAr: json['tip_ar']?.toString() ?? '',
        tipEn: json['tip_en']?.toString() ?? '',
        savedKcal: (json['saved_kcal'] as num?)?.round() ?? 0,
        fromFoodId: json['from_food_id']?.toString() ?? '',
        toFoodId: json['to_food_id']?.toString() ?? '',
        fromGrams: (json['from_grams'] as num?)?.toDouble() ?? 0,
        toGrams: (json['to_grams'] as num?)?.toDouble() ?? 0,
      );
}
