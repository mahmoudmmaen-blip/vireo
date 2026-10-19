import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/supabase_service.dart';
import 'package:vireo/core/utils/walking_goal_calculator.dart';
import 'package:vireo/data/models/activity_level.dart';
import 'package:vireo/data/models/daily_step_count.dart';
import 'package:vireo/features/walking/data/step_counter_service.dart';
import 'package:vireo/features/walking/data/steps_repository.dart';
import 'package:vireo/features/walking/providers/live_steps_provider.dart';

class WalkingContext {
  const WalkingContext({
    required this.activityLevel,
    required this.goalStartDate,
    this.customDailyGoal,
  });

  final ActivityLevel activityLevel;
  final DateTime goalStartDate;
  final int? customDailyGoal;

  int get dailyGoal {
    if (customDailyGoal != null && customDailyGoal! > 0) {
      return customDailyGoal!;
    }
    final goal = WalkingGoalCalculator.dailyGoal(
      activityLevel: activityLevel,
      goalStartDate: goalStartDate,
    );
    return goal > 0 ? goal : 7000;
  }
}

class WalkingTrackerState {
  const WalkingTrackerState({
    this.todaySteps = 0,
    this.dailyGoal = 6000,
    this.last7Days = const [],
    this.isRefreshing = false,
    this.manualEntryActive = false,
    this.permissionGranted = false,
    this.sensorAvailable = false,
  });

  final int todaySteps;
  final int dailyGoal;
  final List<DailyStepCount> last7Days;
  final bool isRefreshing;
  final bool manualEntryActive;
  final bool permissionGranted;
  final bool sensorAvailable;

  double get progress =>
      dailyGoal <= 0 ? 0 : (todaySteps / dailyGoal).clamp(0.0, 1.0);

  int get estimatedWalkingMinutes =>
      todaySteps <= 0 ? 0 : (todaySteps / 100).ceil();

  WalkingTrackerState copyWith({
    int? todaySteps,
    int? dailyGoal,
    List<DailyStepCount>? last7Days,
    bool? isRefreshing,
    bool? manualEntryActive,
    bool? permissionGranted,
    bool? sensorAvailable,
  }) {
    return WalkingTrackerState(
      todaySteps: todaySteps ?? this.todaySteps,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      last7Days: last7Days ?? this.last7Days,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      manualEntryActive: manualEntryActive ?? this.manualEntryActive,
      permissionGranted: permissionGranted ?? this.permissionGranted,
      sensorAvailable: sensorAvailable ?? this.sensorAvailable,
    );
  }
}

class WalkingTrackerNotifier extends AsyncNotifier<WalkingTrackerState> {
  static const _manualStepsKey = 'walking_manual_steps';
  static const _manualStepsDateKey = 'walking_manual_steps_date';

  @override
  Future<WalkingTrackerState> build() async {
    ref.watch(stepCounterBootstrapProvider);
    ref.listen<AsyncValue<LiveStepsSnapshot>>(liveStepsProvider, (_, next) {
      final snap = next.valueOrNull;
      if (snap == null) return;
      final current = state.valueOrNull;
      if (current == null) return;
      if (current.manualEntryActive && _readManualStepsForToday() != null) {
        return;
      }
      state = AsyncData(
        current.copyWith(
          todaySteps: snap.todaySteps,
          last7Days: snap.last7Days,
          permissionGranted: snap.permissionGranted,
          sensorAvailable: snap.sensorAvailable,
          isRefreshing: false,
        ),
      );
    });
    return _load();
  }

  Future<WalkingTrackerState> _load() async {
    final context = await ref.read(walkingContextProvider.future);
    final snap = ref.read(liveStepsProvider).valueOrNull ??
        StepCounterService.latest;
    final manual = _readManualStepsForToday();
    final manualActive = kIsWeb || !snap.sensorAvailable;

    var steps = snap.todaySteps;
    if (manualActive && manual != null) {
      steps = manual;
    }

    final last7 = snap.last7Days.isNotEmpty
        ? snap.last7Days
        : StepCounterService.last7DaysFromHistory(todaySteps: steps);

    return WalkingTrackerState(
      todaySteps: steps,
      dailyGoal: context.dailyGoal,
      last7Days: last7,
      manualEntryActive: manualActive,
      permissionGranted: snap.permissionGranted,
      sensorAvailable: snap.sensorAvailable,
    );
  }

  int? _readManualStepsForToday() {
    if (!HiveService.isInitialized) return null;
    try {
      final date = HiveService.settingsBox.get(_manualStepsDateKey) as String?;
      final today = DateTime.now().toIso8601String().substring(0, 10);
      if (date != today) return null;
      return HiveService.settingsBox.get(_manualStepsKey) as int?;
    } catch (_) {
      return null;
    }
  }

  Future<void> setManualSteps(int steps) async {
    final clamped = steps.clamp(0, 100000);
    if (HiveService.isInitialized) {
      await HiveService.settingsBox.put(_manualStepsKey, clamped);
      await HiveService.settingsBox.put(
        _manualStepsDateKey,
        DateTime.now().toIso8601String().substring(0, 10),
      );
    }
    // Push into StepsRepository so Home + Walk stay identical (P51).
    await StepsRepository.applyManualTodaySteps(clamped);

    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncData(
        current.copyWith(
          todaySteps: clamped,
          last7Days: StepCounterService.last7DaysFromHistory(
            todaySteps: clamped,
          ),
        ),
      );
    } else {
      await refresh();
    }
  }

  Future<void> setDailyGoal(int newGoal) async {
    final clamped = newGoal.clamp(1000, 50000);
    if (HiveService.isInitialized) {
      await HiveService.settingsBox.put('walking_custom_daily_goal', clamped);
    }
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncData(current.copyWith(dailyGoal: clamped));
    }
    ref.invalidate(walkingContextProvider);
  }

  Future<void> refresh() async {
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncData(current.copyWith(isRefreshing: true));
    }
    await StepCounterService.refresh();
    state = await AsyncValue.guard(_load);
  }
}

final walkingContextProvider = FutureProvider<WalkingContext>((ref) async {
  ActivityLevel activityLevel = ActivityLevel.moderatelyActive;
  DateTime goalStartDate = await _readGoalStartDate();

  try {
    if (SupabaseService.isInitialized) {
      final userId = SupabaseService.auth.currentUser?.id;
      if (userId != null) {
        final row = await SupabaseService.client
            .from('users')
            .select('activity_level, created_at')
            .eq('id', userId)
            .maybeSingle();
        if (row != null) {
          activityLevel = ActivityLevel.fromValue(
            row['activity_level'] as String? ?? 'moderately_active',
          );
          final createdAt = row['created_at'] as String?;
          if (createdAt != null) {
            goalStartDate = DateTime.parse(createdAt);
          }
        }
      }
    }
  } catch (_) {
    // Fall through to local profile.
  }

  final guestRow = HiveService.cacheBox.get('guest_profile');
  if (guestRow is Map) {
    final level = guestRow['activity_level'] as String?;
    if (level != null) {
      activityLevel = ActivityLevel.fromValue(level);
    }
  }

  int? customDailyGoal;
  if (HiveService.isInitialized) {
    customDailyGoal = HiveService.settingsBox.get('walking_custom_daily_goal') as int?;
  }

  return WalkingContext(
    activityLevel: activityLevel,
    goalStartDate: goalStartDate,
    customDailyGoal: customDailyGoal ?? 7000,
  );
});

Future<DateTime> _readGoalStartDate() async {
  final stored = HiveService.settingsBox.get(WalkingGoalCalculator.goalStartKey);
  if (stored is String) {
    try {
      return DateTime.parse(stored);
    } catch (_) {}
  }

  final onboardingComplete =
      HiveService.settingsBox.get('onboarding_complete', defaultValue: false);
  if (onboardingComplete == true) {
    final now = DateTime.now();
    await HiveService.settingsBox.put(
      WalkingGoalCalculator.goalStartKey,
      now.toIso8601String(),
    );
    return now;
  }

  return DateTime.now();
}

final walkingTrackerProvider =
    AsyncNotifierProvider<WalkingTrackerNotifier, WalkingTrackerState>(
  WalkingTrackerNotifier.new,
);
