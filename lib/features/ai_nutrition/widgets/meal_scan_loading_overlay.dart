import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';

/// Photo with an animated scan line, rotating nutrition tips, and a 25s timeout retry button.
class MealScanLoadingOverlay extends StatefulWidget {
  const MealScanLoadingOverlay({
    super.key,
    this.imageBytes,
    this.onRetry,
    this.onCancel,
  });

  final Uint8List? imageBytes;
  final VoidCallback? onRetry;
  final VoidCallback? onCancel;

  @override
  State<MealScanLoadingOverlay> createState() => _MealScanLoadingOverlayState();
}

class _MealScanLoadingOverlayState extends State<MealScanLoadingOverlay>
    with SingleTickerProviderStateMixin {
  static const _tips = [
    '💡 نصيحة: تصوير الطبق من زاوية 45° بوضوح بيساعد على دقة تقدير الحجم.',
    'بنتعرّف على المكونات والأصناف…',
    '💡 نصيحة: البروتين في كل وجبة بيساعد على الشبع وبناء العضلات.',
    'بنحسب السعرات والماكروز بدقة…',
    '💡 نصيحة: طبق السلطة أو الخضار بيضيف ألياف ومغذيات بسعرات قليلة.',
    'بنراجع طريقة الطهي والكميات…',
  ];

  late final AnimationController _scanController;
  int _tipIndex = 0;
  Timer? _tipTimer;
  Timer? _timeoutTimer;
  bool _timedOut = false;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _tipTimer = Timer.periodic(const Duration(milliseconds: 3200), (_) {
      if (!mounted) return;
      setState(() => _tipIndex = (_tipIndex + 1) % _tips.length);
    });

    _timeoutTimer = Timer(const Duration(seconds: 25), () {
      if (!mounted) return;
      setState(() => _timedOut = true);
    });
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    _tipTimer?.cancel();
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Photo in background
        if (widget.imageBytes != null)
          Image.memory(
            widget.imageBytes!,
            fit: BoxFit.cover,
          )
        else
          ColoredBox(color: colors.surfaceRaised),

        // 2. Dark tint overlay
        Container(color: Colors.black.withValues(alpha: 0.55)),

        // 3. Animated Scan Line
        if (!_timedOut)
          AnimatedBuilder(
            animation: _scanController,
            builder: (context, _) {
              return CustomPaint(
                size: Size.infinite,
                painter: _ScanLinePainter(
                  progress: _scanController.value,
                  scanColor: colors.ember,
                ),
              );
            },
          ),

        // 4. Content / Rotating Tips or Timeout Retry
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _timedOut
                ? Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colors.surface.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(VRadius.lg),
                      border: Border.all(color: colors.line),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.timer_outlined, size: 48, color: colors.ember),
                        const SizedBox(height: 12),
                        const Text(
                          'استغرق التحليل وقتاً أطول من المتوقع',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'تأكد من الاتصال بالإنترنت وحاول مرة ثانية',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: colors.textMute, fontSize: 13),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            if (widget.onCancel != null)
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: widget.onCancel,
                                  child: const Text('إلغاء'),
                                ),
                              ),
                            if (widget.onCancel != null && widget.onRetry != null)
                              const SizedBox(width: 10),
                            if (widget.onRetry != null)
                              Expanded(
                                child: FilledButton(
                                  style: FilledButton.styleFrom(backgroundColor: colors.ember),
                                  onPressed: () {
                                    setState(() => _timedOut = false);
                                    _timeoutTimer?.cancel();
                                    _timeoutTimer = Timer(const Duration(seconds: 25), () {
                                      if (mounted) setState(() => _timedOut = true);
                                    });
                                    widget.onRetry!();
                                  },
                                  child: const Text('إعادة المحاولة'),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colors.ember.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: CircularProgressIndicator(
                          color: colors.ember,
                          strokeWidth: 3,
                        ),
                      ),
                      const SizedBox(height: 24),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          key: ValueKey(_tipIndex),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(VRadius.md),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Text(
                            _tips[_tipIndex],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

class _ScanLinePainter extends CustomPainter {
  _ScanLinePainter({required this.progress, required this.scanColor});

  final double progress;
  final Color scanColor;

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height * progress;
    final linePaint = Paint()
      ..color = scanColor
      ..strokeWidth = 3;

    final glowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          scanColor.withValues(alpha: 0.0),
          scanColor.withValues(alpha: 0.35),
          scanColor.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, y - 40, size.width, 80));

    canvas.drawRect(Rect.fromLTWH(0, y - 40, size.width, 80), glowPaint);
    canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
  }

  @override
  bool shouldRepaint(covariant _ScanLinePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
