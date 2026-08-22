import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/data/models/onboarding_draft.dart';
import 'package:vireo/features/onboarding/providers/onboarding_provider.dart';
import 'package:vireo/features/onboarding/widgets/onboarding_step_shell.dart';

class Step2HealthScreening extends ConsumerWidget {
  const Step2HealthScreening({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(onboardingProvider);
    final draft = state.draft;
    final colors = context.vireoColors;

    return OnboardingStepShell(
      stepIndex: 1,
      stepCount: OnboardingUiState.stepCount,
      title: l10n.onboardingStep2Title,
      subtitle: l10n.onboardingStep2Subtitle,
      canContinue: state.canContinue,
      onBack: () => ref.read(onboardingProvider.notifier).previousStep(),
      onContinue: () => ref.read(onboardingProvider.notifier).nextStep(),
      child: Column(
        children: [
          if (draft.medicalFlag)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: colors.danger.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.danger),
              ),
              child: Text(
                l10n.onboardingMedicalFlagNotice,
                style: TextStyle(color: colors.danger),
              ),
            ),
          _HealthQuestion(
            question: l10n.healthQuestionHeart,
            value: draft.heartDisease,
            onChanged: (v) => _update(ref, draft.copyWith(heartDisease: v)),
          ),
          _HealthQuestion(
            question: l10n.healthQuestionDiabetes,
            value: draft.diabetes,
            onChanged: (v) => _update(ref, draft.copyWith(diabetes: v)),
          ),
          _HealthQuestion(
            question: l10n.healthQuestionBloodPressure,
            value: draft.highBloodPressure,
            onChanged: (v) => _update(ref, draft.copyWith(highBloodPressure: v)),
          ),
          _HealthQuestion(
            question: l10n.healthQuestionJoints,
            value: draft.jointInjuries,
            onChanged: (v) => _update(ref, draft.copyWith(jointInjuries: v)),
          ),
          _HealthQuestion(
            question: l10n.healthQuestionMedications,
            value: draft.currentMedications,
            onChanged: (v) => _update(ref, draft.copyWith(currentMedications: v)),
          ),
        ],
      ),
    );
  }

  void _update(WidgetRef ref, OnboardingDraft draft) {
    ref.read(onboardingProvider.notifier).updateDraft(draft);
  }
}

class _HealthQuestion extends StatelessWidget {
  const _HealthQuestion({
    required this.question,
    required this.value,
    required this.onChanged,
  });

  final String question;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => onChanged(false),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: !value
                          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
                          : null,
                    ),
                    child: Text(l10n.noButton),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => onChanged(true),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: value
                          ? Theme.of(context).colorScheme.error.withValues(alpha: 0.2)
                          : null,
                    ),
                    child: Text(l10n.yesButton),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
