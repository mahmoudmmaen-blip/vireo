import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/theme/vireo_decorations.dart';
import 'package:vireo/features/water/providers/water_tracker_provider.dart';

class WaterTrackerCard extends ConsumerWidget {
  const WaterTrackerCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final ml = ref.watch(waterTrackerProvider);
    final progress = ref.watch(waterTrackerProgressProvider);
    final filled = ref.watch(waterTrackerFilledGlassesProvider);
    final notifier = ref.read(waterTrackerProvider.notifier);

    final liters = ml / 1000.0;
    final goalLiters = waterDailyGoalMl / 1000.0;
    final pct = (progress * 100).round();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: VireoDecorations.premiumCard(colors),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.water_drop_outlined, color: Color(0xFF5BA4F5)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.waterTrackerTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 10,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ColoredBox(color: colors.line),
                  FractionallySizedBox(
                    alignment: AlignmentDirectional.centerStart,
                    widthFactor: progress.clamp(0.0, 1.0),
                    child: const ColoredBox(color: Color(0xFF5BA4F5)),
                  ),
                  if (progress > 0.05)
                    _WaveOverlay(progress: progress),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.waterTrackerSummary(
              double.parse(liters.toStringAsFixed(1)),
              double.parse(goalLiters.toStringAsFixed(1)),
              pct,
            ),
            style: TextStyle(color: colors.textMute, fontSize: 13),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(waterGlassCount, (index) {
              final isFilled = index < filled;
              return InkWell(
                onTap: () => notifier.toggleGlass(index),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Icon(
                    isFilled ? Icons.local_drink : Icons.local_drink_outlined,
                    size: 26,
                    color: isFilled
                        ? const Color(0xFF5BA4F5)
                        : colors.textMute.withValues(alpha: 0.45),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _WaveOverlay extends StatelessWidget {
  const _WaveOverlay({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _WavePainter(progress: progress),
      size: Size.infinite,
    );
  }
}

class _WavePainter extends CustomPainter {
  _WavePainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.22)
      ..style = PaintingStyle.fill;

    final path = Path()..moveTo(0, size.height);
    final fillWidth = size.width * progress.clamp(0.0, 1.0);
    for (var x = 0.0; x <= fillWidth; x += 3) {
      final y = size.height * 0.35 +
          math.sin((x / size.width) * math.pi * 4) * 1.5;
      path.lineTo(x, y);
    }
    path
      ..lineTo(fillWidth, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
