import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/features/home/providers/daily_program_provider.dart';

void main() {
  group('nextMealTypeFor', () {
    test('morning returns breakfast', () {
      expect(
        nextMealTypeFor(DateTime(2026, 8, 22, 8)),
        MealType.breakfast,
      );
    });

    test('afternoon returns lunch', () {
      expect(
        nextMealTypeFor(DateTime(2026, 8, 22, 13)),
        MealType.lunch,
      );
    });

    test('evening returns dinner', () {
      expect(
        nextMealTypeFor(DateTime(2026, 8, 22, 19)),
        MealType.dinner,
      );
    });
  });
}
