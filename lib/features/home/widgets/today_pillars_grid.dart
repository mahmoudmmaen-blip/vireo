import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/ring_progress.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/core/services/shell_navigation_provider.dart';
import 'package:vireo/features/home/providers/today_nutrition_provider.dart';
import 'package:vireo/features/home/widgets/sleep_log_sheet.dart';
import 'package:vireo/features/vitality/providers/vitality_provider.dart';
import 'package:vireo/features/workout/screens/workout_flow_screen.dart';

/// Today's pillars — food / workout / sleep.
/// Water lives only on [QuickWaterCard] (single Home water tracker).
class TodayPillarsGrid extends ConsumerWidget {
  const TodayPillarsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.vireoColors;
    final isArabic =
        Localizations.localeOf(context).languageCode.startsWith('ar');

    final nutrition = ref.watch(todayNutritionProvider(isArabic ? 'ar' : 'en'));
    final foodRatio = nutrition.goalKcal > 0
        ? (nutrition.eatenKcal / nutrition.goalKcal).clamp(0.0, 1.0)
        : 0.0;

    final vitality = ref.watch(vitalityDailyLogProvider);
    final workoutDone = vitality.workoutCompleted;

    final sleepHours = vitality.sleepHours ?? 0.0;
    final sleepRatio = (sleepHours / 8.0).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 12, 4, 8),
          child: Text(
            isArabic ? 'اليوم' : 'Today\'s Pillars',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.text,
                ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _PillarCard(
                title: isArabic ? 'السعرات' : 'Food',
                subtitle: '${nutrition.eatenKcal}/${nutrition.goalKcal}',
                icon: Icons.restaurant_rounded,
                accentColor: colors.ember,
                progress: foodRatio,
                onTap: () =>
                    ref.read(shellTabIndexProvider.notifier).goNutrition(),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _PillarCard(
                title: isArabic ? 'التمرين' : 'Workout',
                subtitle: workoutDone
                    ? (isArabic ? 'مكتمل ✅' : 'Done')
                    : (isArabic ? 'لسه' : 'Not yet'),
                icon: Icons.fitness_center_rounded,
                accentColor: const Color(0xFF8B5CF6),
                progress: workoutDone ? 1.0 : 0.0,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const WorkoutFlowScreen(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _PillarCard(
                title: isArabic ? 'النوم' : 'Sleep',
                subtitle: sleepHours > 0
                    ? '$sleepHours س'
                    : (isArabic ? 'سجّل' : 'Log'),
                icon: Icons.bedtime_rounded,
                accentColor: const Color(0xFF6366F1),
                progress: sleepRatio,
                onTap: () => showSleepLogSheet(context, ref),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PillarCard extends StatelessWidget {
  const _PillarCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.progress,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final double progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return Pressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(VRadius.lg),
          border: Border.all(color: colors.line.withValues(alpha: 0.6)),
        ),
        constraints: const BoxConstraints(minHeight: 96),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: accentColor, size: 17),
                ),
                RingProgress(
                  progress: progress,
                  size: 24,
                  stroke: 3.5,
                  color: accentColor,
                  trackColor: colors.line.withValues(alpha: 0.4),
                  child: const SizedBox.shrink(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 1),
            Text(
              subtitle,
              style: TextStyle(
                color: colors.textMute,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
