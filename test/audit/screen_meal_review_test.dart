import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/ai_nutrition/data/gemini_food_service_core.dart';
import 'package:vireo/features/ai_nutrition/screens/meal_review_screen.dart';
import 'package:vireo/features/nutrition/data/food_db_models.dart';
import 'audit_test_helper.dart';

void main() {
  testScreenOverflow(
    'MealReviewScreen',
    () => MealReviewScreen(
      draft: MealScanDraft(
        lines: [
          ResolvedMealLine(
            nameAr: 'أرز بسمتي مطبوخ',
            nameEn: 'Cooked Basmati Rice',
            grams: 150,
            cookingMethod: CookingMethod.boiled,
            confidence: 0.95,
            kcal: 195,
            protein: 4.1,
            carbs: 42.0,
            fat: 0.6,
          ),
          ResolvedMealLine(
            nameAr: 'صدر دجاج مشوي',
            nameEn: 'Grilled Chicken Breast',
            grams: 180,
            cookingMethod: CookingMethod.grilled,
            confidence: 0.98,
            kcal: 297,
            protein: 55.8,
            carbs: 0.0,
            fat: 6.5,
          ),
        ],
        imageBytes: Uint8List(0),
      ),
    ),
  );
}
