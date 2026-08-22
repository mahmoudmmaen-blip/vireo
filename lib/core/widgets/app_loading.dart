import 'package:flutter/material.dart';
import 'package:vireo/core/theme/vireo_colors.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return ColoredBox(
      color: colors.background,
      child: Center(
        child: CircularProgressIndicator(color: colors.ember),
      ),
    );
  }
}
