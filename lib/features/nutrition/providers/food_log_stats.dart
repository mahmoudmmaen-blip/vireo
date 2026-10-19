import 'package:vireo/features/nutrition/providers/meal_favorites_provider.dart';
import 'package:vireo/features/nutrition/providers/repeat_meal_service.dart';

/// Aggregates `food_id`s from persisted meal logs for food-search chips.
abstract final class FoodLogStats {
  /// Distinct food IDs in reverse-chronological order (most recently logged first).
  static List<String> recentFoodIds({
    required List<SlotMealRecord> history,
    required List<SavedMealSnippet> recents,
    int limit = 12,
  }) {
    final seen = <String>{};
    final out = <String>[];

    void takeFrom(List<SavedMealSnippet> snippets) {
      for (final s in snippets) {
        for (final id in _foodIds(s)) {
          if (seen.add(id)) {
            out.add(id);
            if (out.length >= limit) return;
          }
        }
      }
    }

    final historySnippets = [...history]
      ..sort((a, b) => b.snippet.savedAt.compareTo(a.snippet.savedAt));
    takeFrom(historySnippets.map((e) => e.snippet).toList());
    if (out.length >= limit) return out;

    final recentSorted = [...recents]
      ..sort((a, b) => b.savedAt.compareTo(a.savedAt));
    takeFrom(recentSorted);
    return out;
  }

  /// Food IDs sorted by log frequency (highest first), last [windowDays] days.
  static List<({String id, int count})> frequentFoodIds({
    required List<SlotMealRecord> history,
    required List<SavedMealSnippet> recents,
    DateTime? now,
    int windowDays = 30,
    int limit = 12,
  }) {
    final t = now ?? DateTime.now();
    final cutoff = DateTime(t.year, t.month, t.day - windowDays);
    final counts = <String, int>{};

    void countSnippet(SavedMealSnippet s) {
      if (s.savedAt.isBefore(cutoff)) return;
      for (final id in _foodIds(s)) {
        counts[id] = (counts[id] ?? 0) + 1;
      }
    }

    for (final r in history) {
      countSnippet(r.snippet);
    }
    for (final s in recents) {
      countSnippet(s);
    }

    final ranked = counts.entries.toList()
      ..sort((a, b) {
        final byCount = b.value.compareTo(a.value);
        if (byCount != 0) return byCount;
        return a.key.compareTo(b.key);
      });

    return ranked
        .take(limit)
        .map((e) => (id: e.key, count: e.value))
        .toList();
  }

  static Iterable<String> _foodIds(SavedMealSnippet s) sync* {
    for (final raw in s.linesJson) {
      final id = raw['food_id']?.toString();
      if (id != null && id.isNotEmpty) yield id;
    }
  }
}
