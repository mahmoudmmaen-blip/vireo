import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/utils/unit_converter.dart';
import 'package:vireo/data/models/activity_level.dart';
import 'package:vireo/data/models/dietary_restriction.dart';
import 'package:vireo/data/models/onboarding_draft.dart';
import 'package:vireo/data/models/unit_preference.dart';
import 'package:vireo/core/widgets/language_selector.dart';
import 'package:vireo/features/onboarding/providers/onboarding_provider.dart';
import 'package:vireo/features/onboarding/widgets/onboarding_step_shell.dart';

class Step1BodyMetrics extends ConsumerStatefulWidget {
  const Step1BodyMetrics({super.key});

  @override
  ConsumerState<Step1BodyMetrics> createState() => _Step1BodyMetricsState();
}

class _Step1BodyMetricsState extends ConsumerState<Step1BodyMetrics> {
  late final TextEditingController _ageCtrl;
  late final TextEditingController _heightCtrl;
  late final TextEditingController _weightCtrl;
  bool _controllersHydrated = false;

  @override
  void initState() {
    super.initState();
    _ageCtrl = TextEditingController();
    _heightCtrl = TextEditingController();
    _weightCtrl = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _hydrateControllersOnce());
  }

  void _hydrateControllersOnce() {
    if (!mounted || _controllersHydrated) return;
    _controllersHydrated = true;

    final draft = ref.read(onboardingProvider).draft;
    if (draft.age != null) {
      _ageCtrl.text = draft.age.toString();
    }
    if (draft.heightCm != null) {
      _heightCtrl.text = _formatHeight(draft);
    }
    if (draft.weightKg != null) {
      _weightCtrl.text = _formatWeight(draft);
    }
  }

  @override
  void dispose() {
    _ageCtrl.dispose();
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  String _formatWeight(OnboardingDraft draft) {
    if (draft.weightKg == null) return '';
    final v = UnitConverter.displayWeight(
      draft.weightKg!,
      draft.unitPreference,
    );
    return v.toStringAsFixed(draft.unitPreference == UnitPreference.imperial ? 1 : 1);
  }

  String _formatHeight(OnboardingDraft draft) {
    if (draft.heightCm == null) return '';
    final v = UnitConverter.displayHeight(
      draft.heightCm!,
      draft.unitPreference,
    );
    return v.toStringAsFixed(1);
  }

  void _syncDraft() {
    final draft = ref.read(onboardingProvider).draft;
    final ageText = _ageCtrl.text.trim();
    final heightText = _heightCtrl.text.trim();
    final weightText = _weightCtrl.text.trim();

    var next = draft;

    if (ageText.isEmpty) {
      next = next.copyWith(clearAge: true);
    } else {
      final age = int.tryParse(ageText);
      if (age != null) next = next.copyWith(age: age);
    }

    if (heightText.isEmpty) {
      next = next.copyWith(clearHeightCm: true);
    } else {
      final heightInput = double.tryParse(heightText.replaceAll(',', '.'));
      if (heightInput != null) {
        next = next.copyWith(
          heightCm: UnitConverter.inputHeightToCm(heightInput, draft.unitPreference),
        );
      }
    }

    if (weightText.isEmpty) {
      next = next.copyWith(clearWeightKg: true);
    } else {
      final weightInput = double.tryParse(weightText.replaceAll(',', '.'));
      if (weightInput != null) {
        next = next.copyWith(
          weightKg: UnitConverter.inputWeightToKg(weightInput, draft.unitPreference),
        );
      }
    }

    ref.read(onboardingProvider.notifier).updateDraft(next);
  }

  InputDecoration _metricDecoration({
    required String label,
    required String unit,
  }) {
    return InputDecoration(
      labelText: '$label ($unit)',
    );
  }

  Widget _numericField({
    required Key key,
    required TextEditingController controller,
    required String label,
    required String unit,
    required void Function(String) onChanged,
  }) {
    return TextField(
      key: key,
      controller: controller,
      enabled: true,
      readOnly: false,
      enableInteractiveSelection: true,
      mouseCursor: SystemMouseCursors.text,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.start,
      decoration: _metricDecoration(label: label, unit: unit),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(onboardingProvider);
    final draft = state.draft;
    final colors = context.vireoColors;
    final isMetric = draft.unitPreference == UnitPreference.metric;

    return OnboardingStepShell(
      stepIndex: 0,
      stepCount: OnboardingUiState.stepCount,
      title: l10n.onboardingStep1Title,
      subtitle: l10n.onboardingStep1Subtitle,
      canContinue: state.canContinue,
      onContinue: () => ref.read(onboardingProvider.notifier).nextStep(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const LanguageSelector(),
          const SizedBox(height: 20),
          SegmentedButton<UnitPreference>(
            segments: [
              ButtonSegment(
                value: UnitPreference.metric,
                label: Text(l10n.unitsMetric),
              ),
              ButtonSegment(
                value: UnitPreference.imperial,
                label: Text(l10n.unitsImperial),
              ),
            ],
            selected: {draft.unitPreference},
            onSelectionChanged: (selected) {
              final unit = selected.first;
              final updated = draft.copyWith(unitPreference: unit);
              ref.read(onboardingProvider.notifier).updateDraft(updated);
              _heightCtrl.text = _formatHeight(updated);
              _weightCtrl.text = _formatWeight(updated);
            },
          ),
          const SizedBox(height: 20),
          TextField(
            key: const ValueKey('onboarding_age_field'),
            controller: _ageCtrl,
            enabled: true,
            readOnly: false,
            enableInteractiveSelection: true,
            mouseCursor: SystemMouseCursors.text,
            keyboardType: TextInputType.number,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.start,
            decoration: InputDecoration(labelText: l10n.onboardingAge),
            onChanged: (_) => _syncDraft(),
          ),
          const SizedBox(height: 12),
          _numericField(
            key: const ValueKey('onboarding_height_field'),
            controller: _heightCtrl,
            label: l10n.onboardingHeight,
            unit: isMetric ? 'cm' : 'in',
            onChanged: (_) => _syncDraft(),
          ),
          const SizedBox(height: 12),
          _numericField(
            key: const ValueKey('onboarding_weight_field'),
            controller: _weightCtrl,
            label: l10n.onboardingWeight,
            unit: isMetric ? 'kg' : 'lb',
            onChanged: (_) => _syncDraft(),
          ),
          const SizedBox(height: 24),
          Text(l10n.onboardingActivityLevel, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ...ActivityLevel.values.map((level) {
            final selected = draft.activityLevel == level;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () {
                  ref.read(onboardingProvider.notifier).updateDraft(
                        draft.copyWith(activityLevel: level),
                      );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected ? colors.ember : colors.line,
                      width: selected ? 2 : 1,
                    ),
                    color: selected
                        ? colors.ember.withValues(alpha: 0.08)
                        : colors.surfaceRaised,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        selected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: selected ? colors.ember : colors.textMute,
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(_activityLabel(l10n, level))),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
          Text(l10n.onboardingDietaryOptional, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: DietaryRestrictions.all.map((tag) {
              final selected = draft.dietaryRestrictions.contains(tag);
              return FilterChip(
                label: Text(_dietLabel(l10n, tag)),
                selected: selected,
                selectedColor: colors.ember.withValues(alpha: 0.25),
                checkmarkColor: colors.ember,
                onSelected: (value) {
                  final list = List<String>.from(draft.dietaryRestrictions);
                  if (value) {
                    list.add(tag);
                  } else {
                    list.remove(tag);
                  }
                  ref.read(onboardingProvider.notifier).updateDraft(
                        draft.copyWith(dietaryRestrictions: list),
                      );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _activityLabel(AppLocalizations l10n, ActivityLevel level) {
    switch (level) {
      case ActivityLevel.sedentary:
        return l10n.activitySedentary;
      case ActivityLevel.moderatelyActive:
        return l10n.activityModerate;
      case ActivityLevel.veryActive:
        return l10n.activityVeryActive;
    }
  }

  String _dietLabel(AppLocalizations l10n, String tag) {
    switch (tag) {
      case DietaryRestrictions.halal:
        return l10n.dietHalal;
      case DietaryRestrictions.vegetarian:
        return l10n.dietVegetarian;
      case DietaryRestrictions.vegan:
        return l10n.dietVegan;
      case DietaryRestrictions.glutenFree:
        return l10n.dietGlutenFree;
      case DietaryRestrictions.dairyFree:
        return l10n.dietDairyFree;
      case DietaryRestrictions.lowSodium:
        return l10n.dietLowSodium;
      case DietaryRestrictions.lowCarb:
        return l10n.dietLowCarb;
      case DietaryRestrictions.diabeticFriendly:
        return l10n.dietDiabeticFriendly;
      default:
        return tag;
    }
  }
}
