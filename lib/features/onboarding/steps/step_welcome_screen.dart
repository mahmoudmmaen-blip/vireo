import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/analytics_service.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/motion.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';
import 'package:vireo/features/onboarding/providers/onboarding_provider.dart';
import 'package:vireo/features/onboarding/widgets/onboarding_step_shell.dart';

class StepWelcomeScreen extends ConsumerStatefulWidget {
  const StepWelcomeScreen({super.key});

  @override
  ConsumerState<StepWelcomeScreen> createState() => _StepWelcomeScreenState();
}

class _StepWelcomeScreenState extends ConsumerState<StepWelcomeScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsService.onboardingStepViewed(
      stepIndex: 0,
      stepName: 'welcome',
    );
  }

  Future<void> _start() async {
    // Ensure anonymous session is created silently in the background
    final authRepo = ref.read(authRepositoryProvider);
    authRepo.ensureAnonymousSession().catchError((_) {});

    await AnalyticsService.onboardingStepCompleted(
      stepIndex: 0,
      stepName: 'welcome',
    );

    if (!mounted) return;
    ref.read(onboardingProvider.notifier).nextStep();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return OnboardingStepShell(
      stepIndex: 0,
      stepCount: OnboardingUiState.stepCount,
      showAppBar: false,
      bottomWidget: Pressable(
        onTap: _start,
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            color: colors.ember,
            borderRadius: BorderRadius.circular(VRadius.md),
            boxShadow: [
              BoxShadow(
                color: colors.ember.withValues(alpha: 0.35),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.continueButton,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 36),
          // Logo with glow
          FadeSlideIn(
            index: 0,
            child: Center(
              child: Container(
                width: 104,
                height: 104,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.surfaceRaised,
                  border: Border.all(
                    color: colors.ember.withValues(alpha: 0.4),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colors.ember.withValues(alpha: 0.25),
                      blurRadius: 32,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  'assets/images/vireo_logo.svg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          // App Title
          FadeSlideIn(
            index: 1,
            child: Text(
              'VIREO',
              textAlign: TextAlign.center,
              style: VType.number(
                size: 38,
                weight: FontWeight.w900,
                color: colors.text,
                letterSpacing: 4,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // One-line value prop
          FadeSlideIn(
            index: 2,
            child: Text(
              'Smart nutrition & intelligent fitness built specifically for men.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: colors.textMute,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 36),
          // Value pillars
          FadeSlideIn(
            index: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                color: colors.surfaceRaised,
                borderRadius: BorderRadius.circular(VRadius.lg),
                border: Border.all(
                  color: colors.line,
                ),
              ),
              child: Column(
                children: [
                  _PillarRow(
                    icon: Icons.camera_alt_outlined,
                    iconColor: VMacro.carbs,
                    title: 'Instant Plate Scanner',
                    subtitle: 'Snap your meal, get accurate calories & protein in 2 seconds',
                  ),
                  const Divider(height: 24),
                  _PillarRow(
                    icon: Icons.bolt_rounded,
                    iconColor: colors.ember,
                    title: 'Personalized Daily Plan',
                    subtitle: 'Evidence-backed targets tailored to your body and goal',
                  ),
                  const Divider(height: 24),
                  _PillarRow(
                    icon: Icons.shield_outlined,
                    iconColor: VMacro.steps,
                    title: 'Clinically Safe Nutrition',
                    subtitle: 'Guidance that protects your metabolism and overall health',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PillarRow extends StatelessWidget {
  const _PillarRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(VRadius.sm),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: colors.textMute,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
