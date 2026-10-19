import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/features/ai_nutrition/screens/ai_scan_screen.dart';
import 'package:vireo/features/ai_nutrition/screens/meal_barcode_screen.dart';
import 'package:vireo/features/home/living_backgrounds/widgets/living_meal_capture_background.dart';
import 'package:vireo/features/home/providers/today_nutrition_provider.dart';
import 'package:vireo/features/home/widgets/saved_meals_sheets.dart';
import 'package:vireo/features/nutrition/providers/meal_relog_service.dart';
import 'package:vireo/features/nutrition/providers/repeat_meal_service.dart';
import 'package:vireo/features/subscription/feature_gates.dart';
import 'package:vireo/features/subscription/meal_scan_quota.dart';

/// Home meal capture — one dominant photo CTA (P49); other actions are icon-only.
class MealCaptureHeroCard extends ConsumerWidget {
  const MealCaptureHeroCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).languageCode;
    final isArabic = locale.startsWith('ar');
    final nutrition = ref.watch(todayNutritionProvider(locale));
    final currentSlot = RepeatMealService.slotForTime(DateTime.now());
    final slotName = switch (currentSlot) {
      MealType.breakfast => isArabic ? 'فطارك' : 'your breakfast',
      MealType.lunch => isArabic ? 'غداك' : 'your lunch',
      MealType.dinner => isArabic ? 'عشاك' : 'your dinner',
      MealType.snack => isArabic ? 'سناكك' : 'your snack',
    };
    final lastMeal = nutrition.items.isNotEmpty ? nutrition.items.last : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          // P50: soft neutral depth — ember stays on the CTA itself, not the card shell.
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.22),
              blurRadius: 16,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: LivingMealCaptureBackground(
          mealSlot: currentSlot,
          borderRadius: 20,
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Dominant CTA — one tap opens camera (P49).
                  InkWell(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      AiScanScreen.openCamera(context, ref);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.22),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.photo_camera_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isArabic ? 'تصوير' : 'Snap meal',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  isArabic
                                      ? 'صوّر وجبتك — تحليل في ثواني'
                                      : 'Photo your meal — instant estimate',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.88),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!ref.watch(isProUserProvider))
                            Text(
                              '${MealScanQuota.remainingFreeScansToday()}',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Secondary actions — icon-only row (6 demoted).
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _SecondaryIcon(
                        icon: Icons.photo_library_rounded,
                        tooltip: isArabic ? 'الاستوديو' : 'Gallery',
                        onTap: () {
                          HapticFeedback.selectionClick();
                          AiScanScreen.openGallery(context, ref);
                        },
                      ),
                      _SecondaryIcon(
                        icon: Icons.edit_note_rounded,
                        tooltip: isArabic ? 'اكتب' : 'Text',
                        onTap: () {
                          HapticFeedback.selectionClick();
                          AiScanScreen.openText(context, ref);
                        },
                      ),
                      _SecondaryIcon(
                        icon: Icons.qr_code_scanner_rounded,
                        tooltip: isArabic ? 'باركود' : 'Barcode',
                        onTap: () {
                          HapticFeedback.selectionClick();
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const MealBarcodeScreen(),
                            ),
                          );
                        },
                      ),
                      _SecondaryIcon(
                        icon: Icons.replay_rounded,
                        tooltip: _yesterdayChipLabel(currentSlot, isArabic),
                        onTap: () => _repeatYesterday(
                          context,
                          ref,
                          currentSlot,
                          isArabic,
                        ),
                      ),
                      _SecondaryIcon(
                        icon: Icons.star_rounded,
                        tooltip: isArabic ? 'وجباتي' : 'My meals',
                        onTap: () {
                          HapticFeedback.selectionClick();
                          showFavoriteMealsSheet(context, slot: currentSlot);
                        },
                      ),
                      _SecondaryIcon(
                        icon: Icons.history_rounded,
                        tooltip: isArabic ? 'آخر حاجات' : 'Recent',
                        onTap: () {
                          HapticFeedback.selectionClick();
                          showRecentMealsSheet(context, slot: currentSlot);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: lastMeal == null
                        ? Text(
                            isArabic
                                ? 'لسه ما سجلتش $slotName'
                                : 'Haven\'t logged $slotName yet',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isArabic
                                    ? 'آخر وجبة: ${lastMeal.title}'
                                    : 'Last meal: ${lastMeal.title}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isArabic
                                    ? '≈ ${lastMeal.calories} سعرة · ${lastMeal.protein.round()} جم بروتين'
                                    : '≈ ${lastMeal.calories} kcal · ${lastMeal.protein.round()} g protein',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _repeatYesterday(
    BuildContext context,
    WidgetRef ref,
    MealType slot,
    bool isArabic,
  ) async {
    HapticFeedback.selectionClick();
    final yesterday = ref.read(yesterdaySameSlotProvider(slot));
    if (yesterday == null) {
      final slotName = switch (slot) {
        MealType.breakfast => isArabic ? 'الفطار' : 'breakfast',
        MealType.lunch => isArabic ? 'الغدا' : 'lunch',
        MealType.dinner => isArabic ? 'العشا' : 'dinner',
        MealType.snack => isArabic ? 'السناك' : 'snack',
      };
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              isArabic
                  ? 'مفيش حاجة متسجلة في $slotName امبارح. جرّب "آخر حاجات"'
                  : 'Nothing logged for $slotName yesterday. Try "Recent".',
            ),
          ),
        );
      return;
    }

    final kcal = await MealRelogService.quickConfirm(
      ref: ref,
      snippet: yesterday,
      slot: slot,
      context: context,
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            kcal == null
                ? (isArabic
                    ? 'مقدرتش أسجّل الوجبة دي. جرّب تاني.'
                    : 'Could not re-log this meal. Please try again.')
                : (isArabic
                    ? 'اتسجلت — ≈ $kcal سعرة'
                    : 'Logged — ≈ $kcal kcal'),
          ),
        ),
      );
  }

  static String _yesterdayChipLabel(MealType slot, bool isArabic) {
    if (!isArabic) {
      return switch (slot) {
        MealType.breakfast => 'Same breakfast?',
        MealType.lunch => 'Same lunch?',
        MealType.dinner => 'Same dinner?',
        MealType.snack => 'Same snack?',
      };
    }
    return switch (slot) {
      MealType.breakfast => 'نفس فطار إمبارح؟',
      MealType.lunch => 'نفس غدا إمبارح؟',
      MealType.dinner => 'نفس عشا إمبارح؟',
      MealType.snack => 'نفس سناك إمبارح؟',
    };
  }
}

class _SecondaryIcon extends StatelessWidget {
  const _SecondaryIcon({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.14),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}
