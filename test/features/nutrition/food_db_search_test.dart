import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/nutrition/data/food_db_models.dart';
import 'package:vireo/features/nutrition/data/food_db_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FoodDb Arabic Normalization', () {
    test('normalizes Alef variants (أ / إ / آ / ٱ -> ا)', () {
      expect(FoodDbRepository.normalizeArabic('أرز'), 'ارز');
      expect(FoodDbRepository.normalizeArabic('إفطار'), 'افطار');
      expect(FoodDbRepository.normalizeArabic('آخر'), 'اخر');
      expect(FoodDbRepository.normalizeArabic('ٱلله'), 'الله');
    });

    test('normalizes Taa Marbuta (ة -> ه)', () {
      expect(FoodDbRepository.normalizeArabic('طعمية'), 'طعميه');
      expect(FoodDbRepository.normalizeArabic('ملوخية'), 'ملوخيه');
      expect(FoodDbRepository.normalizeArabic('بسبوسة'), 'بسبوسه');
    });

    test('normalizes Yaa variants (ى / ئ -> ي)', () {
      expect(FoodDbRepository.normalizeArabic('على'), 'علي');
      expect(FoodDbRepository.normalizeArabic('شاطئ'), 'شاطي');
    });

    test('strips Tashkeel / Harakat', () {
      expect(FoodDbRepository.normalizeArabic('فُولٌ مُدَمَّسْ'), 'فول مدمس');
      expect(FoodDbRepository.normalizeArabic('كُشَرِيّ مَصْرِيّ'), 'كشري مصري');
    });
  });

  group('Food Database Portions and Macro Scaling', () {
    test('rescales macros accurately according to grams and portions', () {
      const per100g = FoodMacros100g(
        kcal: 200,
        protein: 10,
        carbs: 20,
        fat: 5,
        fiber: 2,
      );

      final food = FoodItem(
        id: 'koshari_egyptian',
        nameAr: 'كشري مصري',
        nameEn: 'Egyptian Koshari',
        aliases: const ['koshari', 'كشري'],
        per100g: per100g,
        state: 'cooked',
        commonPortions: const [
          FoodPortion(nameAr: 'طبق صغير', nameEn: 'Small plate', grams: 250),
          FoodPortion(nameAr: 'طبق وسط', nameEn: 'Medium plate', grams: 350),
          FoodPortion(nameAr: 'طبق كبير', nameEn: 'Large plate', grams: 500),
        ],
        source: const FoodSource(name: 'egyptian_food_db', fdcId: 0),
      );

      // Resolve for 100g
      final line100 = resolveLine(
        scanned: const ScannedFoodItem(
          nameAr: 'كشري مصري',
          nameEn: 'Egyptian Koshari',
          estimatedGrams: 100,
          cookingMethod: CookingMethod.raw,
          confidence: 0.95,
        ),
        food: food,
      );

      expect(line100.kcal, 200.0);
      expect(line100.protein, 10.0);
      expect(line100.carbs, 20.0);
      expect(line100.fat, 5.0);
      expect(line100.isEstimated, isFalse);

      // Rescale to Medium plate (350g)
      final lineMedium = rescaleLine(line100, 350);
      // 200 * 3.5 = 700 kcal
      expect(lineMedium.grams, 350);
      expect(lineMedium.kcal, closeTo(700.0, 0.01));
      expect(lineMedium.protein, closeTo(35.0, 0.01));
      expect(lineMedium.carbs, closeTo(70.0, 0.01));
      expect(lineMedium.fat, closeTo(17.5, 0.01));

      // Rescale to Large plate (500g)
      final lineLarge = rescaleLine(lineMedium, 500);
      // 200 * 5 = 1000 kcal
      expect(lineLarge.grams, 500);
      expect(lineLarge.kcal, closeTo(1000.0, 0.01));
      expect(lineLarge.protein, closeTo(50.0, 0.01));
    });

    test('adds absorbed oil on frying if not already fried in DB', () {
      const per100g = FoodMacros100g(
        kcal: 100,
        protein: 2,
        carbs: 20,
        fat: 1,
        fiber: 2,
      );

      final food = FoodItem(
        id: 'potatoes_raw',
        nameAr: 'بطاطس',
        nameEn: 'Potatoes',
        aliases: const [],
        per100g: per100g,
        state: 'raw',
        commonPortions: const [],
        source: const FoodSource(name: 'usda', fdcId: 0),
      );

      // Resolve fried method on 100g of raw potatoes
      // Oil absorbed: ~8g oil / 100g -> 8g oil at 884 kcal/100g = ~70.72 kcal, 8g fat
      final friedLine = resolveLine(
        scanned: const ScannedFoodItem(
          nameAr: 'بطاطس مقلية',
          nameEn: 'French Fries',
          estimatedGrams: 100,
          cookingMethod: CookingMethod.fried,
          confidence: 0.9,
        ),
        food: food,
      );

      expect(friedLine.cookingMethod, CookingMethod.fried);
      expect(friedLine.kcal, greaterThan(100.0)); // 100 base + ~70.72 oil
      expect(friedLine.fat, greaterThan(8.0));    // 1 base + 8 oil
    });
  });
}
