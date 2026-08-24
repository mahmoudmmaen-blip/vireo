import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/theme/vireo_decorations.dart';
import 'package:vireo/core/theme/vireo_scroll_behavior.dart';
import 'package:vireo/features/onboarding/providers/onboarding_provider.dart';
import 'package:vireo/features/onboarding/widgets/onboarding_step_shell.dart';

class Step5Consent extends ConsumerWidget {
  const Step5Consent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(onboardingProvider);
    final draft = state.draft;
    final colors = context.vireoColors;

    return OnboardingStepShell(
      stepIndex: 4,
      stepCount: OnboardingUiState.stepCount,
      title: l10n.onboardingStep5Title,
      subtitle: l10n.onboardingStep5Subtitle,
      canContinue: state.canContinue,
      onBack: () => ref.read(onboardingProvider.notifier).previousStep(),
      onContinue: () => ref.read(onboardingProvider.notifier).nextStep(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            constraints: const BoxConstraints(maxHeight: 340),
            decoration: VireoDecorations.premiumCard(colors),
            child: const NoScrollbarScrollConfiguration(
              child: _DisclaimerScrollBox(),
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

class _DisclaimerScrollBox extends StatefulWidget {
  const _DisclaimerScrollBox();

  @override
  State<_DisclaimerScrollBox> createState() => _DisclaimerScrollBoxState();
}

class _DisclaimerScrollBoxState extends State<_DisclaimerScrollBox> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      controller: _scrollController,
      primary: false,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DisclaimerSection(icon: '⚠️', text: l10n.legalDisclaimerSection1),
          _DisclaimerSection(icon: '🏥', text: l10n.legalDisclaimerSection2),
          _DisclaimerSection(icon: '💊', text: l10n.legalDisclaimerSection3),
          _DisclaimerSection(icon: '🧬', text: l10n.legalDisclaimerSection4),
          _DisclaimerSection(icon: '⚖️', text: l10n.legalDisclaimerSection5),
        ],
      ),
    );
  }
}

class _DisclaimerSection extends StatelessWidget {
  const _DisclaimerSection({required this.icon, required this.text});

  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.text,
                    height: 1.5,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
