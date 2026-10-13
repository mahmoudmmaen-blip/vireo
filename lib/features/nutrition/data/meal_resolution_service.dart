import 'dart:convert';

import 'package:vireo/core/boot/boot_log.dart';
import 'package:vireo/core/config/app_config.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/supabase_service.dart';
import 'package:vireo/features/nutrition/data/food_db_models.dart';
import 'package:vireo/features/nutrition/data/food_db_repository.dart';
import 'package:vireo/features/nutrition/providers/plate_size_provider.dart';

const _correctionsKey = 'food_gram_corrections';
const _correctionsHistoryKey = 'user_portion_corrections_history';

class MealResolutionService {
  MealResolutionService(this._db);

  final FoodDbRepository _db;

  /// Resolves scanned items with two-step verified pipeline:
  /// 1. Look up in bundled Egyptian/Arab DB (439+ items)
  /// 2. Look up in USDA FoodData Central DB (~1,500 items)
  /// 3. Fallback to model estimate
  /// 4. Apply personal portion calibration if >= 3 corrections exist
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
      final match = await _db.matchWithSource(
        foodIdGuess: item.foodIdGuess,
        nameEn: item.nameEn,
        nameAr: item.nameAr,
      );

      if (match == null) {
        unmatched.add(item);
        resolved.add(null);
        continue;
      }

      final food = match.food;
      final foodKey = food.id.isNotEmpty ? food.id : item.nameEn.toLowerCase();

      // Check for personal user calibration (>= 3 historical corrections)
      final calibrationRatio = getPersonalCalibrationRatio(foodKey);
      final isCalibrated = calibrationRatio != null;

      double grams;
      if (isCalibrated) {
        grams = (item.estimatedGrams * plateScale * calibrationRatio).clamp(1.0, 2000.0).roundToDouble();
      } else {
        grams = (item.estimatedGrams * plateScale).clamp(1.0, 2000.0).roundToDouble();
      }

      final lineSource = isCalibrated
          ? FoodDatabaseSource.personalCalibrated
          : match.source;

      resolved.add(
        resolveLine(
          scanned: item,
          food: food,
          gramsOverride: grams,
          oilFood: oil,
          source: lineSource,
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

      final calibrationRatio = getPersonalCalibrationRatio(key);
      final isCalibrated = calibrationRatio != null;
      final grams = isCalibrated
          ? (item.estimatedGrams * plateScale * calibrationRatio).clamp(1.0, 2000.0).roundToDouble()
          : (item.estimatedGrams * plateScale).clamp(1.0, 2000.0).roundToDouble();

      out.add(
        resolveLine(
          scanned: item,
          estimatedPer100g: est,
          gramsOverride: grams,
          oilFood: oil,
          source: isCalibrated ? FoodDatabaseSource.personalCalibrated : FoodDatabaseSource.estimated,
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

  /// Calculates personal calibration factor:
  /// After at least 3 corrections for a food, compute median ratio (user_grams / ai_grams),
  /// clamped to [0.6, 1.6]. Returns null if fewer than 3 corrections.
  double? getPersonalCalibrationRatio(String foodKey) {
    if (!HiveService.isInitialized || foodKey.isEmpty) return null;
    final raw = HiveService.cacheBox.get(_correctionsHistoryKey);
    if (raw is! Map) return null;
    final entries = raw[foodKey];
    if (entries is! List || entries.length < 3) return null;

    final ratios = <double>[];
    for (final entry in entries) {
      if (entry is Map) {
        final ai = (entry['ai_grams'] as num?)?.toDouble() ?? 0;
        final user = (entry['user_grams'] as num?)?.toDouble() ?? 0;
        if (ai > 0 && user > 0) {
          ratios.add((user / ai).clamp(0.6, 1.6));
        }
      }
    }
    if (ratios.length < 3) return null;
    ratios.sort();
    final mid = ratios.length ~/ 2;
    final median = ratios.length % 2 == 1
        ? ratios[mid]
        : (ratios[mid - 1] + ratios[mid]) / 2.0;
    return median.clamp(0.6, 1.6);
  }

  /// Records a user portion correction: (food_id, ai_grams, user_grams).
  Future<void> recordCorrection({
    required String foodKey,
    required double aiGrams,
    required double userGrams,
  }) async {
    if (!HiveService.isInitialized || foodKey.isEmpty) return;
    if (aiGrams <= 0 || userGrams <= 0) return;

    final raw = HiveService.cacheBox.get(_correctionsHistoryKey);
    final map = raw is Map ? Map<String, dynamic>.from(raw) : <String, dynamic>{};
    final list = (map[foodKey] as List? ?? []).toList();

    list.add({
      'ai_grams': aiGrams,
      'user_grams': userGrams,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    // Keep up to 20 recent corrections
    if (list.length > 20) {
      list.removeRange(0, list.length - 20);
    }
    map[foodKey] = list;
    await HiveService.cacheBox.put(_correctionsHistoryKey, map);

    // Also persist simple cache for direct lookup
    final simpleMap = HiveService.cacheBox.get(_correctionsKey);
    final sm = simpleMap is Map ? Map<String, dynamic>.from(simpleMap) : <String, dynamic>{};
    sm[foodKey] = userGrams;
    await HiveService.cacheBox.put(_correctionsKey, sm);
  }

  double? rememberedGrams(String foodId) {
    if (!HiveService.isInitialized) return null;
    final raw = HiveService.cacheBox.get(_correctionsKey);
    if (raw is! Map) return null;
    final v = raw[foodId];
    return (v as num?)?.toDouble();
  }

  Future<void> rememberLines(List<ResolvedMealLine> lines, {List<ScannedFoodItem>? originalScanned}) async {
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final key = line.food?.id ?? line.nameEn.toLowerCase();
      if (key.isNotEmpty) {
        final originalGrams = (originalScanned != null && i < originalScanned.length)
            ? originalScanned[i].estimatedGrams
            : line.grams;
        await recordCorrection(
          foodKey: key,
          aiGrams: originalGrams,
          userGrams: line.grams,
        );
      }
    }
  }

  /// Creates a default Cooking Oil adjustment line item if not already present.
  static ResolvedMealLine createCookingOilLine({
    double oilGrams = 10.0,
    String language = 'ar',
  }) {
    final kcal = (oilGrams * 8.84).roundToDouble(); // 1g oil ≈ 8.84 kcal
    return ResolvedMealLine(
      nameAr: 'زيت / سمن الطبخ (تقديري)',
      nameEn: 'Cooking oil / ghee (estimated)',
      grams: oilGrams,
      cookingMethod: CookingMethod.other,
      confidence: 0.85,
      kcal: kcal,
      protein: 0.0,
      carbs: 0.0,
      fat: oilGrams,
      isEstimated: false,
      source: FoodDatabaseSource.egyptianDb,
      gramsLow: (oilGrams * 0.7).roundToDouble(),
      gramsHigh: (oilGrams * 1.3).roundToDouble(),
      kcalLow: (kcal * 0.7).roundToDouble(),
      kcalHigh: (kcal * 1.3).roundToDouble(),
      hasVisibleOilOrSauce: true,
    );
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
  final result = <ScannedFoodItem>[];
  if (items is List) {
    result.addAll(
      items
          .whereType<Map>()
          .map((e) => ScannedFoodItem.fromJson(Map<String, dynamic>.from(e), isUnsure: false))
          .where((e) => e.estimatedGrams > 0 || e.nameEn.isNotEmpty),
    );
  }
  final unsure = map['items_unsure'];
  if (unsure is List) {
    result.addAll(
      unsure
          .whereType<Map>()
          .map((e) => ScannedFoodItem.fromJson(Map<String, dynamic>.from(e), isUnsure: true))
          .where((e) => e.estimatedGrams > 0 || e.nameEn.isNotEmpty),
    );
  }
  return result;
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
          'source': l.source.name,
        },
    ]);
