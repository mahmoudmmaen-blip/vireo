import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vireo/core/animations/vireo_animations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';

/// Slow-drifting gradient mesh — 30s loop, 25% opacity.
class GradientMeshBackground extends StatefulWidget {
  const GradientMeshBackground({super.key, required this.child});

  final Widget child;

  @override
  State<GradientMeshBackground> createState() => _GradientMeshBackgroundState();
}

class _GradientMeshBackgroundState extends State<GradientMeshBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _animationConfigured = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_animationConfigured) return;
    _animationConfigured = true;
    if (vireoAnimationsEnabled(context)) {
      _controller.repeat();
    } else {
      _controller.value = 0.5;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              painter: _MeshPainter(
                t: _controller.value,
                accent: colors.ember,
                secondary: colors.gold,
                recovery: colors.recovery,
              ),
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

class _MeshPainter extends CustomPainter {
  _MeshPainter({
    required this.t,
    required this.accent,
    required this.secondary,
    required this.recovery,
  });

  final double t;
  final Color accent;
  final Color secondary;
  final Color recovery;

  @override
  void paint(Canvas canvas, Size size) {
    final points = [
      Offset(
        size.width * (0.2 + 0.08 * math.sin(t * math.pi * 2)),
        size.height * (0.15 + 0.06 * math.cos(t * math.pi * 2)),
      ),
      Offset(
        size.width * (0.8 + 0.06 * math.cos(t * math.pi * 2 + 1)),
        size.height * (0.2 + 0.08 * math.sin(t * math.pi * 2 + 0.5)),
      ),
      Offset(
        size.width * (0.3 + 0.07 * math.sin(t * math.pi * 2 + 2)),
        size.height * (0.75 + 0.05 * math.cos(t * math.pi * 2 + 1.2)),
      ),
      Offset(
        size.width * (0.85 + 0.05 * math.cos(t * math.pi * 2 + 0.8)),
        size.height * (0.8 + 0.07 * math.sin(t * math.pi * 2 + 1.5)),
      ),
    ];

    final colors = [accent, secondary, recovery, accent.withValues(alpha: 0.6)];
    for (var i = 0; i < points.length; i++) {
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            colors[i].withValues(alpha: 0.25),
            colors[i].withValues(alpha: 0),
          ],
        ).createShader(
          Rect.fromCircle(center: points[i], radius: size.width * 0.45),
        );
      canvas.drawCircle(points[i], size.width * 0.45, paint);
    }
  }

  @override
  bool shouldRepaint(_MeshPainter oldDelegate) => oldDelegate.t != t;
}

/// 20 floating particles rising upward.
class FloatingParticleBackground extends StatefulWidget {
  const FloatingParticleBackground({super.key, required this.child});

  final Widget child;

  @override
  State<FloatingParticleBackground> createState() =>
      _FloatingParticleBackgroundState();
}

class _FloatingParticleBackgroundState extends State<FloatingParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;
  bool _animationConfigured = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    final rng = math.Random(42);
    _particles = List.generate(20, (i) {
      return _Particle(
        x: rng.nextDouble(),
        speed: 0.15 + rng.nextDouble() * 0.35,
        size: 2 + rng.nextDouble() * 4,
        opacity: 0.08 + rng.nextDouble() * 0.12,
        phase: rng.nextDouble(),
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_animationConfigured) return;
    _animationConfigured = true;
    if (vireoAnimationsEnabled(context)) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = context.vireoColors.ember;

    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              painter: _ParticlePainter(
                particles: _particles,
                t: _controller.value,
                color: accent,
              ),
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

class _Particle {
  const _Particle({
    required this.x,
    required this.speed,
    required this.size,
    required this.opacity,
    required this.phase,
  });

  final double x;
  final double speed;
  final double size;
  final double opacity;
  final double phase;
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter({
    required this.particles,
    required this.t,
    required this.color,
  });

  final List<_Particle> particles;
  final double t;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final y = size.height * (1 - ((t * p.speed + p.phase) % 1.0));
      final paint = Paint()
        ..color = color.withValues(alpha: p.opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      canvas.drawCircle(Offset(p.x * size.width, y), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter oldDelegate) =>
      oldDelegate.t != t;
}
