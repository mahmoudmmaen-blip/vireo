import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/features/ai_nutrition/data/gemini_food_service_core.dart';
import 'package:vireo/features/ai_nutrition/screens/meal_review_screen.dart';
import 'package:vireo/features/insights/domain/meal_suggester.dart';
import 'package:vireo/features/nutrition/data/food_db_models.dart';
import 'package:vireo/features/nutrition/providers/cup_size_preference_provider.dart';
import 'package:vireo/features/nutrition/providers/meal_favorites_provider.dart';
import 'package:vireo/features/ramadan/providers/ramadan_settings_provider.dart';
import 'package:vireo/features/women_health/models/cycle_data.dart';
import 'package:vireo/features/women_health/providers/women_health_provider.dart';

/// Next meal suggestion card ("اقتراح لوجبتك الجاية") displayed in Daily Score
/// on Home and Score & Insights screens under the remaining macro rectangles.
class NextMealSuggestionCard extends ConsumerStatefulWidget {
  const NextMealSuggestionCard({
    super.key,
    required this.remainingKcal,
    required this.remainingProtein,
    required this.remainingCarbs,
    required this.remainingFat,
  });

  final int remainingKcal;
  final double remainingProtein;
  final double remainingCarbs;
  final double remainingFat;

  @override
  ConsumerState<NextMealSuggestionCard> createState() => _NextMealSuggestionCardState();
}

class _NextMealSuggestionCardState extends ConsumerState<NextMealSuggestionCard> {
  int _currentIndex = 0;
  bool _isFavorite = false;

  MealType _currentSlot() {
    final h = DateTime.now().hour;
    if (h < 11) return MealType.breakfast;
    if (h < 16) return MealType.lunch;
    if (h < 21) return MealType.dinner;
    return MealType.snack;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');
    final isRamadan = ref.watch(ramadanSettingsProvider).isEnabled;
    final isPregnancy = ref.watch(womenHealthModeProvider) == WomenMode.pregnant;
    final cupSize = ref.watch(userCupSizeProvider);

    final catalogFoods = <FoodItem>[];

    final suggestions = MealSuggester.suggestNextMeal(
      remainingKcal: widget.remainingKcal,
      remainingProtein: widget.remainingProtein,
      remainingCarbs: widget.remainingCarbs,
      remainingFat: widget.remainingFat,
      currentSlot: _currentSlot(),
      catalogFoods: catalogFoods,
      isRamadan: isRamadan,
      isPregnancyMode: isPregnancy,
      cupSizeMl: cupSize,
      isArabic: isArabic,
    );

    if (suggestions.isEmpty) return const SizedBox.shrink();

    final suggestion = suggestions[_currentIndex % suggestions.length];

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.line.withValues(alpha: 0.8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: "اقتراح لوجبتك الجاية" + Favorite Heart Button
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: colors.ember.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('💡', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.remainingKcal < 0
                          ? (isArabic ? 'خلّي الوجبة الجاية خفيفة' : 'Keep Next Meal Light')
                          : (isArabic ? 'اقتراح لوجبتك الجاية' : 'Next Meal Suggestion'),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      suggestion.displayName(isArabic),
                      style: TextStyle(
                        color: colors.ember,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: _isFavorite ? colors.danger : colors.textMute,
                  size: 20,
                ),
                tooltip: isArabic ? 'حفظ في المفضلة' : 'Favorite',
                onPressed: () async {
                  HapticFeedback.selectionClick();
                  setState(() => _isFavorite = !_isFavorite);
                  final lines = <ResolvedMealLine>[
                    for (final c in suggestion.components)
                      ResolvedMealLine(
                        nameAr: c.food.nameAr,
                        nameEn: c.food.nameEn,
                        food: c.food,
                        grams: c.grams,
                        cookingMethod: CookingMethod.other,
                        confidence: 1.0,
                        kcal: c.kcal.toDouble(),
                        protein: c.protein,
                        carbs: c.carbs,
                        fat: c.fat,
                      ),
                  ];
                  await ref.read(mealFavoritesProvider.notifier).add(lines);
                },
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Household measures description
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              suggestion.componentsDescription(isArabic),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Macros summary line
          Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                '${suggestion.totalKcal} ${isArabic ? "سعرة" : "kcal"}',
                style: TextStyle(color: colors.ember, fontWeight: FontWeight.w800, fontSize: 12),
              ),
              Text(
                '•  P: ${suggestion.totalProtein.round()}g  •  C: ${suggestion.totalCarbs.round()}g  •  F: ${suggestion.totalFat.round()}g',
                style: TextStyle(color: colors.textMute, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Action Buttons: "سجّلها" (1-tap log to review) & "اقتراح تاني"
          Row(
            children: [
              Expanded(
                flex: 5,
                child: FilledButton.icon(
                  onPressed: () async {
                    HapticFeedback.mediumImpact();
                    final lines = <ResolvedMealLine>[
                      for (final c in suggestion.components)
                        ResolvedMealLine(
                          nameAr: c.food.nameAr,
                          nameEn: c.food.nameEn,
                          food: c.food,
                          grams: c.grams,
                          cookingMethod: CookingMethod.other,
                          confidence: 1.0,
                          kcal: c.kcal.toDouble(),
                          protein: c.protein,
                          carbs: c.carbs,
                          fat: c.fat,
                        ),
                    ];
                    final draft = MealScanDraft(
                      lines: lines,
                      imageBytes: Uint8List(0),
                    );
                    await MealReviewScreen.open(context, draft);
                  },
                  icon: const Icon(Icons.check_circle_outline_rounded, size: 16),
                  label: Text(
                    isArabic ? 'سجّلها' : 'Log Meal',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.ember,
                    minimumSize: const Size.fromHeight(38),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 5,
                child: OutlinedButton.icon(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _currentIndex = (_currentIndex + 1) % suggestions.length;
                      _isFavorite = false;
                    });
                  },
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: Text(
                    isArabic ? 'اقتراح تاني' : 'Next Option',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(38),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
