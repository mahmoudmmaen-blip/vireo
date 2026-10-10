import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:vireo/core/theme/vireo_colors.dart';

/// Pulsing radar + cycling food labels while Gemini analyzes a meal photo.
class MealScanLoadingOverlay extends StatefulWidget {
  const MealScanLoadingOverlay({super.key, this.imageBytes});

  final Uint8List? imageBytes;

  @override
  State<MealScanLoadingOverlay> createState() => _MealScanLoadingOverlayState();
}

class _MealScanLoadingOverlayState extends State<MealScanLoadingOverlay>
    with SingleTickerProviderStateMixin {
  static const _cues = [
    'أرز…',
    'فراخ…',
    'سلطة…',
    'عيش…',
    'rice…',
    'chicken…',
    'salad…',
  ];

  late final AnimationController _controller;
  int _cueIndex = 0;
  Timer? _cueTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
    _cueTimer = Timer.periodic(const Duration(milliseconds: 900), (_) {
      if (!mounted) return;
      setState(() => _cueIndex = (_cueIndex + 1) % _cues.length);
    });
  }

  @override
  void dispose() {
    _cueTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (widget.imageBytes != null)
          Image.memory(
            widget.imageBytes!,
            fit: BoxFit.cover,
          )
        else
          ColoredBox(color: colors.surfaceRaised),
        Container(color: colors.background.withValues(alpha: 0.45)),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return CustomPaint(
                    size: const Size(180, 180),
                    painter: _RadarPainter(
                      progress: _controller.value,
                      color: colors.ember,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                child: Text(
                  _cues[_cueIndex],
                  key: ValueKey(_cueIndex),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RadarPainter extends CustomPainter {
  _RadarPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    for (var i = 1; i <= 3; i++) {
      final ringPaint = Paint()
        ..color = color.withValues(alpha: 0.12 + i * 0.06)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawCircle(center, radius * i / 3, ringPaint);
    }

    final sweep = Paint()
      ..shader = SweepGradient(
        colors: [
          color.withValues(alpha: 0),
          color.withValues(alpha: 0.55),
        ],
        transform: GradientRotation(progress * 2 * math.pi),
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, sweep);

    final pulse = (math.sin(progress * 2 * math.pi) + 1) / 2;
    final dotPaint = Paint()..color = color.withValues(alpha: 0.5 + pulse * 0.5);
    canvas.drawCircle(center, 6 + pulse * 4, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
