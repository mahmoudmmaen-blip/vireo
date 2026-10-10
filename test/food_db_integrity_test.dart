import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('foods.json integrity: sources, Atwater, unique ids, portions', () {
    final file = File('assets/food_db/foods.json');
    expect(file.existsSync(), isTrue);
    final decoded = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    final foods = (decoded['foods'] as List).cast<Map<String, dynamic>>();
    expect(foods.length, greaterThanOrEqualTo(200));

    final ids = <String>{};
    for (final item in foods) {
      final id = item['id'] as String;
      expect(ids.contains(id), isFalse, reason: 'duplicate id $id');
      ids.add(id);

      final source = item['source'] as Map<String, dynamic>?;
      expect(source, isNotNull, reason: '$id missing source');
      expect(source!['name'], isNotEmpty);
      expect((source['fdc_id'] as num?)?.toInt() ?? 0, greaterThan(0));

      final m = item['per_100g'] as Map<String, dynamic>;
      final kcal = (m['kcal'] as num).toDouble();
      final p = (m['protein'] as num).toDouble();
      final c = (m['carbs'] as num).toDouble();
      final f = (m['fat'] as num).toDouble();
      final atwater = 4 * p + 4 * c + 9 * f;
      if (kcal > 5) {
        final delta = (atwater - kcal).abs() / kcal;
        expect(
          delta,
          lessThanOrEqualTo(0.15),
          reason: '$id Atwater $atwater vs kcal $kcal (Δ=${(delta * 100).toStringAsFixed(1)}%)',
        );
      }

      final portions = item['common_portions'] as List? ?? [];
      for (final raw in portions) {
        final portion = Map<String, dynamic>.from(raw as Map);
        expect((portion['grams'] as num).toDouble(), greaterThan(0));
      }
    }
  });
}
