import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/ai_nutrition/data/barcode_lookup_service.dart';
import 'package:vireo/features/nutrition/data/food_db_models.dart';
import 'package:vireo/features/nutrition/data/food_db_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Barcode & Food Database Lookup', () {
    test('local Egyptian food item barcode index lookup', () async {
      final item = FoodItem(
        id: 'molokhia_frozen_pack',
        nameAr: 'ملوخية مجمدة',
        nameEn: 'Frozen Molokhia',
        aliases: const ['molokhia'],
        per100g: const FoodMacros100g(kcal: 45, protein: 3, carbs: 7, fat: 0.5, fiber: 2),
        state: 'cooked',
        commonPortions: const [
          FoodPortion(nameAr: 'كيس 400 جم', nameEn: '400g Bag', grams: 400),
          FoodPortion(nameAr: '100 جم', nameEn: '100 g', grams: 100),
        ],
        source: const FoodSource(name: 'egyptian_food_db', fdcId: 0),
        barcodes: const ['6221234567890'],
      );

      expect(item.barcodes.contains('6221234567890'), isTrue);
      expect(item.commonPortions.first.grams, 400);
      expect(item.per100g.kcal, 45);
    });

    test('Barcode lookup result correctly converts food to resolved meal line', () {
      final food = FoodItem(
        id: 'tuna_can_in_water',
        nameAr: 'تونة في ماء',
        nameEn: 'Tuna in Water',
        aliases: const ['tuna'],
        per100g: const FoodMacros100g(kcal: 110, protein: 25, carbs: 0, fat: 1, fiber: 0),
        state: 'cooked',
        commonPortions: const [
          FoodPortion(nameAr: 'علبة (140 جم)', nameEn: 'Can (140g)', grams: 140),
          FoodPortion(nameAr: '100 جم', nameEn: '100 g', grams: 100),
        ],
        source: const FoodSource(name: 'open_food_facts', fdcId: 0),
        barcodes: const ['6229876543210'],
      );

      final line = resolveLine(
        scanned: ScannedFoodItem(
          nameAr: food.nameAr,
          nameEn: food.nameEn,
          foodIdGuess: food.id,
          estimatedGrams: food.commonPortions.first.grams,
          cookingMethod: CookingMethod.raw,
          confidence: 1.0,
        ),
        food: food,
      );

      expect(line.nameAr, 'تونة في ماء');
      expect(line.grams, 140);
      expect(line.kcal, closeTo(154.0, 0.1)); // 110 * 1.4 = 154
      expect(line.protein, closeTo(35.0, 0.1)); // 25 * 1.4 = 35
      expect(line.isEstimated, isFalse);
    });
  });
}
