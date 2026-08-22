import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/utils/unit_converter.dart';
import 'package:vireo/data/models/activity_level.dart';
import 'package:vireo/data/models/training_environment.dart';
import 'package:vireo/features/progress/providers/progress_provider.dart';
import 'package:vireo/features/progress/widgets/reassessment_summary_card.dart';

class ReassessmentFlowScreen extends ConsumerStatefulWidget {
  const ReassessmentFlowScreen({super.key});

  @override
  ConsumerState<ReassessmentFlowScreen> createState() =>
      _ReassessmentFlowScreenState();
}

class _ReassessmentFlowScreenState extends ConsumerState<ReassessmentFlowScreen> {
  final _weightCtrl = TextEditingController();
  ActivityLevel _activity = ActivityLevel.moderatelyActive;
  TrainingEnvironment _environment = TrainingEnvironment.homeNoEquipment;
  bool _submitting = false;
  var _prefilled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_prefilled) {
      _prefilled = true;
      _prefillFromProfile();
    }
  }

  void _prefillFromProfile() {
    final guest = HiveService.cacheBox.get('guest_profile');
    if (guest is Map) {
      final activity = guest['activity_level'] as String?;
      if (activity != null) _activity = ActivityLevel.fromValue(activity);
      final env = guest['training_environment'] as String?;
      if (env != null) _environment = TrainingEnvironment.fromValue(env);
    }
    _prefillAsync();
  }

  Future<void> _prefillAsync() async {
    try {
      final last = await ref.read(lastReassessmentProvider.future);
      if (last != null) {
        _activity = ActivityLevel.fromValue(last.activityLevel);
        _environment = TrainingEnvironment.fromValue(last.trainingEnvironment);
      }
      final weightKg = await ref.read(weightGoalProvider.future);
      if (weightKg != null && _weightCtrl.text.isEmpty) {
        final unit = ref.read(unitPreferenceProvider);
        _weightCtrl.text =
            UnitConverter.displayWeight(weightKg, unit).toStringAsFixed(1);
      }
      if (mounted) setState(() {});
    } catch (_) {}
  }

  @override
  void dispose() {
    _weightCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final value = double.tryParse(_weightCtrl.text.replaceAll(',', '.'));
    if (value == null || value <= 0) return;

    setState(() => _submitting = true);
    try {
      final unit = ref.read(unitPreferenceProvider);
      final weightKg = UnitConverter.inputWeightToKg(value, unit);
      final record = await ref.read(reassessmentRepositoryProvider).completeReassessment(
            weightKg: weightKg,
            activityLevel: _activity,
            trainingEnvironment: _environment,
          );
      ref.invalidate(reassessmentDueProvider);
      ref.invalidate(lastReassessmentProvider);
      if (!mounted) return;

      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        builder: (ctx) => ReassessmentSummaryCard(record: record, unit: unit),
      );
      if (mounted) Navigator.of(context).pop(true);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).authErrorGeneric)),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final unit = ref.watch(unitPreferenceProvider);
    final unitLabel = UnitConverter.weightLabel(unit);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.reassessmentTitle),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: _submitting ? null : () => Navigator.of(context).pop(false),
            child: Text(l10n.reassessmentLater),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(l10n.reassessmentSubtitle, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 24),
          TextField(
            controller: _weightCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: l10n.onboardingWeight,
              suffixText: unitLabel,
            ),
          ),
          const SizedBox(height: 24),
          Text(l10n.onboardingActivityLevel, style: Theme.of(context).textTheme.titleMedium),
          ...ActivityLevel.values.map((level) {
            return RadioListTile<ActivityLevel>(
              value: level,
              groupValue: _activity,
              title: Text(_activityLabel(l10n, level)),
              onChanged: (v) {
                if (v != null) setState(() => _activity = v);
              },
            );
          }),
          const SizedBox(height: 16),
          Text(l10n.onboardingStep3Title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...TrainingEnvironment.values.map((env) {
            final selected = _environment == env;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () => setState(() => _environment = env),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: selected
                        ? colors.ember.withValues(alpha: 0.15)
                        : colors.surfaceRaised,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected ? colors.ember : colors.line,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_envTitle(l10n, env)),
                            Text(
                              _envDesc(l10n, env),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      if (selected) Icon(Icons.check_circle, color: colors.ember),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.reassessmentSubmit),
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

  String _envTitle(AppLocalizations l10n, TrainingEnvironment env) {
    switch (env) {
      case TrainingEnvironment.homeNoEquipment:
        return l10n.envHomeNoEquipment;
      case TrainingEnvironment.homeLightEquipment:
        return l10n.envHomeLightEquipment;
      case TrainingEnvironment.gymFull:
        return l10n.envGymFull;
      case TrainingEnvironment.walkingOnly:
        return l10n.envWalkingOnly;
    }
  }

  String _envDesc(AppLocalizations l10n, TrainingEnvironment env) {
    switch (env) {
      case TrainingEnvironment.homeNoEquipment:
        return l10n.envHomeNoEquipmentDesc;
      case TrainingEnvironment.homeLightEquipment:
        return l10n.envHomeLightEquipmentDesc;
      case TrainingEnvironment.gymFull:
        return l10n.envGymFullDesc;
      case TrainingEnvironment.walkingOnly:
        return l10n.envWalkingOnlyDesc;
    }
  }
}
