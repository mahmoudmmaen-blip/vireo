import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/analytics_service.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/motion.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/data/models/fitness_goal.dart';
import 'package:vireo/features/onboarding/providers/onboarding_provider.dart';
import 'package:vireo/features/onboarding/widgets/onboarding_step_shell.dart';

class StepGoalScreen extends ConsumerStatefulWidget {
  const StepGoalScreen({super.key});

  @override
  ConsumerState<StepGoalScreen> createState() => _StepGoalScreenState();
}

class _StepGoalScreenState extends ConsumerState<StepGoalScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsService.onboardingStepViewed(
      stepIndex: 1,
      stepName: 'goal',
    );
  }

  void _selectGoal(FitnessGoal goal) {
    final draft = ref.read(onboardingProvider).draft;
    ref.read(onboardingProvider.notifier).updateDraft(draft.copyWith(goal: goal));

    AnalyticsService.onboardingStepCompleted(
      stepIndex: 1,
      stepName: 'goal',
      properties: {'goal': goal.value},
    );

    ref.read(onboardingProvider.notifier).nextStep();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final draft = state.draft;

    final goals = [
      (
        goal: FitnessGoal.weightLoss,
        title: 'Lose Fat',
        subtitle: 'Torch stubborn fat while maintaining hard-earned muscle mass',
        icon: Icons.local_fire_department_rounded,
        color: const Color(0xFFFF5252),
      ),
      (
        goal: FitnessGoal.muscleGain,
        title: 'Build Muscle',
        subtitle: 'Maximize lean hypertrophy with optimized protein & progressive overload',
        icon: Icons.fitness_center_rounded,
        color: VMacro.protein,
      ),
      (
        goal: FitnessGoal.generalVitality,
        title: 'More Energy',
        subtitle: 'Eliminate mid-day crashes and elevate everyday stamina & vitality',
        icon: Icons.bolt_rounded,
        color: const Color(0xFFF59E0B),
      ),
      (
        goal: FitnessGoal.allOfAbove,
        title: 'All of the Above',
        subtitle: 'Total body recomposition: drop body fat, gain strength, and feel relentless',
        icon: Icons.all_inclusive_rounded,
        color: colorsOf(context).ember,
      ),
    ];

    return OnboardingStepShell(
      stepIndex: 1,
      stepCount: OnboardingUiState.stepCount,
      title: 'What is your primary focus?',
      subtitle: 'Pick what matters most. We will engineer your daily targets around this.',
      onBack: () => ref.read(onboardingProvider.notifier).previousStep(),
      onSkip: () {
        AnalyticsService.onboardingStepCompleted(
          stepIndex: 1,
          stepName: 'goal',
          properties: {'skipped': true},
        );
        ref.read(onboardingProvider.notifier).nextStep();
      },
      child: Column(
        children: goals.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = draft.goal == item.goal;

          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: FadeSlideIn(
              index: index,
              child: _GoalCard(
                title: item.title,
                subtitle: item.subtitle,
                icon: item.icon,
                accentColor: item.color,
                isSelected: isSelected,
                onTap: () => _selectGoal(item.goal),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  VireoColors colorsOf(BuildContext context) => context.vireoColors;
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return Pressable(
      onTap: onTap,
      child: AnimatedContainer(
        duration: VMotion.fast,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withValues(alpha: 0.12)
              : colors.surfaceRaised,
          borderRadius: BorderRadius.circular(VRadius.lg),
          border: Border.all(
            color: isSelected ? accentColor : colors.line,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(VRadius.md),
              ),
              child: Icon(icon, color: accentColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? accentColor : colors.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.textMute,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? accentColor : Colors.transparent,
                border: Border.all(
                  color: isSelected ? accentColor : colors.textMute.withValues(alpha: 0.4),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
