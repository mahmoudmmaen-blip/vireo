import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/features/ai_nutrition/screens/ai_scan_screen.dart';
import 'package:vireo/features/ai_nutrition/screens/meal_barcode_screen.dart';
import 'package:vireo/features/home/living_backgrounds/widgets/living_meal_capture_background.dart';
import 'package:vireo/features/home/providers/today_nutrition_provider.dart';
import 'package:vireo/features/home/widgets/saved_meals_sheets.dart';
import 'package:vireo/features/nutrition/providers/repeat_meal_service.dart';
import 'package:vireo/features/subscription/feature_gates.dart';
import 'package:vireo/features/subscription/meal_scan_quota.dart';

/// Full-width meal capture card ("سجّل وجبتك") placed right below the Steps hero card.
class MealCaptureHeroCard extends ConsumerWidget {
  const MealCaptureHeroCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.vireoColors;
    final locale = Localizations.localeOf(context).languageCode;
    final isArabic = locale.startsWith('ar');
    final nutrition = ref.watch(todayNutritionProvider(locale));

    // Determine current time-based meal slot name
    final currentSlot = _currentMealSlot();
    final slotName = switch (currentSlot) {
      MealType.breakfast => isArabic ? 'فطارك' : 'your breakfast',
      MealType.lunch => isArabic ? 'غداك' : 'your lunch',
      MealType.dinner => isArabic ? 'عشاك' : 'your dinner',
      MealType.snack => isArabic ? 'سناكك' : 'your snack',
    };

    // Last logged meal
    final lastMeal = nutrition.items.isNotEmpty ? nutrition.items.last : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colors.ember.withValues(alpha: 0.35),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                // Top Row: Big camera circle + Title + Subtitle
                Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 1.5),
                      ),
                      child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 30),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isArabic ? 'صوّر وجبتك' : 'Scan Your Meal',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isArabic ? 'تحليل في ثواني • سعرات وبروتين' : 'Instant analysis • Calories & protein',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!ref.watch(isProUserProvider)) ...[
                      const SizedBox(width: 8),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerEnd,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.22),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                            ),
                            child: Text(
                              isArabic
                                  ? 'فاضلك ${MealScanQuota.remainingFreeScansToday()} تحليلات النهارده'
                                  : '${MealScanQuota.remainingFreeScansToday()} free scans left today',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),

                // Row of 4 quick chips: 📷 تصوير · 🖼 الاستوديو · ✍️ اكتب · 🔎 باركود
                Row(
                  children: [
                    Expanded(
                      child: _QuickActionChip(
                        icon: Icons.photo_camera_rounded,
                        label: isArabic ? 'تصوير' : 'Camera',
                        onTap: () {
                          HapticFeedback.selectionClick();
                          AiScanScreen.openCamera(context, ref);
                        },
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _QuickActionChip(
                        icon: Icons.photo_library_rounded,
                        label: isArabic ? 'الاستوديو' : 'Gallery',
                        onTap: () {
                          HapticFeedback.selectionClick();
                          AiScanScreen.openGallery(context, ref);
                        },
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _QuickActionChip(
                        icon: Icons.edit_note_rounded,
                        label: isArabic ? 'اكتب' : 'Text',
                        onTap: () {
                          HapticFeedback.selectionClick();
                          AiScanScreen.openText(context, ref);
                        },
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _QuickActionChip(
                        icon: Icons.qr_code_scanner_rounded,
                        label: isArabic ? 'باركود' : 'Barcode',
                        onTap: () {
                          HapticFeedback.selectionClick();
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(builder: (_) => const MealBarcodeScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Repeat row (P40): زي امبارح · وجباتي · آخر حاجات
                Row(
                  children: [
                    Expanded(
                      child: _QuickActionChip(
                        icon: Icons.replay_rounded,
                        label: isArabic ? 'زي امبارح' : 'Same as yesterday',
                        minHeight: 48,
                        onTap: () => _repeatYesterday(
                          context,
                          ref,
                          currentSlot,
                          isArabic,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _QuickActionChip(
                        icon: Icons.star_rounded,
                        label: isArabic ? 'وجباتي' : 'My meals',
                        minHeight: 48,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          showFavoriteMealsSheet(context, slot: currentSlot);
                        },
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _QuickActionChip(
                        icon: Icons.history_rounded,
                        label: isArabic ? 'آخر حاجات' : 'Recent',
                        minHeight: 48,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          showRecentMealsSheet(context, slot: currentSlot);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Under it: Today's last logged meal mini row OR "لسه ما سجلتش فطارك"
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        lastMeal != null ? Icons.check_circle_rounded : Icons.schedule_rounded,
                        size: 17,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          lastMeal != null
                              ? '${isArabic ? 'آخر وجبة:' : 'Last meal:'} ${lastMeal.title} • ${lastMeal.calories} ${isArabic ? 'سعرة' : 'kcal'}'
                              : (isArabic ? 'لسه ما سجلتش $slotName' : 'Haven\'t logged $slotName yet'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (lastMeal != null)
                        Text(
                          '${lastMeal.protein.round()}g P',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
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

  /// "زي امبارح": copies yesterday's meal of the same slot into the review
  /// screen (one tap; the user still confirms before it is saved).
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
                  ? 'مفيش حاجة متسجلة في $slotName امبارح. جرّب "آخر حاجات" 😊'
                  : 'Nothing logged for $slotName yesterday. Try "Recent" 😊',
            ),
          ),
        );
      return;
    }
    await openSavedMealInReview(context, yesterday, slot: slot);
  }

  static MealType _currentMealSlot() {
    final h = DateTime.now().hour;
    if (h < 11) return MealType.breakfast;
    if (h < 16) return MealType.lunch;
    if (h < 21) return MealType.dinner;
    return MealType.snack;
  }
}

class _QuickActionChip extends StatelessWidget {
  const _QuickActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
    this.minHeight = 0,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 15),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
