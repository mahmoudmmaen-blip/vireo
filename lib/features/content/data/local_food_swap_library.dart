import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:vireo/features/content/models/local_food_swap.dart';

/// DB-backed local swap catalog (≥100 entries). Deterministic picker helpers.
class LocalFoodSwapLibrary {
  LocalFoodSwapLibrary._();
  static final LocalFoodSwapLibrary instance = LocalFoodSwapLibrary._();

  List<LocalFoodSwap>? _swaps;

  Future<List<LocalFoodSwap>> load() async {
    if (_swaps != null) return _swaps!;
    final raw = await rootBundle.loadString('assets/content/local_food_swaps.json');
    final decoded = Map<String, dynamic>.from(jsonDecode(raw) as Map);
    _swaps = (decoded['swaps'] as List? ?? [])
        .whereType<Map>()
        .map((e) => LocalFoodSwap.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    return _swaps!;
  }

  /// Highest-saving swap mentioning any of [foodIds] (from side of pair).
  Future<LocalFoodSwap?> bestForFoodIds(Iterable<String> foodIds) async {
    final ids = foodIds.map((e) => e.toLowerCase()).toSet();
    final list = await load();
    LocalFoodSwap? best;
    for (final s in list) {
      if (!ids.contains(s.fromFoodId.toLowerCase())) continue;
      if (best == null || s.savedKcal > best.savedKcal) best = s;
    }
    return best;
  }

  /// Match by Arabic/English substring in tips (fallback when IDs unknown).
  Future<LocalFoodSwap?> bestForMealLineNames(Iterable<String> names) async {
    final norm = names.map(_norm).where((e) => e.length > 2).toList();
    if (norm.isEmpty) return null;
    final list = await load();
    LocalFoodSwap? best;
    for (final s in list) {
      final hay = _norm('${s.tipAr} ${s.tipEn} ${s.fromFoodId}');
      var hits = 0;
      for (final n in norm) {
        if (hay.contains(n)) hits++;
      }
      if (hits == 0) continue;
      if (best == null || s.savedKcal > best.savedKcal) best = s;
    }
    return best;
  }

  static String _norm(String s) => s
      .toLowerCase()
      .replaceAll(RegExp('[أإآ]'), 'ا')
      .replaceAll('ى', 'ي')
      .replaceAll('ة', 'ه');
}
