import 'package:flutter/material.dart';
import 'package:vireo/core/theme/vireo_colors.dart';

/// Accessible icon button: tooltip required, min 48×48 tap target.
class VireoIconButton extends StatelessWidget {
  const VireoIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.color,
    this.iconSize = 22,
    this.padding,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final Color? color;
  final double iconSize;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return IconButton(
      icon: Icon(icon, size: iconSize),
      tooltip: tooltip,
      color: color ?? colors.text,
      disabledColor: colors.textMute,
      onPressed: onPressed,
      padding: padding ?? EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      style: IconButton.styleFrom(
        minimumSize: const Size(48, 48),
        tapTargetSize: MaterialTapTargetSize.padded,
      ),
    );
  }
}
