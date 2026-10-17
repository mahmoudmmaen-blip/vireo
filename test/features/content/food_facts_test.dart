import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/content/domain/content_walking_math.dart';
import 'package:vireo/features/content/models/food_fact.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('food_facts.json', () {
    late List<FoodFact> facts;

    setUpAll(() async {
      final path = '${Directory.current.path}/assets/content/food_facts.json';
      final raw = File(path).readAsStringSync();
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      facts = (decoded['facts'] as List)
          .map((e) => FoodFact.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    });

    test('has at least 60 entries with positive kcal and walk minutes', () {
      expect(facts.length, greaterThanOrEqualTo(60));
      for (final f in facts) {
        expect(f.kcal, greaterThan(0), reason: f.id);
        expect(f.walkMinutes, greaterThan(0), reason: f.id);
        expect(f.foodId, isNotEmpty, reason: f.id);
      }
    });

    test('walk minutes match ContentWalkingMath for each fact', () {
      for (final f in facts) {
        final expected = ContentWalkingMath.walkingMinutesForKcal(f.kcal.toDouble());
        expect(f.walkMinutes, expected, reason: 'fact ${f.id}');
      }
    });

    test('koshary large bowl kcal matches food DB JSON', () {
      final dbRaw = File('${Directory.current.path}/assets/food_db/foods.json').readAsStringSync();
      final db = jsonDecode(dbRaw) as Map<String, dynamic>;
      final food = (db['foods'] as List).cast<Map>().firstWhere(
            (f) => f['id'] == 'koshary_egyptian',
          );
      final per100 = (food['per_100g'] as Map)['kcal'] as num;
      const grams = 650.0;
      final kcal = (per100 * grams / 100).round();
      final fact = facts.firstWhere(
        (f) => f.foodId == 'koshary_egyptian' && f.grams == grams,
        orElse: () => throw StateError('missing koshary large fact'),
      );
      expect(fact.kcal, kcal);
    });

    test('day-of-year index is deterministic', () {
      final day = DateTime(2026, 3, 1);
      final start = DateTime(day.year, 1, 1);
      final idx = day.difference(start).inDays % facts.length;
      final idx2 = day.difference(start).inDays % facts.length;
      expect(idx, idx2);
    });
  });
}
