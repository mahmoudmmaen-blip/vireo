import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/utils/program_generator.dart';
import 'package:vireo/core/widgets/feature_scaffold.dart';
import 'package:vireo/data/models/fitness_goal.dart';
import 'package:vireo/data/repositories/workout_repository.dart';
import 'package:vireo/features/cardio/screens/cardio_activity_screen.dart';
import 'package:vireo/features/subscription/premium_access.dart';
import 'package:vireo/features/subscription/providers/subscription_provider.dart';
import 'package:vireo/features/subscription/screens/paywall_screen.dart';
import 'package:vireo/features/workout/providers/workout_flow_provider.dart';
import 'package:vireo/features/workout/screens/workout_flow_screen.dart';

class WorkoutScreen extends ConsumerWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final sessionAsync = ref.watch(todayWorkoutProvider);
    final subAsync = ref.watch(subscriptionProvider);
    final phaseAsync = ref.watch(userProgramPhaseProvider);
    final profile = ref.watch(workoutProfileProvider);
    final colors = context.vireoColors;
    final splitKey = ProgramGenerator.splitLabelKeyForToday(goal: profile.goal);

    return FeatureScaffold(
      title: l10n.workoutTitle,
      actions: [
        IconButton(
          tooltip: l10n.cardioTitle,
          icon: const Icon(Icons.directions_run),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CardioActivityScreen()),
          ),
        ),
      ],
      body: sessionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.authErrorGeneric)),
        data: (session) {
          final sub = subAsync.valueOrNull;
          final phase = phaseAsync.valueOrNull ?? 1;
          final lockedPhases =
              sub != null && !sub.canAccessFullProgramPhases && phase > 1;

          if (lockedPhases) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.lock, size: 56, color: colors.gold),
                  const SizedBox(height: 16),
                  Text(
                    l10n.workoutPhaseLockedTitle(phase),
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.workoutPhaseLockedBody,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colors.textMute),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () => openPaywall(
                      context,
                      paywallContext: paywallContextForSnapshot(sub),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                    ),
                    child: Text(l10n.subscriptionUpgrade),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.workoutTodayTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.workoutGoalPlanLabel(_goalLabel(l10n, profile.goal)),
                  style: TextStyle(color: colors.ember, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  _splitLabel(l10n, splitKey),
                  style: TextStyle(color: colors.textMute),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.workoutTodaySubtitle(session.exercises.length),
                  style: TextStyle(color: colors.textMute),
                ),
                const SizedBox(height: 24),
                Card(
                  color: colors.surfaceRaised,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.workoutWarmUpTitle,
                            style: Theme.of(context).textTheme.titleSmall),
                        Text(
                          l10n.workoutPhaseCount(session.warmUp.length),
                          style: TextStyle(color: colors.textMute),
                        ),
                        const SizedBox(height: 8),
                        Text(l10n.workoutActiveTitle,
                            style: Theme.of(context).textTheme.titleSmall),
                        Text(
                          l10n.workoutPhaseCount(session.exercises.length),
                          style: TextStyle(color: colors.textMute),
                        ),
                        const SizedBox(height: 8),
                        Text(l10n.workoutCoolDownTitle,
                            style: Theme.of(context).textTheme.titleSmall),
                        Text(
                          l10n.workoutPhaseCount(session.coolDown.length),
                          style: TextStyle(color: colors.textMute),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CardioActivityScreen()),
                  ),
                  icon: const Icon(Icons.directions_run),
                  label: Text(l10n.cardioLogCta),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    ref.read(workoutFlowProvider.notifier).startSession(session);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const WorkoutFlowScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                  child: Text(l10n.workoutStartButton),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _goalLabel(AppLocalizations l10n, FitnessGoal goal) => switch (goal) {
        FitnessGoal.weightLoss => l10n.goalWeightLoss,
        FitnessGoal.muscleGain => l10n.goalMuscleGain,
        FitnessGoal.generalVitality => l10n.goalGeneralVitality,
        FitnessGoal.allOfAbove => l10n.goalAllOfAbove,
      };

  String _splitLabel(AppLocalizations l10n, String key) => switch (key) {
        'workoutSplitChestTriceps' => l10n.workoutSplitChestTriceps,
        'workoutSplitBackBiceps' => l10n.workoutSplitBackBiceps,
        'workoutSplitLegs' => l10n.workoutSplitLegs,
        'workoutSplitCardio' => l10n.workoutSplitCardio,
        'workoutSplitShoulders' => l10n.workoutSplitShoulders,
        'workoutSplitFullBody' => l10n.workoutSplitFullBody,
        'workoutSplitRest' => l10n.workoutSplitRest,
        _ => l10n.workoutSplitFullBody,
      };
}
