import 'package:flutter/material.dart';

/// Vireo brand mark — orange ring (#E8763C) with centered dot.
/// Rendered with CustomPaint so it always shows (no SVG loader dependency).
class VireoLogo extends StatelessWidget {
  const VireoLogo({
    super.key,
    this.size = 64,
    this.color = const Color(0xFFE8763C),
    this.showBackground = false,
    this.backgroundColor = const Color(0xFF0D0F12),
  });

  static const assetPath = 'assets/images/vireo_logo.svg';

  final double size;
  final Color color;
  final bool showBackground;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _VireoLogoPainter(
          color: color,
          showBackground: showBackground,
          backgroundColor: backgroundColor,
        ),
      ),
    );
  }
}

class _VireoLogoPainter extends CustomPainter {
  _VireoLogoPainter({
    required this.color,
    required this.showBackground,
    required this.backgroundColor,
  });

  final Color color;
  final bool showBackground;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (showBackground) {
      canvas.drawRect(
        Offset.zero & size,
        Paint()..color = backgroundColor,
      );
    }

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * 0.34;
    final stroke = size.shortestSide * 0.08;
    final dotRadius = size.shortestSide * 0.11;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );

    canvas.drawCircle(center, dotRadius, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _VireoLogoPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.showBackground != showBackground ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
