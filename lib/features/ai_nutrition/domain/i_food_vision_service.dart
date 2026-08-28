import 'dart:typed_data';

import 'package:vireo/features/ai_nutrition/domain/food_analysis_result.dart';
import 'package:vireo/features/ai_nutrition/domain/meal_image_to_bytes_stub.dart'
    if (dart.library.io) 'package:vireo/features/ai_nutrition/domain/meal_image_to_bytes_io.dart'
    if (dart.library.html) 'package:vireo/features/ai_nutrition/domain/meal_image_to_bytes_web.dart';

/// Abstraction for AI meal vision analysis (Gemini or future providers).
abstract class IFoodVisionService {
  Future<FoodAnalysisResult> analyzeImage(
    Uint8List imageBytes,
    int remainingCalories,
    double remainingProtein,
  );
}

sealed class FoodVisionException implements Exception {
  const FoodVisionException(this.message);
  final String message;

  @override
  String toString() => message;
}

final class FoodVisionOfflineException extends FoodVisionException {
  const FoodVisionOfflineException() : super('OFFLINE');
}

final class FoodVisionApiException extends FoodVisionException {
  const FoodVisionApiException([super.message = 'API_ERROR']);
}

final class FoodVisionParseException extends FoodVisionException {
  const FoodVisionParseException() : super('PARSE_ERROR');
}

final class FoodVisionConfigException extends FoodVisionException {
  const FoodVisionConfigException() : super('CONFIG_ERROR');
}

/// File-based scan entry (native [File] or web [Uint8List]).
Future<FoodAnalysisResult> analyzeImageFile(
  IFoodVisionService service,
  Object imageFile,
  int remainingCalories,
  double remainingProtein,
) async {
  final bytes = await mealImageToBytes(imageFile);
  return service.analyzeImage(bytes, remainingCalories, remainingProtein);
}

Future<Uint8List> mealImageToBytes(Object imageFile) =>
    mealImageToBytesImpl(imageFile);
