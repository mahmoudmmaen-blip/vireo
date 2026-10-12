import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vireo/features/nutrition/data/food_db_models.dart';

class LocalProductCacheService {
  static const _cachePrefsKey = 'vireo_barcode_custom_products_cache';

  /// Saves a custom food item linked to a barcode in local SharedPreferences.
  static Future<void> saveProduct({
    required String barcode,
    required FoodItem food,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final currentMap = await getAllCachedProducts();
    currentMap[barcode] = food;

    final encoded = currentMap.map((key, value) {
      return MapEntry(key, {
        'id': value.id,
        'name_ar': value.nameAr,
        'name_en': value.nameEn,
        'aliases': value.aliases,
        'state': value.state,
        'barcodes': [barcode, ...value.barcodes],
        'per_100g': {
          'kcal': value.per100g.kcal,
          'protein': value.per100g.protein,
          'carbs': value.per100g.carbs,
          'fat': value.per100g.fat,
          'fiber': value.per100g.fiber,
        },
        'common_portions': value.commonPortions.map((p) => {
          'name_ar': p.nameAr,
          'name_en': p.nameEn,
          'grams': p.grams,
        }).toList(),
        'source': {
          'name': value.source.name,
          'fdc_id': value.source.fdcId,
        },
      });
    });

    await prefs.setString(_cachePrefsKey, jsonEncode(encoded));
  }

  /// Looks up a product from the local cache by barcode.
  static Future<FoodItem?> getByBarcode(String barcode) async {
    final all = await getAllCachedProducts();
    return all[barcode];
  }

  /// Gets all cached products as a Map of barcode to FoodItem.
  static Future<Map<String, FoodItem>> getAllCachedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cachePrefsKey);
    if (raw == null || raw.isEmpty) return {};

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final result = <String, FoodItem>{};
      decoded.forEach((key, val) {
        if (val is Map) {
          result[key] = FoodItem.fromJson(Map<String, dynamic>.from(val));
        }
      });
      return result;
    } catch (_) {
      return {};
    }
  }
}
