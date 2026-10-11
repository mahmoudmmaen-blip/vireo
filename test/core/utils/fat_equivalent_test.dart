import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/utils/fat_equivalent.dart';
import 'package:vireo/features/diet_programs/application/diet_plan_engine.dart';
import 'package:vireo/features/diet_programs/data/diet_programs_catalog.dart';
import 'package:vireo/features/diet_programs/domain/diet_program.dart';

void main() {
  group('FatEquivalent calculations and rules', () {
    test('1 g body fat ≈ 7.7 kcal (7700 kcal ≈ 1000 g)', () {
      expect(FatEquivalent.gramsFromKcal(7.7), 1);
      expect(FatEquivalent.gramsFromKcal(77), 10);
      expect(FatEquivalent.gramsFromKcal(770), 100);
      expect(FatEquivalent.gramsFromKcal(7700), 1000);
    });

    test('rounding to nearest whole gram', () {
      // 10 / 7.7 = 1.2987... -> 1
      expect(FatEquivalent.gramsFromKcal(10), 1);
      // 12 / 7.7 = 1.5584... -> 2
      expect(FatEquivalent.gramsFromKcal(12), 2);
      // 350 / 7.7 = 45.45... -> 45
      expect(FatEquivalent.gramsFromKcal(350), 45);
      // 500 / 7.7 = 64.935... -> 65
      expect(FatEquivalent.gramsFromKcal(500), 65);
    });

    test('kg switch at >= 1000 g with 1 decimal place', () {
      expect(FatEquivalent.formatAmount(45), '45 g');
      expect(FatEquivalent.formatAmount(999), '999 g');
      expect(FatEquivalent.formatAmount(1000), '1.0 kg');
      expect(FatEquivalent.formatAmount(1050), '1.1 kg');
      expect(FatEquivalent.formatAmount(1500), '1.5 kg');
      expect(FatEquivalent.formatAmount(2000), '2.0 kg');

      // Arabic localization
      expect(FatEquivalent.formatAmount(45, languageCode: 'ar'), '45 جرام');
      expect(FatEquivalent.formatAmount(999, languageCode: 'ar_EG'), '999 جرام');
      expect(FatEquivalent.formatAmount(1000, languageCode: 'ar'), '1.0 كجم');
      expect(FatEquivalent.formatAmount(1500, languageCode: 'ar_SA'), '1.5 كجم');
    });

    test('never shows negative values; 0 kcal hidden', () {
      expect(FatEquivalent.gramsFromKcal(0), 0);
      expect(FatEquivalent.gramsFromKcal(-1), 0);
      expect(FatEquivalent.gramsFromKcal(-500), 0);

      expect(FatEquivalent.hasEquivalent(0), isFalse);
      expect(FatEquivalent.hasEquivalent(-100), isFalse);
      expect(FatEquivalent.hasEquivalent(null), isFalse);
      expect(FatEquivalent.hasEquivalent(1), isFalse); // 1 / 7.7 = 0.129 -> 0 grams
      expect(FatEquivalent.hasEquivalent(4), isTrue); // 4 / 7.7 = 0.519 -> 1 gram

      expect(FatEquivalent.formatAmount(0), '');
      expect(FatEquivalent.formatAmount(-10), '');
      expect(FatEquivalent.formatAmountFromKcal(0), '');
      expect(FatEquivalent.formatAmountFromKcal(-200), '');
    });

    test('weekly grams matches DietPlanEngine weeklyLossKg * 1000 within rounding', () {
      final program = DietProgramsCatalog.byId(DietProgramId.balancedDeficit);
      final input = DietPlanInput(
        weightKg: 85,
        heightCm: 180,
        age: 30,
        maintenanceKcal: 2500,
      );
      final targets = DietPlanEngine.targetsFor(program, input);

      // targets.weeklyLossKg is calculated by DietPlanEngine
      expect(targets.weeklyLossKg, greaterThan(0));

      final weeklyGramsFromLoss = FatEquivalent.weeklyGramsFromWeeklyLossKg(targets.weeklyLossKg);
      final weeklyGramsFromDaily = FatEquivalent.gramsFromKcal(targets.deficitKcal * 7);

      // In DietPlanEngine: weeklyLossKg = double.parse((realDeficit * 7 / 7700).toStringAsFixed(2))
      // Both approaches must be consistent within 15 grams (minor decimal rounding artifact)
      expect((weeklyGramsFromLoss - (targets.weeklyLossKg * 1000).round()).abs(), 0);
      expect((weeklyGramsFromLoss - weeklyGramsFromDaily).abs(), lessThanOrEqualTo(15));
    });
  });
}
