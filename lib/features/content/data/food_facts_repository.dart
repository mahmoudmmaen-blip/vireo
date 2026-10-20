import 'package:vireo/core/utils/asset_json.dart';
import 'package:vireo/features/content/models/food_fact.dart';

class FoodFactsRepository {
  FoodFactsRepository._();
  static final FoodFactsRepository instance = FoodFactsRepository._();

  List<FoodFact>? _facts;

  Future<List<FoodFact>> load() async {
    if (_facts != null) return _facts!;
    final decoded =
        await loadGzippedJsonMap('assets/content/food_facts.json.gz');
    _facts = (decoded['facts'] as List? ?? [])
        .whereType<Map>()
        .map((e) => FoodFact.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    return _facts!;
  }

  /// One fact per calendar day (deterministic index).
  Future<FoodFact?> factForDay(DateTime day) async {
    final list = await load();
    if (list.isEmpty) return null;
    final start = DateTime(day.year, 1, 1);
    final dayOfYear = day.difference(start).inDays;
    return list[dayOfYear % list.length];
  }
}
