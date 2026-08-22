import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vireo/core/theme/vireo_colors.dart';

class ScanningOverlay extends StatefulWidget {
  const ScanningOverlay({super.key, this.imageFile});

  final File? imageFile;

  @override
  State<ScanningOverlay> createState() => _ScanningOverlayState();
}

class _ScanningOverlayState extends State<ScanningOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (widget.imageFile != null)
          Image.file(widget.imageFile!, fit: BoxFit.cover)
        else
          ColoredBox(color: colors.surfaceRaised),
        Container(color: colors.background.withValues(alpha: 0.35)),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Align(
              alignment: Alignment(0, -1 + 2 * _controller.value),
              child: Container(
                height: 3,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colors.ember.withValues(alpha: 0),
                      colors.ember,
                      colors.ember.withValues(alpha: 0),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colors.ember.withValues(alpha: 0.6),
                      blurRadius: 12,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
