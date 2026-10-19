import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/vitality_program/domain/vitality_program_phase.dart';
import 'package:vireo/features/vitality_program/domain/vitality_task.dart';
import 'package:vireo/features/vitality_program/domain/vitality_week.dart';
import 'package:vireo/features/vitality_program/providers/vitality_program_provider.dart';
import 'package:vireo/features/vitality_program/screens/program_complete_screen.dart';
import 'package:vireo/features/vitality_program/widgets/daily_metrics_logger.dart';
import 'package:vireo/features/vitality_program/widgets/vitality_program_theme.dart';
import 'package:vireo/features/vitality_program/widgets/week_report_sheet.dart';
import 'package:vireo/core/theme/vireo_bridge.dart';

class VitalityProgramScreen extends ConsumerWidget {
  const VitalityProgramScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final locale = Localizations.localeOf(context).languageCode;
    final state = ref.watch(vitalityProgramProvider);
    final notifier = ref.read(vitalityProgramProvider.notifier);
    final current = state.currentWeekData;

    if (state.progress.isProgramComplete) {
      return ProgramCompleteScreen(
        onDone: () => Navigator.of(context).pop(),
      );
    }

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: Text(l10n.vitalityProgramTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          _HeroBanner(l10n: l10n, colors: colors),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.gold.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.gold.withValues(alpha: 0.3)),
            ),
            child: Text(
              l10n.vitalityProgramDisclaimer,
              style: const TextStyle(fontSize: 11, height: 1.35),
            ),
          ),
          const SizedBox(height: 20),
          _ProgressRing(
            week: state.progress.currentWeek,
            progress: (current?.completionPercentage ?? 0) / 100,
            l10n: l10n,
            colors: colors,
          ),
          const SizedBox(height: 16),
          _PhaseIndicator(
            activePhase: current?.phase ?? VitalityProgramPhase.foundation,
            l10n: l10n,
            colors: colors,
            locale: locale,
          ),
          const SizedBox(height: 16),
          const DailyMetricsInlineCard(),
          const SizedBox(height: 16),
          if (!state.progress.hasStarted)
            ElevatedButton(
              onPressed: () => notifier.startProgram(),
              child: Text(l10n.vitalityProgramStartCta),
            )
          else if (current != null) ...[
            _CurrentWeekCard(
              week: current,
              locale: locale,
              l10n: l10n,
              colors: colors,
              onToggleTask: notifier.toggleTask,
              onWeekReport: () => WeekReportSheet.show(
                context,
                current.weekNumber,
              ),
            ),
            const SizedBox(height: 12),
            if (current.completionPercentage >= 80 &&
                state.progress.currentWeek < 12)
              OutlinedButton(
                onPressed: () => notifier.unlockNextWeek(),
                child: Text(l10n.vitalityUnlockNextWeek),
              ),
          ],
          const SizedBox(height: 20),
          Text(
            l10n.vitalityProgramAllWeeks,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          ...state.weeks.map(
            (w) => _WeekListTile(
              week: w,
              locale: locale,
              l10n: l10n,
              colors: colors,
              isCurrent: w.weekNumber == state.progress.currentWeek,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.l10n, required this.colors});

  final AppLocalizations l10n;
  final VireoColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            colors.gold.withValues(alpha: 0.85),
            VBridge.cFF6B21A8.withValues(alpha: 0.9),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.vitalityProgramTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              l10n.vitalityProgramSubtitle,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({
    required this.week,
    required this.progress,
    required this.l10n,
    required this.colors,
  });

  final int week;
  final double progress;
  final AppLocalizations l10n;
  final VireoColors colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 72,
          height: 72,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: progress.clamp(0.05, 1.0),
                strokeWidth: 6,
                color: colors.gold,
                backgroundColor: colors.line,
              ),
              Text(
                '$week/12',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.vitalityWeekXOf12(week),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Text(
                l10n.vitalityWeekProgress((progress * 100).round()),
                style: TextStyle(color: colors.textMute),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PhaseIndicator extends StatelessWidget {
  const _PhaseIndicator({
    required this.activePhase,
    required this.l10n,
    required this.colors,
    required this.locale,
  });

  final VitalityProgramPhase activePhase;
  final AppLocalizations l10n;
  final VireoColors colors;
  final String locale;

  @override
  Widget build(BuildContext context) {
    const phases = VitalityProgramPhase.values;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (final phase in phases)
          Expanded(
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: phase == activePhase ? colors.gold : colors.line,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  vitalityPhaseLabel(
                    phase,
                    locale,
                    foundationEn: l10n.vitalityPhaseFoundation,
                    foundationAr: l10n.vitalityPhaseFoundation,
                    optimizationEn: l10n.vitalityPhaseOptimization,
                    optimizationAr: l10n.vitalityPhaseOptimization,
                    peakEn: l10n.vitalityPhasePeak,
                    peakAr: l10n.vitalityPhasePeak,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight:
                        phase == activePhase ? FontWeight.w700 : FontWeight.w400,
                    color:
                        phase == activePhase ? colors.text : colors.textMute,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _CurrentWeekCard extends StatelessWidget {
  const _CurrentWeekCard({
    required this.week,
    required this.locale,
    required this.l10n,
    required this.colors,
    required this.onToggleTask,
    required this.onWeekReport,
  });

  final VitalityWeek week;
  final String locale;
  final AppLocalizations l10n;
  final VireoColors colors;
  final Future<void> Function(String id, bool completed) onToggleTask;
  final VoidCallback onWeekReport;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      tilePadding: EdgeInsets.zero,
      title: Text(
        week.titleFor(locale),
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        week.focusFor(locale),
        style: TextStyle(color: colors.textMute, fontSize: 12),
      ),
      children: [
        for (final task in week.dailyTasks)
          _TaskTile(
            task: task,
            locale: locale,
            colors: colors,
            l10n: l10n,
            onChanged: (v) => onToggleTask(task.id, v ?? false),
          ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: onWeekReport,
          icon: const Icon(Icons.assessment_outlined, size: 18),
          label: Text(l10n.vitalityWeekReport),
        ),
      ],
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.task,
    required this.locale,
    required this.colors,
    required this.l10n,
    required this.onChanged,
  });

  final VitalityTask task;
  final String locale;
  final VireoColors colors;
  final AppLocalizations l10n;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    final catColor = vitalityTaskCategoryColor(task.category, colors);
    final streak = task.completionDates.length;

    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      value: task.isCompleted,
      onChanged: onChanged,
      secondary: Icon(
        vitalityTaskCategoryIcon(task.category),
        color: catColor,
        size: 20,
      ),
      title: Text(
        locale == 'ar' ? task.titleAr : task.titleEn,
        style: const TextStyle(fontSize: 14),
      ),
      subtitle: streak >= 3
          ? Text(
              '🔥 ${l10n.vitalityStreak(streak)}',
              style: TextStyle(color: colors.ember, fontSize: 11),
            )
          : null,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}

class _WeekListTile extends StatelessWidget {
  const _WeekListTile({
    required this.week,
    required this.locale,
    required this.l10n,
    required this.colors,
    required this.isCurrent,
  });

  final VitalityWeek week;
  final String locale;
  final AppLocalizations l10n;
  final VireoColors colors;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: week.isUnlocked
            ? (isCurrent ? colors.gold.withValues(alpha: 0.2) : colors.line)
            : colors.line.withValues(alpha: 0.5),
        child: Text(
          '${week.weekNumber}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: week.isUnlocked ? colors.text : colors.textMute,
          ),
        ),
      ),
      title: Text(
        week.titleFor(locale),
        style: TextStyle(
          fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
          color: week.isUnlocked ? colors.text : colors.textMute,
        ),
      ),
      trailing: week.isCompleted
          ? Icon(Icons.check_circle, color: colors.success, size: 20)
          : week.isUnlocked
              ? Text('${week.completionPercentage.toStringAsFixed(0)}%')
              : Icon(Icons.lock_outline, size: 18, color: colors.textMute),
    );
  }
}

void openVitalityProgram(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => const VitalityProgramScreen()),
  );
}
