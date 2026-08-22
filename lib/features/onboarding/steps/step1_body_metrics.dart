import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/utils/unit_converter.dart';
import 'package:vireo/data/models/activity_level.dart';
import 'package:vireo/data/models/dietary_restriction.dart';
import 'package:vireo/data/models/onboarding_draft.dart';
import 'package:vireo/data/models/unit_preference.dart';
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

  @override
  void initState() {
    super.initState();
    _ageCtrl = TextEditingController();
    _heightCtrl = TextEditingController();
    _weightCtrl = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final draft = ref.read(onboardingProvider).draft;
    if (_ageCtrl.text.isEmpty && draft.age != null) {
      _ageCtrl.text = draft.age.toString();
      _heightCtrl.text = _formatHeight(draft);
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

  void _syncDraft(OnboardingDraft draft) {
    final age = int.tryParse(_ageCtrl.text.trim());
    final heightInput = double.tryParse(_heightCtrl.text.trim());
    final weightInput = double.tryParse(_weightCtrl.text.trim());

    ref.read(onboardingProvider.notifier).updateDraft(
          draft.copyWith(
            age: age,
            heightCm: heightInput != null
                ? UnitConverter.inputHeightToCm(heightInput, draft.unitPreference)
                : null,
            weightKg: weightInput != null
                ? UnitConverter.inputWeightToKg(weightInput, draft.unitPreference)
                : null,
          ),
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
            controller: _ageCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: l10n.onboardingAge),
            onChanged: (_) => _syncDraft(draft),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _heightCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: l10n.onboardingHeight,
              suffixText: isMetric ? 'cm' : 'in',
            ),
            onChanged: (_) => _syncDraft(draft),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _weightCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: l10n.onboardingWeight,
              suffixText: isMetric ? 'kg' : 'lb',
            ),
            onChanged: (_) => _syncDraft(draft),
          ),
          const SizedBox(height: 24),
          Text(l10n.onboardingActivityLevel, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ...ActivityLevel.values.map((level) {
            return RadioListTile<ActivityLevel>(
              value: level,
              groupValue: draft.activityLevel,
              title: Text(_activityLabel(l10n, level)),
              onChanged: (v) {
                if (v == null) return;
                ref.read(onboardingProvider.notifier).updateDraft(
                      draft.copyWith(activityLevel: v),
                    );
              },
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
