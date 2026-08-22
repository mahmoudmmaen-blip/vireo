import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/utils/date_utils.dart';
import 'package:vireo/data/models/app_auth_state.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';

class HomeDashboardSnapshot {
  const HomeDashboardSnapshot({
    required this.displayName,
    required this.programDay,
    required this.phaseName,
    required this.streakDays,
    required this.stepsToday,
    required this.stepsGoal,
    required this.weeklyCompletedDays,
    required this.recoveryScore,
    required this.showCheckIn,
  });

  final String displayName;
  final int programDay;
  final String phaseName;
  final int streakDays;
  final int stepsToday;
  final int stepsGoal;
  final int weeklyCompletedDays;
  final int recoveryScore;
  final bool showCheckIn;
}

final homeDashboardProvider = Provider<HomeDashboardSnapshot>((ref) {
  final auth = ref.watch(authProvider).valueOrNull;
  final isGuest = auth is AppAuthGuest;
  final dayIndex = DateUtilsVireo.todayDayIndex();

  // Demo-friendly dashboard data so guest/home never looks empty.
  return HomeDashboardSnapshot(
    displayName: isGuest
        ? 'بطل' // localized in UI via homeGuestName when guest
        : (auth is AppAuthAuthenticated ? (auth.user.email?.split('@').first ?? 'Vireo') : 'Vireo'),
    programDay: dayIndex + 1,
    phaseName: 'التأسيس',
    streakDays: isGuest ? 0 : 3,
    stepsToday: 4200,
    stepsGoal: 8000,
    weeklyCompletedDays: isGuest ? 2 : 4,
    recoveryScore: 85,
    showCheckIn: dayIndex % 7 == 0,
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
