import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/analytics_service.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/motion.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/ai_nutrition/data/gemini_food_service_core.dart';
import 'package:vireo/features/ai_nutrition/screens/ai_scan_screen.dart';
import 'package:vireo/features/ai_nutrition/screens/meal_review_screen.dart';
import 'package:vireo/features/nutrition/data/food_db_models.dart';
import 'package:vireo/features/onboarding/providers/onboarding_provider.dart';
import 'package:vireo/features/onboarding/widgets/onboarding_step_shell.dart';

class StepTryScanScreen extends ConsumerStatefulWidget {
  const StepTryScanScreen({super.key});

  @override
  ConsumerState<StepTryScanScreen> createState() => _StepTryScanScreenState();
}

class _StepTryScanScreenState extends ConsumerState<StepTryScanScreen> {
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    AnalyticsService.onboardingStepViewed(
      stepIndex: 5,
      stepName: 'try_scan',
    );
  }

  /// Bundled sample plate: Egyptian Grilled Chicken Breast with White Rice & Salad
  MealScanDraft _createSamplePlateDraft() {
    return MealScanDraft(
      lines: const [
        ResolvedMealLine(
          nameAr: 'صدر دجاج مشوي',
          nameEn: 'Grilled Chicken Breast',
          grams: 200,
          cookingMethod: CookingMethod.grilled,
          confidence: 0.95,
          kcal: 330,
          protein: 62.0,
          carbs: 0.0,
          fat: 7.2,
        ),
        ResolvedMealLine(
          nameAr: 'أرز أبيض مصري مطبوخ',
          nameEn: 'Cooked White Rice',
          grams: 180,
          cookingMethod: CookingMethod.boiled,
          confidence: 0.92,
          kcal: 234,
          protein: 4.8,
          carbs: 50.4,
          fat: 0.6,
        ),
        ResolvedMealLine(
          nameAr: 'سلطة بلدي خضراء',
          nameEn: 'Fresh Green Salad',
          grams: 120,
          cookingMethod: CookingMethod.raw,
          confidence: 0.90,
          kcal: 35,
          protein: 1.5,
          carbs: 6.2,
          fat: 0.5,
        ),
      ],
      imageBytes: Uint8List(0),
    );
  }

  Future<void> _scanSamplePlate() async {
    setState(() => _isAnalyzing = true);
    // Simulate instantaneous analysis (no API call)
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;
    setState(() => _isAnalyzing = false);

    final draft = _createSamplePlateDraft();
    await MealReviewScreen.open(context, draft);

    AnalyticsService.onboardingStepCompleted(
      stepIndex: 5,
      stepName: 'try_scan',
      properties: {'type': 'sample_plate'},
    );

    if (mounted) {
      ref.read(onboardingProvider.notifier).nextStep();
    }
  }

  Future<void> _scanOwnPlate() async {
    AnalyticsService.logEvent(
      'onboarding_scan_own_started',
      properties: {'step': 5},
    );

    await AiScanScreen.open(context, ref, fromCamera: true);

    if (mounted) {
      AnalyticsService.onboardingStepCompleted(
        stepIndex: 5,
        stepName: 'try_scan',
        properties: {'type': 'camera_scan'},
      );
      ref.read(onboardingProvider.notifier).nextStep();
    }
  }

  void _skip() {
    AnalyticsService.onboardingStepCompleted(
      stepIndex: 5,
      stepName: 'try_scan',
      properties: {'skipped': true},
    );
    ref.read(onboardingProvider.notifier).nextStep();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return OnboardingStepShell(
      stepIndex: 5,
      stepCount: OnboardingUiState.stepCount,
      title: 'Experience Instant Scanning',
      subtitle: 'See how effortlessly Vireo breaks down real food into macros and calories.',
      onBack: () => ref.read(onboardingProvider.notifier).previousStep(),
      onSkip: _skip,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Sample plate interactive hero card
          FadeSlideIn(
            index: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.surfaceRaised,
                borderRadius: BorderRadius.circular(VRadius.xl),
                border: Border.all(
                  color: colors.ember.withValues(alpha: 0.35),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors.ember.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Plate visual container
                  Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colors.background,
                      borderRadius: BorderRadius.circular(VRadius.lg),
                      border: Border.all(color: colors.line),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.dinner_dining_rounded,
                              size: 54,
                              color: colors.ember,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Sample High-Protein Plate',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Grilled Chicken, Egyptian Rice & Garden Salad',
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.textMute,
                              ),
                            ),
                          ],
                        ),
                        if (_isAnalyzing)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(VRadius.lg),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Button to scan sample plate
                  Pressable(
                    onTap: _isAnalyzing ? null : _scanSamplePlate,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: colors.ember,
                        borderRadius: BorderRadius.circular(VRadius.md),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.flash_on_rounded, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            _isAnalyzing ? 'Analyzing Plate...' : 'Scan Sample Plate (Instant)',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),

          // Divider
          FadeSlideIn(
            index: 1,
            child: Row(
              children: [
                Expanded(child: Divider(color: colors.line)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text('OR TEST LIVE', style: VType.overline(context)),
                ),
                Expanded(child: Divider(color: colors.line)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // "Scan your own" option
          FadeSlideIn(
            index: 2,
            child: Pressable(
              onTap: _scanOwnPlate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                decoration: BoxDecoration(
                  color: colors.surfaceRaised,
                  borderRadius: BorderRadius.circular(VRadius.lg),
                  border: Border.all(color: colors.line),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: VMacro.carbs.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(VRadius.md),
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: VMacro.carbs,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Scan Your Own Meal',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Take a live photo of your current plate',
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.textMute,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: colors.textMute,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
