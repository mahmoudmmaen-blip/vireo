import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/utils/program_generator.dart';
import 'package:vireo/data/models/app_auth_state.dart';
import 'package:vireo/data/repositories/workout_repository.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';
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
    required this.recoveryScore,
    required this.showCheckIn,
    required this.hasProgram,
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
  final int recoveryScore;
  final bool showCheckIn;
  final bool hasProgram;
}

final homeDashboardProvider = Provider<HomeDashboardSnapshot>((ref) {
  final auth = ref.watch(authProvider).valueOrNull;
  final isGuest = auth is AppAuthGuest;
  final onboardingComplete = ref.watch(onboardingCompleteProvider);
  var start = WorkoutRepository.programStartFromHive();
  if (onboardingComplete && start == null) {
    start = DateTime.now().subtract(const Duration(days: 6));
  }
  final programDay = onboardingComplete
      ? ProgramGenerator.programDayFromStart(start)
      : 0;

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
    stepsToday: 4200,
    stepsGoal: 8000,
    weeklyCompletedDays: isGuest ? 4 : 4,
    recoveryScore: 85,
    showCheckIn: programDay > 0 && programDay % 7 == 0,
    hasProgram: onboardingComplete && start != null,
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
