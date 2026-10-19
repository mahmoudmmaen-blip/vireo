import 'dart:io';
import 'dart:ui' as ui show ImageByteFormat;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/home/mascot/domain/mascot_state.dart';
import 'package:vireo/features/progress/providers/progress_extended_provider.dart';
import 'package:vireo/core/theme/vireo_bridge.dart';

/// P40 story card (1080×1920): weekly burn balance — steps, mascot, streak, logo.
class WeeklyBurnShareScreen extends ConsumerStatefulWidget {
  const WeeklyBurnShareScreen({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.push<void>(
      context,
      MaterialPageRoute<void>(builder: (_) => const WeeklyBurnShareScreen()),
    );
  }

  @override
  ConsumerState<WeeklyBurnShareScreen> createState() => _WeeklyBurnShareScreenState();
}

class _WeeklyBurnShareScreenState extends ConsumerState<WeeklyBurnShareScreen> {
  final GlobalKey _cardKey = GlobalKey();
  bool _includeWeight = false;
  bool _sharing = false;

  Future<void> _share() async {
    if (_sharing) return;
    setState(() => _sharing = true);
    try {
      final boundary = _cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;
      final file = File(
        '${(await getTemporaryDirectory()).path}/vireo_weekly_burn_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(byteData.buffer.asUint8List());
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'image/png')],
        text: l10n.weeklyBurnShareCaption,
      );
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final report = ref.watch(weeklyProgressReportDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.weeklyBurnShareTitle),
      ),
      body: report.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(l10n.weeklyProgressShareFailed)),
        data: (data) {
          final math = MascotFillMath(consumedKcal: 0, targetKcal: 2000);
          final mascotEmoji = mascotExpressionEmoji(math.expressionAt(DateTime.now()));

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(l10n.weeklyBurnShareSubtitle, style: TextStyle(color: colors.textMute)),
              const SizedBox(height: 16),
              CheckboxListTile(
                value: _includeWeight,
                onChanged: (v) => setState(() => _includeWeight = v ?? false),
                title: Text(l10n.weeklyBurnShareIncludeWeight),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 12),
              Center(
                child: RepaintBoundary(
                  key: _cardKey,
                  child: WeeklyBurnShareCard(
                    title: l10n.weeklyBurnShareTitle,
                    stepsTotal: data.totalWeeklySteps,
                    streakDays: data.streakDays,
                    mascotEmoji: mascotEmoji,
                    includeWeight: _includeWeight,
                    weightDeltaKg: data.trendWeightChangeKg,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _sharing ? null : _share,
                icon: _sharing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.share_rounded),
                label: Text(l10n.weeklyBurnShareAction),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Fixed 9:16 layout for PNG export (logical 360×640 → pixelRatio 3 ≈ 1080×1920).
class WeeklyBurnShareCard extends StatelessWidget {
  const WeeklyBurnShareCard({
    super.key,
    required this.title,
    required this.stepsTotal,
    required this.streakDays,
    required this.mascotEmoji,
    required this.includeWeight,
    required this.weightDeltaKg,
  });

  final String title;
  final int stepsTotal;
  final int streakDays;
  final String mascotEmoji;
  final bool includeWeight;
  final double weightDeltaKg;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      height: 640,
      padding: const EdgeInsets.all(28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [VBridge.cFF0F172A, VBridge.cFF1E1B4B, VBridge.cFF020617],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'VIREO',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                  fontSize: 16,
                ),
              ),
              Text(mascotEmoji, style: const TextStyle(fontSize: 36)),
            ],
          ),
          const Spacer(),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 24),
          _MetricBlock(
            label: AppLocalizations.of(context).weeklyBurnShareStepsLabel,
            value: '$stepsTotal',
          ),
          const SizedBox(height: 14),
          _MetricBlock(
            label: AppLocalizations.of(context).weeklyBurnShareStreakLabel,
            value: '$streakDays 🔥',
          ),
          if (includeWeight) ...[
            const SizedBox(height: 14),
            _MetricBlock(
              label: AppLocalizations.of(context).weeklyBurnShareWeightLabel,
              value:
                  '${weightDeltaKg >= 0 ? '+' : ''}${weightDeltaKg.toStringAsFixed(1)} kg',
            ),
          ],
          const Spacer(),
          const Text(
            'vireo.app',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white38, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _MetricBlock extends StatelessWidget {
  const _MetricBlock({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
