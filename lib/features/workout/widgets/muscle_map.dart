import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';

/// Front/back body silhouette with primary (red) and secondary (orange) highlights.
class MuscleMap extends StatefulWidget {
  const MuscleMap({
    super.key,
    required this.primaryMuscles,
    this.secondaryMuscles = const [],
    this.compact = false,
  });

  final List<String> primaryMuscles;
  final List<String> secondaryMuscles;
  final bool compact;

  @override
  State<MuscleMap> createState() => _MuscleMapState();
}

class _MuscleMapState extends State<MuscleMap> {
  bool _backView = false;

  static const _viewBox = Size(120, 240);

  static const _frontRegions = <String, Rect>{
    'chest': Rect.fromLTWH(38, 52, 44, 24),
    'shoulders': Rect.fromLTWH(24, 48, 72, 16),
    'biceps': Rect.fromLTWH(18, 64, 84, 34),
    'core': Rect.fromLTWH(42, 76, 36, 40),
    'quads': Rect.fromLTWH(38, 116, 44, 56),
    'calves': Rect.fromLTWH(40, 172, 40, 36),
  };

  static const _backRegions = <String, Rect>{
    'back': Rect.fromLTWH(38, 52, 44, 36),
    'triceps': Rect.fromLTWH(18, 64, 84, 34),
    'glutes': Rect.fromLTWH(42, 88, 36, 24),
    'hamstrings': Rect.fromLTWH(38, 112, 44, 56),
    'calves': Rect.fromLTWH(40, 168, 40, 40),
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final l10n = AppLocalizations.of(context);
    final asset = _backView
        ? 'assets/exercises/svg/body_back.svg'
        : 'assets/exercises/svg/body_front.svg';
    final regions = _backView ? _backRegions : _frontRegions;
    final mapHeight = widget.compact ? 120.0 : 180.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: mapHeight,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final scale = math.min(
                constraints.maxWidth / _viewBox.width,
                mapHeight / _viewBox.height,
              );
              final width = _viewBox.width * scale;
              final height = _viewBox.height * scale;

              return Center(
                child: SizedBox(
                  width: width,
                  height: height,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SvgPicture.asset(
                        asset,
                        fit: BoxFit.contain,
                        colorFilter: ColorFilter.mode(
                          colors.textMute.withValues(alpha: 0.45),
                          BlendMode.srcIn,
                        ),
                      ),
                      for (final muscle in widget.secondaryMuscles)
                        if (regions.containsKey(muscle))
                          _MuscleHighlight(
                            rect: regions[muscle]!,
                            scale: scale,
                            color: colors.ember.withValues(alpha: 0.75),
                          ),
                      for (final muscle in widget.primaryMuscles)
                        if (regions.containsKey(muscle))
                          _MuscleHighlight(
                            rect: regions[muscle]!,
                            scale: scale,
                            color: colors.danger.withValues(alpha: 0.85),
                          ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (!widget.compact) ...[
          const SizedBox(height: 8),
          ToggleButtons(
            isSelected: [!_backView, _backView],
            onPressed: (index) => setState(() => _backView = index == 1),
            borderRadius: BorderRadius.circular(8),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(l10n.exerciseViewFront),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(l10n.exerciseViewBack),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _MuscleHighlight extends StatelessWidget {
  const _MuscleHighlight({
    required this.rect,
    required this.scale,
    required this.color,
  });

  final Rect rect;
  final double scale;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: rect.left * scale,
      top: rect.top * scale,
      width: rect.width * scale,
      height: rect.height * scale,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 6),
          ],
        ),
      ),
    );
  }
}
