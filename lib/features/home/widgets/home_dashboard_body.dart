import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/shell_navigation_provider.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/theme/vireo_decorations.dart';
import 'package:vireo/core/theme/vireo_scroll_behavior.dart';
import 'package:vireo/data/models/app_auth_state.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/features/ai_nutrition/widgets/quick_ai_scanner_card.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';
import 'package:vireo/features/auth/widgets/guest_auth_gate.dart';
import 'package:vireo/features/cardio/providers/cardio_log_provider.dart';
import 'package:vireo/features/cardio/screens/cardio_activity_screen.dart';
import 'package:vireo/features/home/providers/home_dashboard_provider.dart';
import 'package:vireo/features/home/widgets/recovery_breakdown_sheet.dart';
import 'package:vireo/features/nutrition/providers/confirmed_meals_provider.dart';
import 'package:vireo/features/nutrition/providers/demo_meal_overrides_provider.dart';
import 'package:vireo/features/progress/providers/weekly_checkin_provider.dart';
import 'package:vireo/features/progress/screens/weekly_checkin_screen.dart';
import 'package:vireo/features/walking/walking_tracker_screen.dart';
import 'package:vireo/features/workout/screens/workout_flow_screen.dart';
import 'package:vireo/data/repositories/workout_repository.dart';

class HomeDashboardBody extends ConsumerWidget {
  const HomeDashboardBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final locale = Localizations.localeOf(context).languageCode;
    final auth = ref.watch(authProvider).valueOrNull;
    final isGuest = auth is AppAuthGuest;
    final dash = ref.watch(homeDashboardProvider);
    final workoutAsync = ref.watch(todayWorkoutProvider);
    final mealsAsync = ref.watch(effectiveTodayMealsProvider);
    final confirmed = ref.watch(confirmedMealsProvider);
    final weeklyDue = ref.watch(weeklyCheckInDueProvider);
    final cardioToday = ref.watch(todayCardioCaloriesProvider);

    return NoScrollbarScrollConfiguration(
      child: ListView(
        primary: false,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
        Text(
          l10n.homeGreeting(homeDisplayName(l10n, dash, isGuest)),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 4),
        Text(
          dash.hasProgram
              ? l10n.homeProgramDay(dash.programDay, dash.programTotalDays)
              : l10n.homeDayPhase(dash.programDay, homePhaseName(l10n, dash, locale)),
          style: TextStyle(color: colors.textMute),
        ),
        const SizedBox(height: 16),
        const QuickAiScannerCard(),
        if (isGuest) ...[
          _GuestBanner(
            onSignUp: () => requireAccountAccess(
              context,
              ref,
              reason: AuthGateReason.saveProgress,
            ),
          ),
          const SizedBox(height: 12),
        ],
        _StreakCard(streakDays: dash.streakDays),
        const SizedBox(height: 12),
        workoutAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => const SizedBox.shrink(),
          data: (session) {
            if (!dash.hasProgram) {
              return _StartProgramCard(
                onStart: () {
                  // Navigate to onboarding or workout tab — user completes onboarding first.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.homeStartProgram)),
                  );
                },
              );
            }
            if (session.exercises.isEmpty) {
              return _RestDayCard();
            }
            final lead = session.exercises.first;
            return _WorkoutHeroCard(
              title: lead.localizedName(locale),
              exerciseCount: session.exercises.length,
              onStart: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const WorkoutFlowScreen(),
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(height: 12),
        mealsAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
          data: (meals) {
            final breakfast = meals
                .where((m) => m.mealType == MealType.breakfast)
                .firstOrNull;
            return _QuickStatsRow(
              mealTitle: breakfast?.recipe.localizedTitle(locale) ?? '—',
              mealConfirmed: confirmed.contains(MealType.breakfast),
              stepsCurrent: dash.stepsToday,
              stepsGoal: dash.stepsGoal,
              onBreakfastTap: () {
                ref.read(shellTabIndexProvider.notifier).goNutrition(
                      mealTab: MealType.breakfast,
                    );
              },
              onWalkingTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const WalkingTrackerScreen(),
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(height: 12),
        _WeeklyProgressRow(completedDays: dash.weeklyCompletedDays),
        if (dash.showCheckIn || weeklyDue) ...[
          const SizedBox(height: 12),
          _CheckInBanner(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const WeeklyCheckInScreen(),
                ),
              );
            },
          ),
        ],
        const SizedBox(height: 12),
        _RecoveryScoreCard(
          score: dash.recoveryScore,
          onInfo: () => showRecoveryBreakdownSheet(context, dash.recovery),
        ),
        const SizedBox(height: 12),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const CardioActivityScreen(),
                ),
              );
            },
            borderRadius: BorderRadius.circular(VireoDecorations.cardRadius),
            child: Ink(
              padding: const EdgeInsets.all(14),
              decoration: VireoDecorations.premiumCard(colors),
              child: Row(
                children: [
                  Icon(Icons.directions_run, color: colors.ember),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.cardioTitle,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.cardioTodayTotal(cardioToday),
                          style: TextStyle(color: colors.textMute, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: colors.textMute),
                ],
              ),
            ),
          ),
        ),
        if (isGuest) ...[
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => requireAccountAccess(
              context,
              ref,
              reason: AuthGateReason.saveProgress,
            ),
            child: Text(l10n.homeGuestCta),
          ),
        ],
      ],
      ),
    );
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull {
    final it = iterator;
    return it.moveNext() ? it.current : null;
  }
}

class _GuestBanner extends StatelessWidget {
  const _GuestBanner({required this.onSignUp});

  final VoidCallback onSignUp;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.ember.withValues(alpha: 0.25), colors.surfaceRaised],
        ),
        borderRadius: BorderRadius.circular(VireoDecorations.cardRadius),
        border: Border.all(color: colors.ember.withValues(alpha: 0.4)),
        boxShadow: VireoDecorations.cardShadow(glow: colors.ember),
      ),
      child: Row(
        children: [
          Expanded(child: Text(l10n.homeGuestBanner)),
          const SizedBox(width: 8),
          FilledButton(onPressed: onSignUp, child: Text(l10n.homeGuestSignUp)),
        ],
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  const _StreakCard({required this.streakDays});

  final int streakDays;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final label = streakDays > 0
        ? l10n.homeStreakDays(streakDays)
        : l10n.homeStartStreak;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: VireoDecorations.premiumCard(colors),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_fire_department, color: colors.ember),
              const SizedBox(width: 8),
              Text(label, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: streakDays > 0 ? (streakDays / 7).clamp(0.0, 1.0) : 0.05,
              backgroundColor: colors.line,
              valueColor: AlwaysStoppedAnimation<Color>(colors.ember),
            ),
          ),
          const SizedBox(height: 6),
          ShaderMask(
            shaderCallback: (bounds) =>
                VireoDecorations.streakGradient.createShader(bounds),
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: VireoDecorations.streakGradient,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StartProgramCard extends StatelessWidget {
  const _StartProgramCard({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: VireoDecorations.premiumCard(colors),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.homeStartProgram,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: onStart, child: Text(l10n.homeStartProgram)),
        ],
      ),
    );
  }
}

class _WorkoutHeroCard extends StatelessWidget {
  const _WorkoutHeroCard({
    required this.title,
    required this.exerciseCount,
    required this.onStart,
  });

  final String title;
  final int exerciseCount;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: VireoDecorations.emberGradient,
        borderRadius: BorderRadius.circular(VireoDecorations.cardRadius),
        boxShadow: VireoDecorations.cardShadow(glow: colors.ember),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.homeTodayWorkoutTitle,
            style: TextStyle(color: colors.text.withValues(alpha: 0.9)),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: colors.text,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.homeWorkoutExerciseCount(exerciseCount),
            style: TextStyle(color: colors.text.withValues(alpha: 0.85)),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onStart,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.background,
                foregroundColor: colors.text,
              ),
              child: Text(l10n.homeStartWorkout),
            ),
          ),
        ],
      ),
    );
  }
}

class _RestDayCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: VireoDecorations.premiumCard(colors, glow: true),
      child: Text(
        l10n.homeRestDay,
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _QuickStatsRow extends StatelessWidget {
  const _QuickStatsRow({
    required this.mealTitle,
    required this.mealConfirmed,
    required this.stepsCurrent,
    required this.stepsGoal,
    required this.onBreakfastTap,
    required this.onWalkingTap,
  });

  final String mealTitle;
  final bool mealConfirmed;
  final int stepsCurrent;
  final int stepsGoal;
  final VoidCallback onBreakfastTap;
  final VoidCallback onWalkingTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final stepRatio = stepsGoal > 0 ? stepsCurrent / stepsGoal : 0.0;

    return Row(
      children: [
        Expanded(
          child: _MiniStatCard(
            icon: Icons.free_breakfast_outlined,
            title: l10n.homeBreakfast,
            subtitle: mealTitle,
            badge: mealConfirmed ? l10n.homeMealConfirmed : l10n.homeMealPending,
            badgeColor: mealConfirmed ? colors.success : colors.gold,
            onTap: onBreakfastTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MiniStatCard(
            icon: Icons.directions_walk_outlined,
            title: l10n.walkingTitle,
            subtitle: l10n.homeWalkingSteps(stepsCurrent, stepsGoal),
            badge: '${(stepRatio * 100).round()}%',
            badgeColor: colors.recovery,
            onTap: onWalkingTap,
          ),
        ),
      ],
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  const _MiniStatCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.badgeColor,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String badge;
  final Color badgeColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(VireoDecorations.cardRadius),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: VireoDecorations.premiumCard(colors),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: colors.ember, size: 22),
                  const Spacer(),
                  if (onTap != null)
                    Icon(Icons.chevron_right, size: 18, color: colors.textMute),
                ],
              ),
              const SizedBox(height: 8),
              Text(title, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 4),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: colors.textMute, fontSize: 12),
              ),
              const SizedBox(height: 6),
              Text(
                badge,
                style: TextStyle(color: badgeColor, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeeklyProgressRow extends StatelessWidget {
  const _WeeklyProgressRow({required this.completedDays});

  final int completedDays;

  static const _daysAr = ['س', 'ح', 'ن', 'ث', 'ر', 'خ', 'ج'];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final todayIndex = DateTime.now().weekday % 7;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: VireoDecorations.premiumCard(colors),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final done = index < completedDays;
              final isToday = index == todayIndex;
              return Column(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: done
                          ? colors.ember
                          : colors.surface.withValues(alpha: 0.8),
                      border: isToday
                          ? Border.all(color: colors.gold, width: 2)
                          : null,
                      boxShadow: done
                          ? [BoxShadow(color: colors.ember.withValues(alpha: 0.35), blurRadius: 8)]
                          : null,
                    ),
                    child: done
                        ? Icon(Icons.check, size: 18, color: colors.text)
                        : Center(
                            child: Text(
                              _daysAr[index],
                              style: TextStyle(
                                color: colors.textMute,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.homeWeeklyProgress(completedDays),
            style: TextStyle(color: colors.textMute),
          ),
        ],
      ),
    );
  }
}

class _CheckInBanner extends StatelessWidget {
  const _CheckInBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(VireoDecorations.cardRadius),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors.ember.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(VireoDecorations.cardRadius),
            border: Border.all(color: colors.ember.withValues(alpha: 0.35)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l10n.weeklyCheckInBanner,
                  style: TextStyle(color: colors.ember, fontWeight: FontWeight.w600),
                ),
              ),
              Icon(Icons.chevron_right, color: colors.ember),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecoveryScoreCard extends StatelessWidget {
  const _RecoveryScoreCard({required this.score, required this.onInfo});

  final int score;
  final VoidCallback onInfo;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onInfo,
        borderRadius: BorderRadius.circular(VireoDecorations.cardRadius),
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colors.recovery.withValues(alpha: 0.35),
                colors.success.withValues(alpha: 0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(VireoDecorations.cardRadius),
            border: Border.all(color: colors.recovery.withValues(alpha: 0.45)),
            boxShadow: VireoDecorations.cardShadow(),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          l10n.homeRecoveryScore,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(width: 6),
                        Icon(Icons.info_outline, size: 18, color: colors.textMute),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.homeRecoveryReady,
                      style: TextStyle(color: colors.textMute),
                    ),
                  ],
                ),
              ),
              Text(
                '$score%',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: colors.success,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
