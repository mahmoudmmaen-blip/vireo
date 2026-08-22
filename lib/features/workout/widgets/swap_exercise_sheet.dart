import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/locale_provider.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/data/models/exercise.dart';
import 'package:vireo/data/models/training_environment.dart';
import 'package:vireo/data/repositories/workout_repository.dart';
import 'package:vireo/features/workout/providers/workout_flow_provider.dart';

Future<void> showSwapExerciseSheet(
  BuildContext context,
  WidgetRef ref, {
  required Exercise current,
  required TrainingEnvironment environment,
}) async {
  final l10n = AppLocalizations.of(context);
  final colors = context.vireoColors;
  final locale = ref.read(localeProvider).languageCode;

  final alternatives = await ref.read(exerciseRepositoryProvider).fetchAlternatives(
        targetMuscle: current.targetMuscle,
        environment: environment,
        excludeId: current.id,
      );

  if (!context.mounted) return;

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.workoutSwapTitle,
                style: Theme.of(ctx).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.workoutSwapSubtitle,
                style: TextStyle(color: colors.textMute),
              ),
              const SizedBox(height: 16),
              if (alternatives.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    l10n.workoutSwapEmpty,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colors.textMute),
                  ),
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: alternatives.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, index) {
                      final alt = alternatives[index];
                      return ListTile(
                        title: Text(alt.localizedName(locale)),
                        subtitle: Text(alt.localizedTargetMuscle(locale)),
                        trailing: Text(
                          '${alt.sets}×${alt.reps}',
                          style: TextStyle(color: colors.textMute),
                        ),
                        onTap: () {
                          ref.read(workoutFlowProvider.notifier).swapExercise(alt);
                          Navigator.of(ctx).pop();
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}
