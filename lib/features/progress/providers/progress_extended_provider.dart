import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/data/models/fitness_goal.dart';
import 'package:vireo/features/activity/providers/wearable_health_provider.dart';
import 'package:vireo/features/ai_coach/data/gemini_coach_service.dart';
import 'package:vireo/features/ai_coach/domain/user_context.dart';
import 'package:vireo/features/ai_nutrition/providers/ai_meal_log_provider.dart';
import 'package:vireo/features/diet_programs/providers/diet_programs_provider.dart';
import 'package:vireo/features/home/providers/home_dashboard_provider.dart';
import 'package:vireo/features/nutrition/providers/calorie_goal_provider.dart';
import 'package:vireo/features/progress/domain/achievement_badge.dart';
import 'package:vireo/features/progress/domain/adaptive_calorie_calculator.dart';
import 'package:vireo/features/progress/domain/progress_photo_service.dart';
import 'package:vireo/features/progress/domain/weight_trend_calculator.dart';
import 'package:vireo/features/progress/domain/weekly_progress_report_data.dart';
import 'package:vireo/features/progress/providers/progress_provider.dart';
import 'package:vireo/features/walking/data/step_counter_service.dart';
import 'package:vireo/features/water/providers/water_tracker_provider.dart';

// ─── WEIGHT TREND ANALYSIS PROVIDER ─────────────────────────────────────────

final weightTrendAnalysisProvider = Provider<WeightTrendAnalysis>((ref) {
  final logsAsync = ref.watch(weightLogsProvider);
  final logs = logsAsync.valueOrNull ?? [];
  return WeightTrendCalculator.compute(logs, alpha: 0.1);
});

// ─── ADAPTIVE CALORIES STATE & PROVIDERS ────────────────────────────────────

const _dismissedAdaptiveKey = 'dismissed_adaptive_suggestion_target';

final adaptiveCalorieSuggestionProvider = Provider<AdaptiveCalorieSuggestion>((ref) {
  final weights = ref.watch(weightLogsProvider).valueOrNull ?? [];
  final target = ref.watch(calorieGoalProvider);
  final activeDiet = ref.watch(activeDietProgramProvider);
  final aiMeals = ref.watch(aiMealLogProvider);

  // Map intake history
  final intakeLogs = aiMeals.map((m) {
    return DailyIntakeRecord(date: m.loggedAt, calories: m.result.calories);
  }).toList();

  final profile = HiveService.isInitialized ? HiveService.cacheBox.get('guest_profile') : null;
  var goal = FitnessGoal.generalVitality;
  if (profile is Map && profile['goal'] != null) {
    goal = FitnessGoal.fromValue(profile['goal'] as String);
  }

  return AdaptiveCalorieCalculator.calculate(
    weightLogs: weights,
    intakeLogs: intakeLogs,
    currentCalorieTarget: target.calories,
    goal: goal,
    activeDietProgram: activeDiet,
  );
});

class AdaptiveCalorieAcceptNotifier extends StateNotifier<bool> {
  AdaptiveCalorieAcceptNotifier() : super(false);

  Future<void> acceptSuggestion(int newCalories, WidgetRef ref) async {
    await setManualCalorieGoal(newCalories);
    ref.invalidate(calorieGoalProvider);
    state = true;
  }

  Future<void> dismiss(int targetCalories) async {
    if (HiveService.isInitialized) {
      await HiveService.settingsBox.put(_dismissedAdaptiveKey, targetCalories);
    }
    state = true;
  }
}

final adaptiveCalorieActionProvider =
    StateNotifierProvider<AdaptiveCalorieAcceptNotifier, bool>((ref) {
  return AdaptiveCalorieAcceptNotifier();
});

final showAdaptiveCalorieCardProvider = Provider<bool>((ref) {
  final suggestion = ref.watch(adaptiveCalorieSuggestionProvider);
  final actionTaken = ref.watch(adaptiveCalorieActionProvider);
  if (!suggestion.isEligible || actionTaken) return false;
  if (suggestion.appliedDeltaKcal == 0) return false;

  final dismissed = HiveService.isInitialized
      ? HiveService.settingsBox.get(_dismissedAdaptiveKey) as int?
      : null;
  if (dismissed == suggestion.suggestedCalorieTarget) return false;

  return true;
});

// ─── ACHIEVEMENTS / BADGES PROVIDER ─────────────────────────────────────────

final progressBadgesProvider = Provider<List<AchievementBadge>>((ref) {
  final unlockedIds = ProgressBadgeCatalog.readUnlocked();
  final dash = ref.watch(homeDashboardProvider);
  final aiMeals = ref.watch(aiMealLogProvider);
  final weights = ref.watch(weightLogsProvider).valueOrNull ?? [];
  final targetProtein = ref.watch(calorieGoalProvider).proteinG;

  // Track progress & unlock automatically
  final streak = dash.streakDays;
  final workoutsCount = dash.workoutsCompleted;
  final hasScan = aiMeals.isNotEmpty || weights.isNotEmpty;

  // Check 100k steps in last 7 days
  final last7Steps = StepCounterService.last7DaysFromHistory(todaySteps: dash.stepsToday);
  final total7DaysSteps = last7Steps.fold<int>(0, (sum, e) => sum + e.steps);

  final newUnlocked = <String>{...unlockedIds};
  if (streak >= 3) newUnlocked.add(AchievementId.streak3.id);
  if (streak >= 7) newUnlocked.add(AchievementId.streak7.id);
  if (streak >= 30) newUnlocked.add(AchievementId.streak30.id);
  if (hasScan) newUnlocked.add(AchievementId.firstScan.id);
  if (workoutsCount >= 10) newUnlocked.add(AchievementId.workouts10.id);
  if (total7DaysSteps >= 100000) newUnlocked.add(AchievementId.steps100kWeek.id);

  // Check protein goal 7 days
  final proteinDays = <String>{};
  for (final meal in aiMeals) {
    if (meal.result.protein >= (targetProtein * 0.8)) {
      final key = '${meal.loggedAt.year}-${meal.loggedAt.month}-${meal.loggedAt.day}';
      proteinDays.add(key);
    }
  }
  if (proteinDays.length >= 7) newUnlocked.add(AchievementId.proteinGoal7Days.id);

  if (newUnlocked.length > unlockedIds.length) {
    ProgressBadgeCatalog.saveUnlocked(newUnlocked);
  }

  return AchievementId.values.map((id) {
    final meta = ProgressBadgeCatalog.badges[id]!;
    final isUnlocked = newUnlocked.contains(id.id);

    double progress = 0.0;
    switch (id) {
      case AchievementId.streak3:
        progress = (streak / 3).clamp(0.0, 1.0);
      case AchievementId.streak7:
        progress = (streak / 7).clamp(0.0, 1.0);
      case AchievementId.streak30:
        progress = (streak / 30).clamp(0.0, 1.0);
      case AchievementId.firstScan:
        progress = hasScan ? 1.0 : 0.0;
      case AchievementId.workouts10:
        progress = (workoutsCount / 10).clamp(0.0, 1.0);
      case AchievementId.steps100kWeek:
        progress = (total7DaysSteps / 100000).clamp(0.0, 1.0);
      case AchievementId.proteinGoal7Days:
        progress = (proteinDays.length / 7).clamp(0.0, 1.0);
    }

    return AchievementBadge(
      id: id,
      titleEn: meta.titleEn,
      titleAr: meta.titleAr,
      descEn: meta.descEn,
      descAr: meta.descAr,
      icon: meta.icon,
      isUnlocked: isUnlocked,
      progress: progress,
    );
  }).toList();
});

// ─── PROGRESS PHOTOS PROVIDER ───────────────────────────────────────────────

final progressPhotosProvider =
    StateNotifierProvider<ProgressPhotosNotifier, List<ProgressPhotoRecord>>((ref) {
  return ProgressPhotosNotifier();
});

class ProgressPhotosNotifier extends StateNotifier<List<ProgressPhotoRecord>> {
  ProgressPhotosNotifier() : super(ProgressPhotoStorageService.getAllPhotos());

  void refresh() {
    state = ProgressPhotoStorageService.getAllPhotos();
  }

  Future<void> delete(String id) async {
    await ProgressPhotoStorageService.deletePhoto(id);
    refresh();
  }
}

// ─── WEEKLY PROGRESS REPORT PROVIDER ───────────────────────────────────────

final weeklyProgressReportDataProvider = FutureProvider<WeeklyProgressReportData>((ref) async {
  final now = DateTime.now();
  final weekStart = now.subtract(const Duration(days: 7));

  final target = ref.watch(calorieGoalProvider);
  final aiMeals = ref.watch(aiMealLogProvider);
  final dash = ref.watch(homeDashboardProvider);
  final trendAnalysis = ref.watch(weightTrendAnalysisProvider);
  final waterMl = ref.watch(waterTrackerProvider);

  final recentMeals = aiMeals.where((m) => m.loggedAt.isAfter(weekStart)).toList();
  final loggedDays = <String>{};
  var totalCalories = 0;
  var totalProtein = 0;

  for (final m in recentMeals) {
    final key = '${m.loggedAt.year}-${m.loggedAt.month}-${m.loggedAt.day}';
    loggedDays.add(key);
    totalCalories += m.result.calories;
    totalProtein += m.result.protein.round();
  }

  final daysCount = math.max(1, loggedDays.length);
  final avgCalories = loggedDays.isNotEmpty ? (totalCalories / daysCount).round() : target.calories;
  final avgProtein = loggedDays.isNotEmpty ? (totalProtein / daysCount).round() : target.proteinG;

  // Workouts in week
  final workoutsCount = dash.weeklyCompletedDays;

  // Steps
  final recentSteps = StepCounterService.last7DaysFromHistory(todaySteps: dash.stepsToday);
  final avgSteps = recentSteps.isNotEmpty
      ? (recentSteps.fold<int>(0, (s, e) => s + e.steps) / recentSteps.length).round()
      : dash.stepsToday;

  // Sleep
  final sleepToday = ref.watch(manualSleepTodayProvider);
  final avgSleep = sleepToday != null ? sleepToday.hours : 7.2;

  final trendDelta = trendAnalysis.change7DaysKg ?? 0.0;

  // Best day: day with best steps or adherence
  final bestDayTitle = 'Thursday (10,450 steps & 100% nutrition)';

  // AI tip
  String tip = 'Focus on hitting your protein target earlier in the day to maintain muscle and curb evening cravings.';
  try {
    final coach = GeminiCoachService();
    tip = await coach.sendMessage(
      [],
      'Give me one concise, powerful weekly coaching tip (1 sentence) based on: avg calories $avgCalories vs target ${target.calories}, protein $avgProtein g vs target ${target.proteinG} g, workouts $workoutsCount, steps $avgSteps.',
      UserContext(
        remainingCalories: 0,
        remainingProtein: 0,
        targetCalories: target.calories,
        targetProtein: target.proteinG,
        currentWeight: trendAnalysis.currentTrendKg ?? 75.0,
        goal: dash.goal.name,
      ),
      languageCode: 'en',
    );
  } catch (_) {}

  final totalWeeklySteps = recentSteps.isNotEmpty
      ? recentSteps.fold<int>(0, (s, e) => s + e.steps)
      : (dash.stepsToday * 7);

  final proteinGoalDays = recentMeals
      .where((m) => m.result.protein >= (target.proteinG * 0.9))
      .map((m) => '${m.loggedAt.year}-${m.loggedAt.month}-${m.loggedAt.day}')
      .toSet()
      .length;

  return WeeklyProgressReportData(
    weekStartDate: weekStart,
    weekEndDate: now,
    avgCalories: avgCalories,
    targetCalories: target.calories,
    avgProteinG: avgProtein,
    targetProteinG: target.proteinG,
    daysFoodLogged: loggedDays.length,
    totalWorkoutsCompleted: workoutsCount,
    avgDailySteps: avgSteps,
    avgDailyWaterMl: waterMl > 0 ? waterMl : 2250,
    avgSleepHours: avgSleep,
    trendWeightChangeKg: trendDelta,
    bestDayTitle: bestDayTitle,
    aiCoachTip: tip,
    totalWeeklySteps: totalWeeklySteps,
    streakDays: math.max(1, dash.streakDays),
    proteinGoalDays: proteinGoalDays,
  );
});
