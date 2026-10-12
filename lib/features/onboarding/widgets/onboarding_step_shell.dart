import 'package:flutter/material.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/theme/vireo_scroll_behavior.dart';
import 'package:vireo/core/ui/motion.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';

class OnboardingStepShell extends StatelessWidget {
  const OnboardingStepShell({
    super.key,
    required this.stepIndex,
    required this.stepCount,
    this.title,
    this.subtitle,
    required this.child,
    this.canContinue = true,
    this.onContinue,
    this.onBack,
    this.onSkip,
    this.continueLabel,
    this.secondaryLabel,
    this.onSecondary,
    this.isLoading = false,
    this.showTopProgress = true,
    this.showAppBar = true,
    this.bottomWidget,
  });

  final int stepIndex;
  final int stepCount;
  final String? title;
  final String? subtitle;
  final Widget child;
  final bool canContinue;
  final VoidCallback? onContinue;
  final VoidCallback? onBack;
  final VoidCallback? onSkip;
  final String? continueLabel;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final bool isLoading;
  final bool showTopProgress;
  final bool showAppBar;
  final Widget? bottomWidget;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final progress = ((stepIndex + 1) / stepCount).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            if (showTopProgress)
              LinearProgressIndicator(
                value: progress,
                backgroundColor: colors.surfaceRaised,
                color: colors.ember,
                minHeight: 4,
              ),
            if (showAppBar)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Row(
                  children: [
                    if (onBack != null)
                      IconButton(
                        tooltip: l10n.authBack,
                        onPressed: onBack,
                        icon: const Icon(Icons.arrow_back),
                      )
                    else
                      const SizedBox(width: 48, height: 48),
                    const Spacer(),
                    Text(
                      '${stepIndex + 1} / $stepCount',
                      style: VType.overline(context),
                    ),
                    const Spacer(),
                    if (onSkip != null)
                      TextButton(
                        onPressed: onSkip,
                        child: Text(
                          l10n.skipButton,
                          style: TextStyle(
                            color: colors.textMute,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 48, height: 48),
                  ],
                ),
              ),
            Expanded(
              child: NoScrollbarScrollConfiguration(
                child: SingleChildScrollView(
                  primary: false,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (title != null) ...[
                        FadeSlideIn(
                          index: 0,
                          child: Text(
                            title!,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 8),
                          FadeSlideIn(
                            index: 1,
                            child: Text(
                              subtitle!,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: colors.textMute,
                                    height: 1.4,
                                  ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                      ],
                      FadeSlideIn(
                        index: 2,
                        child: child,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (bottomWidget != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: bottomWidget!,
              )
            else if (onContinue != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (secondaryLabel != null && onSecondary != null) ...[
                      TextButton(
                        onPressed: onSecondary,
                        child: Text(secondaryLabel!),
                      ),
                      const SizedBox(height: 8),
                    ],
                    Pressable(
                      onTap: canContinue && !isLoading ? onContinue : null,
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: canContinue && !isLoading
                              ? colors.ember
                              : colors.surfaceRaised,
                          borderRadius: BorderRadius.circular(VRadius.md),
                        ),
                        alignment: Alignment.center,
                        child: isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colors.text,
                                ),
                              )
                            : Text(
                                continueLabel ?? l10n.continueButton,
                                style: TextStyle(
                                  color: canContinue && !isLoading
                                      ? Colors.white
                                      : colors.textMute,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
