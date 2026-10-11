import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/analytics_service.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/motion.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/diet_programs/data/diet_plan_storage.dart';
import 'package:vireo/features/diet_programs/data/diet_programs_catalog.dart';
import 'package:vireo/features/diet_programs/domain/diet_program.dart';
import 'package:vireo/features/onboarding/providers/onboarding_provider.dart';
import 'package:vireo/features/onboarding/widgets/onboarding_step_shell.dart';

class StepHealthSafetyScreen extends ConsumerStatefulWidget {
  const StepHealthSafetyScreen({super.key});

  @override
  ConsumerState<StepHealthSafetyScreen> createState() =>
      _StepHealthSafetyScreenState();
}

class _StepHealthSafetyScreenState
    extends ConsumerState<StepHealthSafetyScreen> {
  final Set<HealthCondition> _selectedConditions = {};

  @override
  void initState() {
    super.initState();
    AnalyticsService.onboardingStepViewed(
      stepIndex: 4,
      stepName: 'health_safety',
    );

    final savedConditions = DietPlanStorage.readConditions();
    _selectedConditions.addAll(savedConditions);

    final draft = ref.read(onboardingProvider).draft;
    for (final cond in HealthCondition.values) {
      if (draft.healthConditions.contains(cond.value)) {
        _selectedConditions.add(cond);
      }
    }
  }

  void _syncAndContinue() {
    DietPlanStorage.saveConditions(_selectedConditions);

    final draft = ref.read(onboardingProvider).draft;
    final conditionStrings = _selectedConditions.map((c) => c.value).toSet();

    final updated = draft.copyWith(
      healthConditions: conditionStrings,
      heartDisease: _selectedConditions
          .contains(HealthCondition.heartDiseaseOrArrhythmia),
      diabetes: _selectedConditions.contains(HealthCondition.type1Diabetes) ||
          _selectedConditions.contains(HealthCondition.diabetesOnMedication),
      highBloodPressure:
          _selectedConditions.contains(HealthCondition.bloodPressureMedication),
      jointInjuries: false,
      currentMedications:
          _selectedConditions.contains(HealthCondition.medicationWithFood),
    );

    ref.read(onboardingProvider.notifier).updateDraft(updated);

    AnalyticsService.onboardingStepCompleted(
      stepIndex: 4,
      stepName: 'health_safety',
      properties: {
        'conditions_count': _selectedConditions.length,
        'conditions': conditionStrings.toList(),
      },
    );

    ref.read(onboardingProvider.notifier).nextStep();
  }

  void _clearAllAndContinue() {
    setState(() => _selectedConditions.clear());
    _syncAndContinue();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final lang = Localizations.localeOf(context).languageCode;
    final questions = DietSafetyCopy.questions;

    return OnboardingStepShell(
      stepIndex: 4,
      stepCount: OnboardingUiState.stepCount,
      title: 'Health Safety Screening',
      subtitle: 'Select any conditions that apply so our engine can protect your safety.',
      onBack: () => ref.read(onboardingProvider.notifier).previousStep(),
      onSkip: _syncAndContinue,
      onContinue: _syncAndContinue,
      continueLabel: l10n.continueButton,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // "None of these" button prominently placed on top
          FadeSlideIn(
            index: 0,
            child: Pressable(
              onTap: _clearAllAndContinue,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: _selectedConditions.isEmpty
                      ? VMacro.steps.withValues(alpha: 0.15)
                      : colors.surfaceRaised,
                  borderRadius: BorderRadius.circular(VRadius.md),
                  border: Border.all(
                    color: _selectedConditions.isEmpty
                        ? VMacro.steps
                        : colors.line,
                    width: _selectedConditions.isEmpty ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: _selectedConditions.isEmpty
                          ? VMacro.steps
                          : colors.textMute,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'None of these apply to me',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _selectedConditions.isEmpty
                            ? VMacro.steps
                            : colors.text,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),

          FadeSlideIn(
            index: 1,
            child: Row(
              children: [
                Expanded(child: Divider(color: colors.line)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'OR SELECT ANY APPLICABLE',
                    style: VType.overline(context),
                  ),
                ),
                Expanded(child: Divider(color: colors.line)),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 12 DietSafetyCopy questions as quick Yes/No chips
          ...questions.entries.toList().asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            final condition = item.key;
            final questionText = item.value.of(lang);
            final isYes = _selectedConditions.contains(condition);

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FadeSlideIn(
                index: idx + 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: colors.surfaceRaised,
                    borderRadius: BorderRadius.circular(VRadius.md),
                    border: Border.all(
                      color: isYes
                          ? colors.ember.withValues(alpha: 0.8)
                          : colors.line,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          questionText,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: colors.text,
                            height: 1.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Yes / No chips
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _ChipButton(
                            label: 'No',
                            isSelected: !isYes,
                            activeColor: colors.textMute,
                            onTap: () {
                              setState(() {
                                _selectedConditions.remove(condition);
                              });
                            },
                          ),
                          const SizedBox(width: 6),
                          _ChipButton(
                            label: 'Yes',
                            isSelected: isYes,
                            activeColor: colors.ember,
                            onTap: () {
                              setState(() {
                                _selectedConditions.add(condition);
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ChipButton extends StatelessWidget {
  const _ChipButton({
    required this.label,
    required this.isSelected,
    required this.activeColor,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return Pressable(
      onTap: onTap,
      child: AnimatedContainer(
        duration: VMotion.fast,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: 0.2)
              : colors.background,
          borderRadius: BorderRadius.circular(VRadius.pill),
          border: Border.all(
            color: isSelected ? activeColor : colors.line,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isSelected ? activeColor : colors.textMute,
          ),
        ),
      ),
    );
  }
}
