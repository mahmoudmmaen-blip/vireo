import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/analytics_service.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/motion.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/data/models/activity_level.dart';
import 'package:vireo/data/models/training_environment.dart';
import 'package:vireo/features/onboarding/providers/onboarding_provider.dart';
import 'package:vireo/features/onboarding/widgets/onboarding_step_shell.dart';

class StepActivityEnvironmentScreen extends ConsumerStatefulWidget {
  const StepActivityEnvironmentScreen({super.key});

  @override
  ConsumerState<StepActivityEnvironmentScreen> createState() =>
      _StepActivityEnvironmentScreenState();
}

class _StepActivityEnvironmentScreenState
    extends ConsumerState<StepActivityEnvironmentScreen> {
  late ActivityLevel _activityLevel;
  late TrainingEnvironment _environment;

  @override
  void initState() {
    super.initState();
    AnalyticsService.onboardingStepViewed(
      stepIndex: 3,
      stepName: 'activity_environment',
    );

    final draft = ref.read(onboardingProvider).draft;
    _activityLevel = draft.activityLevel;
    _environment = draft.trainingEnvironment;
  }

  void _syncAndContinue() {
    final cur = ref.read(onboardingProvider).draft;
    ref.read(onboardingProvider.notifier).updateDraft(
          cur.copyWith(
            activityLevel: _activityLevel,
            trainingEnvironment: _environment,
          ),
        );

    AnalyticsService.onboardingStepCompleted(
      stepIndex: 3,
      stepName: 'activity_environment',
      properties: {
        'activity_level': _activityLevel.value,
        'environment': _environment.value,
      },
    );

    ref.read(onboardingProvider.notifier).nextStep();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final activityLevels = [
      (
        level: ActivityLevel.sedentary,
        title: l10n.activitySedentaryTitle,
        subtitle: l10n.activitySedentarySubtitle,
        icon: Icons.chair_outlined,
      ),
      (
        level: ActivityLevel.moderatelyActive,
        title: l10n.activityModeratelyActiveTitle,
        subtitle: l10n.activityModeratelyActiveSubtitle,
        icon: Icons.directions_walk_rounded,
      ),
      (
        level: ActivityLevel.veryActive,
        title: l10n.activityVeryActiveTitle,
        subtitle: l10n.activityVeryActiveSubtitle,
        icon: Icons.directions_run_rounded,
      ),
    ];

    final trainingPlaces = [
      (
        env: TrainingEnvironment.gymFull,
        title: l10n.trainingPlaceGymTitle,
        subtitle: l10n.trainingPlaceGymSubtitle,
        icon: Icons.fitness_center_rounded,
      ),
      (
        env: TrainingEnvironment.homeLightEquipment,
        title: l10n.trainingPlaceHomeTitle,
        subtitle: l10n.trainingPlaceHomeSubtitle,
        icon: Icons.home_rounded,
      ),
      (
        env: TrainingEnvironment.walkingOnly,
        title: l10n.trainingPlaceWalkingTitle,
        subtitle: l10n.trainingPlaceWalkingSubtitle,
        icon: Icons.nature_people_rounded,
      ),
    ];

    return OnboardingStepShell(
      stepIndex: 3,
      stepCount: OnboardingUiState.stepCount,
      title: l10n.onboardingActivityTitle,
      subtitle: l10n.onboardingActivitySubtitle,
      onBack: () => ref.read(onboardingProvider.notifier).previousStep(),
      onSkip: _syncAndContinue,
      onContinue: _syncAndContinue,
      continueLabel: l10n.continueButton,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Activity Level Section
          FadeSlideIn(
            index: 0,
            child: Text(
              l10n.dailyActivityLevelHeader,
              style: VType.overline(context),
            ),
          ),
          const SizedBox(height: 10),
          ...activityLevels.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            final selected = _activityLevel == item.level;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FadeSlideIn(
                index: idx + 1,
                child: _SelectableCard(
                  title: item.title,
                  subtitle: item.subtitle,
                  icon: item.icon,
                  isSelected: selected,
                  onTap: () {
                    setState(() => _activityLevel = item.level);
                  },
                ),
              ),
            );
          }),

          const SizedBox(height: 24),

          // Training Place Section
          FadeSlideIn(
            index: 4,
            child: Text(
              l10n.trainingPlaceHeader,
              style: VType.overline(context),
            ),
          ),
          const SizedBox(height: 10),
          ...trainingPlaces.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            final selected = _environment == item.env;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FadeSlideIn(
                index: idx + 5,
                child: _SelectableCard(
                  title: item.title,
                  subtitle: item.subtitle,
                  icon: item.icon,
                  isSelected: selected,
                  onTap: () {
                    setState(() => _environment = item.env);
                  },
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _SelectableCard extends StatelessWidget {
  const _SelectableCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return Pressable(
      onTap: onTap,
      child: AnimatedContainer(
        duration: VMotion.fast,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.ember.withValues(alpha: 0.12)
              : colors.surfaceRaised,
          borderRadius: BorderRadius.circular(VRadius.md),
          border: Border.all(
            color: isSelected ? colors.ember : colors.line,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected
                    ? colors.ember.withValues(alpha: 0.2)
                    : colors.background,
                borderRadius: BorderRadius.circular(VRadius.sm),
              ),
              child: Icon(
                icon,
                color: isSelected ? colors.ember : colors.textMute,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? colors.ember : colors.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.textMute,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? colors.ember : Colors.transparent,
                border: Border.all(
                  color: isSelected ? colors.ember : colors.textMute.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
