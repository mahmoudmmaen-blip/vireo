import 'package:flutter/foundation.dart';

/// All weight-loss programs Vireo offers. Order = default display order.
enum DietProgramId {
  balancedDeficit('balanced_deficit'),
  highProtein('high_protein'),
  intermittentFasting('intermittent_fasting'),
  lowCarb('low_carb'),
  keto('keto'),
  fastingLowCarb('fasting_low_carb'),
  egyptianClean('egyptian_clean');

  const DietProgramId(this.value);
  final String value;

  static DietProgramId fromValue(String? value) => DietProgramId.values.firstWhere(
        (e) => e.value == value,
        orElse: () => DietProgramId.balancedDeficit,
      );
}

/// Health conditions asked in the safety screening (yes/no questions).
///
/// Answers are stored locally only. They decide which programs need a
/// doctor's approval before the user can start them.
enum HealthCondition {
  type1Diabetes('type1_diabetes'),
  diabetesOnMedication('diabetes_on_medication'),
  kidneyDisease('kidney_disease'),
  liverDisease('liver_disease'),
  pancreatitisOrGallbladder('pancreatitis_or_gallbladder'),
  heartDiseaseOrArrhythmia('heart_disease_or_arrhythmia'),
  highCholesterolFamilial('high_cholesterol_familial'),
  bloodPressureMedication('blood_pressure_medication'),
  goutHistory('gout_history'),
  eatingDisorderHistory('eating_disorder_history'),
  faintingOrLowBloodPressure('fainting_or_low_blood_pressure'),
  medicationWithFood('medication_with_food');

  const HealthCondition(this.value);
  final String value;

  static HealthCondition? fromValue(String value) {
    for (final c in HealthCondition.values) {
      if (c.value == value) return c;
    }
    return null;
  }
}

/// Eating preferences used to rank programs (not for safety).
@immutable
class DietPreferences {
  const DietPreferences({
    this.lovesBreadAndRice = true,
    this.canSkipBreakfast = false,
    this.wantsSimpleRules = true,
    this.eatsOutOften = false,
    this.trainsWithWeights = false,
  });

  final bool lovesBreadAndRice;
  final bool canSkipBreakfast;
  final bool wantsSimpleRules;
  final bool eatsOutOften;
  final bool trainsWithWeights;

  Map<String, dynamic> toJson() => {
        'loves_bread_and_rice': lovesBreadAndRice,
        'can_skip_breakfast': canSkipBreakfast,
        'wants_simple_rules': wantsSimpleRules,
        'eats_out_often': eatsOutOften,
        'trains_with_weights': trainsWithWeights,
      };

  factory DietPreferences.fromJson(Map<String, dynamic> json) => DietPreferences(
        lovesBreadAndRice: json['loves_bread_and_rice'] as bool? ?? true,
        canSkipBreakfast: json['can_skip_breakfast'] as bool? ?? false,
        wantsSimpleRules: json['wants_simple_rules'] as bool? ?? true,
        eatsOutOften: json['eats_out_often'] as bool? ?? false,
        trainsWithWeights: json['trains_with_weights'] as bool? ?? false,
      );
}

/// How the program splits calories into macros.
@immutable
class MacroRule {
  const MacroRule({
    required this.proteinGPerKg,
    this.fatPercent,
    this.carbsGrams,
    this.carbsMaxGrams,
  }) : assert(
          fatPercent != null || carbsGrams != null,
          'Provide fatPercent (carbs = rest) or carbsGrams (fat = rest)',
        );

  /// Protein per kg of *reference* body weight (see engine).
  final double proteinGPerKg;

  /// If set: fat = this % of calories, carbs fill the rest.
  final double? fatPercent;

  /// If set: carbs fixed at this many grams/day, fat fills the rest.
  final int? carbsGrams;

  /// Hard upper limit shown to the user (e.g. keto 50 g).
  final int? carbsMaxGrams;
}

/// Eating window for fasting-based programs.
@immutable
class EatingWindow {
  const EatingWindow({
    required this.fastingHours,
    required this.eatingHours,
    required this.defaultStartHour,
  });

  final int fastingHours;
  final int eatingHours;

  /// Suggested first-meal hour (24h). Users can change it.
  final int defaultStartHour;
}

/// Localized text pair.
@immutable
class L10nText {
  const L10nText(this.ar, this.en);
  final String ar;
  final String en;

  String of(String languageCode) => languageCode == 'ar' ? ar : en;
}

@immutable
class SampleMeal {
  const SampleMeal({required this.time, required this.name, required this.items});
  final L10nText time;
  final L10nText name;
  final L10nText items;
}

@immutable
class EvidenceSource {
  const EvidenceSource({required this.title, required this.url});
  final String title;
  final String url;
}

/// A complete, explainable diet program.
@immutable
class DietProgram {
  const DietProgram({
    required this.id,
    required this.name,
    required this.tagline,
    required this.howItWorks,
    required this.bestFor,
    required this.notIdealFor,
    required this.rules,
    required this.allowedFoods,
    required this.limitFoods,
    required this.sampleDay,
    required this.sideEffects,
    required this.tips,
    required this.evidenceSummary,
    required this.sources,
    required this.macroRule,
    required this.difficulty,
    required this.emoji,
    this.window,
    this.deficitFactor = 1.0,
    this.requiresDoctorIf = const {},
    this.cautionIf = const {},
  });

  final DietProgramId id;
  final L10nText name;
  final L10nText tagline;
  final L10nText howItWorks;
  final List<L10nText> bestFor;
  final List<L10nText> notIdealFor;
  final List<L10nText> rules;
  final List<L10nText> allowedFoods;
  final List<L10nText> limitFoods;
  final List<SampleMeal> sampleDay;
  final List<L10nText> sideEffects;
  final List<L10nText> tips;
  final L10nText evidenceSummary;
  final List<EvidenceSource> sources;
  final MacroRule macroRule;

  /// 1 = easy, 3 = hard.
  final int difficulty;
  final String emoji;
  final EatingWindow? window;

  /// Multiplier on the standard deficit (1.0 = standard).
  final double deficitFactor;

  /// Program is LOCKED behind "my doctor approved this" if any is present.
  final Set<HealthCondition> requiresDoctorIf;

  /// Program is allowed but shows a strong warning if any is present.
  final Set<HealthCondition> cautionIf;
}
