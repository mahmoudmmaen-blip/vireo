import 'package:flutter/foundation.dart';

@immutable
class FoodFact {
  const FoodFact({
    required this.id,
    required this.titleAr,
    required this.bodyAr,
    required this.titleEn,
    required this.bodyEn,
    required this.kcal,
    required this.walkMinutes,
    required this.foodId,
    required this.grams,
  });

  final String id;
  final String titleAr;
  final String bodyAr;
  final String titleEn;
  final String bodyEn;
  final int kcal;
  final int walkMinutes;
  final String foodId;
  final double grams;

  factory FoodFact.fromJson(Map<String, dynamic> json) => FoodFact(
        id: json['id']?.toString() ?? '',
        titleAr: json['title_ar']?.toString() ?? '',
        bodyAr: json['body_ar']?.toString() ?? '',
        titleEn: json['title_en']?.toString() ?? '',
        bodyEn: json['body_en']?.toString() ?? '',
        kcal: (json['kcal'] as num?)?.round() ?? 0,
        walkMinutes: (json['walk_minutes'] as num?)?.round() ?? 0,
        foodId: json['food_id']?.toString() ?? '',
        grams: (json['grams'] as num?)?.toDouble() ?? 0,
      );
}
