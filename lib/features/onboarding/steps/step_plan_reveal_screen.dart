import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/analytics_service.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/motion.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/core/utils/calorie_calculator.dart';
import 'package:vireo/data/models/activity_level.dart';
import 'package:vireo/features/diet_programs/application/diet_plan_engine.dart';
import 'package:vireo/features/diet_programs/data/diet_plan_storage.dart';
import 'package:vireo/features/diet_programs/data/diet_programs_catalog.dart';
import 'package:vireo/features/onboarding/providers/onboarding_provider.dart';
import 'package:vireo/features/onboarding/widgets/onboarding_step_shell.dart';

class StepPlanRevealScreen extends ConsumerStatefulWidget {
  const StepPlanRevealScreen({super.key});

  @override
  ConsumerState<StepPlanRevealScreen> createState() =>
      _StepPlanRevealScreenState();
}

class _StepPlanRevealScreenState extends ConsumerState<StepPlanRevealScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsService.onboardingStepViewed(
      stepIndex: 6,
      stepName: 'plan_reveal',
    );
  }

  void _onStartPlan() {
    AnalyticsService.onboardingStepCompleted(
      stepIndex: 6,
      stepName: 'plan_reveal',
    );
    ref.read(onboardingProvider.notifier).nextStep();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final draft = ref.watch(onboardingProvider).draft;

    final weight = draft.weightKg ?? 82.0;
    final height = draft.heightCm ?? 178.0;
    final age = draft.age ?? 28;
    final activity = draft.activityLevel;
    final goal = draft.goal;

    // Calculate personalized target
    final target = CalorieCalculator.compute(
      weightKg: weight,
      heightCm: height,
      age: age,
      activityLevel: activity,
      goal: goal,
    );

    // Calculate water recommendation (35ml per kg body weight)
    final waterMl = (weight * 35).round().clamp(2000, 4500);
    final waterLiters = (waterMl / 1000).toStringAsFixed(1);

    // Daily steps target based on goal and activity
    final stepsTarget = switch (activity) {
      ActivityLevel.sedentary => 7500,
      ActivityLevel.moderatelyActive => 10000,
      ActivityLevel.veryActive => 12500,
    };

    // Calculate expected weekly change based on deficit / surplus
    final maintenance = CalorieCalculator.maintenanceKcal(
      weightKg: weight,
      heightCm: height,
      age: age,
      activityLevel: activity,
    );
    final diff = target.calories - maintenance;
    // 7700 kcal = 1 kg fat
    final weeklyChangeKg = (diff * 7 / 7700.0);
    final isLoss = weeklyChangeKg < 0;
    final changeText = weeklyChangeKg.abs() < 0.1
        ? l10n.planRevealSteadyRecomp
        : isLoss
            ? l10n.planRevealFatLossPace(weeklyChangeKg.abs().toStringAsFixed(2))
            : l10n.planRevealLeanMassPace(weeklyChangeKg.abs().toStringAsFixed(2));

    // Recommended diet program
    final conditions = DietPlanStorage.readConditions();
    final ranked = DietPlanEngine.rank(
      DietProgramsCatalog.all,
      DietPlanInput(
        weightKg: weight,
        heightCm: height,
        age: age,
        maintenanceKcal: maintenance,
        conditions: conditions,
      ),
    );
    final topProg = ranked.isNotEmpty ? ranked.first : null;
    final programName = topProg?.program.name.en ?? l10n.planRevealBalancedPlanDefault;

    return OnboardingStepShell(
      stepIndex: 6,
      stepCount: OnboardingUiState.stepCount,
      title: l10n.onboardingPlanRevealTitle,
      subtitle: l10n.onboardingPlanRevealSubtitle,
      onBack: () => ref.read(onboardingProvider.notifier).previousStep(),
      onSkip: _onStartPlan,
      bottomWidget: Pressable(
        onTap: _onStartPlan,
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
          child: Text(
            l10n.planRevealStartPlan,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Weekly Change Banner
          FadeSlideIn(
            index: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colors.ember.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(VRadius.md),
                border: Border.all(color: colors.ember.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  Icon(
                    isLoss ? Icons.trending_down_rounded : Icons.trending_up_rounded,
                    color: colors.ember,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.planRevealProjectedPace,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: colors.ember,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          changeText,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Daily Calories Hero Card
          FadeSlideIn(
            index: 1,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.surfaceRaised,
                borderRadius: BorderRadius.circular(VRadius.lg),
                border: Border.all(color: colors.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.planRevealDailyCalories,
                        style: VType.overline(context),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: colors.ember.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(VRadius.pill),
                        ),
                        child: Text(
                          l10n.planRevealPersonalizedBadge,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: colors.ember,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      AnimatedCount(
                        value: target.calories,
                        style: VType.number(
                          size: 40,
                          weight: FontWeight.w800,
                          color: colors.text,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.planRevealKcalPerDay,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colors.textMute,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // 2x2 Macro & Activity Grid with AnimatedCount
          FadeSlideIn(
            index: 2,
            child: Row(
              children: [
                // Protein
                Expanded(
                  child: _MetricCard(
                    title: l10n.planRevealDailyProtein,
                    value: target.proteinG,
                    unit: l10n.planRevealGramPerDay,
                    color: VMacro.protein,
                    icon: Icons.fitness_center_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                // Water
                Expanded(
                  child: _MetricWaterCard(
                    title: l10n.planRevealHydration,
                    display: '$waterLiters L',
                    unit: '$waterMl ml',
                    color: VMacro.water,
                    icon: Icons.water_drop_rounded,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          FadeSlideIn(
            index: 3,
            child: Row(
              children: [
                // Steps
                Expanded(
                  child: _MetricCard(
                    title: l10n.planRevealDailySteps,
                    value: stepsTarget,
                    unit: l10n.planRevealStepsPerDay,
                    color: VMacro.steps,
                    icon: Icons.directions_walk_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                // Diet Program
                Expanded(
                  child: Container(
                    height: 110,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colors.surfaceRaised,
                      borderRadius: BorderRadius.circular(VRadius.md),
                      border: Border.all(color: colors.line),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.restaurant_menu_rounded, size: 16, color: VMacro.carbs),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                l10n.planRevealDietProtocol,
                                style: VType.overline(context),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          programName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.planRevealOptimalMatch,
                          style: TextStyle(fontSize: 11, color: colors.textMute),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.color,
    required this.icon,
  });

  final String title;
  final int value;
  final String unit;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return Container(
      height: 110,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(VRadius.md),
        border: Border.all(color: colors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: VType.overline(context),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          AnimatedCount(
            value: value,
            style: VType.number(
              size: 26,
              weight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            unit,
            style: TextStyle(
              fontSize: 11,
              color: colors.textMute,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricWaterCard extends StatelessWidget {
  const _MetricWaterCard({
    required this.title,
    required this.display,
    required this.unit,
    required this.color,
    required this.icon,
  });

  final String title;
  final String display;
  final String unit;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return Container(
      height: 110,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(VRadius.md),
        border: Border.all(color: colors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: VType.overline(context),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            display,
            style: VType.number(
              size: 26,
              weight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            unit,
            style: TextStyle(
              fontSize: 11,
              color: colors.textMute,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
