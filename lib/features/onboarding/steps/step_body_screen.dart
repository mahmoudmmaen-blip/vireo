import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/analytics_service.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/motion.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/data/models/unit_preference.dart';
import 'package:vireo/features/onboarding/providers/onboarding_provider.dart';
import 'package:vireo/features/onboarding/widgets/onboarding_step_shell.dart';
import 'package:vireo/features/onboarding/widgets/why_we_ask_box.dart';

class StepBodyScreen extends ConsumerStatefulWidget {
  const StepBodyScreen({super.key});

  @override
  ConsumerState<StepBodyScreen> createState() => _StepBodyScreenState();
}

class _StepBodyScreenState extends ConsumerState<StepBodyScreen> {
  late String _sex;
  late int _age;
  late double _heightCm;
  late double _weightKg;
  late double _targetWeightKg;
  late UnitPreference _unitPreference;

  @override
  void initState() {
    super.initState();
    AnalyticsService.onboardingStepViewed(
      stepIndex: 2,
      stepName: 'body',
    );

    final draft = ref.read(onboardingProvider).draft;
    _sex = draft.sex;
    _age = (draft.age ?? 28).clamp(18, 90);
    _heightCm = (draft.heightCm ?? 178).clamp(130, 225);
    _weightKg = (draft.weightKg ?? 82).clamp(40, 200);
    _targetWeightKg = (draft.targetWeightKg ?? (_weightKg - 5)).clamp(40, 200);
    _unitPreference = draft.unitPreference;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _syncDraft();
    });
  }

  void _syncDraft() {
    final cur = ref.read(onboardingProvider).draft;
    final updated = cur.copyWith(
      sex: _sex,
      age: _age,
      heightCm: _heightCm,
      weightKg: _weightKg,
      targetWeightKg: _targetWeightKg,
      unitPreference: _unitPreference,
    );
    ref.read(onboardingProvider.notifier).updateDraft(updated);
  }

  void _onContinue() {
    _syncDraft();
    AnalyticsService.onboardingStepCompleted(
      stepIndex: 2,
      stepName: 'body',
      properties: {
        'sex': _sex,
        'age': _age,
        'height_cm': _heightCm,
        'weight_kg': _weightKg,
        'target_weight_kg': _targetWeightKg,
        'unit': _unitPreference.value,
      },
    );
    ref.read(onboardingProvider.notifier).nextStep();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final isMetric = _unitPreference == UnitPreference.metric;

    return OnboardingStepShell(
      stepIndex: 2,
      stepCount: OnboardingUiState.stepCount,
      title: l10n.onboardingBodyTitle,
      subtitle: l10n.onboardingBodySubtitle,
      onBack: () => ref.read(onboardingProvider.notifier).previousStep(),
      onSkip: _onContinue,
      onContinue: _onContinue,
      continueLabel: l10n.continueButton,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Metric / Imperial toggle & Sex selection
          FadeSlideIn(
            index: 0,
            child: Row(
              children: [
                // Sex Selector (Male default, targeted at men)
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: colors.surfaceRaised,
                      borderRadius: BorderRadius.circular(VRadius.md),
                      border: Border.all(color: colors.line),
                    ),
                    child: Row(
                      children: [
                        _SexButton(
                          label: l10n.sexMale,
                          icon: Icons.male_rounded,
                          isSelected: _sex == 'male',
                          onTap: () {
                            setState(() => _sex = 'male');
                            _syncDraft();
                          },
                        ),
                        const SizedBox(width: 4),
                        _SexButton(
                          label: l10n.sexFemale,
                          icon: Icons.female_rounded,
                          isSelected: _sex == 'female',
                          onTap: () {
                            setState(() => _sex = 'female');
                            _syncDraft();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Units toggle
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: colors.surfaceRaised,
                      borderRadius: BorderRadius.circular(VRadius.md),
                      border: Border.all(color: colors.line),
                    ),
                    child: Row(
                      children: [
                        _UnitTab(
                          label: l10n.unitMetric,
                          isSelected: isMetric,
                          onTap: () {
                            setState(() => _unitPreference = UnitPreference.metric);
                            _syncDraft();
                          },
                        ),
                        _UnitTab(
                          label: l10n.unitImperial,
                          isSelected: !isMetric,
                          onTap: () {
                            setState(() => _unitPreference = UnitPreference.imperial);
                            _syncDraft();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Wheel Pickers in modern cards
          FadeSlideIn(
            index: 1,
            child: _WheelCard(
              title: l10n.bodyMetricAge,
              displayValue: l10n.bodyMetricYears(_age),
              onTapEdit: () => _showPicker(
                title: l10n.selectAgeTitle,
                initialIndex: _age - 18,
                items: List.generate(73, (i) => l10n.ageYearsSuffix(i + 18)),
                onSelected: (i) {
                  setState(() => _age = i + 18);
                  _syncDraft();
                },
              ),
            ),
          ),
          const SizedBox(height: 12),

          FadeSlideIn(
            index: 2,
            child: _WheelCard(
              title: l10n.bodyMetricHeight,
              displayValue: isMetric
                  ? '${_heightCm.round()} cm'
                  : '${(_heightCm / 2.54).round() ~/ 12}\' ${((_heightCm / 2.54).round() % 12)}" (${_heightCm.round()} cm)',
              onTapEdit: () => _showPicker(
                title: l10n.selectHeightTitle,
                initialIndex: (_heightCm.round() - 140).clamp(0, 75),
                items: List.generate(76, (i) {
                  final cm = i + 140;
                  final totalIn = (cm / 2.54).round();
                  final ft = totalIn ~/ 12;
                  final inch = totalIn % 12;
                  return isMetric ? '$cm cm' : '$ft\' $inch" ($cm cm)';
                }),
                onSelected: (i) {
                  setState(() => _heightCm = (i + 140).toDouble());
                  _syncDraft();
                },
              ),
            ),
          ),
          const SizedBox(height: 12),

          FadeSlideIn(
            index: 3,
            child: _WheelCard(
              title: l10n.bodyMetricCurrentWeight,
              displayValue: isMetric
                  ? '${_weightKg.toStringAsFixed(1)} kg'
                  : '${(_weightKg * 2.20462).round()} lb (${_weightKg.toStringAsFixed(1)} kg)',
              onTapEdit: () => _showPicker(
                title: l10n.selectCurrentWeightTitle,
                initialIndex: ((_weightKg - 45) * 2).round().clamp(0, 250),
                items: List.generate(251, (i) {
                  final kg = 45.0 + (i * 0.5);
                  final lb = (kg * 2.20462).round();
                  return isMetric ? '${kg.toStringAsFixed(1)} kg' : '$lb lb (${kg.toStringAsFixed(1)} kg)';
                }),
                onSelected: (i) {
                  setState(() => _weightKg = 45.0 + (i * 0.5));
                  _syncDraft();
                },
              ),
            ),
          ),
          const SizedBox(height: 12),

          FadeSlideIn(
            index: 4,
            child: _WheelCard(
              title: l10n.bodyMetricTargetWeight,
              displayValue: isMetric
                  ? '${_targetWeightKg.toStringAsFixed(1)} kg'
                  : '${(_targetWeightKg * 2.20462).round()} lb (${_targetWeightKg.toStringAsFixed(1)} kg)',
              highlightColor: colors.ember,
              onTapEdit: () => _showPicker(
                title: l10n.selectTargetWeightTitle,
                initialIndex: ((_targetWeightKg - 45) * 2).round().clamp(0, 250),
                items: List.generate(251, (i) {
                  final kg = 45.0 + (i * 0.5);
                  final lb = (kg * 2.20462).round();
                  return isMetric ? '${kg.toStringAsFixed(1)} kg' : '$lb lb (${kg.toStringAsFixed(1)} kg)';
                }),
                onSelected: (i) {
                  setState(() => _targetWeightKg = 45.0 + (i * 0.5));
                  _syncDraft();
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          FadeSlideIn(
            index: 5,
            child: WhyWeAskBox(
              text: Localizations.localeOf(context).languageCode.startsWith('ar')
                  ? 'نستخدم وزنك وطولك وعمرك لحساب معدل الحرق اليومي (BMR و TDEE) واحتياجك الدقيق من البروتين والسعرات.'
                  : 'We use your height, weight, and age to compute your BMR, TDEE, and precise protein and calorie targets.',
            ),
          ),
        ],
      ),
    );
  }

  void _showPicker({
    required String title,
    required int initialIndex,
    required List<String> items,
    required ValueChanged<int> onSelected,
  }) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.surfaceRaised,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(VRadius.xl)),
      ),
      builder: (ctx) {
        var selected = initialIndex.clamp(0, items.length - 1);
        return SizedBox(
          height: 310,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        onSelected(selected);
                        Navigator.of(ctx).pop();
                      },
                      child: Text(
                        l10n.pickerDone,
                        style: TextStyle(
                          color: colors.ember,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 44,
                  scrollController: FixedExtentScrollController(
                    initialItem: selected,
                  ),
                  onSelectedItemChanged: (idx) {
                    selected = idx;
                    HapticFeedback.selectionClick();
                  },
                  children: items
                      .map((item) => Center(
                            child: Text(
                              item,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: colors.text,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SexButton extends StatelessWidget {
  const _SexButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return Expanded(
      child: Pressable(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? colors.ember : Colors.transparent,
            borderRadius: BorderRadius.circular(VRadius.sm),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : colors.textMute,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : colors.textMute,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UnitTab extends StatelessWidget {
  const _UnitTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return Expanded(
      child: Pressable(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? colors.background : Colors.transparent,
            borderRadius: BorderRadius.circular(VRadius.sm),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isSelected ? colors.text : colors.textMute,
            ),
          ),
        ),
      ),
    );
  }
}

class _WheelCard extends StatelessWidget {
  const _WheelCard({
    required this.title,
    required this.displayValue,
    required this.onTapEdit,
    this.highlightColor,
  });

  final String title;
  final String displayValue;
  final VoidCallback onTapEdit;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final color = highlightColor ?? colors.text;

    return Pressable(
      onTap: onTapEdit,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: colors.surfaceRaised,
          borderRadius: BorderRadius.circular(VRadius.lg),
          border: Border.all(
            color: highlightColor != null
                ? highlightColor!.withValues(alpha: 0.5)
                : colors.line,
            width: highlightColor != null ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.textMute,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    displayValue,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colors.background,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.unfold_more_rounded,
                color: colors.textMute,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
