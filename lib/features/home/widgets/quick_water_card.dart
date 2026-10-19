import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/ramadan/providers/ramadan_settings_provider.dart';
import 'package:vireo/features/water/providers/water_daily_goal_provider.dart';
import 'package:vireo/features/water/providers/water_goal_override_provider.dart';
import 'package:vireo/features/water/providers/water_tracker_provider.dart';
import 'package:vireo/features/water/widgets/water_tracker_card.dart';

/// Home water card: 1-tap glass/bottle, wave progress, Ramadan copy.
class QuickWaterCard extends ConsumerStatefulWidget {
  const QuickWaterCard({super.key});

  @override
  ConsumerState<QuickWaterCard> createState() => _QuickWaterCardState();
}

class _QuickWaterCardState extends ConsumerState<QuickWaterCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _wave;

  @override
  void initState() {
    super.initState();
    _wave = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _wave.dispose();
    super.dispose();
  }

  Future<void> _add(int ml) async {
    HapticFeedback.selectionClick();
    await ref.read(waterTrackerProvider.notifier).addMl(ml);
  }

  Future<void> _customMl() async {
    final isArabic =
        Localizations.localeOf(context).languageCode.startsWith('ar');
    final controller = TextEditingController(text: '250');
    final ml = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isArabic ? 'كمية مخصصة' : 'Custom amount'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            suffixText: isArabic ? 'مل' : 'ml',
            hintText: isArabic ? 'مثلاً 200' : 'e.g. 200',
          ),
          onSubmitted: (v) =>
              Navigator.pop(ctx, int.tryParse(v.trim())),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(ctx, int.tryParse(controller.text.trim())),
            child: Text(isArabic ? 'إضافة' : 'Add'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (ml != null && ml > 0 && ml <= 2000) {
      await _add(ml);
    }
  }

  Future<void> _editGoal() async {
    final isArabic =
        Localizations.localeOf(context).languageCode.startsWith('ar');
    final current = ref.read(waterDailyGoalMlProvider);
    final controller = TextEditingController(text: '$current');
    final ml = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isArabic ? 'هدف الماء اليومي' : 'Daily water goal'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            suffixText: isArabic ? 'مل (افتراضي 2000)' : 'ml (default 2000)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(waterGoalOverrideMlProvider.notifier).clear();
              if (ctx.mounted) Navigator.pop(ctx, -1);
            },
            child: Text(isArabic ? 'تلقائي' : 'Auto'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(ctx, int.tryParse(controller.text.trim())),
            child: Text(isArabic ? 'حفظ' : 'Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (ml == null || ml == -1) {
      ref.invalidate(waterDailyGoalMlProvider);
      return;
    }
    if (ml >= 1000 && ml <= 5000) {
      await ref.read(waterGoalOverrideMlProvider.notifier).setMl(ml);
    }
  }

  void _openSheet() {
    final colors = context.vireoColors;
    showModalBottomSheet<void>(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final l10n = AppLocalizations.of(context);
    final isArabic =
        Localizations.localeOf(context).languageCode.startsWith('ar');
    final isRamadan = ref.watch(ramadanSettingsProvider).isEnabled;
    final waterMl = ref.watch(waterTrackerProvider);
    final goalMl = ref.watch(waterDailyGoalMlProvider);
    final progress = goalMl > 0 ? (waterMl / goalMl).clamp(0.0, 1.0) : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: VireoCard(
        onTap: _openSheet,
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 52,
                  height: 52,
                  child: AnimatedBuilder(
                    animation: _wave,
                    builder: (context, _) {
                      return CustomPaint(
                        painter: WaterWavePainter(
                          progress: progress,
                          t: _wave.value,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.water_drop_rounded,
                            size: 22,
                            color: VMacro.water.withValues(
                              alpha: 0.55 + progress * 0.45,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isRamadan
                            ? l10n.ramadanWaterTrackerQuestion
                            : (isArabic ? 'الماء والترطيب' : 'Hydration'),
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '≈ ${(waterMl / 1000).toStringAsFixed(2)} / ${(goalMl / 1000).toStringAsFixed(1)} ${isArabic ? 'لتر' : 'L'}',
                        style: TextStyle(
                          color: colors.textMute,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: isArabic ? 'تعديل الهدف' : 'Edit goal',
                  onPressed: _editGoal,
                  icon: Icon(
                    Icons.tune_rounded,
                    color: colors.textMute,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _QuickAddChip(
                    label: isArabic ? 'كوباية 250' : 'Cup 250',
                    onTap: () => _add(250),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _QuickAddChip(
                    label: isArabic ? 'زجاجة 500' : 'Bottle 500',
                    onTap: () => _add(500),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _QuickAddChip(
                    label: isArabic ? 'مخصص' : 'Custom',
                    onTap: _customMl,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAddChip extends StatelessWidget {
  const _QuickAddChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: VMacro.water.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: VMacro.water,
              fontWeight: FontWeight.w800,
              fontSize: 12.5,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
