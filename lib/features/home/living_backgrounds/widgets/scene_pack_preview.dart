import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/theme/app_theme_variant_provider.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/features/home/living_backgrounds/domain/journey_stage.dart';
import 'package:vireo/features/home/living_backgrounds/painters/meal_doodle_painter.dart';
import 'package:vireo/features/home/living_backgrounds/painters/step_journey_painter.dart';
import 'package:vireo/features/home/living_backgrounds/providers/living_background_settings_provider.dart';
import 'package:vireo/core/theme/vireo_bridge.dart';

class ScenePackPreview extends ConsumerStatefulWidget {
  const ScenePackPreview({
    super.key,
    this.initialStage = 5,
  });

  final int initialStage;

  @override
  ConsumerState<ScenePackPreview> createState() => _ScenePackPreviewState();
}

class _ScenePackPreviewState extends ConsumerState<ScenePackPreview> {
  late int _previewStage;

  @override
  void initState() {
    super.initState();
    _previewStage = widget.initialStage;
  }

  @override
  Widget build(BuildContext context) {
    final pack = ref.watch(activeScenePackProvider);
    final variant = ref.watch(appThemeVariantProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = Localizations.localeOf(context).languageCode.startsWith('ar');

    final stage = JourneyStage.fromSteps(_previewStage * 1000);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Mini Steps Card Preview
        Container(
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CustomPaint(
                  painter: StepJourneyPainter(
                    stage: stage,
                    pack: pack,
                    variant: variant,
                    isDark: isDark,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${_previewStage * 1000}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              if (stage.hasStarBadge) ...[
                                const SizedBox(width: 6),
                                const Icon(Icons.star_rounded, color: VBridge.cFFFFD700, size: 24),
                              ],
                            ],
                          ),
                          Text(
                            isAr ? 'المرحلة $_previewStage من 12' : 'Stage $_previewStage of 12',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: stage.ringAccent(variant).withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: stage.ringAccent(variant), width: 1),
                            ),
                            child: Text(
                              pack.id.displayName(isAr),
                              style: TextStyle(
                                color: stage.ringAccent(variant),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Mini Progress Ring
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: stage.ringAccent(variant),
                            width: 5,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${((_previewStage / 12) * 100).round()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),

        // 2. Stage preview selector chips: [0 (بداية), 5 (منتصف), 12 (هدف منجز)]
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _stageChip(0, isAr ? 'مرحلة 0 (فجر)' : 'Stage 0'),
            const SizedBox(width: 8),
            _stageChip(5, isAr ? 'مرحلة 5 (نهار)' : 'Stage 5'),
            const SizedBox(width: 8),
            _stageChip(12, isAr ? 'مرحلة 12 (ذهبي ★)' : 'Stage 12 ★'),
          ],
        ),

        const SizedBox(height: 12),

        // 3. Mini Meal Card Preview
        Container(
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              colors: pack.mealCaptureGradient(
                slot: MealType.lunch,
                isRamadan: false,
                variant: variant,
                isDark: isDark,
              ),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CustomPaint(
                  painter: const MealDoodlePainter(lineColor: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.25),
                        ),
                        child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAr ? 'صوّر وجبتك (غداك)' : 'Scan Your Meal (Lunch)',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            isAr ? 'رسومات وزخارف هادئة' : 'Subtle food line-art',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _stageChip(int stage, String label) {
    final selected = _previewStage == stage;
    return ChoiceChip(
      selected: selected,
      label: Text(label),
      onSelected: (_) => setState(() => _previewStage = stage),
    );
  }
}
