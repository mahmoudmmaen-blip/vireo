import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/analytics_service.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/motion.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/data/models/fitness_goal.dart';
import 'package:vireo/features/onboarding/providers/onboarding_provider.dart';
import 'package:vireo/features/onboarding/widgets/onboarding_step_shell.dart';
import 'package:vireo/features/onboarding/widgets/why_we_ask_box.dart';

class StepGoalScreen extends ConsumerStatefulWidget {
  const StepGoalScreen({super.key});

  @override
  ConsumerState<StepGoalScreen> createState() => _StepGoalScreenState();
}

class _StepGoalScreenState extends ConsumerState<StepGoalScreen> {
  late FitnessGoal _selectedGoal;
  final Set<String> _selectedFocus = {};

  @override
  void initState() {
    super.initState();
    AnalyticsService.onboardingStepViewed(
      stepIndex: 1,
      stepName: 'goal',
    );
    final draft = ref.read(onboardingProvider).draft;
    _selectedGoal = draft.goal;
    _selectedFocus.addAll(draft.focusGoals);
  }

  void _toggleFocus(String key) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_selectedFocus.contains(key)) {
        _selectedFocus.remove(key);
      } else {
        if (_selectedFocus.length < 3) {
          _selectedFocus.add(key);
        } else {
          // Max 3 selected: show gentle feedback
          HapticFeedback.heavyImpact();
        }
      }
    });
  }

  void _onContinue() {
    final draft = ref.read(onboardingProvider).draft;
    ref.read(onboardingProvider.notifier).updateDraft(
          draft.copyWith(
            goal: _selectedGoal,
            focusGoals: _selectedFocus.toList(),
          ),
        );

    AnalyticsService.onboardingStepCompleted(
      stepIndex: 1,
      stepName: 'goal',
      properties: {
        'goal': _selectedGoal.value,
        'focus_goals': _selectedFocus.toList(),
      },
    );

    ref.read(onboardingProvider.notifier).nextStep();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(onboardingProvider);
    final draft = state.draft;
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');
    final isFemale = draft.sex.toLowerCase().startsWith('f');
    final colors = context.vireoColors;

    final goals = [
      (
        goal: FitnessGoal.weightLoss,
        title: l10n.goalLoseFatTitle,
        subtitle: l10n.goalLoseFatSubtitle,
        icon: Icons.local_fire_department_rounded,
        color: const Color(0xFFFF5252),
      ),
      (
        goal: FitnessGoal.muscleGain,
        title: l10n.goalBuildMuscleTitle,
        subtitle: l10n.goalBuildMuscleSubtitle,
        icon: Icons.fitness_center_rounded,
        color: VMacro.protein,
      ),
      (
        goal: FitnessGoal.generalVitality,
        title: l10n.goalMoreEnergyTitle,
        subtitle: l10n.goalMoreEnergySubtitle,
        icon: Icons.bolt_rounded,
        color: const Color(0xFFF59E0B),
      ),
      (
        goal: FitnessGoal.allOfAbove,
        title: l10n.goalAllOfAboveTitle,
        subtitle: l10n.goalAllOfAboveSubtitle,
        icon: Icons.all_inclusive_rounded,
        color: colors.ember,
      ),
    ];

    final focusOptions = [
      ('fat_loss', isArabic ? 'خسارة دهون' : 'Fat Loss', Icons.local_fire_department_rounded),
      ('muscle_build', isArabic ? 'بناء عضل' : 'Build Muscle', Icons.fitness_center_rounded),
      ('fitness', isArabic ? 'لياقة' : 'Fitness', Icons.directions_run_rounded),
      ('better_sleep', isArabic ? 'نوم أفضل' : 'Better Sleep', Icons.bedtime_rounded),
      ('healthy_eating', isArabic ? 'أكل صحي' : 'Healthy Eating', Icons.restaurant_rounded),
      ('higher_energy', isArabic ? 'طاقة أعلى' : 'Higher Energy', Icons.bolt_rounded),
      (
        'gender_health',
        isFemale
            ? (isArabic ? 'صحتك' : 'Women\'s Health')
            : (isArabic ? 'صحة الرجل' : 'Men\'s Health'),
        Icons.spa_rounded
      ),
    ];

    return OnboardingStepShell(
      stepIndex: 1,
      stepCount: OnboardingUiState.stepCount,
      title: l10n.onboardingGoalTitle,
      subtitle: l10n.onboardingGoalSubtitle,
      onBack: () => ref.read(onboardingProvider.notifier).previousStep(),
      onSkip: _onContinue,
      onContinue: _onContinue,
      continueLabel: l10n.continueButton,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Primary Goals ──
          ...goals.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = _selectedGoal == item.goal;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: FadeSlideIn(
                index: index,
                child: _GoalCard(
                  title: item.title,
                  subtitle: item.subtitle,
                  icon: item.icon,
                  accentColor: item.color,
                  isSelected: isSelected,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedGoal = item.goal);
                  },
                ),
              ),
            );
          }),

          const SizedBox(height: 12),

          // ── "عايز تركز على إيه؟" Multi-select chips (max 3) ──
          FadeSlideIn(
            index: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        isArabic ? 'عايز تركز على إيه؟' : 'What do you want to focus on?',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isArabic ? 'اختر حتى ٣ مجالات' : 'Select up to 3',
                      style: TextStyle(fontSize: 12, color: colors.textMute, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: focusOptions.map((opt) {
                    final isSelected = _selectedFocus.contains(opt.$1);
                    return FilterChip(
                      avatar: Icon(opt.$3, size: 15, color: isSelected ? colors.ember : colors.textMute),
                      label: Text(opt.$2),
                      selected: isSelected,
                      onSelected: (_) => _toggleFocus(opt.$1),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // ── "ليه بنسأل؟" Info Box ──
          FadeSlideIn(
            index: 5,
            child: WhyWeAskBox(
              text: isArabic
                  ? 'نستخدم أهدافك ومجالات تركيزك لتخصيص مهام "رحلة اليوم" وترتيب النصائح الغذائية والرياضية المناسبة لك.'
                  : 'We use your goals and focus areas to personalize your Daily Journey tasks and smart tips.',
            ),
          ),
        ],
      ),
    );
  }
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
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected
                    ? colors.ember.withValues(alpha: 0.2)
                    : accentColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? colors.ember : accentColor,
                size: 22,
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
                      fontWeight: FontWeight.w800,
                      color: colors.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.textMute,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
              color: isSelected ? colors.ember : colors.line,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
