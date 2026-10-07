import 'package:flutter/material.dart';
import 'package:vireo/core/animations/vireo_animations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';

/// Shimmer skeleton placeholder when exercise Lottie/GIF is unavailable.
class ExerciseMediaPlaceholder extends StatefulWidget {
  const ExerciseMediaPlaceholder({
    super.key,
    required this.exerciseName,
    this.compact = false,
  });

  final String exerciseName;
  final bool compact;

  @override
  State<ExerciseMediaPlaceholder> createState() =>
      _ExerciseMediaPlaceholderState();
}

class _ExerciseMediaPlaceholderState extends State<ExerciseMediaPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmer;
  bool _animationConfigured = false;

  @override
  void initState() {
    super.initState();
    _shimmer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_animationConfigured) return;
    _animationConfigured = true;
    if (vireoAnimationsEnabled(context)) {
      _shimmer.repeat();
    } else {
      _shimmer.value = 0.5;
    }
  }

  @override
  void dispose() {
    _shimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final iconSize = widget.compact ? 36.0 : 64.0;

    return AnimatedBuilder(
      animation: _shimmer,
      builder: (context, _) {
        return CustomPaint(
          painter: _ShimmerPainter(
            progress: _shimmer.value,
            base: colors.surfaceRaised,
            highlight: colors.ember.withValues(alpha: 0.18),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.fitness_center, size: iconSize, color: colors.ember),
                if (!widget.compact) ...[
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      widget.exerciseName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colors.text,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ShimmerPainter extends CustomPainter {
  _ShimmerPainter({
    required this.progress,
    required this.base,
    required this.highlight,
  });

  final double progress;
  final Color base;
  final Color highlight;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = base);

    final bandWidth = size.width * 0.35;
    final left = (size.width + bandWidth) * progress - bandWidth;
    final gradient = LinearGradient(
      colors: [
        base,
        highlight,
        base,
      ],
      stops: const [0.35, 0.5, 0.65],
    );
    canvas.drawRect(
      Rect.fromLTWH(left, 0, bandWidth, size.height),
      Paint()..shader = gradient.createShader(Rect.fromLTWH(left, 0, bandWidth, size.height)),
    );
  }

  @override
  bool shouldRepaint(_ShimmerPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
