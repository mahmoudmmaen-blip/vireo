import 'package:flutter/material.dart';

/// Circular action button without [FloatingActionButton] Hero semantics.
class VireoFab extends StatelessWidget {
  const VireoFab({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.mini = false,
    this.tooltip,
  });

  final VoidCallback onPressed;
  final Widget child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool mini;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).floatingActionButtonTheme;
    final size = mini ? 40.0 : 56.0;
    final bg = backgroundColor ??
        theme.backgroundColor ??
        Theme.of(context).colorScheme.primaryContainer;
    final fg = foregroundColor ??
        theme.foregroundColor ??
        Theme.of(context).colorScheme.onPrimaryContainer;

    Widget button = Material(
      elevation: 6,
      shadowColor: Colors.black26,
      color: bg,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: size,
          height: size,
          child: IconTheme.merge(
            data: IconThemeData(color: fg),
            child: Center(child: child),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      button = Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}

/// Extended pill action button without [FloatingActionButton] Hero semantics.
class VireoExtendedFab extends StatelessWidget {
  const VireoExtendedFab({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  final VoidCallback onPressed;
  final Widget label;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).floatingActionButtonTheme;
    final bg = backgroundColor ??
        theme.backgroundColor ??
        Theme.of(context).colorScheme.primaryContainer;
    final fg = foregroundColor ??
        theme.foregroundColor ??
        Theme.of(context).colorScheme.onPrimaryContainer;

    return Material(
      elevation: 6,
      shadowColor: Colors.black26,
      color: bg,
      shape: const StadiumBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: padding,
          child: IconTheme.merge(
            data: IconThemeData(color: fg, size: 20),
            child: DefaultTextStyle.merge(
              style: TextStyle(color: fg, fontWeight: FontWeight.w700),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 8),
                  ],
                  label,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
