import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/theme/app_theme_variant_provider.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/features/home/living_backgrounds/painters/meal_doodle_painter.dart';
import 'package:vireo/features/home/living_backgrounds/providers/living_background_settings_provider.dart';
import 'package:vireo/features/ramadan/providers/ramadan_settings_provider.dart';

class LivingMealCaptureBackground extends ConsumerWidget {
  const LivingMealCaptureBackground({
    super.key,
    required this.child,
    required this.mealSlot,
    this.borderRadius = 20.0,
  });

  final Widget child;
  final MealType mealSlot;
  final double borderRadius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(activeScenePackProvider);
    final variant = ref.watch(appThemeVariantProvider);
    final isRamadan = ref.watch(ramadanSettingsProvider).isEnabled;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final gradientColors = pack.mealCaptureGradient(
      slot: mealSlot,
      isRamadan: isRamadan,
      variant: variant,
      isDark: isDark,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          // 1. Scene-pack aware dynamic gradient background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          // 2. Subtle line-art food doodles at low opacity
          Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: MealDoodlePainter(
                  lineColor: Colors.white,
                ),
              ),
            ),
          ),

          // 3. Child content
          child,
        ],
      ),
    );
  }
}
