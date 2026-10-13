import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:vireo/features/nutrition/data/food_db_models.dart';

class FoodMatchResult {
  const FoodMatchResult({
    required this.food,
    required this.source,
  });

  final FoodItem food;
  final FoodDatabaseSource source;
}

/// Food composition repository loading both Egyptian/Arab curated foods (439+)
/// and the USDA FoodData Central subset (~1,500 generic foods) from assets.
class FoodDbRepository {
  FoodDbRepository._();
  static final FoodDbRepository instance = FoodDbRepository._();

  List<FoodItem>? _foods;
  List<FoodItem>? _egyptianFoods;
  List<FoodItem>? _usdaFoods;

  Map<String, FoodItem>? _byId;
  Map<String, FoodItem>? _egyptianById;
  Map<String, FoodItem>? _usdaById;
  Map<String, FoodItem>? _byBarcode;

  Future<List<FoodItem>> load() async {
    if (_foods != null) return _foods!;

    // 1. Load Egyptian/Arab curated DB
    final rawEg = await rootBundle.loadString('assets/food_db/foods.json');
    final decodedEg = Map<String, dynamic>.from(jsonDecode(rawEg) as Map);
    final egList = (decodedEg['foods'] as List? ?? [])
        .whereType<Map>()
        .map((e) => FoodItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    _egyptianFoods = egList;
    _egyptianById = {for (final f in egList) f.id: f};

    // 2. Load USDA FoodData Central generic subset (~1,500 foods)
    var usdaList = <FoodItem>[];
    try {
      final rawUsda = await rootBundle.loadString('assets/food_db/usda_foods.json');
      final decodedUsda = Map<String, dynamic>.from(jsonDecode(rawUsda) as Map);
      usdaList = (decodedUsda['foods'] as List? ?? [])
          .whereType<Map>()
          .map((e) => FoodItem.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      // Fallback if asset loading fails in headless test
      usdaList = [];
    }
    _usdaFoods = usdaList;
    _usdaById = {for (final f in usdaList) f.id: f};

    // 3. Combined pool
    final combined = [...egList, ...usdaList];
    _foods = combined;
    _byId = {for (final f in combined) f.id: f};
    _byBarcode = {};
    for (final f in combined) {
      for (final bc in f.barcodes) {
        _byBarcode![bc] = f;
      }
    }
    return combined;
  }

  FoodItem? byId(String id) => _byId?[id];
  FoodItem? byBarcode(String barcode) => _byBarcode?[barcode];

  /// Look up food with origin tracking:
  /// 1. Egyptian/Arab DB (highest priority for local cuisine)
  /// 2. USDA FoodData Central DB (generic foods)
  /// 3. Returns null (model estimate fallback)
  Future<FoodMatchResult?> matchWithSource({
    String? foodIdGuess,
    required String nameEn,
    required String nameAr,
  }) async {
    await load();

    // 1. Match against Egyptian DB
    if (foodIdGuess != null && foodIdGuess.isNotEmpty) {
      final hit = _egyptianById?[foodIdGuess];
      if (hit != null) {
        return FoodMatchResult(food: hit, source: FoodDatabaseSource.egyptianDb);
      }
    }
    final egMatch = _findBestMatch(_egyptianFoods ?? const [], nameEn, nameAr);
    if (egMatch != null) {
      return FoodMatchResult(food: egMatch, source: FoodDatabaseSource.egyptianDb);
    }

    // 2. Match against USDA DB
    if (foodIdGuess != null && foodIdGuess.isNotEmpty) {
      final hit = _usdaById?[foodIdGuess];
      if (hit != null) {
        return FoodMatchResult(food: hit, source: FoodDatabaseSource.usda);
      }
    }
    final usdaMatch = _findBestMatch(_usdaFoods ?? const [], nameEn, nameAr);
    if (usdaMatch != null) {
      return FoodMatchResult(food: usdaMatch, source: FoodDatabaseSource.usda);
    }

    return null;
  }

  Future<FoodItem?> match({
    String? foodIdGuess,
    required String nameEn,
    required String nameAr,
  }) async {
    final result = await matchWithSource(
      foodIdGuess: foodIdGuess,
      nameEn: nameEn,
      nameAr: nameAr,
    );
    return result?.food;
  }

  FoodItem? _findBestMatch(List<FoodItem> pool, String nameEn, String nameAr) {
    if (pool.isEmpty) return null;
    final needle = _norm('$nameEn $nameAr');
    FoodItem? best;
    var bestScore = 0.0;

    for (final food in pool) {
      final candidates = [
        food.id,
        food.nameEn,
        food.nameAr,
        ...food.aliases,
      ].map(_norm);

      for (final c in candidates) {
        if (c.isEmpty) continue;
        if (c == needle || needle.contains(c) || c.contains(needle)) {
          final score = c.length / (needle.length + 1);
          if (score > bestScore) {
            bestScore = score;
            best = food;
          }
        } else {
          final score = _fuzzy(needle, c);
          if (score > 0.68 && score > bestScore) {
            bestScore = score;
            best = food;
          }
        }
      }
    }
    return best;
  }

  Future<List<FoodItem>> search(String query, {int limit = 20}) async {
    await load();
    final q = _norm(query);
    if (q.isEmpty) return _foods!.take(limit).toList();
    final scored = <({FoodItem food, double score})>[];
    for (final food in _foods!) {
      final hay = _norm(
        '${food.id} ${food.nameEn} ${food.nameAr} ${food.aliases.join(' ')}',
      );
      if (!hay.contains(q) && _fuzzy(q, hay) < 0.5) continue;
      scored.add((food: food, score: hay.contains(q) ? 1.0 : _fuzzy(q, hay)));
    }
    scored.sort((a, b) => b.score.compareTo(a.score));
    return scored.take(limit).map((e) => e.food).toList();
  }

  static String normalizeArabic(String s) {
    var out = s.toLowerCase();
    // Strip Arabic diacritics / tashkeel (\u064B-\u065F, \u0670)
    out = out.replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '');
    // Normalize Alef variants: أ, إ, آ, ٱ -> ا
    out = out.replaceAll(RegExp(r'[أإآٱ]'), 'ا');
    // Normalize Taa Marbuta and Haa: ة -> ه
    out = out.replaceAll(RegExp(r'[ة]'), 'ه');
    // Normalize Yaa variants: ى, ئ -> ي
    out = out.replaceAll(RegExp(r'[ىئ]'), 'ي');
    // Replace non-word / non-Arabic characters with space
    out = out.replaceAll(RegExp(r'[^\w\u0600-\u06FF]+'), ' ');
    return out.trim();
  }

  static String _norm(String s) => normalizeArabic(s);

  static double _fuzzy(String a, String b) {
    if (a.isEmpty || b.isEmpty) return 0;
    final shorter = a.length < b.length ? a : b;
    final longer = a.length < b.length ? b : a;
    if (longer.contains(shorter)) return shorter.length / longer.length;
    var hits = 0;
    final parts = shorter.split(' ').where((e) => e.length > 2);
    for (final p in parts) {
      if (longer.contains(p)) hits++;
    }
    final n = parts.length;
    return n == 0 ? 0 : hits / n;
  }
}

/// Scale macros for [grams], calculating verified DB / USDA / estimate nutrition
/// and applying exact oil absorption based on cooking method.
ResolvedMealLine resolveLine({
  required ScannedFoodItem scanned,
  FoodItem? food,
  FoodMacros100g? estimatedPer100g,
  CookingMethod? methodOverride,
  double? gramsOverride,
  FoodItem? oilFood,
  FoodDatabaseSource source = FoodDatabaseSource.egyptianDb,
}) {
  final method = methodOverride ?? scanned.cookingMethod;
  final grams = (gramsOverride ?? scanned.estimatedGrams).clamp(1, 2000);
  final base = food?.per100g ?? estimatedPer100g;
  final isEstimated = food == null;

  double kcal = 0, protein = 0, carbs = 0, fat = 0;
  if (base != null) {
    final f = grams / 100.0;
    kcal = base.kcal * f;
    protein = base.protein * f;
    carbs = base.carbs * f;
    fat = base.fat * f;
  }

  // Calculate oil absorption according to cooking method table
  final oilAbsorptionGramsPer100 = method.oilAbsorptionGramsPer100g;
  if (oilAbsorptionGramsPer100 > 0 && food?.isAlreadyFried != true) {
    final absorbedOilG = oilAbsorptionGramsPer100 * (grams / 100.0);
    final oil = oilFood?.per100g ??
        const FoodMacros100g(
          kcal: 884,
          protein: 0,
          carbs: 0,
          fat: 100,
          fiber: 0,
        );
    final of = absorbedOilG / 100.0;
    kcal += oil.kcal * of;
    fat += oil.fat * of;
  }

  // Calculate confidence ± range for grams and calories
  final gLow = scanned.gramsLow ?? (grams * 0.88);
  final gHigh = scanned.gramsHigh ?? (grams * 1.12);
  final kRatio = grams > 0 ? (kcal / grams) : 1.0;
  final kLow = (gLow * kRatio).roundToDouble();
  final kHigh = (gHigh * kRatio).roundToDouble();

  return ResolvedMealLine(
    nameAr: food?.nameAr ?? scanned.nameAr,
    nameEn: food?.nameEn ?? scanned.nameEn,
    grams: grams.toDouble(),
    cookingMethod: method,
    confidence: scanned.confidence,
    kcal: kcal,
    protein: protein,
    carbs: carbs,
    fat: fat,
    food: food,
    isEstimated: isEstimated,
    portions: food?.commonPortions ?? const [],
    isUnsure: scanned.isUnsure,
    source: isEstimated ? FoodDatabaseSource.estimated : source,
    gramsLow: gLow,
    gramsHigh: gHigh,
    kcalLow: kLow,
    kcalHigh: kHigh,
    hasVisibleOilOrSauce: scanned.visibleOilOrSauce,
  );
}

ResolvedMealLine rescaleLine(ResolvedMealLine line, double newGrams) {
  if (line.grams <= 0) return line;
  final r = newGrams / line.grams;
  return line.copyWith(
    grams: newGrams,
    kcal: line.kcal * r,
    protein: line.protein * r,
    carbs: line.carbs * r,
    fat: line.fat * r,
    kcalLow: (line.displayKcalLow * r).roundToDouble(),
    kcalHigh: (line.displayKcalHigh * r).roundToDouble(),
    gramsLow: (line.gramsLow != null) ? line.gramsLow! * r : null,
    gramsHigh: (line.gramsHigh != null) ? line.gramsHigh! * r : null,
  );
}

ResolvedMealLine recomputeWithMethod(
  ResolvedMealLine line,
  CookingMethod method, {
  FoodItem? oilFood,
}) {
  if (line.food == null && line.isEstimated) {
    return line.copyWith(cookingMethod: method);
  }
  final scanned = ScannedFoodItem(
    nameAr: line.nameAr,
    nameEn: line.nameEn,
    foodIdGuess: line.food?.id,
    estimatedGrams: line.grams,
    cookingMethod: method,
    confidence: line.confidence,
    gramsLow: line.gramsLow,
    gramsHigh: line.gramsHigh,
    visibleOilOrSauce: line.hasVisibleOilOrSauce,
  );
  return resolveLine(
    scanned: scanned,
    food: line.food,
    estimatedPer100g: line.food == null && line.grams > 0
        ? FoodMacros100g(
            kcal: line.kcal / line.grams * 100,
            protein: line.protein / line.grams * 100,
            carbs: line.carbs / line.grams * 100,
            fat: line.fat / line.grams * 100,
            fiber: 0,
          )
        : null,
    methodOverride: method,
    oilFood: oilFood,
    source: line.source,
  );
}
