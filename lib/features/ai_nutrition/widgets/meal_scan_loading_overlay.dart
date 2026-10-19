import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/ai_nutrition/application/ai_scan_stage.dart';
import 'package:vireo/core/theme/vireo_bridge.dart';

/// Photo with an animated scan line, staged progress, and a 25s timeout retry.
class MealScanLoadingOverlay extends StatefulWidget {
  const MealScanLoadingOverlay({
    super.key,
    this.imageBytes,
    this.errorMessage,
    this.isError = false,
    this.onRetry,
    this.onCancel,
    this.stage,
  });

  final Uint8List? imageBytes;
  final String? errorMessage;
  final bool isError;
  final VoidCallback? onRetry;
  final VoidCallback? onCancel;

  /// When set, shows this stage label; otherwise cycles the three P52 stages.
  final AiScanStage? stage;

  @override
  State<MealScanLoadingOverlay> createState() => _MealScanLoadingOverlayState();
}

class _MealScanLoadingOverlayState extends State<MealScanLoadingOverlay>
    with SingleTickerProviderStateMixin {
  static const _stages = AiScanStage.values;

  late final AnimationController _scanController;
  int _stageIndex = 0;
  Timer? _stageTimer;
  Timer? _timeoutTimer;
  bool _timedOut = false;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _stageTimer = Timer.periodic(const Duration(milliseconds: 2800), (_) {
      if (!mounted || widget.stage != null) return;
      setState(() => _stageIndex = (_stageIndex + 1) % _stages.length);
    });

    _timeoutTimer = Timer(const Duration(seconds: 25), () {
      if (!mounted) return;
      setState(() => _timedOut = true);
    });
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    _stageTimer?.cancel();
    _scanController.dispose();
    super.dispose();
  }

  String _stageLabel(BuildContext context) {
    final isAr =
        Localizations.localeOf(context).languageCode.startsWith('ar');
    final stage = widget.stage ?? _stages[_stageIndex];
    return isAr ? stage.labelAr() : stage.labelEn();
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
            child: (widget.isError || widget.errorMessage != null || _timedOut)
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
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 48,
                          color: colors.ember,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.errorMessage ??
                              (Localizations.localeOf(context).languageCode.startsWith('ar')
                                  ? 'التحليل أخد وقت أطول من المتوقع.. حاول تاني'
                                  : 'Analysis timed out. Please try again.'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            if (widget.onCancel != null)
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: widget.onCancel,
                                  child: Text(
                                    Localizations.localeOf(context).languageCode.startsWith('ar')
                                        ? 'إلغاء'
                                        : 'Cancel',
                                  ),
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
                                  child: Text(
                                    Localizations.localeOf(context).languageCode.startsWith('ar')
                                        ? 'حاول تاني'
                                        : 'Try again',
                                  ),
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
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var i = 0; i < _stages.length; i++) ...[
                            if (i > 0) const SizedBox(width: 8),
                            _StageDot(
                              active: (widget.stage ?? _stages[_stageIndex])
                                      .index >=
                                  i,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          key: ValueKey(
                            widget.stage?.index ?? _stageIndex,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(VRadius.md),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Text(
                            _stageLabel(context),
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

class _StageDot extends StatelessWidget {
  const _StageDot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: active ? 22 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? VBridge.cFFFF6B35 : Colors.white24,
        borderRadius: BorderRadius.circular(99),
      ),
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
