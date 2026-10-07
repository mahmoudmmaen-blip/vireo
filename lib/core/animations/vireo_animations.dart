import 'package:flutter/material.dart';

/// Respects system reduced-motion preference.
bool vireoAnimationsEnabled(BuildContext context) {
  return !MediaQuery.of(context).disableAnimations;
}

/// Scales to 0.96 on press, 1.0 on release — 120ms, easeOut.
class ScaleOnTap extends StatefulWidget {
  const ScaleOnTap({
    super.key,
    required this.child,
    this.onTap,
    this.enabled = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  State<ScaleOnTap> createState() => _ScaleOnTapState();
}

class _ScaleOnTapState extends State<ScaleOnTap> {
  double _scale = 1.0;

  void _setScale(double value) {
    if (!widget.enabled || !vireoAnimationsEnabled(context)) return;
    setState(() => _scale = value);
  }

  @override
  Widget build(BuildContext context) {
    final animated = vireoAnimationsEnabled(context);

    return GestureDetector(
      onTapDown: widget.enabled ? (_) => _setScale(0.96) : null,
      onTapUp: widget.enabled ? (_) => _setScale(1.0) : null,
      onTapCancel: widget.enabled ? () => _setScale(1.0) : null,
      onTap: widget.enabled ? widget.onTap : null,
      child: AnimatedScale(
        scale: animated ? _scale : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// Fade + slide-up enter animation — 400ms, optional stagger delay.
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 400),
  });

  final Widget child;
  final Duration delay;
  final Duration duration;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _offset = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller.status == AnimationStatus.dismissed) {
      if (vireoAnimationsEnabled(context)) {
        Future<void>.delayed(widget.delay, () {
          if (mounted) _controller.forward();
        });
      } else {
        _controller.value = 1;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _offset, child: widget.child),
    );
  }
}

/// Counts up to [value] on entry.
class CountUpNumber extends StatelessWidget {
  const CountUpNumber({
    super.key,
    required this.value,
    this.duration = const Duration(milliseconds: 800),
    this.style,
    this.formatter,
  });

  final num value;
  final Duration duration;
  final TextStyle? style;
  final String Function(num value)? formatter;

  @override
  Widget build(BuildContext context) {
    if (!vireoAnimationsEnabled(context)) {
      return Text(
        formatter?.call(value) ?? value.toString(),
        style: style,
      );
    }

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value.toDouble()),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, animated, _) {
        final display = formatter != null
            ? formatter!(animated)
            : animated % 1 == 0
                ? animated.round().toString()
                : animated.toStringAsFixed(1);
        return Text(display, style: style);
      },
    );
  }
}

/// Gentle bounce loop for FABs — 3s cycle.
class BounceLoop extends StatefulWidget {
  const BounceLoop({super.key, required this.child});

  final Widget child;

  @override
  State<BounceLoop> createState() => _BounceLoopState();
}

class _BounceLoopState extends State<BounceLoop>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounce;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _bounce = Tween<double>(begin: 0, end: -6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!vireoAnimationsEnabled(context)) return widget.child;

    return AnimatedBuilder(
      animation: _bounce,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _bounce.value),
        child: child,
      ),
      child: widget.child,
    );
  }
}

/// Breathing pulse — scale 1.0 → 1.02 loop.
class BreathingPulse extends StatefulWidget {
  const BreathingPulse({
    super.key,
    required this.child,
    this.active = true,
  });

  final Widget child;
  final bool active;

  @override
  State<BreathingPulse> createState() => _BreathingPulseState();
}

class _BreathingPulseState extends State<BreathingPulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    _scale = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.active) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(BreathingPulse oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.active) {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.active || !vireoAnimationsEnabled(context)) {
      return widget.child;
    }

    return ScaleTransition(scale: _scale, child: widget.child);
  }
}
