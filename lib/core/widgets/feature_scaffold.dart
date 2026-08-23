import 'package:flutter/material.dart';
import 'package:vireo/core/theme/vireo_colors.dart';

/// Shared scaffold for feature screens.
class FeatureScaffold extends StatelessWidget {
  const FeatureScaffold({
    super.key,
    this.title,
    this.titleWidget,
    required this.body,
    this.actions,
  }) : assert(title != null || titleWidget != null, 'Provide title or titleWidget');

  final String? title;
  final Widget? titleWidget;
  final Widget body;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return Scaffold(
      appBar: AppBar(
        title: titleWidget ?? Text(title!),
        actions: actions,
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(color: colors.background),
        child: body,
      ),
    );
  }
}
