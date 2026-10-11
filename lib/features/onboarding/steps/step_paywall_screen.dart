import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/analytics_service.dart';
import 'package:vireo/core/services/revenue_cat_service.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/motion.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/data/models/app_auth_state.dart';
import 'package:vireo/data/models/subscription_state.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';
import 'package:vireo/features/onboarding/providers/onboarding_provider.dart';
import 'package:vireo/features/onboarding/widgets/onboarding_step_shell.dart';
import 'package:vireo/features/subscription/providers/subscription_provider.dart';
import 'package:vireo/features/subscription/subscription_gate.dart';

class StepPaywallScreen extends ConsumerStatefulWidget {
  const StepPaywallScreen({super.key});

  @override
  ConsumerState<StepPaywallScreen> createState() => _StepPaywallScreenState();
}

class _StepPaywallScreenState extends ConsumerState<StepPaywallScreen> {
  SubscriptionPlanId _selectedPlan = SubscriptionPlanId.annual;
  bool _isPurchasing = false;

  @override
  void initState() {
    super.initState();
    AnalyticsService.onboardingStepViewed(
      stepIndex: 8,
      stepName: 'soft_paywall',
    );
  }

  Future<void> _finishOnboarding() async {
    final authState = ref.read(authProvider).valueOrNull;
    final userId = authState?.user?.id;
    await ref.read(onboardingProvider.notifier).complete(userId: userId);
  }

  Future<void> _subscribe() async {
    final sub = ref.read(subscriptionProvider).valueOrNull;
    if (sub == null || !sub.isConfigured) {
      // Offline/sandbox fallback: complete gracefully
      await _finishOnboarding();
      return;
    }

    final offerings = await RevenueCatService.getOfferings();
    final package = RevenueCatService.findPackage(
      offerings?.current,
      _selectedPlan,
    );

    if (!mounted) return;
    if (package == null) {
      await _finishOnboarding();
      return;
    }

    setState(() => _isPurchasing = true);
    try {
      final info = await purchaseWithAccountGate(context, ref, package);
      if (info != null && !ref.read(hasPremiumAccessProvider)) {
        await ref.read(subscriptionProvider.notifier).refresh();
      }
      await AnalyticsService.onboardingStepCompleted(
        stepIndex: 8,
        stepName: 'soft_paywall',
        properties: {'purchased': true, 'plan': _selectedPlan.name},
      );
    } catch (_) {
      // Never trap user on purchase error
    } finally {
      if (mounted) setState(() => _isPurchasing = false);
      await _finishOnboarding();
    }
  }

  Future<void> _skip() async {
    AnalyticsService.onboardingStepCompleted(
      stepIndex: 8,
      stepName: 'soft_paywall',
      properties: {'skipped': true},
    );
    await _finishOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final state = ref.watch(onboardingProvider);

    return OnboardingStepShell(
      stepIndex: 8,
      stepCount: OnboardingUiState.stepCount,
      title: 'Accelerate Your Results',
      subtitle: 'Unlock unlimited plate scans, full AI workout generation, and advanced analytics.',
      onBack: () => ref.read(onboardingProvider.notifier).previousStep(),
      onSkip: _skip,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Premium badge
          FadeSlideIn(
            index: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: colors.gold.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(VRadius.pill),
                  border: Border.all(color: colors.gold.withValues(alpha: 0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.workspace_premium_rounded, size: 18, color: colors.gold),
                    const SizedBox(width: 6),
                    Text(
                      'VIREO PRO',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: colors.gold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Features List
          FadeSlideIn(
            index: 1,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surfaceRaised,
                borderRadius: BorderRadius.circular(VRadius.lg),
                border: Border.all(color: colors.line),
              ),
              child: Column(
                children: [
                  _FeatureRow(
                    icon: Icons.all_inclusive_rounded,
                    title: 'Unlimited Instant Plate Scans',
                    subtitle: 'Never worry about daily limits or quotas',
                  ),
                  const Divider(height: 18),
                  _FeatureRow(
                    icon: Icons.auto_awesome_rounded,
                    title: 'AI Smart Substitution & Meal Prep',
                    subtitle: 'Instant macro-friendly swaps for Egyptian dishes',
                  ),
                  const Divider(height: 18),
                  _FeatureRow(
                    icon: Icons.fitness_center_rounded,
                    title: 'Custom Adaptive Workout Splits',
                    subtitle: 'Progressive overload tracking for gym or home',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Plan selection cards
          FadeSlideIn(
            index: 2,
            child: Row(
              children: [
                // Annual (Best Value)
                Expanded(
                  child: _PlanOptionCard(
                    title: 'Annual',
                    price: '\$4.99 / mo',
                    subtext: 'Billed yearly (Save 50%)',
                    badge: 'BEST VALUE',
                    isSelected: _selectedPlan == SubscriptionPlanId.annual,
                    onTap: () => setState(() => _selectedPlan = SubscriptionPlanId.annual),
                  ),
                ),
                const SizedBox(width: 12),
                // Monthly
                Expanded(
                  child: _PlanOptionCard(
                    title: 'Monthly',
                    price: '\$9.99 / mo',
                    subtext: 'Billed monthly',
                    isSelected: _selectedPlan == SubscriptionPlanId.monthly,
                    onTap: () => setState(() => _selectedPlan = SubscriptionPlanId.monthly),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Primary CTA
          FadeSlideIn(
            index: 3,
            child: Pressable(
              onTap: _isPurchasing || state.isSubmitting ? null : _subscribe,
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
                child: _isPurchasing || state.isSubmitting
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Start 7-Day Free Trial',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Secondary CTA: Skip
          FadeSlideIn(
            index: 4,
            child: TextButton(
              onPressed: state.isSubmitting ? null : _skip,
              child: Text(
                'Continue with Free Tier',
                style: TextStyle(
                  color: colors.textMute,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: colors.ember.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(VRadius.sm),
          ),
          child: Icon(icon, color: colors.ember, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11.5,
                  color: colors.textMute,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlanOptionCard extends StatelessWidget {
  const _PlanOptionCard({
    required this.title,
    required this.price,
    required this.subtext,
    required this.isSelected,
    required this.onTap,
    this.badge,
  });

  final String title;
  final String price;
  final String subtext;
  final bool isSelected;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return Pressable(
      onTap: onTap,
      child: AnimatedContainer(
        duration: VMotion.fast,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.ember.withValues(alpha: 0.12)
              : colors.surfaceRaised,
          borderRadius: BorderRadius.circular(VRadius.lg),
          border: Border.all(
            color: isSelected ? colors.ember : colors.line,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (badge != null)
              Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: colors.ember,
                  borderRadius: BorderRadius.circular(VRadius.pill),
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              )
            else
              const SizedBox(height: 18),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected ? colors.ember : colors.text,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              price,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtext,
              style: TextStyle(
                fontSize: 10.5,
                color: colors.textMute,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
