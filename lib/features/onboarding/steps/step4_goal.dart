import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/data/models/fitness_goal.dart';
import 'package:vireo/features/onboarding/providers/onboarding_provider.dart';
import 'package:vireo/features/onboarding/widgets/onboarding_step_shell.dart';

class Step4Goal extends ConsumerWidget {
  const Step4Goal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(onboardingProvider);
    final draft = state.draft;
    final colors = context.vireoColors;

    return OnboardingStepShell(
      stepIndex: 3,
      stepCount: OnboardingUiState.stepCount,
      title: l10n.onboardingStep4Title,
      subtitle: l10n.onboardingStep4Subtitle,
      canContinue: state.canContinue,
      onBack: () => ref.read(onboardingProvider.notifier).previousStep(),
      onContinue: () => ref.read(onboardingProvider.notifier).nextStep(),
      child: Column(
        children: FitnessGoal.values.map((goal) {
          final selected = draft.goal == goal;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: selected ? colors.ember : colors.surfaceRaised,
                  width: 2,
                ),
              ),
              tileColor: selected
                  ? colors.ember.withValues(alpha: 0.12)
                  : colors.surfaceRaised,
              title: Text(_goalTitle(l10n, goal)),
              subtitle: Text(_goalDesc(l10n, goal)),
              trailing: selected ? Icon(Icons.check, color: colors.ember) : null,
              onTap: () => ref.read(onboardingProvider.notifier).updateDraft(
                    draft.copyWith(goal: goal),
                  ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _goalTitle(AppLocalizations l10n, FitnessGoal goal) {
    switch (goal) {
      case FitnessGoal.weightLoss:
        return l10n.goalWeightLoss;
      case FitnessGoal.muscleGain:
        return l10n.goalMuscleGain;
      case FitnessGoal.generalVitality:
        return l10n.goalGeneralVitality;
      case FitnessGoal.allOfAbove:
        return l10n.goalAllOfAbove;
    }
  }

  String _goalDesc(AppLocalizations l10n, FitnessGoal goal) {
    switch (goal) {
      case FitnessGoal.weightLoss:
        return l10n.goalWeightLossDesc;
      case FitnessGoal.muscleGain:
        return l10n.goalMuscleGainDesc;
      case FitnessGoal.generalVitality:
        return l10n.goalGeneralVitalityDesc;
      case FitnessGoal.allOfAbove:
        return l10n.goalAllOfAboveDesc;
    }
  }
}
