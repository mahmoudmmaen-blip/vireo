import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/diet_programs/data/program_meal_library.dart';
import 'package:vireo/features/diet_programs/domain/diet_program.dart';

void main() {
  test('every program x slot has at least 15 options', () {
    for (final program in DietProgramId.values) {
      for (final slot in MealSlot.values) {
        final n = mealsFor(program, slot).length;
        expect(
          n,
          greaterThanOrEqualTo(15),
          reason: '${program.value} / ${slot.name} has only $n options',
        );
      }
    }
  });

  test('options are real: ids unique, macros non-zero, fields filled', () {
    final ids = <String>{};
    for (final o in allProgramMeals) {
      expect(ids.add(o.id), isTrue, reason: 'duplicate id ${o.id}');
      expect(o.kcal, greaterThan(20), reason: o.id);
      expect(o.proteinG + o.carbsG + o.fatG, greaterThan(1), reason: o.id);
      expect(o.nameAr.trim(), isNotEmpty);
      expect(o.nameEn.trim(), isNotEmpty);
      expect(o.householdMeasureAr.trim(), isNotEmpty, reason: o.id);
      expect(o.prepMinutes, greaterThan(0), reason: o.id);
      expect(o.foodDbIds, isNotEmpty, reason: o.id);
      expect(o.swaps, isNotEmpty, reason: o.id);
      // Atwater sanity: macros explain the kcal within 20 % (fiber and DB
      // rounding, e.g. watermelon, explain the gap on very low-kcal foods).
      final atwater = o.proteinG * 4 + o.carbsG * 4 + o.fatG * 9;
      expect(
        (atwater - o.kcal).abs() / o.kcal,
        lessThan(0.20),
        reason: '${o.id} kcal ${o.kcal} vs macros $atwater',
      );
    }
  });

  test('Arabic names and measures contain no Latin letters', () {
    final latin = RegExp(r'[A-Za-z]');
    for (final o in allProgramMeals) {
      expect(latin.hasMatch(o.nameAr), isFalse, reason: o.nameAr);
      expect(latin.hasMatch(o.householdMeasureAr), isFalse, reason: o.id);
      for (final s in o.swaps) {
        expect(latin.hasMatch(s), isFalse, reason: s);
      }
    }
  });

  test('every foodDbId exists in assets/food_db/foods.json', () {
    final raw = File('assets/food_db/foods.json').readAsStringSync();
    final foods = (jsonDecode(raw) as Map)['foods'] as List;
    final known = {for (final f in foods) (f as Map)['id'] as String};
    for (final o in allProgramMeals) {
      for (final id in o.foodDbIds) {
        expect(known.contains(id), isTrue, reason: '${o.id} -> $id');
      }
    }
  });

  test('keto options respect the carb ceiling; filters are populated', () {
    for (final slot in MealSlot.values) {
      for (final o in mealsFor(DietProgramId.keto, slot)) {
        expect(o.carbsG, lessThanOrEqualTo(10), reason: o.id);
      }
    }
    expect(allProgramMeals.where((o) => o.noCook), isNotEmpty);
    expect(allProgramMeals.where((o) => o.highProtein), isNotEmpty);
    expect(allProgramMeals.where((o) => o.budget), isNotEmpty);
    expect(allProgramMeals.where((o) => o.ramadanSuhoor), isNotEmpty);
  });

  test('P36 Egyptian breakfast staples are present', () {
    final names = mealsFor(DietProgramId.balancedDeficit, MealSlot.breakfast)
        .map((o) => o.nameAr)
        .join('|');
    for (final needle in [
      'فول بالزيت',
      'طعمية مشوية',
      'مسلوق',
      'عيون',
      'أومليت خضار',
      'قريش',
      'جبنة بيضاء لايت',
      'زبادي يوناني',
      'شوفان',
      'عيش بلدي',
      'فطير خفيف',
      'مربى قليل السكر',
      'العسل',
      'ساندوتش',
      'بروتين شيك',
      'تمرات',
      'سحور',
    ]) {
      expect(names.contains(needle), isTrue, reason: 'missing $needle');
    }
  });
}
