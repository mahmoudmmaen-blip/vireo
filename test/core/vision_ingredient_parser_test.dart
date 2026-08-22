import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/utils/vision_ingredient_parser.dart';

void main() {
  group('VisionIngredientParser §4 JSON array contract', () {
    test('parses plain JSON array', () {
      expect(
        VisionIngredientParser.parse('["بيض", "طماطم"]'),
        ['بيض', 'طماطم'],
      );
    });

    test('parses fenced JSON block from model output', () {
      const raw = '''
```json
["Chicken", "Rice"]
```''';
      expect(VisionIngredientParser.parse(raw), ['Chicken', 'Rice']);
    });

    test('deduplicates case-insensitively', () {
      expect(
        VisionIngredientParser.parse('["Eggs", "eggs", "EGGS"]'),
        ['Eggs'],
      );
    });

    test('returns empty list for empty array', () {
      expect(VisionIngredientParser.parse('[]'), isEmpty);
    });

    test('throws on non-array JSON', () {
      expect(
        () => VisionIngredientParser.parse('{"items": []}'),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
