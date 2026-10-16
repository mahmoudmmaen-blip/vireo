import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/home/mascot/domain/mascot_companion.dart';
import 'package:vireo/features/home/mascot/domain/mascot_state.dart';
import 'package:vireo/features/home/mascot/widgets/mascot_wave_painter.dart';

/// Animated calorie companion with liquid-wave body fill.
///
/// Pauses when off-screen, app backgrounded, or reduce-motion is on.
class CalorieMascotWave extends StatefulWidget {
  const CalorieMascotWave({
    super.key,
    required this.consumedKcal,
    required this.targetKcal,
    required this.companion,
    this.size = 148,
    this.showMacroLayers = false,
    this.proteinRatio = 0,
    this.carbsRatio = 0,
    this.fatRatio = 0,
    this.animateFromFill,
    this.fillAnimationDuration = const Duration(milliseconds: 900),
    this.onTap,
    this.onLongPress,
    this.isFemale = false,
    this.showCaption = true,
    this.now,
  });

  final int consumedKcal;
  final int targetKcal;
  final MascotCompanion companion;
  final double size;
  final bool showMacroLayers;
  final double proteinRatio;
  final double carbsRatio;
  final double fatRatio;

  /// When set, wave animates from this fill (0..1) to the new level.
  final double? animateFromFill;
  final Duration fillAnimationDuration;

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isFemale;
  final bool showCaption;
  final DateTime? now;

  @override
  State<CalorieMascotWave> createState() => CalorieMascotWaveState();
}

@visibleForTesting
class CalorieMascotWaveState extends State<CalorieMascotWave>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _loopCtrl;
  late final AnimationController _fillCtrl;
  bool _visible = true;
  bool _appActive = true;
  double _displayFill = 0;

  /// Exposed for tests.
  bool get isAnimationPaused => !_shouldAnimate;

  bool get _shouldAnimate {
    final reduce = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    return _visible && _appActive && !reduce;
  }

  MascotFillMath get math => MascotFillMath(
        consumedKcal: widget.consumedKcal,
        targetKcal: widget.targetKcal,
      );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loopCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _fillCtrl = AnimationController(
      vsync: this,
      duration: widget.fillAnimationDuration,
    );
    final from = widget.animateFromFill;
    final to = math.visualFill;
    if (from != null && (from - to).abs() > 0.001) {
      _displayFill = from.clamp(0.0, 1.0);
      _fillCtrl.addListener(() {
        setState(() {
          _displayFill = from + (to - from) * _fillCtrl.value;
        });
      });
      _fillCtrl.forward(from: 0);
    } else {
      _displayFill = to;
    }
    _syncLoop();
  }

  @override
  void didUpdateWidget(covariant CalorieMascotWave oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.consumedKcal != widget.consumedKcal ||
        oldWidget.targetKcal != widget.targetKcal) {
      final from = _displayFill;
      final to = math.visualFill;
      _fillCtrl.duration = widget.fillAnimationDuration;
      _fillCtrl.reset();
      void listener() {
        if (!mounted) return;
        setState(() {
          _displayFill = from + (to - from) * _fillCtrl.value;
        });
      }

      _fillCtrl.addListener(listener);
      _fillCtrl.forward(from: 0).whenComplete(() {
        _fillCtrl.removeListener(listener);
      });
    }
    _syncLoop();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appActive = state == AppLifecycleState.resumed;
    _syncLoop();
  }

  void _syncLoop() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_shouldAnimate) {
        if (!_loopCtrl.isAnimating) _loopCtrl.repeat();
      } else {
        _loopCtrl.stop();
      }
    });
  }

  /// Call from parent VisibilityDetector / notifications.
  void setVisible(bool visible) {
    if (_visible == visible) return;
    _visible = visible;
    _syncLoop();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _loopCtrl.dispose();
    _fillCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final m = math;
    final now = widget.now ?? DateTime.now();
    final expression = m.expressionAt(now);
    final reduce = MediaQuery.disableAnimationsOf(context);
    final phase = reduce ? 0.0 : _loopCtrl.value;

    final caption = Localizations.localeOf(context).languageCode.startsWith('ar')
        ? mascotCaptionAr(
            remainingKcal: m.remainingKcal,
            isOver: m.showOverBadge,
            isFemale: widget.isFemale,
          )
        : mascotCaptionEn(
            remainingKcal: m.remainingKcal,
            isOver: m.showOverBadge,
          );

    final semantics =
        '${widget.consumedKcal} / ${widget.targetKcal} kcal. $caption';

    return Semantics(
      label: semantics,
      button: widget.onTap != null,
      child: GestureDetector(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: widget.size,
              height: widget.size,
              child: NotificationListener<ScrollNotification>(
                onNotification: (_) => false,
                child: _VisibilityBinder(
                  onVisibility: setVisible,
                  child: RepaintBoundary(
                    child: AnimatedBuilder(
                      animation: Listenable.merge([_loopCtrl, _fillCtrl]),
                      builder: (context, _) {
                        return CustomPaint(
                          painter: MascotWavePainter(
                            companion: widget.companion,
                            fill: reduce ? m.visualFill : _displayFill,
                            expression: expression,
                            colorState: m.colorState,
                            accent: colors.ember,
                            success: colors.success,
                            amber: colors.gold,
                            bodyOutline: colors.text,
                            wavePhase: phase,
                            showMacroLayers: widget.showMacroLayers,
                            proteinFill: widget.proteinRatio,
                            carbsFill: widget.carbsRatio,
                            fatFill: widget.fatRatio,
                          ),
                          child: m.showOverBadge
                              ? Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    key: const ValueKey('mascot_over_badge'),
                                    margin: const EdgeInsets.all(4),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colors.gold.withValues(alpha: 0.92),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      Localizations.localeOf(context)
                                              .languageCode
                                              .startsWith('ar')
                                          ? 'زيادة شوية'
                                          : 'A bit over',
                                      style: TextStyle(
                                        color: colors.background,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                )
                              : null,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            if (widget.showCaption) ...[
              const SizedBox(height: 6),
              Text(
                caption,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colors.textMute,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Lightweight visibility: pauses when not in the render tree's hit-testable area
/// via [Visibility] + route awareness. Parents can also call [CalorieMascotWaveState.setVisible].
class _VisibilityBinder extends StatefulWidget {
  const _VisibilityBinder({required this.child, required this.onVisibility});

  final Widget child;
  final ValueChanged<bool> onVisibility;

  @override
  State<_VisibilityBinder> createState() => _VisibilityBinderState();
}

class _VisibilityBinderState extends State<_VisibilityBinder> {
  bool _tickerEnabled(BuildContext context) {
    return TickerMode.valuesOf(context).enabled;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.onVisibility(_tickerEnabled(context));
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.onVisibility(_tickerEnabled(context));
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
