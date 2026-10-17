import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/ramadan/providers/ramadan_settings_provider.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/ring_progress.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/water/providers/water_daily_goal_provider.dart';
import 'package:vireo/features/water/providers/water_tracker_provider.dart';
import 'package:vireo/features/water/widgets/water_tracker_card.dart';

/// 1-tap quick water card for Home.
class QuickWaterCard extends ConsumerWidget {
  const QuickWaterCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.vireoColors;
    final l10n = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');
    final isRamadan = ref.watch(ramadanSettingsProvider).isEnabled;
    final waterMl = ref.watch(waterTrackerProvider);
    final goalMl = ref.watch(waterDailyGoalMlProvider);
    final progress = goalMl > 0 ? (waterMl / goalMl).clamp(0.0, 1.0) : 0.0;

    return VireoCard(
      onTap: () => showModalBottomSheet<void>(
        context: context,
        backgroundColor: colors.surface,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) => const SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: WaterTrackerCard(),
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: VSpace.md, vertical: VSpace.sm + 2),
      child: Row(
        children: [
          RingProgress(
            progress: progress,
            size: 44,
            stroke: 5,
            color: VMacro.water,
            child: const Icon(Icons.water_drop_rounded, size: 20, color: VMacro.water),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isRamadan
                      ? l10n.ramadanWaterTrackerQuestion
                      : (isArabic ? 'الماء والترطيب' : 'Hydration'),
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${(waterMl / 1000).toStringAsFixed(2)} / ${(goalMl / 1000).toStringAsFixed(1)} ${isArabic ? 'لتر' : 'L'}',
                  style: TextStyle(color: colors.textMute, fontSize: 12.5),
                ),
              ],
            ),
          ),
          FilledButton.tonal(
            onPressed: () async {
              HapticFeedback.selectionClick();
              await ref.read(waterTrackerProvider.notifier).addGlass();
            },
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              '+250 ml',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
