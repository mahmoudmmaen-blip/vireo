import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/data/models/training_environment.dart';
import 'package:vireo/features/onboarding/providers/onboarding_provider.dart';
import 'package:vireo/features/onboarding/widgets/onboarding_step_shell.dart';

class Step3TrainingEnvironment extends ConsumerWidget {
  const Step3TrainingEnvironment({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(onboardingProvider);
    final draft = state.draft;
    final colors = context.vireoColors;

    return OnboardingStepShell(
      stepIndex: 2,
      stepCount: OnboardingUiState.stepCount,
      title: l10n.onboardingStep3Title,
      subtitle: l10n.onboardingStep3Subtitle,
      canContinue: state.canContinue,
      onBack: () => ref.read(onboardingProvider.notifier).previousStep(),
      onContinue: () => ref.read(onboardingProvider.notifier).nextStep(),
      child: Column(
        children: TrainingEnvironment.values.map((env) {
          final selected = draft.trainingEnvironment == env;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => ref.read(onboardingProvider.notifier).updateDraft(
                    draft.copyWith(trainingEnvironment: env),
                  ),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: selected
                      ? colors.ember.withValues(alpha: 0.15)
                      : colors.surfaceRaised,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected ? colors.ember : colors.surfaceRaised,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(_iconFor(env), color: selected ? colors.ember : colors.textMute),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _title(l10n, env),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _subtitle(l10n, env),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    if (selected) Icon(Icons.check_circle, color: colors.ember),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _iconFor(TrainingEnvironment env) {
    switch (env) {
      case TrainingEnvironment.homeNoEquipment:
        return Icons.home_outlined;
      case TrainingEnvironment.homeLightEquipment:
        return Icons.fitness_center_outlined;
      case TrainingEnvironment.gymFull:
        return Icons.sports_gymnastics;
      case TrainingEnvironment.walkingOnly:
        return Icons.directions_walk;
    }
  }

  String _title(AppLocalizations l10n, TrainingEnvironment env) {
    switch (env) {
      case TrainingEnvironment.homeNoEquipment:
        return l10n.envHomeNoEquipment;
      case TrainingEnvironment.homeLightEquipment:
        return l10n.envHomeLightEquipment;
      case TrainingEnvironment.gymFull:
        return l10n.envGymFull;
      case TrainingEnvironment.walkingOnly:
        return l10n.envWalkingOnly;
    }
  }

  String _subtitle(AppLocalizations l10n, TrainingEnvironment env) {
    switch (env) {
      case TrainingEnvironment.homeNoEquipment:
        return l10n.envHomeNoEquipmentDesc;
      case TrainingEnvironment.homeLightEquipment:
        return l10n.envHomeLightEquipmentDesc;
      case TrainingEnvironment.gymFull:
        return l10n.envGymFullDesc;
      case TrainingEnvironment.walkingOnly:
        return l10n.envWalkingOnlyDesc;
    }
  }
}
