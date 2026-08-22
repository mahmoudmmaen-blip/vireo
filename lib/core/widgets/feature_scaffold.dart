import 'package:flutter/material.dart';
import 'package:vireo/core/theme/vireo_colors.dart';

/// Shared scaffold for feature screens.
class FeatureScaffold extends StatelessWidget {
  const FeatureScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(color: colors.background),
        child: body,
      ),
    );
  }
}
