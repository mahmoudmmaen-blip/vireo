import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/utils/program_generator.dart';
import 'package:vireo/core/utils/recovery_score_calculator.dart';
import 'package:vireo/data/models/app_auth_state.dart';
import 'package:vireo/data/models/fitness_goal.dart';
import 'package:vireo/data/repositories/workout_repository.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';
import 'package:vireo/features/nutrition/providers/confirmed_meals_provider.dart';
import 'package:vireo/features/onboarding/providers/onboarding_provider.dart';

class HomeDashboardSnapshot {
  const HomeDashboardSnapshot({
    required this.displayName,
    required this.programDay,
    required this.programTotalDays,
    required this.phaseName,
    required this.streakDays,
    required this.workoutsCompleted,
    required this.stepsToday,
    required this.stepsGoal,
    required this.weeklyCompletedDays,
    required this.recovery,
    required this.showCheckIn,
    required this.hasProgram,
    required this.goal,
  });

  final String displayName;
  final int programDay;
  final int programTotalDays;
  final String phaseName;
  final int streakDays;
  final int workoutsCompleted;
  final int stepsToday;
  final int stepsGoal;
  final int weeklyCompletedDays;
  final RecoveryBreakdown recovery;
  final bool showCheckIn;
  final bool hasProgram;
  final FitnessGoal goal;

  int get recoveryScore => recovery.totalScore;
}

final homeDashboardProvider = Provider<HomeDashboardSnapshot>((ref) {
  final auth = ref.watch(authProvider).valueOrNull;
  final isGuest = auth is AppAuthGuest;
  final onboardingComplete = ref.watch(onboardingCompleteProvider);
  final workoutProfile = ref.watch(workoutProfileProvider);
  final confirmed = ref.watch(confirmedMealsProvider);
  var start = WorkoutRepository.programStartFromHive();
  if (onboardingComplete && start == null) {
    start = DateTime.now().subtract(const Duration(days: 6));
  }
  final programDay = onboardingComplete
      ? ProgramGenerator.programDayFromStart(start)
      : 0;

  const stepsToday = 4200;
  const stepsGoal = 8000;
  final weeklyCompleted = isGuest ? 4 : 4;
  // Rest days in last 7 = days not completed as workouts (simplified).
  final weeklyRestDays = (7 - weeklyCompleted).clamp(0, 7);

  final recovery = RecoveryScoreCalculator.compute(
    weeklyRestDays: weeklyRestDays,
    stepsToday: stepsToday,
    stepsGoal: stepsGoal,
    mealsConfirmed: confirmed.length,
    mealsPlanned: 4,
    workoutsCompletedThisWeek: weeklyCompleted,
    workoutsPlannedThisWeek: 6,
  );

  return HomeDashboardSnapshot(
    displayName: isGuest
        ? 'بطل'
        : (auth is AppAuthAuthenticated
            ? (auth.user.email?.split('@').first ?? 'Vireo')
            : 'Vireo'),
    programDay: programDay,
    programTotalDays: ProgramGenerator.programLengthDays,
    phaseName: 'التأسيس',
    streakDays: isGuest ? 3 : 3,
    workoutsCompleted: isGuest ? 7 : 7,
    stepsToday: stepsToday,
    stepsGoal: stepsGoal,
    weeklyCompletedDays: weeklyCompleted,
    recovery: recovery,
    showCheckIn: programDay > 0 && programDay % 7 == 0,
    hasProgram: onboardingComplete && start != null,
    goal: workoutProfile.goal,
  );
});

/// Resolves localized display name.
String homeDisplayName(AppLocalizations l10n, HomeDashboardSnapshot dash, bool isGuest) {
  if (isGuest) return l10n.homeGuestName;
  return dash.displayName;
}

String homePhaseName(AppLocalizations l10n, HomeDashboardSnapshot dash, String locale) {
  if (locale == 'ar' && dash.phaseName == 'التأسيس') {
    return l10n.homePhaseFoundation;
  }
  return dash.phaseName;
}
