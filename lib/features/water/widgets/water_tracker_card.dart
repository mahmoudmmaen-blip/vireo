import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/theme/vireo_decorations.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/ramadan/providers/ramadan_settings_provider.dart';
import 'package:vireo/features/ramadan/services/ramadan_schedule_service.dart';
import 'package:vireo/features/water/providers/water_cup_size_provider.dart';
import 'package:vireo/features/water/providers/water_daily_goal_provider.dart';
import 'package:vireo/features/water/providers/water_tracker_provider.dart';
import 'package:vireo/core/theme/vireo_bridge.dart';

class WaterTrackerCard extends ConsumerStatefulWidget {
  const WaterTrackerCard({super.key});

  @override
  ConsumerState<WaterTrackerCard> createState() => _WaterTrackerCardState();
}

class _WaterTrackerCardState extends ConsumerState<WaterTrackerCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fillCtrl;
  bool _canUndo = false;

  @override
  void initState() {
    super.initState();
    _fillCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
  }

  @override
  void dispose() {
    _fillCtrl.dispose();
    super.dispose();
  }

  Future<void> _add([int? ml]) async {
    HapticFeedback.lightImpact();
    final added = ml == null
        ? await ref.read(waterTrackerProvider.notifier).addGlass()
        : await ref.read(waterTrackerProvider.notifier).addMl(ml);
    if (!added || !mounted) return;
    setState(() => _canUndo = true);
    _fillCtrl.forward(from: 0);
  }

  Future<void> _undo() async {
    await ref.read(waterTrackerProvider.notifier).undoLastOrCup();
    if (mounted) setState(() => _canUndo = false);
  }

  Future<void> _quickAmounts() async {
    final l10n = AppLocalizations.of(context);
    final cup = ref.read(waterCupSizeProvider);
    final customCtrl = TextEditingController();
    final picked = await showModalBottomSheet<int>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(VSpace.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.waterQuickAmountsTitle,
                    style: Theme.of(ctx).textTheme.titleMedium),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final ml in kQuickWaterAmounts)
                      ActionChip(
                        label: Text('$ml ml'),
                        onPressed: () => Navigator.pop(ctx, ml),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(l10n.waterDefaultCupTitle,
                    style: Theme.of(ctx).textTheme.titleSmall),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final ml in kQuickWaterAmounts)
                      ChoiceChip(
                        label: Text('$ml'),
                        selected: cup == ml,
                        onSelected: (_) async {
                          await ref
                              .read(waterCupSizeProvider.notifier)
                              .setCupMl(ml);
                          if (ctx.mounted) Navigator.pop(ctx);
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: customCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.waterCustomMl,
                    suffixText: 'ml',
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: () {
                    final v = int.tryParse(customCtrl.text.trim());
                    if (v != null && v > 0) Navigator.pop(ctx, v);
                  },
                  child: Text(l10n.waterAddCustom),
                ),
              ],
            ),
          ),
        );
      },
    );
    customCtrl.dispose();
    if (picked != null) await _add(picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final ml = ref.watch(waterTrackerProvider);
    final progress = ref.watch(waterTrackerProgressProvider);
    final cup = ref.watch(waterCupSizeProvider);
    final goalMl = ref.watch(waterDailyGoalMlProvider);
    final isRamadan = ref.watch(ramadanSettingsProvider).isEnabled;
    final liters = ml / 1000.0;
    final goalLiters = goalMl / 1000.0;
    final split = isRamadan ? RamadanScheduleService.distributeWaterMl(goalMl) : null;
    final cupMlSafe = cup > 0 ? cup : 250;
    String? ramadanSplitLine;
    if (split != null) {
      int cups(int partMl) => (partMl / cupMlSafe).round().clamp(0, 99);
      ramadanSplitLine = l10n.ramadanWaterGoalSplit(
        cups(split['iftar']!),
        cups(split['evening']!),
        cups(split['suhoor']!),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: VireoDecorations.premiumCard(colors),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.water_drop_outlined, color: VBridge.cFF5BA4F5),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isRamadan ? l10n.ramadanWaterTrackerQuestion : l10n.waterTrackerTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              if (_canUndo)
                TextButton(onPressed: _undo, child: Text(l10n.uxUndo)),
            ],
          ),
          const SizedBox(height: 12),
          AnimatedBuilder(
            animation: _fillCtrl,
            builder: (context, _) {
              final boost = Curves.easeOut.transform(_fillCtrl.value) * 0.04;
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: (progress + boost).clamp(0.0, 1.0),
                  minHeight: 12,
                  backgroundColor: colors.line,
                  color: VBridge.cFF5BA4F5,
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          Text(
            l10n.waterTrackerSummary(
              double.parse(liters.toStringAsFixed(1)),
              double.parse(goalLiters.toStringAsFixed(1)),
              (progress * 100).round(),
            ),
            style: TextStyle(color: colors.textMute, fontSize: 13),
          ),
          if (ramadanSplitLine != null) ...[
            const SizedBox(height: 6),
            Text(
              ramadanSplitLine,
              style: TextStyle(color: colors.textMute, fontSize: 12, height: 1.35),
            ),
          ],
          const SizedBox(height: 14),
          SizedBox(
            height: 56,
            child: FilledButton.icon(
              onPressed: () => _add(),
              onLongPress: _quickAmounts,
              icon: const Icon(Icons.add),
              label: Text(l10n.waterAddOneGlass(cup)),
              style: FilledButton.styleFrom(
                backgroundColor: VBridge.cFF5BA4F5,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.waterLongPressHint,
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.textMute, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// Keep wave painter available for other screens if needed.
class WaterWavePainter extends CustomPainter {
  WaterWavePainter({required this.progress, required this.t});
  final double progress;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = VBridge.cFF5BA4F5.withValues(alpha: 0.35);
    final path = Path()..moveTo(0, size.height);
    for (var x = 0.0; x <= size.width; x += 4) {
      final y = size.height * (1 - progress) +
          math.sin((x / size.width * 4 * math.pi) + t * math.pi * 2) * 3;
      path.lineTo(x, y);
    }
    path
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WaterWavePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.t != t;
}
