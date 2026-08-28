import 'dart:typed_data';

import 'package:vireo/features/ai_nutrition/data/gemini_food_service_core.dart';
import 'package:vireo/features/ai_nutrition/domain/food_analysis_result.dart';
import 'package:vireo/features/ai_nutrition/domain/i_food_vision_service.dart';

class GeminiFoodService implements IFoodVisionService {
  GeminiFoodService({this.apiKey});

  final String? apiKey;

  @override
  Future<FoodAnalysisResult> analyzeImage(
    Uint8List imageBytes,
    int remainingCalories,
    double remainingProtein,
  ) {
    return GeminiFoodServiceCore.analyzeBytes(
      imageBytes,
      remainingCalories,
      remainingProtein,
      apiKey: apiKey,
    );
  }
}
