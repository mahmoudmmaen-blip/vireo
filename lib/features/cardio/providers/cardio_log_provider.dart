import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/utils/cardio_calorie_calculator.dart';

const _cardioLogKey = 'cardio_logs';

class CardioLogNotifier extends Notifier<List<CardioLogEntry>> {
  @override
  List<CardioLogEntry> build() {
    if (!HiveService.isInitialized) return const [];
    final raw = HiveService.cacheBox.get(_cardioLogKey);
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => CardioLogEntry.fromJson(Map<String, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => b.loggedAt.compareTo(a.loggedAt));
  }

  Future<CardioLogEntry> logActivity({
    required CardioActivityType activity,
    required int durationMinutes,
    required double weightKg,
  }) async {
    final entry = CardioLogEntry(
      id: 'cardio_${DateTime.now().millisecondsSinceEpoch}',
      activity: activity,
      durationMinutes: durationMinutes.clamp(1, 300),
      caloriesBurned: CardioCalorieCalculator.burn(
        activity: activity,
        durationMinutes: durationMinutes,
        weightKg: weightKg,
      ),
      loggedAt: DateTime.now(),
    );
    final next = [entry, ...state];
    state = next;
    await _persist(next);
    return entry;
  }

  Future<void> remove(String id) async {
    final next = state.where((e) => e.id != id).toList();
    state = next;
    await _persist(next);
  }

  Future<void> _persist(List<CardioLogEntry> entries) async {
    if (!HiveService.isInitialized) return;
    await HiveService.cacheBox.put(
      _cardioLogKey,
      entries.map((e) => e.toJson()).toList(),
    );
  }

  int get todayCalories {
    final today = DateTime.now();
    return state
        .where(
          (e) =>
              e.loggedAt.year == today.year &&
              e.loggedAt.month == today.month &&
              e.loggedAt.day == today.day,
        )
        .fold<int>(0, (sum, e) => sum + e.caloriesBurned);
  }
}

final cardioLogProvider =
    NotifierProvider<CardioLogNotifier, List<CardioLogEntry>>(
  CardioLogNotifier.new,
);

final todayCardioCaloriesProvider = Provider<int>((ref) {
  ref.watch(cardioLogProvider);
  return ref.read(cardioLogProvider.notifier).todayCalories;
});
