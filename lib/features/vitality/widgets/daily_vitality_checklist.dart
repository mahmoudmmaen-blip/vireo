import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/navigation/vireo_page_routes.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/vitality/providers/vitality_progress_provider.dart';
import 'package:vireo/features/vitality/providers/vitality_provider.dart';
import 'package:vireo/features/vitality/screens/vitality_hub_screen.dart';

class DailyVitalityChecklist extends ConsumerWidget {
  const DailyVitalityChecklist({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final log = ref.watch(vitalityDailyLogProvider);
    final proteinMet = ref.watch(proteinGoalMetProvider);
    final completed = log.checklistCompleted(proteinGoalMet: proteinMet);
    const total = 5;
    final progress = completed / total;

    return Material(
      color: colors.surfaceRaised,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            SlideUpRoute<void>(page: const VitalityHubScreen()),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 4,
                      color: colors.recovery,
                      backgroundColor: colors.line,
                    ),
                    Text(
                      '$completed/$total',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.vitalityDailyChecklistTitle,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.vitalityDailyChecklistProgress(completed, total),
                      style: TextStyle(color: colors.textMute, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colors.textMute),
            ],
          ),
        ),
      ),
    );
  }
}

class DailyVitalityChecklistExpanded extends ConsumerWidget {
  const DailyVitalityChecklistExpanded({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final log = ref.watch(vitalityDailyLogProvider);
    final proteinMet = ref.watch(proteinGoalMetProvider);
    final notifier = ref.read(vitalityDailyLogProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CheckRow(
          label: l10n.vitalityCheckSleep,
          checked: log.sleepGoalMet,
          onChanged: null,
        ),
        _CheckRow(
          label: l10n.vitalityCheckProtein,
          checked: proteinMet,
          onChanged: proteinMet
              ? null
              : (_) {
                  ref
                      .read(vitalityBadgeProgressProvider.notifier)
                      .onProteinGoalMet(true);
                },
        ),
        _CheckRow(
          label: l10n.vitalityCheckWorkout,
          checked: log.workoutCompleted,
          onChanged: log.workoutCompleted
              ? null
              : (_) => notifier.markWorkoutCompleted(),
        ),
        _CheckRow(
          label: l10n.vitalityCheckSunlight,
          checked: log.sunlightDone,
          onChanged: (v) => notifier.toggleSunlightDone(v ?? false),
        ),
        _CheckRow(
          label: l10n.vitalityCheckZincVitD,
          checked: log.zincVitDDone,
          onChanged: (v) => notifier.toggleZincVitDDone(v ?? false),
        ),
      ],
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({
    required this.label,
    required this.checked,
    required this.onChanged,
  });

  final String label;
  final bool checked;
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      value: checked,
      onChanged: onChanged,
      title: Text(label),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
