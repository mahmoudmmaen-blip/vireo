import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/health_steps_service.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/supabase_service.dart';
import 'package:vireo/core/utils/walking_goal_calculator.dart';
import 'package:vireo/data/models/activity_level.dart';
import 'package:vireo/data/models/daily_step_count.dart';

class WalkingContext {
  const WalkingContext({
    required this.activityLevel,
    required this.goalStartDate,
  });

  final ActivityLevel activityLevel;
  final DateTime goalStartDate;

  int get dailyGoal => WalkingGoalCalculator.dailyGoal(
        activityLevel: activityLevel,
        goalStartDate: goalStartDate,
      );
}

class WalkingTrackerState {
  const WalkingTrackerState({
    required this.status,
    this.todaySteps = 0,
    this.dailyGoal = 7500,
    this.last7Days = const [],
    this.isRefreshing = false,
  });

  final HealthStepsStatus status;
  final int todaySteps;
  final int dailyGoal;
  final List<DailyStepCount> last7Days;
  final bool isRefreshing;

  double get progress =>
      dailyGoal <= 0 ? 0 : (todaySteps / dailyGoal).clamp(0.0, 1.0);

  WalkingTrackerState copyWith({
    HealthStepsStatus? status,
    int? todaySteps,
    int? dailyGoal,
    List<DailyStepCount>? last7Days,
    bool? isRefreshing,
  }) {
    return WalkingTrackerState(
      status: status ?? this.status,
      todaySteps: todaySteps ?? this.todaySteps,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      last7Days: last7Days ?? this.last7Days,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

class WalkingTrackerNotifier extends AsyncNotifier<WalkingTrackerState> {
  @override
  Future<WalkingTrackerState> build() async {
    return _load();
  }

  Future<WalkingTrackerState> _load() async {
    final context = await ref.read(walkingContextProvider.future);
    final snapshot = await HealthStepsService.fetchSnapshot();

    return WalkingTrackerState(
      status: snapshot.status,
      todaySteps: snapshot.todaySteps,
      dailyGoal: context.dailyGoal,
      last7Days: snapshot.last7Days,
    );
  }

  Future<void> refresh() async {
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncData(current.copyWith(isRefreshing: true));
    }
    state = await AsyncValue.guard(_load);
  }

  Future<void> requestPermission() async {
    await HealthStepsService.requestPermission();
    await refresh();
  }

  Future<void> openSettings() async {
    await HealthStepsService.openSystemSettings();
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

  return WalkingContext(
    activityLevel: activityLevel,
    goalStartDate: goalStartDate,
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
