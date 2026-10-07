import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/features/ai_nutrition/providers/ai_meal_log_provider.dart';
import 'package:vireo/features/nutrition/providers/calorie_goal_provider.dart';
import 'package:vireo/features/nutrition/providers/confirmed_meals_provider.dart';
import 'package:vireo/features/nutrition/providers/demo_meal_overrides_provider.dart';
import 'package:vireo/features/vitality/application/vitality_score_calculator.dart';
import 'package:vireo/features/vitality/data/vitality_content_repository.dart';
import 'package:vireo/features/vitality/data/vitality_daily_log.dart';
import 'package:vireo/features/vitality/domain/vitality_models.dart';
import 'package:vireo/features/vitality/providers/vitality_progress_provider.dart';

const _vitalityLogKey = 'vitality_daily_log';

final vitalityContentRepositoryProvider = Provider<IVitalityContentRepository>(
  (ref) => const VitalityContentRepository(),
);

final dailyProteinConsumedProvider = Provider<int>((ref) {
  final meals = ref.watch(effectiveTodayMealsProvider).valueOrNull ?? [];
  final confirmed = ref.watch(confirmedMealsProvider);
  var total = 0;
  for (final meal in meals) {
    if (confirmed.contains(meal.mealType)) {
      total += meal.recipe.proteinG;
    }
  }
  total += ref.watch(dailyAiMealProteinProvider).round();
  return total;
});

final proteinGoalMetProvider = Provider<bool>((ref) {
  final consumed = ref.watch(dailyProteinConsumedProvider);
  final target = ref.watch(calorieGoalProvider).proteinG;
  return target > 0 && consumed >= target;
});

class VitalityDailyLogNotifier extends Notifier<VitalityDailyLog> {
  @override
  VitalityDailyLog build() => _loadForToday();

  VitalityDailyLog _loadForToday() {
    final today = vitalityTodayDateKey();
    if (!HiveService.isInitialized) {
      return VitalityDailyLog.empty(today);
    }
    try {
      final raw = HiveService.cacheBox.get(_vitalityLogKey);
      if (raw is Map) {
        final log = VitalityDailyLog.fromJson(Map<String, dynamic>.from(raw));
        if (log.dateKey == today) return log;
      }
    } catch (_) {}
    final fresh = VitalityDailyLog.empty(today);
    _persistAsync(fresh);
    return fresh;
  }

  Future<void> setSleepHours(double hours) async {
    final clamped = hours.clamp(0.0, 14.0);
    state = state.copyWith(sleepHours: clamped);
    await _persistAsync(state);
    await ref
        .read(vitalityBadgeProgressProvider.notifier)
        .onSleepLogged(clamped);
  }

  Future<void> logBreathingSession() async {
    final next = state.breathingSessions + 1;
    state = state.copyWith(breathingSessions: next);
    await _persistAsync(state);
    await ref
        .read(vitalityBadgeProgressProvider.notifier)
        .onBreathingSession(next);
  }

  Future<void> markWorkoutCompleted() async {
    state = state.copyWith(workoutCompleted: true);
    await _persistAsync(state);
  }

  Future<void> toggleSunlightDone(bool value) async {
    state = state.copyWith(sunlightDone: value);
    await _persistAsync(state);
  }

  Future<void> toggleZincVitDDone(bool value) async {
    state = state.copyWith(zincVitDDone: value);
    await _persistAsync(state);
  }

  Future<bool> markArticleRead(String articleId) async {
    if (state.readArticleIds.contains(articleId)) return false;
    final updatedIds = {...state.readArticleIds, articleId};
    final points = (state.educationPoints + 5).clamp(0, 20);
    state = state.copyWith(
      readArticleIds: updatedIds,
      educationPoints: points,
    );
    await _persistAsync(state);
    return true;
  }

  Future<void> _persistAsync(VitalityDailyLog log) async {
    if (!HiveService.isInitialized) return;
    try {
      await HiveService.cacheBox.put(_vitalityLogKey, log.toJson());
    } catch (_) {}
  }
}

final vitalityDailyLogProvider =
    NotifierProvider<VitalityDailyLogNotifier, VitalityDailyLog>(
  VitalityDailyLogNotifier.new,
);

final vitalityScoreProvider = Provider<VitalityScoreBreakdown>((ref) {
  final log = ref.watch(vitalityDailyLogProvider);
  final target = ref.watch(calorieGoalProvider);
  final protein = ref.watch(dailyProteinConsumedProvider);

  return VitalityScoreCalculator.compute(
    sleepHours: log.sleepHours,
    workoutCompleted: log.workoutCompleted,
    proteinConsumed: protein,
    proteinTarget: target.proteinG,
    breathingSessions: log.breathingSessions,
    educationPoints: log.educationPoints,
  );
});

final dailyVitalityChecklistProgressProvider = Provider<int>((ref) {
  final log = ref.watch(vitalityDailyLogProvider);
  final proteinMet = ref.watch(proteinGoalMetProvider);
  return log.checklistCompleted(proteinGoalMet: proteinMet);
});

final dailyVitalityTipProvider = Provider<VitalityTip>((ref) {
  ref.watch(vitalityContentRepositoryProvider);
  return const VitalityContentRepository().tipForDay(DateTime.now());
});

final vitalityArticleProvider =
    Provider.family<VitalityArticle?, String>((ref, id) {
  return ref.read(vitalityContentRepositoryProvider).getArticleById(id);
});
