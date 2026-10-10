import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/data/repositories/workout_repository.dart';
import 'package:vireo/features/diet_programs/providers/diet_programs_provider.dart';
import 'package:vireo/features/home/domain/today_plan_item.dart';
import 'package:vireo/features/home/providers/today_plan_checks_provider.dart';
import 'package:vireo/features/nutrition/providers/confirmed_meals_provider.dart';
import 'package:vireo/features/nutrition/providers/demo_meal_overrides_provider.dart';
import 'package:vireo/features/notifications/providers/notification_settings_provider.dart';
import 'package:vireo/features/vitality/data/vitality_content_repository.dart';
import 'package:vireo/features/vitality/domain/vitality_models.dart';
import 'package:vireo/features/vitality/providers/vitality_provider.dart';
import 'package:vireo/features/walking/providers/live_steps_provider.dart';
import 'package:vireo/features/walking/providers/walking_tracker_provider.dart';
import 'package:vireo/features/water/providers/water_daily_goal_provider.dart';
import 'package:vireo/features/water/providers/water_tracker_provider.dart';

class TodayPlanSnapshot {
  const TodayPlanSnapshot({
    required this.items,
    required this.completedById,
    required this.completedCount,
    required this.totalCount,
    required this.progress,
    required this.nowItemId,
  });

  final List<TodayPlanItem> items;
  final Map<String, bool> completedById;
  final int completedCount;
  final int totalCount;
  final double progress;
  final String? nowItemId;

  bool isComplete(String id) => completedById[id] ?? false;
}

int _mealMinutes(MealType type) => switch (type) {
      MealType.breakfast => 8 * 60,
      MealType.lunch => 13 * 60,
      MealType.dinner => 19 * 60,
      MealType.snack => 16 * 60,
    };

int _minutesNow() {
  final n = DateTime.now();
  return n.hour * 60 + n.minute;
}

int _bedtimeMinutes() {
  if (HiveService.isInitialized) {
    final prefs = HiveService.settingsBox.get('notification_preferences');
    if (prefs is Map) {
      final iso = Map<String, dynamic>.from(prefs)['bedtime'] as String?;
      final dt = iso != null ? DateTime.tryParse(iso) : null;
      if (dt != null) return dt.hour * 60 + dt.minute;
    }
  }
  return 23 * 60;
}

int _workoutMinutes() {
  final tod = readPreferredWorkoutTimeFromProfile();
  if (tod != null) return tod.hour * 60 + tod.minute;
  if (HiveService.isInitialized) {
    final profile = HiveService.cacheBox.get('guest_profile');
    if (profile is Map) {
      final iso =
          Map<String, dynamic>.from(profile)['preferred_workout_time'] as String?;
      final dt = iso != null ? DateTime.tryParse(iso) : null;
      if (dt != null) return dt.hour * 60 + dt.minute;
    }
  }
  return 17 * 60;
}

List<int> _waterReminderMinutes(int count, {int wake = 7 * 60, int sleep = 22 * 60}) {
  if (count <= 0) return const [];
  if (count == 1) return [(wake + sleep) ~/ 2];
  final span = sleep - wake;
  return List.generate(count, (i) {
    final t = wake + ((i + 1) * span ~/ (count + 1));
    return t.clamp(wake, sleep);
  });
}

bool isTodayPlanItemComplete(
  TodayPlanItem item,
  Ref ref,
  Set<String> manualChecks,
) {
  switch (item.kind) {
    case TodayPlanKind.waterReminder:
      final idx = int.tryParse(item.id.replaceFirst('water_', '')) ?? 0;
      final ml = ref.watch(waterTrackerProvider);
      return ml >= (idx + 1) * waterGlassMl;
    case TodayPlanKind.meal:
      final type = item.mealType;
      if (type == null) return false;
      return ref.watch(confirmedMealsProvider).contains(type);
    case TodayPlanKind.fastingOpen:
    case TodayPlanKind.fastingClose:
      return manualChecks.contains(item.id);
    case TodayPlanKind.workout:
      return ref.watch(vitalityDailyLogProvider).workoutCompleted;
    case TodayPlanKind.steps:
      final goal = ref.watch(walkingContextProvider).valueOrNull?.dailyGoal ?? 6000;
      final steps = ref.watch(todayStepsProvider);
      return goal > 0 && steps >= goal;
    case TodayPlanKind.vitalitySleep:
      return ref.watch(vitalityDailyLogProvider).sleepGoalMet;
    case TodayPlanKind.vitalityProtein:
      return ref.watch(proteinGoalMetProvider);
    case TodayPlanKind.vitalitySun:
      return ref.watch(vitalityDailyLogProvider).sunlightDone;
    case TodayPlanKind.vitalityBreathing:
      return ref.watch(vitalityDailyLogProvider).breathingSessions > 0;
    case TodayPlanKind.vitalityZinc:
      return ref.watch(vitalityDailyLogProvider).zincVitDDone;
    case TodayPlanKind.sleepBedtime:
      return manualChecks.contains(item.id);
    case TodayPlanKind.protocolPro:
    case TodayPlanKind.aiSuggestionPro:
      return manualChecks.contains(item.id);
  }
}

typedef TodayPlanBuilder = TodayPlanSnapshot Function(
  AppLocalizations l10n,
  String locale,
);

final todayPlanProvider = Provider<TodayPlanBuilder>((ref) {
  ref.watch(waterDailyGoalMlProvider);
  ref.watch(waterGlassCountProvider);
  ref.watch(waterTrackerProvider);
  ref.watch(effectiveTodayMealsProvider);
  ref.watch(activeDietProgramProvider);
  ref.watch(fastingWindowStatusProvider);
  ref.watch(todayWorkoutProvider);
  ref.watch(todayPlanChecksProvider);
  ref.watch(todayStepsProvider);
  ref.watch(walkingContextProvider);
  ref.watch(vitalityDailyLogProvider);
  ref.watch(proteinGoalMetProvider);
  ref.watch(confirmedMealsProvider);

  final waterGoal = ref.read(waterDailyGoalMlProvider);
  final glassCount = ref.read(waterGlassCountProvider);
  final meals = ref.read(effectiveTodayMealsProvider).valueOrNull ?? const [];
  final activeDiet = ref.read(activeDietProgramProvider);
  final fasting = ref.read(fastingWindowStatusProvider);
  final workout = ref.read(todayWorkoutProvider).valueOrNull;
  final manualChecks = ref.read(todayPlanChecksProvider);
  final steps = ref.read(todayStepsProvider);
  final stepsGoal =
      ref.read(walkingContextProvider).valueOrNull?.dailyGoal ?? 6000;

  VitalityArticle? protocolArticle;
  final articles = const VitalityContentRepository().getArticles();
  for (final a in articles) {
    if (a.hasProtocol && a.id.contains('zinc')) {
      protocolArticle = a;
      break;
    }
  }
  if (protocolArticle == null) {
    for (final a in articles) {
      if (a.hasProtocol) {
        protocolArticle = a;
        break;
      }
    }
  }

  return (AppLocalizations l10n, String locale) {
    final items = <TodayPlanItem>[];
    final waterTimes = _waterReminderMinutes(glassCount);

    for (var i = 0; i < glassCount; i++) {
      items.add(
        TodayPlanItem(
          id: 'water_$i',
          kind: TodayPlanKind.waterReminder,
          minutesOfDay: waterTimes[i],
          icon: Icons.water_drop_outlined,
          title: l10n.todayPlanWaterReminder(i + 1, glassCount),
          subtitle: l10n.todayPlanWaterGoalLine(waterGoal),
          isPro: false,
          autoComplete: true,
        ),
      );
    }

    if (meals.isNotEmpty) {
      for (final entry in meals) {
        items.add(
          TodayPlanItem(
            id: 'meal_${entry.mealType.value}',
            kind: TodayPlanKind.meal,
            minutesOfDay: _mealMinutes(entry.mealType),
            icon: _mealIcon(entry.mealType),
            title: _mealTitle(l10n, entry.mealType),
            subtitle: entry.recipe.localizedTitle(locale),
            isPro: false,
            mealType: entry.mealType,
            autoComplete: true,
          ),
        );
      }
    } else if (activeDiet != null) {
      final sample = activeDiet.sampleDay;
      const types = [
        MealType.breakfast,
        MealType.lunch,
        MealType.snack,
        MealType.dinner,
      ];
      for (var i = 0; i < sample.length && i < types.length; i++) {
        final type = types[i];
        items.add(
          TodayPlanItem(
            id: 'meal_${type.value}',
            kind: TodayPlanKind.meal,
            minutesOfDay: _mealMinutes(type),
            icon: _mealIcon(type),
            title: _mealTitle(l10n, type),
            subtitle: sample[i].name.of(locale),
            isPro: false,
            mealType: type,
            autoComplete: true,
          ),
        );
      }
    }

    if (fasting != null && activeDiet?.window != null) {
      final openMin = fasting.startHour * 60;
      final closeMin =
          (fasting.startHour * 60 + fasting.eatingHours * 60) % (24 * 60);
      items.add(
        TodayPlanItem(
          id: 'fasting_open',
          kind: TodayPlanKind.fastingOpen,
          minutesOfDay: openMin,
          icon: Icons.restaurant_outlined,
          title: l10n.todayPlanFastingOpen,
          subtitle: l10n.todayPlanFastingOpenSubtitle(fasting.eatingHours),
          isPro: false,
        ),
      );
      items.add(
        TodayPlanItem(
          id: 'fasting_close',
          kind: TodayPlanKind.fastingClose,
          minutesOfDay: closeMin,
          icon: Icons.nightlight_round_outlined,
          title: l10n.todayPlanFastingClose,
          subtitle: l10n.todayPlanFastingCloseSubtitle(fasting.fastingHours),
          isPro: false,
        ),
      );
    }

    if (workout != null && workout.exercises.isNotEmpty) {
      items.add(
        TodayPlanItem(
          id: 'workout',
          kind: TodayPlanKind.workout,
          minutesOfDay: _workoutMinutes(),
          icon: Icons.fitness_center_outlined,
          title: l10n.todayPlanWorkout,
          subtitle: l10n.homeWorkoutExerciseCount(workout.exercises.length),
          isPro: false,
          autoComplete: true,
        ),
      );
    }

    items.add(
      TodayPlanItem(
        id: 'steps',
        kind: TodayPlanKind.steps,
        minutesOfDay: 12 * 60,
        icon: Icons.directions_walk_outlined,
        title: l10n.todayPlanSteps,
        subtitle: l10n.todayPlanStepsProgress(steps, stepsGoal),
        isPro: false,
        autoComplete: true,
      ),
    );

    items.addAll([
      TodayPlanItem(
        id: 'vitality_sleep',
        kind: TodayPlanKind.vitalitySleep,
        minutesOfDay: 7 * 60 + 30,
        icon: Icons.bedtime_outlined,
        title: l10n.vitalityCheckSleep,
        subtitle: l10n.todayPlanVitalitySleepSubtitle,
        isPro: false,
        autoComplete: true,
      ),
      TodayPlanItem(
        id: 'vitality_protein',
        kind: TodayPlanKind.vitalityProtein,
        minutesOfDay: 20 * 60,
        icon: Icons.egg_outlined,
        title: l10n.vitalityCheckProtein,
        subtitle: l10n.todayPlanVitalityProteinSubtitle,
        isPro: false,
        autoComplete: true,
      ),
      TodayPlanItem(
        id: 'vitality_sun',
        kind: TodayPlanKind.vitalitySun,
        minutesOfDay: 9 * 60,
        icon: Icons.wb_sunny_outlined,
        title: l10n.vitalityCheckSunlight,
        subtitle: l10n.todayPlanVitalitySunSubtitle,
        isPro: false,
        autoComplete: true,
      ),
      TodayPlanItem(
        id: 'vitality_breathing',
        kind: TodayPlanKind.vitalityBreathing,
        minutesOfDay: 15 * 60,
        icon: Icons.self_improvement_outlined,
        title: l10n.todayPlanVitalityStress,
        subtitle: l10n.todayPlanVitalityStressSubtitle,
        isPro: false,
        autoComplete: true,
      ),
      TodayPlanItem(
        id: 'vitality_zinc',
        kind: TodayPlanKind.vitalityZinc,
        minutesOfDay: 21 * 60,
        icon: Icons.medication_outlined,
        title: l10n.vitalityCheckZincVitD,
        subtitle: l10n.todayPlanVitalityZincSubtitle,
        isPro: false,
        autoComplete: true,
      ),
      TodayPlanItem(
        id: 'sleep_bedtime',
        kind: TodayPlanKind.sleepBedtime,
        minutesOfDay: _bedtimeMinutes(),
        icon: Icons.nights_stay_outlined,
        title: l10n.todayPlanSleepTarget,
        subtitle: l10n.todayPlanSleepTargetSubtitle,
        isPro: false,
      ),
    ]);

    if (protocolArticle != null) {
      items.add(
        TodayPlanItem(
          id: 'protocol_zinc',
          kind: TodayPlanKind.protocolPro,
          minutesOfDay: 10 * 60,
          icon: Icons.science_outlined,
          title: l10n.todayPlanProtocolItem,
          subtitle: protocolArticle.titleFor(locale),
          isPro: true,
        ),
      );
    }

    items.add(
      TodayPlanItem(
        id: 'ai_suggestion',
        kind: TodayPlanKind.aiSuggestionPro,
        minutesOfDay: 14 * 60,
        icon: Icons.auto_awesome_outlined,
        title: l10n.todayPlanAiSuggestion,
        subtitle: l10n.todayPlanAiSuggestionSubtitle,
        isPro: true,
      ),
    );

    items.sort((a, b) => a.minutesOfDay.compareTo(b.minutesOfDay));

    final completedById = <String, bool>{};
    for (final item in items) {
      completedById[item.id] =
          isTodayPlanItemComplete(item, ref, manualChecks);
    }
    final completed = completedById.values.where((v) => v).length;

    final now = _minutesNow();
    String? nowId;
    for (final item in items) {
      if (completedById[item.id] != true) {
        nowId = item.id;
        if (item.minutesOfDay >= now - 30) break;
      }
    }

    final total = items.length;
    return TodayPlanSnapshot(
      items: items,
      completedById: completedById,
      completedCount: completed,
      totalCount: total,
      progress: total > 0 ? completed / total : 0,
      nowItemId: nowId,
    );
  };
});

IconData _mealIcon(MealType type) => switch (type) {
      MealType.breakfast => Icons.free_breakfast_outlined,
      MealType.lunch => Icons.lunch_dining_outlined,
      MealType.dinner => Icons.dinner_dining_outlined,
      MealType.snack => Icons.cookie_outlined,
    };

String _mealTitle(AppLocalizations l10n, MealType type) => switch (type) {
      MealType.breakfast => l10n.nutritionTabBreakfast,
      MealType.lunch => l10n.nutritionTabLunch,
      MealType.dinner => l10n.nutritionTabDinner,
      MealType.snack => l10n.nutritionTabSnack,
    };
