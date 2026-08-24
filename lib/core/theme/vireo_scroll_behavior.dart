import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// App-wide scroll behavior — suppresses implicit [Scrollbar] wrappers that
/// throw on Flutter Web when no [ScrollController] is attached.
class VireoScrollBehavior extends MaterialScrollBehavior {
  const VireoScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      };

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}

/// Wraps a subtree to disable scrollbars (e.g. nested scroll regions).
class NoScrollbarScrollConfiguration extends StatelessWidget {
  const NoScrollbarScrollConfiguration({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: child,
    );
  }
}
