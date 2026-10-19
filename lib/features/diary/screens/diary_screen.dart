import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/theme/vireo_decorations.dart';
import 'package:vireo/core/ui/async_state_view.dart';
import 'package:vireo/core/utils/cardio_calorie_calculator.dart';
import 'package:vireo/features/ai_nutrition/screens/ai_scan_screen.dart';
import 'package:vireo/features/cardio/screens/cardio_activity_screen.dart';
import 'package:vireo/features/diary/data/diary_repository_impl.dart';
import 'package:vireo/features/diary/domain/diary_day.dart';
import 'package:vireo/features/diary/domain/diary_entry.dart';
import 'package:vireo/features/diary/providers/diary_provider.dart';
import 'package:vireo/features/progress/screens/weekly_checkin_screen.dart';
import 'package:vireo/features/water/providers/water_daily_goal_provider.dart';
import 'package:vireo/core/theme/vireo_bridge.dart';

class DiaryScreen extends ConsumerWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final selected = ref.watch(diarySelectedDateProvider);
    final diaryAsync = ref.watch(diaryProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: Text(l10n.diaryTitle)),
      body: diaryAsync.when(
        loading: () => AsyncStateView.loading(skeletonRows: 5),
        error: (error, _) => AsyncStateView.error(
          message: l10n.authErrorGeneric,
          onRetry: () => ref.invalidate(diaryProvider),
        ),
        data: (day) => Column(
          children: [
            _WeekSelector(
              selected: selected,
              onSelect: (d) => ref.read(diaryProvider.notifier).selectDate(d),
            ),
            if (day.fromCache && day.lastUpdated != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Text(
                  l10n.diaryLastUpdated(DateFormat.Hm().format(day.lastUpdated!)),
                  style: TextStyle(color: colors.textMute, fontSize: 11),
                ),
              ),
            Expanded(
              child: day.hasTdee
                  ? _DiaryBody(day: day)
                  : _NoTdeeBody(
                      onSetGoals: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const WeeklyCheckInScreen(),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeekSelector extends ConsumerWidget {
  const _WeekSelector({required this.selected, required this.onSelect});

  final DateTime selected;
  final ValueChanged<DateTime> onSelect;

  static const _weekdayEn = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  static const _weekdayAr = ['ح', 'ن', 'ث', 'ر', 'خ', 'ج', 'س'];

  String _dayKey(DateTime day) => '${day.year}-${day.month}-${day.day}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final locale = Localizations.localeOf(context).languageCode;
    final labels = locale == 'ar' ? _weekdayAr : _weekdayEn;
    final days = diaryWeekDaysFor(selected);
    final today = diaryDateOnly(DateTime.now());
    final weekDays = ref.watch(calendarWeekDiaryProvider).valueOrNull ?? [];
    final netByDay = {
      for (final entry in weekDays) _dayKey(entry.date): entry.netBalance,
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: Row(
        children: List.generate(7, (index) {
          final day = days[index];
          final isSelected = diaryIsSameDay(day, selected);
          final isToday = diaryIsSameDay(day, today);
          final net = netByDay[_dayKey(day)];

          final chipColor = isSelected
              ? colors.ember
              : net != null && net > 0
                  ? colors.success.withValues(alpha: 0.22)
                  : net != null && net < 0
                      ? colors.gold.withValues(alpha: 0.22)
                      : colors.surfaceRaised;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Material(
                color: chipColor,
                borderRadius: BorderRadius.circular(VireoDecorations.chipRadius),
                child: InkWell(
                  onTap: () => onSelect(day),
                  borderRadius: BorderRadius.circular(VireoDecorations.chipRadius),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        Text(
                          labels[index],
                          style: TextStyle(
                            color: isSelected ? colors.background : colors.textMute,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${day.day}',
                          style: TextStyle(
                            color: isSelected ? colors.background : colors.text,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (isToday) ...[
                          const SizedBox(height: 2),
                          Text(
                            l10n.diaryToday,
                            style: TextStyle(
                              color: isSelected ? colors.background : colors.gold,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NoTdeeBody extends StatelessWidget {
  const _NoTdeeBody({required this.onSetGoals});

  final VoidCallback onSetGoals;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.flag_outlined, size: 48),
            const SizedBox(height: 16),
            Text(l10n.diarySetGoalsFirst, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onSetGoals, child: Text(l10n.diarySetGoalsCta)),
          ],
        ),
      ),
    );
  }
}

class _DiaryBody extends ConsumerWidget {
  const _DiaryBody({required this.day});

  final DiaryDay day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final locale = Localizations.localeOf(context).languageCode;
    final timeFormat = DateFormat.jm(locale);

    final timeline = <_TimelineItem>[
      ...day.meals.map(
        (m) => _TimelineItem(
          time: m.time,
          icon: '🍽️',
          title: m.name,
          subtitle: l10n.diaryMealCalories(m.calories),
        ),
      ),
      ...day.workouts.map(
        (w) => _TimelineItem(
          time: w.time,
          icon: '🏋️',
          title: _workoutLabel(l10n, w, locale),
          subtitle: l10n.diaryWorkoutSubtitle(w.duration, w.caloriesBurned),
        ),
      ),
      ...day.waterLogs.map(
        (w) => _TimelineItem(
          time: w.time,
          icon: '💧',
          title: l10n.diaryWater,
          subtitle: l10n.diaryWaterAmount(w.amountMl),
        ),
      ),
    ]..sort((a, b) => a.time.compareTo(b.time));

    final netColor = day.netBalance >= 0 ? colors.success : colors.gold;
    final proteinProgress = day.proteinTarget > 0
        ? (day.proteinTotal / day.proteinTarget).clamp(0.0, 1.0)
        : 0.0;
    final waterGoalMl = ref.watch(waterDailyGoalMlProvider);
    final waterProgress = waterGoalMl > 0
        ? (day.waterIntake / waterGoalMl).clamp(0.0, 1.0)
        : 0.0;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: VireoDecorations.premiumCard(colors),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SummaryRow(
                label: l10n.diaryCaloriesIn,
                value: l10n.diaryKcal(day.totalCaloriesIn),
              ),
              _SummaryRow(
                label: l10n.diaryCaloriesOut,
                value: l10n.diaryKcal(day.totalCaloriesOut),
              ),
              _SummaryRow(
                label: l10n.diaryNetBalance,
                value: l10n.diaryKcal(day.netBalance),
                valueColor: netColor,
              ),
              const SizedBox(height: 12),
              Text(l10n.diaryProtein, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: proteinProgress,
                  minHeight: 8,
                  backgroundColor: colors.line,
                  color: colors.recovery,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.diaryProteinProgress(day.proteinTotal, day.proteinTarget),
                style: TextStyle(color: colors.textMute, fontSize: 12),
              ),
              const SizedBox(height: 12),
              Text(l10n.diaryWater, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: waterProgress,
                  minHeight: 8,
                  backgroundColor: colors.line,
                  color: VBridge.cFF5BA4F5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.diaryWaterProgress(day.waterIntake, waterGoalMl),
                style: TextStyle(color: colors.textMute, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (timeline.isEmpty)
          _EmptyDay(
            onAddMeal: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const AiScanScreen()),
              );
            },
            onAddWorkout: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const CardioActivityScreen()),
              );
            },
          )
        else ...[
          Text(l10n.diaryTimeline, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...timeline.map(
            (item) => _TimelineTile(item: item, timeLabel: timeFormat.format(item.time)),
          ),
        ],
      ],
    );
  }

  String _workoutLabel(AppLocalizations l10n, WorkoutEntry entry, String locale) {
    final activity = CardioActivityType.fromStorage(entry.name);
    if (activity.storageKey == entry.name) {
      return switch (activity) {
        CardioActivityType.briskWalking => l10n.cardioBriskWalking,
        CardioActivityType.running => l10n.cardioRunning,
        CardioActivityType.cycling => l10n.cardioCycling,
        CardioActivityType.swimming => l10n.cardioSwimming,
        CardioActivityType.jumpRope => l10n.cardioJumpRope,
        CardioActivityType.hiit => l10n.cardioHiit,
        CardioActivityType.elliptical => l10n.cardioElliptical,
      };
    }
    return entry.name;
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: colors.textMute)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: valueColor ?? colors.text,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineItem {
  const _TimelineItem({
    required this.time,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final DateTime time;
  final String icon;
  final String title;
  final String subtitle;
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({required this.item, required this.timeLabel});

  final _TimelineItem item;
  final String timeLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: VireoDecorations.premiumCard(colors),
      child: Row(
        children: [
          Text(item.icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(item.subtitle, style: TextStyle(color: colors.textMute, fontSize: 12)),
              ],
            ),
          ),
          Text(timeLabel, style: TextStyle(color: colors.textMute, fontSize: 12)),
        ],
      ),
    );
  }
}

class _EmptyDay extends StatelessWidget {
  const _EmptyDay({required this.onAddMeal, required this.onAddWorkout});

  final VoidCallback onAddMeal;
  final VoidCallback onAddWorkout;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: VireoDecorations.premiumCard(colors),
      child: Column(
        children: [
          Icon(Icons.event_note_outlined, size: 48, color: colors.textMute),
          const SizedBox(height: 12),
          Text(l10n.diaryNoEntries, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onAddMeal,
                  child: Text(l10n.diaryAddMeal),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: onAddWorkout,
                  child: Text(l10n.diaryAddWorkout),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
