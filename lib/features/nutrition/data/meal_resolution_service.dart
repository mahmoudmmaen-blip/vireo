import 'dart:convert';

import 'package:vireo/core/boot/boot_log.dart';
import 'package:vireo/core/config/app_config.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/supabase_service.dart';
import 'package:vireo/features/nutrition/data/food_db_models.dart';
import 'package:vireo/features/nutrition/data/food_db_repository.dart';
import 'package:vireo/features/nutrition/providers/plate_size_provider.dart';

const _correctionsKey = 'food_gram_corrections';

class MealResolutionService {
  MealResolutionService(this._db);

  final FoodDbRepository _db;

  Future<List<ResolvedMealLine>> resolveItems(
    List<ScannedFoodItem> items, {
    String language = 'ar',
  }) async {
    await _db.load();
    final oil = _db.byId('sunflower_oil') ?? _db.byId('olive_oil');
    final plateScale = _plateScale();
    final unmatched = <ScannedFoodItem>[];
    final resolved = <ResolvedMealLine?>[];

    for (final item in items) {
      final food = await _db.match(
        foodIdGuess: item.foodIdGuess,
        nameEn: item.nameEn,
        nameAr: item.nameAr,
      );
      if (food == null) {
        unmatched.add(item);
        resolved.add(null);
        continue;
      }
      var grams = item.estimatedGrams * plateScale;
      final remembered = rememberedGrams(food.id);
      if (remembered != null) grams = remembered;

      resolved.add(
        resolveLine(
          scanned: item,
          food: food,
          gramsOverride: grams,
          oilFood: oil,
        ),
      );
    }

    Map<String, FoodMacros100g> estimates = {};
    if (unmatched.isNotEmpty) {
      estimates = await _estimateUnmatched(unmatched, language: language);
    }

    final out = <ResolvedMealLine>[];
    var u = 0;
    for (var i = 0; i < items.length; i++) {
      final existing = resolved[i];
      if (existing != null) {
        out.add(existing);
        continue;
      }
      final item = unmatched[u++];
      final key = item.nameEn.toLowerCase();
      final est = estimates[key] ??
          estimates[item.nameAr] ??
          const FoodMacros100g(
            kcal: 150,
            protein: 5,
            carbs: 15,
            fat: 6,
            fiber: 1,
          );
      out.add(
        resolveLine(
          scanned: item,
          estimatedPer100g: est,
          oilFood: oil,
        ),
      );
    }
    return out;
  }

  Future<Map<String, FoodMacros100g>> _estimateUnmatched(
    List<ScannedFoodItem> items, {
    required String language,
  }) async {
    if (!SupabaseService.isInitialized) return {};
    try {
      final response = await SupabaseService.client.functions.invoke(
        AppConfig.parseMealTextFunctionName,
        body: {
          'mode': 'estimate_macros',
          'items': [
            for (final i in items)
              {'name_ar': i.nameAr, 'name_en': i.nameEn},
          ],
          'language': language,
        },
      );
      if (response.status >= 400) return {};
      final data = response.data;
      if (data is! Map) return {};
      final list = data['estimates'];
      if (list is! List) return {};
      final map = <String, FoodMacros100g>{};
      for (final e in list.whereType<Map>()) {
        final m = Map<String, dynamic>.from(e);
        final name = m['name_en']?.toString().toLowerCase() ?? '';
        if (name.isEmpty) continue;
        map[name] = FoodMacros100g(
          kcal: (m['kcal'] as num?)?.toDouble() ?? 0,
          protein: (m['protein'] as num?)?.toDouble() ?? 0,
          carbs: (m['carbs'] as num?)?.toDouble() ?? 0,
          fat: (m['fat'] as num?)?.toDouble() ?? 0,
          fiber: (m['fiber'] as num?)?.toDouble() ?? 0,
        );
      }
      return map;
    } catch (e) {
      BootLog.warn('unmatched macro estimate failed', e);
      return {};
    }
  }

  double _plateScale() {
    if (!HiveService.isInitialized) return 1.0;
    final raw = HiveService.settingsBox.get('usual_plate_size')?.toString();
    final size = PlateSize.values.where((e) => e.name == raw).firstOrNull;
    return size?.scale ?? 1.0;
  }

  double? rememberedGrams(String foodId) {
    if (!HiveService.isInitialized) return null;
    final raw = HiveService.cacheBox.get(_correctionsKey);
    if (raw is! Map) return null;
    final v = raw[foodId];
    return (v as num?)?.toDouble();
  }

  Future<void> rememberCorrection(String foodId, double grams) async {
    if (!HiveService.isInitialized || foodId.isEmpty) return;
    final raw = HiveService.cacheBox.get(_correctionsKey);
    final map = raw is Map
        ? Map<String, dynamic>.from(raw)
        : <String, dynamic>{};
    map[foodId] = grams;
    await HiveService.cacheBox.put(_correctionsKey, map);
  }

  Future<void> rememberLines(List<ResolvedMealLine> lines) async {
    for (final line in lines) {
      final id = line.food?.id;
      if (id != null) await rememberCorrection(id, line.grams);
    }
  }
}

/// Parse Gemini / Edge Function items payload.
List<ScannedFoodItem> parseScannedItems(Object? data) {
  Object? payload = data;
  if (payload is String) {
    try {
      payload = jsonDecode(payload);
    } catch (_) {
      return const [];
    }
  }
  if (payload is! Map) return const [];
  final map = Map<String, dynamic>.from(payload);
  final items = map['items'];
  if (items is! List) return const [];
  return items
      .whereType<Map>()
      .map((e) => ScannedFoodItem.fromJson(Map<String, dynamic>.from(e)))
      .where((e) => e.estimatedGrams > 0 || e.nameEn.isNotEmpty)
      .toList();
}

String encodeFavorites(List<ResolvedMealLine> lines) => jsonEncode([
      for (final l in lines)
        {
          'name_ar': l.nameAr,
          'name_en': l.nameEn,
          'grams': l.grams,
          'cooking_method': l.cookingMethod.name,
          'food_id': l.food?.id,
          'kcal': l.kcal,
          'protein': l.protein,
          'carbs': l.carbs,
          'fat': l.fat,
        },
    ]);
