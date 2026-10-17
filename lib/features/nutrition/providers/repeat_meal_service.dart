import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/features/nutrition/data/food_db_models.dart';
import 'package:vireo/features/nutrition/providers/meal_favorites_provider.dart';

const _slotHistoryKey = 'meal_slot_history_v1';
const _slotHistoryKeepDays = 14;
const _slotHistoryMaxRecords = 60;

/// One confirmed meal, remembered with the slot it was logged in
/// (breakfast / lunch / dinner / snack) and the local day.
class SlotMealRecord {
  const SlotMealRecord({
    required this.day,
    required this.slot,
    required this.snippet,
  });

  /// Local calendar day, `yyyy-MM-dd`.
  final String day;
  final MealType slot;
  final SavedMealSnippet snippet;

  factory SlotMealRecord.fromJson(Map<String, dynamic> json) {
    return SlotMealRecord(
      day: json['day']?.toString() ?? '',
      slot: MealType.fromValue(json['slot']?.toString() ?? ''),
      snippet: SavedMealSnippet.fromJson(
        Map<String, dynamic>.from(json['snippet'] as Map? ?? const {}),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'day': day,
        'slot': slot.value,
        'snippet': snippet.toJson(),
      };
}

/// "زي امبارح" helper: finds what the user ate in the same meal slot yesterday.
abstract final class RepeatMealService {
  /// Same time-of-day slot rules used by the Home meal card and review screen.
  static MealType slotForTime(DateTime t) {
    final h = t.hour;
    if (h < 11) return MealType.breakfast;
    if (h < 16) return MealType.lunch;
    if (h < 21) return MealType.dinner;
    return MealType.snack;
  }

  /// Local calendar day key, `yyyy-MM-dd`.
  static String dayKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  static String yesterdayKey(DateTime now) =>
      dayKey(DateTime(now.year, now.month, now.day - 1));

  /// Pure, unit-testable picker.
  ///
  /// 1. Exact: a [history] record logged yesterday in [slot] (latest wins).
  /// 2. Fallback for users who logged before slot history existed: a recent
  ///    snippet saved yesterday whose save time falls in [slot].
  /// Returns null when nothing matches (the chip is then hidden / disabled).
  static SavedMealSnippet? pickYesterdaySameSlot({
    required MealType slot,
    required DateTime now,
    required List<SlotMealRecord> history,
    required List<SavedMealSnippet> recents,
  }) {
    final yKey = yesterdayKey(now);

    SavedMealSnippet? best;
    for (final r in history) {
      if (r.day != yKey || r.slot != slot) continue;
      if (r.snippet.linesJson.isEmpty) continue;
      if (best == null || r.snippet.savedAt.isAfter(best.savedAt)) {
        best = r.snippet;
      }
    }
    if (best != null) return best;

    for (final s in recents) {
      if (s.linesJson.isEmpty) continue;
      if (dayKey(s.savedAt) != yKey) continue;
      if (slotForTime(s.savedAt) != slot) continue;
      if (best == null || s.savedAt.isAfter(best.savedAt)) best = s;
    }
    return best;
  }

  /// Looks at the persisted Hive data (slot history, then recents).
  static SavedMealSnippet? findYesterdaySameSlot(
    MealType slot, {
    DateTime? now,
  }) {
    return pickYesterdaySameSlot(
      slot: slot,
      now: now ?? DateTime.now(),
      history: _loadHistory(),
      recents: loadRecentMealSnippets(),
    );
  }
}

List<SlotMealRecord> _loadHistory() {
  if (!HiveService.isInitialized) return const [];
  final raw = HiveService.cacheBox.get(_slotHistoryKey);
  if (raw is! List) return const [];
  return raw
      .whereType<Map>()
      .map((e) => SlotMealRecord.fromJson(Map<String, dynamic>.from(e)))
      .toList();
}

/// Remembers every confirmed meal with its slot so "زي امبارح" is exact.
class MealSlotHistoryNotifier extends Notifier<List<SlotMealRecord>> {
  @override
  List<SlotMealRecord> build() => _loadHistory();

  Future<void> record(
    MealType slot,
    List<ResolvedMealLine> lines, {
    DateTime? now,
  }) async {
    if (lines.isEmpty) return;
    final t = now ?? DateTime.now();
    final record = SlotMealRecord(
      day: RepeatMealService.dayKey(t),
      slot: slot,
      snippet: SavedMealSnippet.fromLines(lines),
    );
    final cutoff = RepeatMealService.dayKey(
      DateTime(t.year, t.month, t.day - _slotHistoryKeepDays),
    );
    final next = [
      record,
      ...state.where((e) => e.day.compareTo(cutoff) >= 0),
    ].take(_slotHistoryMaxRecords).toList();
    state = next;
    if (!HiveService.isInitialized) return;
    await HiveService.cacheBox.put(
      _slotHistoryKey,
      next.map((e) => e.toJson()).toList(),
    );
  }
}

final mealSlotHistoryProvider =
    NotifierProvider<MealSlotHistoryNotifier, List<SlotMealRecord>>(
  MealSlotHistoryNotifier.new,
);

/// What the user ate yesterday in [slot] (null when nothing to repeat).
final yesterdaySameSlotProvider =
    Provider.family<SavedMealSnippet?, MealType>((ref, slot) {
  final history = ref.watch(mealSlotHistoryProvider);
  final recents = ref.watch(mealRecentProvider);
  return RepeatMealService.pickYesterdaySameSlot(
    slot: slot,
    now: DateTime.now(),
    history: history,
    recents: recents,
  );
});
