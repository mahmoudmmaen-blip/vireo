import 'package:flutter/foundation.dart';

@immutable
class FoodAnalysisResult {
  const FoodAnalysisResult({
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.portionEstimate,
    required this.isHighCalorie,
    this.warningMessage,
    this.smartSwaps = const [],
  });

  final String foodName;
  final int calories;
  final double protein;
  final double carbs;
  final double fats;
  final String portionEstimate;
  final bool isHighCalorie;
  final String? warningMessage;
  final List<String> smartSwaps;

  factory FoodAnalysisResult.fromJson(Map<String, dynamic> json) {
    final swapsRaw = json['smart_swaps'];
    final swaps = swapsRaw is List
        ? swapsRaw.map((e) => e.toString()).where((s) => s.isNotEmpty).toList()
        : <String>[];

    final warning = json['warning_message'];
    return FoodAnalysisResult(
      foodName: json['food_name']?.toString() ?? 'وجبة',
      calories: _asInt(json['calories']),
      protein: _asDouble(json['protein']),
      carbs: _asDouble(json['carbs']),
      fats: _asDouble(json['fats']),
      portionEstimate: json['portion_estimate']?.toString() ?? '',
      isHighCalorie: json['is_high_calorie'] == true,
      warningMessage: warning == null || warning.toString().trim().isEmpty
          ? null
          : warning.toString(),
      smartSwaps: swaps,
    );
  }

  Map<String, dynamic> toJson() => {
        'food_name': foodName,
        'portion_estimate': portionEstimate,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fats': fats,
        'is_high_calorie': isHighCalorie,
        'warning_message': warningMessage,
        'smart_swaps': smartSwaps,
      };

  static int _asInt(Object? value) {
    if (value is int) return value;
    if (value is double) return value.round();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _asDouble(Object? value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
