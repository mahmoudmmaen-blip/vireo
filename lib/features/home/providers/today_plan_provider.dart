import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/data/repositories/workout_repository.dart';
import 'package:vireo/features/diet_programs/domain/cuisine_meal_catalog.dart';
import 'package:vireo/features/diet_programs/domain/cuisine_type.dart';
import 'package:vireo/features/home/domain/today_plan_item.dart';
import 'package:vireo/features/home/providers/today_plan_checks_provider.dart';
import 'package:vireo/features/notifications/providers/notification_settings_provider.dart';
import 'package:vireo/features/nutrition/providers/confirmed_meals_provider.dart';
import 'package:vireo/features/nutrition/providers/demo_meal_overrides_provider.dart';
import 'package:vireo/features/vitality/providers/vitality_provider.dart';
import 'package:vireo/features/walking/providers/live_steps_provider.dart';
import 'package:vireo/features/walking/providers/walking_tracker_provider.dart';
import 'package:vireo/features/water/providers/water_daily_goal_provider.dart';
import 'package:vireo/features/water/providers/water_tracker_provider.dart';
import 'package:vireo/features/ramadan/providers/ramadan_settings_provider.dart';

class TodayPlanSnapshot {
  const TodayPlanSnapshot({
    required this.items,
    required this.completedById,
    required this.completedCount,
    required this.totalCount,
    required this.progress,
    required this.nowItemId,
    this.waterItem,
  });

  final List<TodayPlanItem> items;
  final Map<String, bool> completedById;
  final int completedCount;
  final int totalCount;
  final double progress;
  final String? nowItemId;
  final TodayPlanItem? waterItem;

  bool isComplete(String id) => completedById[id] ?? false;

  List<TodayPlanItem> itemsForSection(TodayPlanSectionKind section) =>
      items.where((it) => it.section == section).toList();
}

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
  return 22 * 60 + 30; // 10:30 PM
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
  return 16 * 60; // 4:00 PM
}

bool isTodayPlanItemComplete(
  TodayPlanItem item,
  Ref ref,
  Set<String> manualChecks,
) {
  if (manualChecks.contains(item.id)) return true;

  switch (item.kind) {
    case TodayPlanKind.waterReminder:
      final ml = ref.watch(waterTrackerProvider);
      final goal = ref.watch(waterDailyGoalMlProvider);
      return goal > 0 && ml >= goal;
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
      return ref.watch(vitalityDailyLogProvider).sleepGoalMet;
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
  ref.watch(waterTrackerProvider);
  ref.watch(effectiveTodayMealsProvider);
  ref.watch(todayWorkoutProvider);
  ref.watch(todayPlanChecksProvider);
  ref.watch(todayStepsProvider);
  ref.watch(walkingContextProvider);
  ref.watch(vitalityDailyLogProvider);
  ref.watch(proteinGoalMetProvider);
  ref.watch(confirmedMealsProvider);
  final cuisine = ref.watch(cuisineProvider);

  final waterGoal = ref.read(waterDailyGoalMlProvider);
  final waterMl = ref.read(waterTrackerProvider);
  final meals = ref.read(effectiveTodayMealsProvider).valueOrNull ?? const [];
  final workout = ref.read(todayWorkoutProvider).valueOrNull;
  final manualChecks = ref.read(todayPlanChecksProvider);
  final steps = ref.read(todayStepsProvider);
  final stepsGoal =
      ref.read(walkingContextProvider).valueOrNull?.dailyGoal ?? 6000;

  return (AppLocalizations l10n, String locale) {
    // 1. Single collapsed water card / item
    final waterRatio = waterGoal > 0 ? (waterMl / waterGoal).clamp(0.0, 1.0) : 0.0;
    final curL = (waterMl / 1000.0).toStringAsFixed(1);
    final goalL = (waterGoal / 1000.0).toStringAsFixed(1);
    final waterProgressStr = l10n.todayPlanWaterProgress(curL, goalL);

    final isRamadan = ref.watch(ramadanSettingsProvider).isEnabled;
    final prayer = ref.watch(ramadanPrayerTimesProvider);

    final waterSubtitle = isRamadan
        ? (locale.startsWith('ar')
            ? '$waterProgressStr (موزعة بين الإفطار والسحور)'
            : '$waterProgressStr (split: iftar & suhoor)')
        : waterProgressStr;

    final waterItem = TodayPlanItem(
      id: 'water_summary',
      kind: TodayPlanKind.waterReminder,
      minutesOfDay: isRamadan ? (18 * 60) : (8 * 60),
      icon: Icons.water_drop_rounded,
      title: l10n.planRevealHydration,
      subtitle: waterSubtitle,
      isPro: false,
      section: isRamadan ? TodayPlanSectionKind.evening : TodayPlanSectionKind.morning,
      progress: waterRatio,
      progressLabel: waterProgressStr,
      quickActionLabel: l10n.todayPlanWaterQuickAdd,
      autoComplete: true,
    );

    // Helper to resolve dish subtitle per meal type
    String dishSubtitle(MealType type) {
      if (isRamadan) {
        final slot = switch (type) {
          MealType.breakfast => 'suhoor',
          MealType.lunch || MealType.dinner => 'iftar',
          MealType.snack => 'snack',
        };
        return CuisineMealCatalog.sampleRamadanDishName(
          cuisine: cuisine,
          slot: slot,
          locale: locale,
        );
      }
      final logged = meals.where((m) => m.mealType == type).firstOrNull;
      if (logged != null) {
        return logged.recipe.localizedTitle(locale);
      }
      return CuisineMealCatalog.sampleDishName(
        cuisine: cuisine,
        type: type,
        locale: locale,
      );
    }

    // 2. Sections: Morning, Afternoon, Evening (~8 items max)
    final items = <TodayPlanItem>[];

    if (isRamadan && prayer != null) {
      final suhoorMinutes = prayer.fajr.hour * 60 + prayer.fajr.minute - 60; // 1h before Fajr
      final iftarMinutes = prayer.maghrib.hour * 60 + prayer.maghrib.minute;
      final workoutMinutes = iftarMinutes + 75; // 75 min after iftar

      items.addAll([
        // Suhoor (Dawn)
        TodayPlanItem(
          id: 'meal_suhoor',
          kind: TodayPlanKind.meal,
          minutesOfDay: suhoorMinutes.clamp(180, 360),
          icon: Icons.nightlight_round,
          title: locale.startsWith('ar') ? 'سحور مبارك' : 'Suhoor',
          subtitle: dishSubtitle(MealType.breakfast),
          isPro: false,
          mealType: MealType.breakfast,
          section: TodayPlanSectionKind.morning,
          autoComplete: true,
        ),
        // Afternoon Light Walk / Steps
        TodayPlanItem(
          id: 'steps',
          kind: TodayPlanKind.steps,
          minutesOfDay: (iftarMinutes - 45).clamp(900, 1140),
          icon: Icons.directions_walk_rounded,
          title: locale.startsWith('ar') ? 'مشي خفيف قبل الإفطار' : 'Pre-Iftar Light Walk',
          subtitle: l10n.todayPlanStepsProgress(steps, stepsGoal),
          isPro: false,
          section: TodayPlanSectionKind.afternoon,
          autoComplete: true,
        ),
        // Iftar (Evening)
        TodayPlanItem(
          id: 'meal_iftar',
          kind: TodayPlanKind.meal,
          minutesOfDay: iftarMinutes,
          icon: Icons.wb_twilight_rounded,
          title: locale.startsWith('ar') ? 'إفطار هنيء' : 'Iftar Meal',
          subtitle: dishSubtitle(MealType.lunch),
          isPro: false,
          mealType: MealType.lunch,
          section: TodayPlanSectionKind.evening,
          autoComplete: true,
        ),
        // Workout post-Iftar
        TodayPlanItem(
          id: 'workout',
          kind: TodayPlanKind.workout,
          minutesOfDay: workoutMinutes.clamp(1140, 1380),
          icon: Icons.fitness_center_rounded,
          title: locale.startsWith('ar') ? 'تمرين ما بعد الإفطار' : 'Post-Iftar Workout',
          subtitle: workout != null && workout.exercises.isNotEmpty
              ? '${workout.exercises.first.localizedName(locale)} · ${l10n.homeWorkoutExerciseCount(workout.exercises.length)}'
              : (locale.startsWith('ar') ? 'توقيت مثالي لتجديد الطاقة والنشاط' : 'Optimal timing for energy and hydration'),
          isPro: false,
          section: TodayPlanSectionKind.evening,
          autoComplete: true,
        ),
        // Post-Iftar snack
        TodayPlanItem(
          id: 'meal_snack',
          kind: TodayPlanKind.meal,
          minutesOfDay: (workoutMinutes + 60).clamp(1200, 1410),
          icon: Icons.cookie_outlined,
          title: locale.startsWith('ar') ? 'سناك بعد الفطار' : 'Post-Iftar Snack',
          subtitle: dishSubtitle(MealType.snack),
          isPro: false,
          mealType: MealType.snack,
          section: TodayPlanSectionKind.evening,
          autoComplete: true,
        ),
      ]);
    } else {
      items.addAll([
        // ── MORNING (صباحاً) ──
        TodayPlanItem(
          id: 'vitality_sun',
          kind: TodayPlanKind.vitalitySun,
          minutesOfDay: 7 * 60 + 30,
          icon: Icons.wb_sunny_rounded,
          title: l10n.vitalityCheckSunlight,
          subtitle: l10n.todayPlanVitalitySunSubtitle,
          isPro: false,
          section: TodayPlanSectionKind.morning,
          autoComplete: true,
        ),
        TodayPlanItem(
          id: 'meal_breakfast',
          kind: TodayPlanKind.meal,
          minutesOfDay: 8 * 60 + 30,
          icon: _mealIcon(MealType.breakfast),
          title: _mealTitle(l10n, MealType.breakfast),
          subtitle: dishSubtitle(MealType.breakfast),
          isPro: false,
          mealType: MealType.breakfast,
          section: TodayPlanSectionKind.morning,
          autoComplete: true,
        ),

        // ── AFTERNOON (الظهر) ──
        TodayPlanItem(
          id: 'meal_lunch',
          kind: TodayPlanKind.meal,
          minutesOfDay: 13 * 60,
          icon: _mealIcon(MealType.lunch),
          title: _mealTitle(l10n, MealType.lunch),
          subtitle: dishSubtitle(MealType.lunch),
          isPro: false,
          mealType: MealType.lunch,
          section: TodayPlanSectionKind.afternoon,
          autoComplete: true,
        ),
        TodayPlanItem(
          id: 'workout',
          kind: TodayPlanKind.workout,
          minutesOfDay: _workoutMinutes(),
          icon: Icons.fitness_center_rounded,
          title: l10n.todayPlanWorkout,
          subtitle: workout != null && workout.exercises.isNotEmpty
              ? '${workout.exercises.first.localizedName(locale)} · ${l10n.homeWorkoutExerciseCount(workout.exercises.length)}'
              : l10n.homeWorkoutExerciseCount(5),
          isPro: false,
          section: TodayPlanSectionKind.afternoon,
          autoComplete: true,
        ),
        TodayPlanItem(
          id: 'steps',
          kind: TodayPlanKind.steps,
          minutesOfDay: 15 * 60,
          icon: Icons.directions_walk_rounded,
          title: l10n.todayPlanSteps,
          subtitle: l10n.todayPlanStepsProgress(steps, stepsGoal),
          isPro: false,
          section: TodayPlanSectionKind.afternoon,
          autoComplete: true,
        ),

        // ── EVENING (المساء) ──
        TodayPlanItem(
          id: 'meal_dinner',
          kind: TodayPlanKind.meal,
          minutesOfDay: 19 * 60,
          icon: _mealIcon(MealType.dinner),
          title: _mealTitle(l10n, MealType.dinner),
          subtitle: dishSubtitle(MealType.dinner),
          isPro: false,
          mealType: MealType.dinner,
          section: TodayPlanSectionKind.evening,
          autoComplete: true,
        ),
      ]);
    }
    items.addAll([
      TodayPlanItem(
        id: 'vitality_protein',
        kind: TodayPlanKind.vitalityProtein,
        minutesOfDay: 20 * 60,
        icon: Icons.egg_rounded,
        title: l10n.vitalityCheckProtein,
        subtitle: l10n.todayPlanVitalityProteinSubtitle,
        isPro: false,
        section: TodayPlanSectionKind.evening,
        autoComplete: true,
      ),
      TodayPlanItem(
        id: 'vitality_breathing',
        kind: TodayPlanKind.vitalityBreathing,
        minutesOfDay: 21 * 60,
        icon: Icons.self_improvement_rounded,
        title: l10n.todayPlanBreathingAction,
        subtitle: l10n.todayPlanVitalityStressSubtitle,
        isPro: false,
        section: TodayPlanSectionKind.evening,
        autoComplete: true,
      ),
      TodayPlanItem(
        id: 'vitality_sleep',
        kind: TodayPlanKind.vitalitySleep,
        minutesOfDay: _bedtimeMinutes(),
        icon: Icons.bedtime_rounded,
        title: l10n.vitalityCheckSleep,
        subtitle: l10n.todayPlanVitalitySleepSubtitle,
        isPro: false,
        section: TodayPlanSectionKind.evening,
        autoComplete: true,
      ),
    ]);

    items.sort((a, b) => a.minutesOfDay.compareTo(b.minutesOfDay));

    final completedById = <String, bool>{};
    for (final item in items) {
      completedById[item.id] = isTodayPlanItemComplete(item, ref, manualChecks);
    }
    completedById[waterItem.id] = isTodayPlanItemComplete(waterItem, ref, manualChecks);

    final completed = completedById.values.where((v) => v).length;
    final total = items.length + 1; // including water summary

    final now = _minutesNow();
    String? nowId;
    for (final item in items) {
      if (completedById[item.id] != true) {
        nowId = item.id;
        if (item.minutesOfDay >= now - 30) break;
      }
    }

    return TodayPlanSnapshot(
      items: items,
      completedById: completedById,
      completedCount: completed,
      totalCount: total,
      progress: total > 0 ? completed / total : 0,
      nowItemId: nowId,
      waterItem: waterItem,
    );
  };
});

IconData _mealIcon(MealType type) => switch (type) {
      MealType.breakfast => Icons.free_breakfast_rounded,
      MealType.lunch => Icons.lunch_dining_rounded,
      MealType.dinner => Icons.dinner_dining_rounded,
      MealType.snack => Icons.cookie_rounded,
    };

String _mealTitle(AppLocalizations l10n, MealType type) => switch (type) {
      MealType.breakfast => l10n.nutritionTabBreakfast,
      MealType.lunch => l10n.nutritionTabLunch,
      MealType.dinner => l10n.nutritionTabDinner,
      MealType.snack => l10n.nutritionTabSnack,
    };
