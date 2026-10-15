// Unit tests for the accuracy bench engine (P35b round 2):
// Arabic matcher behavior, portion-gram math, composite dishes, and the
// deterministic hold-out split. The engine lives in tool/accuracy_bench/.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../../tool/accuracy_bench/bench_engine.dart';

List<Map<String, dynamic>> loadPool(String path) {
  final data = jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
  return (data['foods'] as List).cast<Map<String, dynamic>>();
}

void main() {
  final egFoods = loadPool('assets/food_db/foods.json');
  final usdaFoods = loadPool('assets/food_db/usda_foods.json');

  group('normalizeText / hasWord', () {
    test('normalizes Arabic spelling variants', () {
      expect(normalizeText('كفتة'), 'كفته');
      expect(normalizeText('بيضاء'), 'بيضاء');
      expect(normalizeText('أرز'), 'ارز');
      expect(normalizeText('ملوخية'), 'ملوخيه');
    });

    test('hasWord avoids substring collisions', () {
      expect(hasWord('كفته مشويه', 'فته'), isFalse);
      expect(hasWord('فته مصريه', 'فته'), isTrue);
      expect(hasWord('سكوب بروتين', 'كوب'), isFalse);
      expect(hasWord('كوب ارز', 'كوب'), isTrue);
      expect(hasWord('زيت الزيتون', 'زيتون'), isFalse);
      expect(hasWord('حبات زيتون اسود', 'زيتون'), isTrue);
    });
  });

  group('matcher (matchFood)', () {
    test('matches dialect spellings via aliases (رز/أرز)', () {
      final (food, src) = matchFood('ارز ابيض مطبوخ', egFoods, usdaFoods);
      expect(food, isNotNull);
      expect(food!['id'], 'white_rice_cooked');
      expect(src, 'egyptian_db');
    });

    test('"زبادي يوناني" matches Greek yogurt, not baladi plain', () {
      final (food, _) = matchFood('زبادي يوناني', egFoods, usdaFoods);
      expect(food!['id'], 'yogurt_greek');
    });

    test('"لوز مجروش" matches almonds, not almond milk', () {
      final (food, _) = matchFood('لوز مجروش', egFoods, usdaFoods);
      expect(food!['id'], 'almonds');
    });

    test('"كبدة إسكندرانية" matches the Alexandrian liver dish, not pate', () {
      final (food, _) = matchFood('كبدة إسكندرانية', egFoods, usdaFoods);
      expect(food!['id'], 'kebda_iskandarani');
    });

    test('Alexandrian liver sandwich clean-name maps to the dish entry', () {
      final (clean, g) = parsePortionAndName('2 ساندوتش كبدة إسكندراني في عيش فينو');
      expect(g, 380.0);
      final (food, _) = matchFood(clean, egFoods, usdaFoods);
      expect(food!['id'], 'kebda_iskandarani');
    });

    test('USDA fallback for generic foods', () {
      final (food, src) = matchFood('شوفان مطبوخ', egFoods, usdaFoods);
      expect(food, isNotNull);
      expect(src, anyOf('egyptian_db', 'usda'));
    });
  });

  group('parsePortionAndName — portion grams', () {
    (String, double) p(String s) => parsePortionAndName(s);

    test('kofta is not parsed as fatta (كفته vs فتة)', () {
      final (clean, g) = p('3 صوابع كفتة مشوية');
      expect(g, 135.0);
      expect(clean, contains('كفته'));
    });

    test('بيضاء (white beans) is not parsed as eggs', () {
      final (_, g) = p('طبق فاصوليا بيضاء باللحمة');
      expect(g, 240.0);
    });

    test('ممبار محشي counts pieces, not the generic محشي plate', () {
      final (_, g) = p('4 أصابع ممبار محشي ومحمر');
      expect(g, 200.0);
    });

    test('سكوب is not parsed as a cup', () {
      final (_, g) = p('سكوب بروتين واي');
      expect(g, 30.0);
    });

    test('زيت الزيتون is not parsed as olives', () {
      final (_, g) = p('ملعقة كبيرة زيت زيتون');
      expect(g, 14.0);
    });

    test('spoons: tablespoon 14 g oil, teaspoon 5 g butter', () {
      expect(p('ملعقة كبيرة زيت زيتون').$2, 14.0);
      expect(p('2 ملعقة كبيرة طحينة').$2, 30.0);
      expect(p('ملعقة صغيرة زبدة').$2, 5.0);
    });

    test('bread: baladi loaf, pita, burger bun, tortilla', () {
      expect(p('رغيف عيش بلدي').$2, 90.0);
      expect(p('رغيف خبز شامي بيتا').$2, 65.0);
      expect(p('خبز برجر كايزر').$2, 60.0);
      expect(p('خبز تورتيلا كبير').$2, 75.0);
    });

    test('fruit fractions: quarter and half', () {
      expect(p('ربع ثمرة أفوكادو').$2, 35.0);
      expect(p('نصف ثمرة أفوكادو').$2, 65.0);
    });

    test('sandwiches: liver, shawarma, default', () {
      expect(p('2 ساندوتش كبدة إسكندراني في عيش فينو').$2, 380.0);
      expect(p('ساندوتش شاورما فراخ في خبز شامي').$2, 200.0);
      expect(p('ساندوتش جبنة رومي في عيش فينو').$2, 120.0);
    });

    test('كبيرة token is stripped whole (no stray ه)', () {
      final (clean, _) = p('ملعقة كبيرة عسل');
      expect(clean, isNot('ه عسل'));
      expect(clean, contains('عسل'));
    });

    test('ribeye steak gets a large-cut portion', () {
      expect(p('قطعة ستيك لحم بقري ريب آي').$2, 220.0);
      expect(p('قطعة ستيك سلمون مشوي').$2, 170.0);
    });
  });

  group('composite dishes', () {
    MealRow row(String items) => MealRow(
          mealId: 'x',
          category: 'egyptian',
          mealName: 'x',
          itemsText: items,
          trueKcal: 1,
          source: '',
        );

    test('شاورما sandwich is not a composite, جبنة رومي sandwich is', () {
      final r1 = estimateMeal(row('ساندوتش شاورما فراخ في خبز شامي'), egFoods, usdaFoods);
      final r2 = estimateMeal(row('ساندوتش جبنة رومي في عيش فينو'), egFoods, usdaFoods);
      // Composite: فينو + cheese ≈ 325 kcal; a single pure-cheese match would be ~456.
      expect(r2.estKcal, lessThan(400));
      expect((r1.estKcal - 460).abs(), lessThan(120));
    });

    test('chili expands to beef + beans + oil', () {
      final r = estimateMeal(row('طبق تشيلي لحم مفروم بالفاصوليا والصلصة'), egFoods, usdaFoods);
      expect(r.estKcal, greaterThan(240));
      expect(r.estKcal, lessThan(320));
    });
  });

  group('hold-out split', () {
    test('is deterministic, stratified, and exactly 20 meals', () {
      final meals = [
        for (var i = 1; i <= 45; i++)
          MealRow(
            mealId: 'eg_${i.toString().padLeft(2, '0')}',
            category: 'egyptian',
            mealName: '',
            itemsText: 'x',
            trueKcal: 100,
            source: '',
          ),
        for (var i = 1; i <= 25; i++)
          MealRow(
            mealId: 'gen_${i.toString().padLeft(2, '0')}',
            category: 'generic',
            mealName: '',
            itemsText: 'x',
            trueKcal: 100,
            source: '',
          ),
      ];
      final a = computeHeldOutIds(meals);
      final b = computeHeldOutIds(meals);
      expect(a, equals(b), reason: 'split must be deterministic');
      expect(a.length, 20);
      expect(a.where((id) => id.startsWith('eg_')).length, 13);
      expect(a.where((id) => id.startsWith('gen_')).length, 7);
      // Stable under reordering.
      final c = computeHeldOutIds(meals.reversed.toList());
      expect(c, equals(a));
    });
  });
}
