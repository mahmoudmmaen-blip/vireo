import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/utils/asset_json.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('P55 gzipped food DB loads', () async {
    final map = await loadGzippedJsonMap('assets/food_db/foods.json.gz');
    final foods = map['foods'] as List?;
    expect(foods, isNotNull);
    expect(foods!.length, greaterThan(100));
  });

  test('P55 gzipped food facts loads (≤366)', () async {
    final map = await loadGzippedJsonMap('assets/content/food_facts.json.gz');
    final facts = map['facts'] as List?;
    expect(facts, isNotNull);
    expect(facts!.length, lessThanOrEqualTo(366));
    expect(facts.length, greaterThan(100));
  });
}
