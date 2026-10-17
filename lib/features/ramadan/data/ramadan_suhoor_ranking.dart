import 'package:vireo/features/nutrition/data/food_db_repository.dart';

/// Suhoor satiety score from DB protein + fiber per 100 g (no invented macros).
class RamadanSuhoorRankEntry {
  const RamadanSuhoorRankEntry({
    required this.foodId,
    required this.nameAr,
    required this.nameEn,
    required this.score,
    required this.gramsExample,
    required this.kcalExample,
  });

  final String foodId;
  final String nameAr;
  final String nameEn;
  final double score;
  final double gramsExample;
  final int kcalExample;
}

abstract final class RamadanSuhoorRanking {
  static const _candidateIds = [
    'oats_dry',
    'foul_medames',
    'egg_boiled',
    'date_medjool',
    'yogurt_plain',
    'labneh',
    'white_cheese_egyptian',
    'peanut_butter',
    'chickpeas_cooked',
    'lentils_cooked',
  ];

  static Future<List<RamadanSuhoorRankEntry>> loadRanked() async {
    await FoodDbRepository.instance.load();
    final entries = <RamadanSuhoorRankEntry>[];
    for (final id in _candidateIds) {
      final food = FoodDbRepository.instance.byId(id);
      if (food == null) continue;
      final grams = food.commonPortions.isNotEmpty
          ? food.commonPortions.first.grams
          : 100.0;
      final f = grams / 100.0;
      final protein = food.per100g.protein * f;
      final fiber = food.per100g.fiber * f;
      final score = protein * 2 + fiber;
      final kcal = (food.per100g.kcal * f).round();
      entries.add(RamadanSuhoorRankEntry(
        foodId: id,
        nameAr: food.nameAr,
        nameEn: food.nameEn,
        score: score,
        gramsExample: grams,
        kcalExample: kcal,
      ));
    }
    entries.sort((a, b) => b.score.compareTo(a.score));
    return entries;
  }
}
