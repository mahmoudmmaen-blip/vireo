import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/shell_navigation_provider.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/theme/vireo_decorations.dart';
import 'package:vireo/features/diary/providers/diary_provider.dart';

class DiaryCalendarCard extends ConsumerWidget {
  const DiaryCalendarCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final diaryAsync = ref.watch(diaryProvider);

    return diaryAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (error, _) => const SizedBox.shrink(),
      data: (day) {
        final netColor = day.netBalance >= 0 ? colors.success : colors.gold;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => ref.read(shellTabIndexProvider.notifier).goDiary(),
            borderRadius: BorderRadius.circular(VireoDecorations.cardRadius),
            child: Ink(
              padding: const EdgeInsets.all(16),
              decoration: VireoDecorations.premiumCard(colors),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, color: colors.recovery),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.diaryTitle,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Icon(Icons.chevron_right, color: colors.textMute),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _MiniMetric(
                          label: l10n.diaryCaloriesIn,
                          value: l10n.diaryKcal(day.totalCaloriesIn),
                          colors: colors,
                        ),
                      ),
                      Expanded(
                        child: _MiniMetric(
                          label: l10n.diaryCaloriesOut,
                          value: l10n.diaryKcal(day.totalCaloriesOut),
                          colors: colors,
                        ),
                      ),
                      Expanded(
                        child: _MiniMetric(
                          label: l10n.diaryNetBalance,
                          value: l10n.diaryKcal(day.netBalance),
                          colors: colors,
                          valueColor: netColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({
    required this.label,
    required this.value,
    required this.colors,
    this.valueColor,
  });

  final String label;
  final String value;
  final VireoColors colors;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: colors.textMute, fontSize: 11)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 13,
            color: valueColor ?? colors.text,
          ),
        ),
      ],
    );
  }
}
