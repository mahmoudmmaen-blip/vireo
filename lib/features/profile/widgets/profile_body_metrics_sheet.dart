import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/onboarding_calorie_sync.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/data/models/activity_level.dart';
import 'package:vireo/data/models/fitness_goal.dart';
import 'package:vireo/data/models/onboarding_draft.dart';
import 'package:vireo/features/diet_programs/providers/diet_programs_provider.dart';
import 'package:vireo/features/nutrition/providers/calorie_goal_provider.dart';
import 'package:vireo/features/water/providers/water_daily_goal_provider.dart';

Future<void> showProfileBodyMetricsSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.vireoColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => _ProfileBodyMetricsSheet(ref: ref),
  );
}

class _ProfileBodyMetricsSheet extends ConsumerStatefulWidget {
  const _ProfileBodyMetricsSheet({required this.ref});

  final WidgetRef ref;

  @override
  ConsumerState<_ProfileBodyMetricsSheet> createState() =>
      _ProfileBodyMetricsSheetState();
}

class _ProfileBodyMetricsSheetState
    extends ConsumerState<_ProfileBodyMetricsSheet> {
  late int _age;
  late double _height;
  late double _weight;
  late ActivityLevel _activity;
  late FitnessGoal _goal;

  @override
  void initState() {
    super.initState();
    final map = _readProfile();
    _age = (map['age'] as num?)?.toInt() ?? 30;
    _height = (map['height_cm'] as num?)?.toDouble() ?? 170;
    _weight = (map['weight_kg'] as num?)?.toDouble() ?? 75;
    _activity = ActivityLevel.fromValue(
      map['activity_level'] as String? ?? ActivityLevel.moderatelyActive.value,
    );
    _goal = FitnessGoal.fromValue(map['goal'] as String? ?? FitnessGoal.generalVitality.value);
  }

  Map<String, dynamic> _readProfile() {
    if (!HiveService.isInitialized) return {};
    final raw = HiveService.cacheBox.get('guest_profile');
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return {};
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (!HiveService.isInitialized) return;
    final map = _readProfile();
    map['age'] = _age;
    map['height_cm'] = _height;
    map['weight_kg'] = _weight;
    map['activity_level'] = _activity.value;
    map['goal'] = _goal.value;
    await HiveService.cacheBox.put('guest_profile', map);

    await OnboardingCalorieSync.syncFromDraft(
      OnboardingDraft(
        age: _age,
        heightCm: _height,
        weightKg: _weight,
        activityLevel: _activity,
        goal: _goal,
        consentAccepted: true,
      ),
    );

    widget.ref.invalidate(calorieGoalProvider);
    widget.ref.invalidate(waterDailyGoalMlProvider);
    widget.ref.invalidate(dietPlanInputProvider);
    widget.ref.invalidate(activeDietTargetsProvider);
    widget.ref.read(dietPlanRevisionProvider.notifier).state++;

    if (mounted) Navigator.of(context).pop();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(duration: const Duration(seconds: 3), persist: false, content: Text(l10n.profileBodyMetricsSaved)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.profileMyBody,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 16),
          _NumberField(
            label: l10n.onboardingAge,
            value: _age.toDouble(),
            onChanged: (v) => setState(() => _age = v.round()),
          ),
          _NumberField(
            label: l10n.onboardingHeight,
            value: _height,
            onChanged: (v) => setState(() => _height = v),
          ),
          _NumberField(
            label: l10n.onboardingWeight,
            value: _weight,
            onChanged: (v) => setState(() => _weight = v),
          ),
          DropdownButtonFormField<FitnessGoal>(
            initialValue: _goal,
            decoration: InputDecoration(labelText: l10n.profileFitnessGoal),
            items: FitnessGoal.values
                .map(
                  (g) => DropdownMenuItem(
                    value: g,
                    child: Text(_goalLabel(l10n, g)),
                  ),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _goal = v);
            },
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<ActivityLevel>(
            initialValue: _activity,
            decoration: InputDecoration(labelText: l10n.profileActivityLevel),
            items: ActivityLevel.values
                .map(
                  (a) => DropdownMenuItem(
                    value: a,
                    child: Text(_activityLabel(l10n, a)),
                  ),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _activity = v);
            },
          ),
          const SizedBox(height: 20),
          FilledButton(onPressed: _save, child: Text(l10n.profileSaveBodyMetrics)),
        ],
      ),
    );
  }

  String _goalLabel(AppLocalizations l10n, FitnessGoal g) => switch (g) {
        FitnessGoal.weightLoss => l10n.goalWeightLoss,
        FitnessGoal.muscleGain => l10n.goalMuscleGain,
        FitnessGoal.generalVitality => l10n.goalGeneralVitality,
        FitnessGoal.allOfAbove => l10n.goalAllOfAbove,
      };

  String _activityLabel(AppLocalizations l10n, ActivityLevel a) => switch (a) {
        ActivityLevel.sedentary => l10n.activitySedentary,
        ActivityLevel.moderatelyActive => l10n.activityModerate,
        ActivityLevel.veryActive => l10n.activityVeryActive,
      };
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final ctrl = TextEditingController(text: value.toStringAsFixed(value == value.roundToDouble() ? 0 : 1));
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(labelText: label),
        onChanged: (t) {
          final v = double.tryParse(t.replaceAll(',', '.'));
          if (v != null) onChanged(v);
        },
      ),
    );
  }
}
