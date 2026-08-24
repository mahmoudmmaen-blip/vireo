import 'package:flutter/material.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/theme/vireo_scroll_behavior.dart';

class OnboardingStepShell extends StatelessWidget {
  const OnboardingStepShell({
    super.key,
    required this.stepIndex,
    required this.stepCount,
    required this.title,
    required this.subtitle,
    required this.child,
    required this.canContinue,
    required this.onContinue,
    this.onBack,
    this.continueLabel,
    this.secondaryLabel,
    this.onSecondary,
    this.isLoading = false,
  });

  final int stepIndex;
  final int stepCount;
  final String title;
  final String subtitle;
  final Widget child;
  final bool canContinue;
  final VoidCallback onContinue;
  final VoidCallback? onBack;
  final String? continueLabel;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        leading: stepIndex > 0 && onBack != null
            ? IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back))
            : null,
        title: Text(l10n.onboardingStepProgress(stepIndex + 1, stepCount)),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (stepIndex + 1) / stepCount,
            backgroundColor: colors.surfaceRaised,
            color: colors.ember,
            minHeight: 3,
          ),
          Expanded(
            child: NoScrollbarScrollConfiguration(
              child: SingleChildScrollView(
                primary: false,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 24),
                    child,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (secondaryLabel != null && onSecondary != null) ...[
                  TextButton(onPressed: onSecondary, child: Text(secondaryLabel!)),
                  const SizedBox(height: 8),
                ],
                ElevatedButton(
                  onPressed: canContinue && !isLoading ? onContinue : null,
                  child: isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colors.text,
                          ),
                        )
                      : Text(continueLabel ?? l10n.continueButton),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
