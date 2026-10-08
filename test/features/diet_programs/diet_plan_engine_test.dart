import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/diet_programs/application/diet_plan_engine.dart';
import 'package:vireo/features/diet_programs/data/diet_programs_catalog.dart';
import 'package:vireo/features/diet_programs/domain/diet_program.dart';

void main() {
  group('DietPlanEngine', () {
    test('applies 1500 kcal floor when deficit would go lower', () {
      final program = DietProgramsCatalog.byId(DietProgramId.balancedDeficit);
      final input = DietPlanInput(
        weightKg: 70,
        heightCm: 175,
        age: 30,
        maintenanceKcal: 1600,
      );
      final targets = DietPlanEngine.targetsFor(program, input);
      expect(targets.calories, DietPlanEngine.calorieFloorMen);
      expect(targets.floorApplied, isTrue);
    });

    test('locks keto for diabetesOnMedication', () {
      final keto = DietProgramsCatalog.byId(DietProgramId.keto);
      final input = DietPlanInput(
        weightKg: 80,
        heightCm: 175,
        age: 35,
        maintenanceKcal: 2500,
        conditions: {HealthCondition.diabetesOnMedication},
      );
      final elig = DietPlanEngine.eligibilityFor(keto, input);
      expect(elig.status, EligibilityStatus.doctorRequired);
      expect(elig.reasons, contains(HealthCondition.diabetesOnMedication));
    });

    test('locks intermittent fasting for eatingDisorderHistory', () {
      final ifast =
          DietProgramsCatalog.byId(DietProgramId.intermittentFasting);
      final input = DietPlanInput(
        weightKg: 75,
        heightCm: 170,
        age: 28,
        maintenanceKcal: 2400,
        conditions: {HealthCondition.eatingDisorderHistory},
      );
      final elig = DietPlanEngine.eligibilityFor(ifast, input);
      expect(elig.status, EligibilityStatus.doctorRequired);
      expect(elig.reasons, contains(HealthCondition.eatingDisorderHistory));
    });

    test('under 18 → isMinor and doctorRequired', () {
      final program = DietProgramsCatalog.byId(DietProgramId.balancedDeficit);
      final input = DietPlanInput(
        weightKg: 60,
        heightCm: 165,
        age: 16,
        maintenanceKcal: 2200,
      );
      final elig = DietPlanEngine.eligibilityFor(program, input);
      expect(elig.isMinor, isTrue);
      expect(elig.status, EligibilityStatus.doctorRequired);
    });

    test('protein uses reference weight when BMI > 27', () {
      const weight = 100.0;
      const height = 170.0;
      final bmi = DietPlanEngine.bmi(weight, height);
      expect(bmi, greaterThan(27));

      final ref = DietPlanEngine.referenceWeight(weight, height);
      expect(ref, lessThan(weight));

      final program = DietProgramsCatalog.byId(DietProgramId.highProtein);
      final input = DietPlanInput(
        weightKg: weight,
        heightCm: height,
        age: 30,
        maintenanceKcal: 2800,
      );
      final targets = DietPlanEngine.targetsFor(program, input);
      final expectedProtein =
          (program.macroRule.proteinGPerKg * ref).round();
      expect(targets.proteinG, expectedProtein);
    });
  });
}
