import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/features/ai_nutrition/domain/food_analysis_result.dart';

const _aiMealLogKey = 'ai_meal_logs';

class AiMealLogEntry {
  const AiMealLogEntry({
    required this.id,
    required this.loggedAt,
    required this.result,
  });

  final String id;
  final DateTime loggedAt;
  final FoodAnalysisResult result;

  factory AiMealLogEntry.fromJson(Map<String, dynamic> json) {
    return AiMealLogEntry(
      id: json['id'] as String,
      loggedAt: DateTime.parse(json['logged_at'] as String),
      result: FoodAnalysisResult.fromJson(
        Map<String, dynamic>.from(json['result'] as Map),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'logged_at': loggedAt.toIso8601String(),
        'result': result.toJson(),
      };
}

class AiMealLogNotifier extends Notifier<List<AiMealLogEntry>> {
  @override
  List<AiMealLogEntry> build() {
    if (!HiveService.isInitialized) return const [];
    final raw = HiveService.cacheBox.get(_aiMealLogKey);
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => AiMealLogEntry.fromJson(Map<String, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => b.loggedAt.compareTo(a.loggedAt));
  }

  Future<void> save(FoodAnalysisResult result) async {
    final entry = AiMealLogEntry(
      id: 'ai_meal_${DateTime.now().millisecondsSinceEpoch}',
      loggedAt: DateTime.now(),
      result: result,
    );
    final next = [entry, ...state];
    state = next;
    await _persist(next);
  }

  Future<void> remove(String id) async {
    final next = state.where((e) => e.id != id).toList();
    state = next;
    await _persist(next);
  }

  Future<void> _persist(List<AiMealLogEntry> entries) async {
    if (!HiveService.isInitialized) return;
    await HiveService.cacheBox.put(
      _aiMealLogKey,
      entries.map((e) => e.toJson()).toList(),
    );
  }

  List<AiMealLogEntry> get todayEntries {
    final today = DateTime.now();
    return state.where((e) {
      final d = e.loggedAt;
      return d.year == today.year &&
          d.month == today.month &&
          d.day == today.day;
    }).toList();
  }

  int get todayCalories =>
      todayEntries.fold(0, (sum, e) => sum + e.result.calories);

  double get todayProtein =>
      todayEntries.fold(0.0, (sum, e) => sum + e.result.protein);
}

final aiMealLogProvider =
    NotifierProvider<AiMealLogNotifier, List<AiMealLogEntry>>(
  AiMealLogNotifier.new,
);

final dailyAiMealCaloriesProvider = Provider<int>((ref) {
  ref.watch(aiMealLogProvider);
  return ref.read(aiMealLogProvider.notifier).todayCalories;
});

final dailyAiMealProteinProvider = Provider<double>((ref) {
  ref.watch(aiMealLogProvider);
  return ref.read(aiMealLogProvider.notifier).todayProtein;
});
