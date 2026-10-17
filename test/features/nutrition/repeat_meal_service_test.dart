import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/features/nutrition/providers/meal_favorites_provider.dart';
import 'package:vireo/features/nutrition/providers/repeat_meal_service.dart';

SavedMealSnippet _snippet(String id, DateTime savedAt, {bool withLines = true}) {
  return SavedMealSnippet(
    id: id,
    labelAr: 'كشري $id',
    labelEn: 'Koshari $id',
    kcal: 600,
    linesJson: withLines
        ? [
            {'food_id': 'koshari', 'grams': 300, 'name_ar': 'كشري'},
          ]
        : const [],
    savedAt: savedAt,
  );
}

void main() {
  final now = DateTime(2026, 10, 16, 13, 0); // Friday lunch
  final yesterdayLunch = DateTime(2026, 10, 15, 13, 30);

  group('RepeatMealService.slotForTime', () {
    test('matches the Home card thresholds', () {
      expect(RepeatMealService.slotForTime(DateTime(2026, 1, 1, 7)), MealType.breakfast);
      expect(RepeatMealService.slotForTime(DateTime(2026, 1, 1, 11)), MealType.lunch);
      expect(RepeatMealService.slotForTime(DateTime(2026, 1, 1, 16)), MealType.dinner);
      expect(RepeatMealService.slotForTime(DateTime(2026, 1, 1, 21)), MealType.snack);
    });
  });

  group('pickYesterdaySameSlot', () {
    test('exact slot history wins', () {
      final lunch = _snippet('a', yesterdayLunch);
      final dinner = _snippet('b', DateTime(2026, 10, 15, 19));
      final picked = RepeatMealService.pickYesterdaySameSlot(
        slot: MealType.lunch,
        now: now,
        history: [
          SlotMealRecord(day: '2026-10-15', slot: MealType.dinner, snippet: dinner),
          SlotMealRecord(day: '2026-10-15', slot: MealType.lunch, snippet: lunch),
        ],
        recents: const [],
      );
      expect(picked?.id, 'a');
    });

    test('latest meal of that slot wins when there are several', () {
      final early = _snippet('early', DateTime(2026, 10, 15, 12));
      final late = _snippet('late', DateTime(2026, 10, 15, 14));
      final picked = RepeatMealService.pickYesterdaySameSlot(
        slot: MealType.lunch,
        now: now,
        history: [
          SlotMealRecord(day: '2026-10-15', slot: MealType.lunch, snippet: early),
          SlotMealRecord(day: '2026-10-15', slot: MealType.lunch, snippet: late),
        ],
        recents: const [],
      );
      expect(picked?.id, 'late');
    });

    test('ignores today and older days', () {
      final today = _snippet('today', now);
      final old = _snippet('old', DateTime(2026, 10, 14, 13));
      final picked = RepeatMealService.pickYesterdaySameSlot(
        slot: MealType.lunch,
        now: now,
        history: [
          SlotMealRecord(day: '2026-10-16', slot: MealType.lunch, snippet: today),
          SlotMealRecord(day: '2026-10-14', slot: MealType.lunch, snippet: old),
        ],
        recents: const [],
      );
      expect(picked, isNull);
    });

    test('falls back to recents saved yesterday in the same time slot', () {
      final recent = _snippet('r', yesterdayLunch);
      final other = _snippet('o', DateTime(2026, 10, 15, 20));
      final picked = RepeatMealService.pickYesterdaySameSlot(
        slot: MealType.lunch,
        now: now,
        history: const [],
        recents: [other, recent],
      );
      expect(picked?.id, 'r');
    });

    test('snippets without lines cannot be repeated', () {
      final empty = _snippet('e', yesterdayLunch, withLines: false);
      final picked = RepeatMealService.pickYesterdaySameSlot(
        slot: MealType.lunch,
        now: now,
        history: [
          SlotMealRecord(day: '2026-10-15', slot: MealType.lunch, snippet: empty),
        ],
        recents: [empty],
      );
      expect(picked, isNull);
    });

    test('month boundary: yesterday of Nov 1 is Oct 31', () {
      expect(RepeatMealService.yesterdayKey(DateTime(2026, 11, 1, 9)), '2026-10-31');
    });
  });

  test('SlotMealRecord JSON round-trip', () {
    final rec = SlotMealRecord(
      day: '2026-10-15',
      slot: MealType.dinner,
      snippet: _snippet('x', DateTime(2026, 10, 15, 20)),
    );
    final back = SlotMealRecord.fromJson(rec.toJson());
    expect(back.day, rec.day);
    expect(back.slot, MealType.dinner);
    expect(back.snippet.id, 'x');
    expect(back.snippet.linesJson, isNotEmpty);
  });
}
