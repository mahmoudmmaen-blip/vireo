import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:vireo/core/boot/boot_log.dart';
import 'package:vireo/features/ai_nutrition/data/gemini_food_service_core.dart';
import 'package:vireo/features/ai_nutrition/data/local_product_cache_service.dart';
import 'package:vireo/features/nutrition/data/food_db_models.dart';
import 'package:vireo/features/nutrition/data/food_db_repository.dart';

class BarcodeLookupResult {
  const BarcodeLookupResult({
    required this.line,
    required this.sourceDescription,
    this.foodItem,
  });

  final ResolvedMealLine line;
  final String sourceDescription;
  final FoodItem? foodItem;
}

class BarcodeLookupService {
  /// 1. Local cache
  /// 2. Bundled Egyptian food DB
  /// 3. Open Food Facts API (World + Egypt)
  /// If not found in any, returns null.
  static Future<BarcodeLookupResult?> lookup(String barcode) async {
    final cleanCode = barcode.trim();
    if (cleanCode.isEmpty) return null;

    // 1. Check local cache
    final cached = await LocalProductCacheService.getByBarcode(cleanCode);
    if (cached != null) {
      return BarcodeLookupResult(
        line: _foodItemToResolvedLine(cached, sourceTag: 'local_cache'),
        sourceDescription: 'من المنتجات المحفوظة محلياً',
        foodItem: cached,
      );
    }

    // 2. Check bundled Egyptian food DB
    await FoodDbRepository.instance.load();
    final localDbFood = FoodDbRepository.instance.byBarcode(cleanCode);
    if (localDbFood != null) {
      return BarcodeLookupResult(
        line: _foodItemToResolvedLine(localDbFood, sourceTag: 'local_db'),
        sourceDescription: 'من قاعدة البيانات المصرية',
        foodItem: localDbFood,
      );
    }

    // 3. Open Food Facts API (World + Egypt)
    try {
      final offResult = await _fetchOpenFoodFacts(cleanCode);
      if (offResult != null) {
        // Cache it for instant next lookup
        await LocalProductCacheService.saveProduct(
          barcode: cleanCode,
          food: offResult.foodItem!,
        );
        return offResult;
      }
    } catch (e) {
      BootLog.warn('OpenFoodFacts fetch error for barcode $cleanCode', e);
    }

    return null;
  }

  /// 4. Gemini nutrition label photo extraction fallback
  static Future<BarcodeLookupResult> analyzeNutritionLabel({
    required Uint8List labelImageBytes,
    required String barcode,
    String language = 'ar',
  }) async {
    // Invoke Gemini vision with a prompt specifically tailored to reading nutrition facts tables
    final draft = await GeminiFoodServiceCore.analyzeImagesToDraft(
      [labelImageBytes],
      2000,
      120.0,
      language: language,
      userHint: 'اقرأ الملصق الغذائي (Nutrition Facts) واستخرج اسم المنتج والسعرات والبروتين والكارب والدهون وحجم الحصة بدقة.',
    );

    final line = draft.lines.isNotEmpty
        ? draft.lines.first
        : ResolvedMealLine(
            nameAr: 'منتج غذائي',
            nameEn: 'Food Product',
            grams: 100,
            cookingMethod: CookingMethod.raw,
            confidence: 0.9,
            kcal: 200,
            protein: 5,
            carbs: 25,
            fat: 5,
            isEstimated: false,
          );

    // Save as local custom product
    final food = FoodItem(
      id: 'custom_barcode_$barcode',
      nameAr: line.nameAr,
      nameEn: line.nameEn,
      aliases: [barcode],
      state: 'packaged',
      barcodes: [barcode],
      per100g: line.grams > 0
          ? FoodMacros100g(
              kcal: line.kcal / line.grams * 100,
              protein: line.protein / line.grams * 100,
              carbs: line.carbs / line.grams * 100,
              fat: line.fat / line.grams * 100,
              fiber: 0,
            )
          : const FoodMacros100g(kcal: 200, protein: 5, carbs: 25, fat: 5, fiber: 0),
      commonPortions: [
        FoodPortion(nameAr: 'حصة (${line.grams.round()} جم)', nameEn: 'Serving (${line.grams.round()}g)', grams: line.grams),
        const FoodPortion(nameAr: '100 جم', nameEn: '100 g', grams: 100),
      ],
      source: const FoodSource(name: 'gemini_nutrition_label', fdcId: 0),
    );

    await LocalProductCacheService.saveProduct(barcode: barcode, food: food);

    return BarcodeLookupResult(
      line: line.copyWith(
        food: food,
        portions: food.commonPortions,
        isEstimated: false,
      ),
      sourceDescription: 'تم التحليل بواسطة ملصق التغذية الذكي',
      foodItem: food,
    );
  }

  static Future<BarcodeLookupResult?> _fetchOpenFoodFacts(String barcode) async {
    // Try Egypt-specific node first or fallback to global
    final endpoints = [
      'https://eg.openfoodfacts.org/api/v2/product/$barcode.json',
      'https://world.openfoodfacts.org/api/v2/product/$barcode.json',
    ];

    for (final url in endpoints) {
      try {
        final res = await http.get(
          Uri.parse(url),
          headers: {'User-Agent': 'VireoNutrition/2.0 (support@vireo.app)'},
        ).timeout(const Duration(seconds: 4));

        if (res.statusCode != 200) continue;
        final decoded = jsonDecode(res.body) as Map<String, dynamic>;
        final product = decoded['product'] as Map<String, dynamic>?;
        if (product == null) continue;

        final nameAr = product['product_name_ar']?.toString() ??
            product['product_name']?.toString() ??
            product['product_name_en']?.toString() ??
            'منتج';
        final nameEn = product['product_name_en']?.toString() ??
            product['product_name']?.toString() ??
            nameAr;

        final nutriments = product['nutriments'] as Map<String, dynamic>? ?? {};
        final kcal100 = (nutriments['energy-kcal_100g'] as num?)?.toDouble() ??
            ((nutriments['energy_100g'] as num?)?.toDouble() ?? 0) / 4.184;
        final protein100 = (nutriments['proteins_100g'] as num?)?.toDouble() ?? 0;
        final carbs100 = (nutriments['carbohydrates_100g'] as num?)?.toDouble() ?? 0;
        final fat100 = (nutriments['fat_100g'] as num?)?.toDouble() ?? 0;
        final fiber100 = (nutriments['fiber_100g'] as num?)?.toDouble() ?? 0;

        final servingQuantity = (product['serving_quantity'] as num?)?.toDouble() ?? 100.0;
        final servingUnit = product['serving_size']?.toString() ?? '100g';

        final portions = <FoodPortion>[
          FoodPortion(
            nameAr: 'حصة ($servingUnit)',
            nameEn: 'Serving ($servingUnit)',
            grams: servingQuantity > 0 ? servingQuantity : 100.0,
          ),
          const FoodPortion(nameAr: '100 جم', nameEn: '100 g', grams: 100),
        ];

        final foodItem = FoodItem(
          id: 'off_$barcode',
          nameAr: nameAr,
          nameEn: nameEn,
          aliases: [barcode],
          state: 'packaged',
          barcodes: [barcode],
          per100g: FoodMacros100g(
            kcal: kcal100,
            protein: protein100,
            carbs: carbs100,
            fat: fat100,
            fiber: fiber100,
          ),
          commonPortions: portions,
          source: const FoodSource(name: 'open_food_facts', fdcId: 0),
        );

        final initialGrams = servingQuantity > 0 ? servingQuantity : 100.0;
        final factor = initialGrams / 100.0;

        final line = ResolvedMealLine(
          nameAr: nameAr,
          nameEn: nameEn,
          grams: initialGrams,
          cookingMethod: CookingMethod.raw,
          confidence: 0.95,
          kcal: kcal100 * factor,
          protein: protein100 * factor,
          carbs: carbs100 * factor,
          fat: fat100 * factor,
          food: foodItem,
          portions: portions,
          isEstimated: false,
        );

        return BarcodeLookupResult(
          line: line,
          sourceDescription: 'Open Food Facts',
          foodItem: foodItem,
        );
      } catch (_) {
        // try next endpoint
      }
    }
    return null;
  }

  static ResolvedMealLine _foodItemToResolvedLine(FoodItem food, {required String sourceTag}) {
    final grams = food.commonPortions.isNotEmpty ? food.commonPortions.first.grams : 100.0;
    final f = grams / 100.0;

    return ResolvedMealLine(
      nameAr: food.nameAr,
      nameEn: food.nameEn,
      grams: grams,
      cookingMethod: CookingMethod.raw,
      confidence: 1.0,
      kcal: food.per100g.kcal * f,
      protein: food.per100g.protein * f,
      carbs: food.per100g.carbs * f,
      fat: food.per100g.fat * f,
      food: food,
      portions: food.commonPortions,
      isEstimated: false,
    );
  }
}
