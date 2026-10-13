import 'package:flutter/foundation.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/features/nutrition/data/food_db_models.dart';

@immutable
class MealAdviceResult {
  const MealAdviceResult({
    required this.adviceText,
    required this.remainingKcalAfter,
    required this.remainingProteinAfter,
    required this.remainingCarbsAfter,
    required this.remainingFatAfter,
    required this.suggestedMealTitle,
    required this.suggestedItems,
    required this.targetNextMealType,
  });

  final String adviceText;
  final int remainingKcalAfter;
  final double remainingProteinAfter;
  final double remainingCarbsAfter;
  final double remainingFatAfter;
  final String suggestedMealTitle;
  final List<FoodItem> suggestedItems;
  final MealType targetNextMealType;
}

abstract final class MealAdviceEngine {
  /// Evaluates nutrition remaining after saving the current meal and produces rule-based advice.
  static MealAdviceResult computeAdvice({
    required int dailyGoalKcal,
    required double dailyGoalProteinG,
    required double dailyGoalCarbsG,
    required double dailyGoalFatG,
    required int eatenKcalBefore,
    required double eatenProteinBefore,
    required double eatenCarbsBefore,
    required double eatenFatBefore,
    required int mealKcal,
    required double mealProteinG,
    required double mealCarbsG,
    required double mealFatG,
    required MealType currentSlot,
    required Set<MealType> confirmedSlots,
    required bool isRamadan,
    required List<FoodItem> availableFoods,
    bool isArabic = true,
  }) {
    final totalEatenKcal = eatenKcalBefore + mealKcal;
    final totalEatenP = eatenProteinBefore + mealProteinG;
    final totalEatenC = eatenCarbsBefore + mealCarbsG;
    final totalEatenF = eatenFatBefore + mealFatG;

    final remainingKcal = dailyGoalKcal - totalEatenKcal;
    final remainingP = dailyGoalProteinG - totalEatenP;
    final remainingC = dailyGoalCarbsG - totalEatenC;
    final remainingF = dailyGoalFatG - totalEatenF;

    final nextMeal = _determineNextMeal(currentSlot, confirmedSlots, isRamadan);
    final nextMealName = _mealSlotName(nextMeal, isArabic, isRamadan);

    String advice;
    String suggestedTitle = '';
    final suggested = <FoodItem>[];

    final isLastMeal = nextMeal == null;

    if (remainingKcal < -50) {
      // Over on calories
      final over = remainingKcal.abs();
      if (isLastMeal) {
        advice = isArabic
            ? 'عديت الهدف بـ $over سعرة اليوم. مش مشكلة، بكرة نرجع نظبطها بنشاط أعلى 💪'
            : 'Over daily target by $over kcal today. Tomorrow is a fresh start!';
        suggestedTitle = isArabic ? 'مشروب دافئ خفيف' : 'Light warm drink';
      } else {
        advice = isArabic
            ? 'خدت زيادة $over سعرة، خلي $nextMealName خفيف: سلطة خضراء + 150 جم فراخ مشوية (~350 سعرة)'
            : 'Over by $over kcal. Keep $nextMealName light: green salad + 150g grilled chicken (~350 kcal)';
        suggestedTitle = isArabic ? 'عشا خفيف وبروتين نقي' : 'Light high-protein meal';
        _addMatching(suggested, availableFoods, ['grilled_chicken_breast', 'green_salad', 'cucumber']);
      }
    } else if (remainingP > 25 && (!isLastMeal || remainingKcal > 150)) {
      // Low protein
      final pNeeded = remainingP.round();
      if (isLastMeal) {
        advice = isArabic
            ? 'محتاج $pNeeded جم بروتين كمان لتقفيل هدفك: علبة تونة مصفاة أو زبادي يوناني قبل النوم'
            : 'Need $pNeeded g more protein: canned tuna or Greek yogurt before bed';
        suggestedTitle = isArabic ? 'سناك بروتين قبل النوم' : 'Bedtime protein snack';
        _addMatching(suggested, availableFoods, ['canned_tuna', 'greek_yogurt', 'boiled_egg']);
      } else {
        advice = isArabic
            ? 'محتاج $pNeeded جم بروتين كمان: علبة تونة + 2 بيض مسلوق في $nextMealName'
            : 'Need $pNeeded g more protein: canned tuna + 2 eggs for $nextMealName';
        suggestedTitle = isArabic ? 'وجبة بروتين مدعمة' : 'High protein boost meal';
        _addMatching(suggested, availableFoods, ['canned_tuna', 'boiled_egg', 'cottage_cheese']);
      }
    } else if (remainingC < -20 && !isLastMeal) {
      // Over on carbs
      advice = isArabic
          ? 'نسبة الكارب عالية اليوم، قلل الرز أو العيش في $nextMealName واعتمد على البروتين والخضار'
          : 'Carbs are high today, cut bread/rice in $nextMealName and rely on protein & veggies';
      suggestedTitle = isArabic ? 'وجبة بدون نشويات' : 'Low carb meal';
      _addMatching(suggested, availableFoods, ['grilled_chicken_breast', 'green_salad']);
    } else if (remainingF < -10 && !isLastMeal) {
      // Over on fat
      advice = isArabic
          ? 'الدهون وصلت الحد الأقصى، تجنب المقليات والزيوت في $nextMealName واشوي أو اسلق أكلك'
          : 'Fats reached the limit, avoid frying in $nextMealName and choose grilled/boiled';
      suggestedTitle = isArabic ? 'وجبة منخفضة الدهون' : 'Low fat meal';
      _addMatching(suggested, availableFoods, ['boiled_chicken', 'boiled_potato']);
    } else {
      // On track
      if (isLastMeal) {
        advice = isArabic
            ? 'يومك ممتاز ومتوازن تماماً! قفلت سعراتك وبروتينك بنجاح 🌟'
            : 'Perfect day! You balanced calories and protein on point 🌟';
        suggestedTitle = isArabic ? 'يوم مكتمل' : 'Completed day';
      } else {
        final remKcal = remainingKcal > 0 ? remainingKcal : 0;
        advice = isArabic
            ? 'ماشي تمام 👌 فاضلك $remKcal سعرة لـ $nextMealName'
            : 'On track 👌 You have $remKcal kcal remaining for $nextMealName';
        suggestedTitle = isArabic ? 'خطة $nextMealName المقترحة' : 'Suggested $nextMealName';
        _addMatching(suggested, availableFoods, ['white_rice_cooked', 'grilled_chicken_breast']);
      }
    }

    return MealAdviceResult(
      adviceText: advice,
      remainingKcalAfter: remainingKcal,
      remainingProteinAfter: remainingP,
      remainingCarbsAfter: remainingC,
      remainingFatAfter: remainingF,
      suggestedMealTitle: suggestedTitle,
      suggestedItems: suggested,
      targetNextMealType: nextMeal ?? MealType.snack,
    );
  }

  static MealType? _determineNextMeal(
    MealType current,
    Set<MealType> confirmed,
    bool isRamadan,
  ) {
    if (isRamadan) {
      // In Ramadan: Iftar -> Snack -> Suhoor
      if (current == MealType.dinner || current == MealType.lunch) {
        return confirmed.contains(MealType.snack) ? MealType.breakfast : MealType.snack;
      }
      if (current == MealType.snack) return MealType.breakfast; // Suhoor
      return null;
    }

    // Normal order: breakfast -> lunch -> dinner -> snack
    switch (current) {
      case MealType.breakfast:
        return !confirmed.contains(MealType.lunch) ? MealType.lunch : MealType.dinner;
      case MealType.lunch:
        return !confirmed.contains(MealType.dinner) ? MealType.dinner : MealType.snack;
      case MealType.dinner:
        return !confirmed.contains(MealType.snack) ? MealType.snack : null;
      case MealType.snack:
        if (!confirmed.contains(MealType.dinner)) return MealType.dinner;
        return null;
    }
  }

  static String _mealSlotName(MealType? slot, bool isArabic, bool isRamadan) {
    if (slot == null) return isArabic ? 'باقي اليوم' : 'rest of day';
    if (isRamadan) {
      return switch (slot) {
        MealType.breakfast => isArabic ? 'السحور' : 'Suhoor',
        MealType.lunch || MealType.dinner => isArabic ? 'الإفطار' : 'Iftar',
        MealType.snack => isArabic ? 'سناك بعد التراويح' : 'Post-Taraweeh Snack',
      };
    }
    return switch (slot) {
      MealType.breakfast => isArabic ? 'الفطار' : 'Breakfast',
      MealType.lunch => isArabic ? 'الغدا' : 'Lunch',
      MealType.dinner => isArabic ? 'العشا' : 'Dinner',
      MealType.snack => isArabic ? 'السناك' : 'Snack',
    };
  }

  static void _addMatching(List<FoodItem> list, List<FoodItem> catalog, List<String> idKeywords) {
    for (final kw in idKeywords) {
      final hit = catalog.where((f) => f.id.contains(kw) || f.nameEn.toLowerCase().contains(kw)).firstOrNull;
      if (hit != null && !list.contains(hit)) {
        list.add(hit);
      }
    }
  }
}
