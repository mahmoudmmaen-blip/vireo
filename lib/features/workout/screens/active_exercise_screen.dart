import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/locale_provider.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/data/repositories/workout_repository.dart';
import 'package:vireo/features/workout/providers/workout_flow_provider.dart';
import 'package:vireo/features/workout/widgets/exercise_video_player.dart';
import 'package:vireo/features/workout/widgets/medical_banner.dart';
import 'package:vireo/features/workout/widgets/swap_exercise_sheet.dart';

class ActiveExerciseScreen extends ConsumerWidget {
  const ActiveExerciseScreen({
    super.key,
    required this.showMedicalBanner,
  });

  final bool showMedicalBanner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flow = ref.watch(workoutFlowProvider)!;
    final exercise = flow.currentExercise!;
    final locale = ref.watch(localeProvider).languageCode;
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final notifier = ref.read(workoutFlowProvider.notifier);
    final profile = ref.watch(userProfileProvider).valueOrNull;
    final completedSets = flow.setsForCurrentExercise();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showMedicalBanner) const MedicalBanner(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${l10n.workoutExerciseProgress} ${flow.exerciseIndex + 1}/${flow.exercises.length}',
                  style: TextStyle(color: colors.textMute),
                ),
                const SizedBox(height: 12),
                ExerciseVideoPlayer(
                  videoUrl: exercise.videoUrl,
                  aspectRatio: exercise.videoAspectRatio,
                ),
                const SizedBox(height: 16),
                Text(
                  exercise.localizedName(locale),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  exercise.localizedTargetMuscle(locale),
                  style: TextStyle(color: colors.textMute, fontSize: 16),
                ),
                const SizedBox(height: 16),
                _StatRow(
                  sets: exercise.sets,
                  reps: exercise.reps,
                  restSeconds: exercise.restSeconds,
                ),
                const SizedBox(height: 20),
                Text(l10n.workoutSetsLabel, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                ...List.generate(exercise.sets, (index) {
                  final done = index < completedSets.length && completedSets[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _SetCheckboxTile(
                      setNumber: index + 1,
                      done: done,
                      onTap: done ? null : () => notifier.completeSet(index),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: profile == null
                      ? null
                      : () => showSwapExerciseSheet(
                            context,
                            ref,
                            current: exercise,
                            environment: profile.trainingEnvironment,
                          ),
                  icon: const Icon(Icons.swap_horiz),
                  label: Text(l10n.workoutSwapExercise),
                ),
              ],
            ),
          ),
        ),
        _ExerciseNavBar(
          canGoPrevious: !flow.isFirstExercise,
          canGoNext: true,
          onPrevious: notifier.previousExercise,
          onNext: notifier.nextExercise,
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.sets,
    required this.reps,
    required this.restSeconds,
  });

  final int sets;
  final int reps;
  final int restSeconds;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return Row(
      children: [
        _StatChip(label: l10n.workoutStatSets, value: '$sets', colors: colors),
        const SizedBox(width: 8),
        _StatChip(label: l10n.workoutStatReps, value: '$reps', colors: colors),
        const SizedBox(width: 8),
        _StatChip(
          label: l10n.workoutStatRest,
          value: '${restSeconds}s',
          colors: colors,
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
    required this.colors,
  });

  final String label;
  final String value;
  final VireoColors colors;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: colors.surfaceRaised,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(label, style: TextStyle(color: colors.textMute, fontSize: 12)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _SetCheckboxTile extends StatelessWidget {
  const _SetCheckboxTile({
    required this.setNumber,
    required this.done,
    required this.onTap,
  });

  final int setNumber;
  final bool done;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return Material(
      color: done ? colors.success.withValues(alpha: 0.12) : colors.surfaceRaised,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(
                done ? Icons.check_circle : Icons.circle_outlined,
                color: done ? colors.success : colors.textMute,
              ),
              const SizedBox(width: 12),
              Text(
                l10n.workoutSetNumber(setNumber),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: done ? colors.success : colors.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExerciseNavBar extends StatelessWidget {
  const _ExerciseNavBar({
    required this.canGoPrevious,
    required this.canGoNext,
    required this.onPrevious,
    required this.onNext,
  });

  final bool canGoPrevious;
  final bool canGoNext;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.surfaceRaised)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: canGoPrevious ? onPrevious : null,
              child: Text(l10n.workoutPrevious),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: canGoNext ? onNext : null,
              child: Text(l10n.workoutNext),
            ),
          ),
        ],
      ),
    );
  }
}
