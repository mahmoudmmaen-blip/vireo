/// Meal Diversity Engine constants (Section 8).
/// Mirrors `meal-plan-generator.ts` history windows.
abstract final class MealDiversity {
  static const defaultHistoryDays = 14;
  static const relaxedHistoryDays = 7;
  static const cuisineLookbackDays = 30;

  /// Returns recipe IDs served within [withinDays] of [reference].
  static Set<String> recentRecipeIds({
    required Iterable<({String recipeId, DateTime servedAt})> history,
    required DateTime reference,
    required int withinDays,
  }) {
    final cutoff = reference.subtract(Duration(days: withinDays));
    return history
        .where((row) => !row.servedAt.isBefore(cutoff))
        .map((row) => row.recipeId)
        .toSet();
  }

  /// Picks the first candidate not blocked by history or current exclusions.
  static String? pickAlternative({
    required List<String> candidates,
    required Set<String> blockedIds,
  }) {
    for (final id in candidates) {
      if (!blockedIds.contains(id)) return id;
    }
    return null;
  }
}
