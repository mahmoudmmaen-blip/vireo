import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/features/onboarding/providers/onboarding_provider.dart';
import 'package:vireo/features/onboarding/widgets/onboarding_step_shell.dart';

class Step5Consent extends ConsumerWidget {
  const Step5Consent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(onboardingProvider);
    final draft = state.draft;

    return OnboardingStepShell(
      stepIndex: 4,
      stepCount: OnboardingUiState.stepCount,
      title: l10n.onboardingStep5Title,
      subtitle: l10n.onboardingStep5Subtitle,
      canContinue: state.canContinue,
      onBack: () => ref.read(onboardingProvider.notifier).previousStep(),
      onContinue: () => ref.read(onboardingProvider.notifier).nextStep(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              l10n.legalDisclaimerText,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            value: draft.consentAccepted,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(l10n.consentCheckboxLabel),
            onChanged: (value) {
              ref.read(onboardingProvider.notifier).updateDraft(
                    draft.copyWith(
                      consentAccepted: value ?? false,
                      consentAcceptedAt:
                          (value ?? false) ? DateTime.now().toUtc() : null,
                    ),
                  );
            },
          ),
        ],
      ),
    );
  }
}
