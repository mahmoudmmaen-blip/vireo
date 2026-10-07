import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';

/// Counts smoothly from the previous value to [value].
class AnimatedCount extends StatelessWidget {
  const AnimatedCount({
    super.key,
    required this.value,
    this.style,
    this.duration = VMotion.ring,
    this.grouping = true,
    this.prefix = '',
    this.suffix = '',
  });

  final int value;
  final TextStyle? style;
  final Duration duration;
  final bool grouping;
  final String prefix;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    // Western digits in both locales keep numbers consistent with the rest
    // of the app (charts, inputs).
    final fmt = NumberFormat.decimalPattern('en');
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value.toDouble()),
      duration: duration,
      curve: VMotion.emphasized,
      builder: (context, v, _) {
        final n = v.round();
        final text = grouping ? fmt.format(n) : n.toString();
        return Text('$prefix$text$suffix', style: style);
      },
    );
  }
}

/// Fades + slides its child in once, with a stagger based on [index].
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.index = 0,
    this.offset = 18,
    this.stagger = const Duration(milliseconds: 55),
    this.onceId,
  });

  final Widget child;
  final int index;
  final double offset;
  final Duration stagger;

  /// When set, the entrance plays only the first time this id is seen in the
  /// app session (so lazily rebuilt list items don't re-animate on scroll).
  final String? onceId;

  static final Set<String> _played = <String>{};

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: VMotion.slow,
  );
  late final Animation<double> _t =
      CurvedAnimation(parent: _c, curve: VMotion.emphasized);

  @override
  void initState() {
    super.initState();
    final id = widget.onceId;
    if (id != null && !FadeSlideIn._played.add(id)) {
      _c.value = 1;
      return;
    }
    final delay = widget.stagger * widget.index.clamp(0, 12);
    Future<void>.delayed(delay, () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (reduce) return widget.child;
    return AnimatedBuilder(
      animation: _t,
      child: widget.child,
      builder: (context, child) => Opacity(
        opacity: _t.value,
        child: Transform.translate(
          offset: Offset(0, widget.offset * (1 - _t.value)),
          child: child,
        ),
      ),
    );
  }
}
