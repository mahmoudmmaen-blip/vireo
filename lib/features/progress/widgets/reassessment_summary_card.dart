import 'package:flutter/material.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/utils/unit_converter.dart';
import 'package:vireo/data/models/activity_level.dart';
import 'package:vireo/data/models/progress_models.dart';
import 'package:vireo/data/models/training_environment.dart';
import 'package:vireo/data/models/unit_preference.dart';

class ReassessmentSummaryCard extends StatelessWidget {
  const ReassessmentSummaryCard({
    super.key,
    required this.record,
    required this.unit,
  });

  final ReassessmentRecord record;
  final UnitPreference unit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.insights, size: 48, color: colors.gold),
            const SizedBox(height: 12),
            Text(
              l10n.reassessmentSummaryTitle,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.reassessmentSummarySubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _ChangeRow(
              label: l10n.onboardingWeight,
              before: _formatWeight(record.previousWeightKg),
              after: _formatWeight(record.weightKg),
              changed: _weightChanged,
            ),
            _ChangeRow(
              label: l10n.onboardingActivityLevel,
              before: _activityLabel(l10n, record.previousActivityLevel),
              after: _activityLabel(l10n, record.activityLevel),
              changed: record.previousActivityLevel != record.activityLevel,
            ),
            _ChangeRow(
              label: l10n.onboardingStep3Title,
              before: _envLabel(l10n, record.previousTrainingEnvironment),
              after: _envLabel(l10n, record.trainingEnvironment),
              changed:
                  record.previousTrainingEnvironment != record.trainingEnvironment,
            ),
            if (record.phaseRecalculated) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.gold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.gold.withValues(alpha: 0.4)),
                ),
                child: Text(
                  l10n.reassessmentPhaseUpdated(record.programPhase),
                  style: TextStyle(color: colors.gold),
                ),
              ),
            ] else ...[
              const SizedBox(height: 12),
              Text(
                l10n.reassessmentNoPhaseChange,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.continueButton),
            ),
          ],
        ),
      ),
    );
  }

  bool get _weightChanged {
    final prev = record.previousWeightKg;
    if (prev == null) return false;
    return (record.weightKg - prev).abs() >= 0.1;
  }

  String _formatWeight(double? kg) {
    if (kg == null) return '—';
    return '${UnitConverter.displayWeight(kg, unit).toStringAsFixed(1)} ${UnitConverter.weightLabel(unit)}';
  }

  String _activityLabel(AppLocalizations l10n, String? value) {
    if (value == null) return '—';
    switch (ActivityLevel.fromValue(value)) {
      case ActivityLevel.sedentary:
        return l10n.activitySedentary;
      case ActivityLevel.moderatelyActive:
        return l10n.activityModerate;
      case ActivityLevel.veryActive:
        return l10n.activityVeryActive;
    }
  }

  String _envLabel(AppLocalizations l10n, String? value) {
    if (value == null) return '—';
    switch (TrainingEnvironment.fromValue(value)) {
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
}

class _ChangeRow extends StatelessWidget {
  const _ChangeRow({
    required this.label,
    required this.before,
    required this.after,
    required this.changed,
  });

  final String label;
  final String before;
  final String after;
  final bool changed;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    before,
                    style: TextStyle(color: colors.textMute),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: changed ? colors.ember : colors.textMute,
                ),
                Expanded(
                  child: Text(
                    after,
                    style: TextStyle(
                      fontWeight: changed ? FontWeight.w600 : FontWeight.normal,
                      color: changed ? colors.ember : colors.text,
                    ),
                    overflow: TextOverflow.ellipsis,
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
