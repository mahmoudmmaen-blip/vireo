import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vireo/core/services/hive_service.dart';

enum CelebrationType {
  water,
  protein,
  steps,
  workout,
}

abstract final class CelebrationService {
  static String _dateKey([DateTime? dt]) {
    final d = dt ?? DateTime.now();
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$m-$day';
  }

  static bool hasCelebratedToday(CelebrationType type) {
    if (!HiveService.isInitialized) return false;
    final key = 'celebration_${type.name}_${_dateKey()}';
    return HiveService.settingsBox.get(key) == true;
  }

  static Future<void> markCelebratedToday(CelebrationType type) async {
    if (!HiveService.isInitialized) return;
    final key = 'celebration_${type.name}_${_dateKey()}';
    await HiveService.settingsBox.put(key, true);
  }

  static Future<void> trigger(
    BuildContext context, {
    required CelebrationType type,
    required String message,
  }) async {
    if (hasCelebratedToday(type)) return;
    await markCelebratedToday(type);

    HapticFeedback.mediumImpact();

    if (!context.mounted) return;
    _showConfettiOverlay(context);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.stars_rounded, color: Colors.amber),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
  }

  static void _showConfettiOverlay(BuildContext context) {
    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => _ConfettiParticleOverlay(
        onFinished: () {
          entry.remove();
        },
      ),
    );
    overlay.insert(entry);
  }
}

class _ConfettiParticleOverlay extends StatefulWidget {
  const _ConfettiParticleOverlay({required this.onFinished});
  final VoidCallback onFinished;

  @override
  State<_ConfettiParticleOverlay> createState() => _ConfettiParticleOverlayState();
}

class _ConfettiParticleOverlayState extends State<_ConfettiParticleOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    final random = Random();
    final colors = [
      const Color(0xFFE8763C), // Ember
      const Color(0xFF1976D2), // Ocean
      const Color(0xFF2E7D32), // Forest
      const Color(0xFF7B1FA2), // Royal
      const Color(0xFFFFD700), // Gold
      const Color(0xFFFF4081), // Pink
    ];

    _particles = List.generate(45, (i) {
      return _Particle(
        x: random.nextDouble(),
        y: -0.1 - (random.nextDouble() * 0.3),
        speedY: 0.4 + (random.nextDouble() * 0.6),
        speedX: (random.nextDouble() - 0.5) * 0.3,
        rotation: random.nextDouble() * 2 * pi,
        rotationSpeed: (random.nextDouble() - 0.5) * 4 * pi,
        color: colors[random.nextInt(colors.length)],
        size: 7.0 + random.nextDouble() * 6.0,
      );
    });

    _controller.forward().then((_) {
      if (mounted) widget.onFinished();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final progress = _controller.value;
          final size = MediaQuery.sizeOf(context);
          return CustomPaint(
            size: size,
            painter: _ConfettiPainter(
              particles: _particles,
              progress: progress,
            ),
          );
        },
      ),
    );
  }
}

class _Particle {
  _Particle({
    required this.x,
    required this.y,
    required this.speedY,
    required this.speedX,
    required this.rotation,
    required this.rotationSpeed,
    required this.color,
    required this.size,
  });

  final double x;
  final double y;
  final double speedY;
  final double speedX;
  final double rotation;
  final double rotationSpeed;
  final Color color;
  final double size;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.particles, required this.progress});
  final List<_Particle> particles;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final opacity = progress > 0.8 ? (1.0 - progress) / 0.2 : 1.0;

    for (final p in particles) {
      final currentY = (p.y + p.speedY * progress) * size.height;
      final currentX = (p.x + p.speedX * progress) * size.width;
      final currentRot = p.rotation + p.rotationSpeed * progress;

      if (currentY > size.height + 20) continue;

      final paint = Paint()
        ..color = p.color.withValues(alpha: opacity.clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(currentX, currentY);
      canvas.rotate(currentRot);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: p.size,
          height: p.size * 0.6,
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}
