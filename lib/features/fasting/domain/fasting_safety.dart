import 'package:flutter/foundation.dart';

@immutable
class FastingSafetyProfile {
  const FastingSafetyProfile({
    this.isPregnantOrNursing = false,
    this.isUnder18 = false,
    this.hasDiabetesOnMedication = false,
    this.hasEatingDisorderHistory = false,
    this.confirmedLongFastDoctorAdvice = false,
  });

  final bool isPregnantOrNursing;
  final bool isUnder18;
  final bool hasDiabetesOnMedication;
  final bool hasEatingDisorderHistory;
  final bool confirmedLongFastDoctorAdvice;

  /// Whether fasting suggestions and plans should be disabled due to medical contraindications.
  bool get hasContraindications =>
      isPregnantOrNursing ||
      isUnder18 ||
      hasDiabetesOnMedication ||
      hasEatingDisorderHistory;

  /// Human-readable medical warning text.
  String getWarningMessage(bool isArabic) {
    if (isPregnantOrNursing) {
      return isArabic
          ? 'الصيام المتقطع غير موصى به أثناء الحمل أو الرضاعة الطبيعية لضمان التغذية الكافية للجنين والطفل.'
          : 'Intermittent fasting is not recommended during pregnancy or breastfeeding.';
    }
    if (isUnder18) {
      return isArabic
          ? 'المراهقون والأشخاص تحت سن 18 عاماً يحتاجون لطاقة وتغذية منتظمة للنمو السليم، ولا يوصى بالصيام المتقطع.'
          : 'Individuals under 18 require continuous nutrition for healthy development; fasting is not advised.';
    }
    if (hasDiabetesOnMedication) {
      return isArabic
          ? 'مرضى السكري المعتمدون على أدوية أو أنسولين معرضون لخطر هبوط السكر الحاد؛ استشر طبيبك المعالج أولاً.'
          : 'Diabetic individuals on medication are at high risk of hypoglycemia; consult your physician first.';
    }
    if (hasEatingDisorderHistory) {
      return isArabic
          ? 'الصيام المتقطع قد يحفز اضطرابات الأكل السابقة؛ نوصي بالتركيز على وجبات متوازنة ومنتظمة.'
          : 'Fasting may trigger disordered eating patterns; regular balanced meals are recommended.';
    }
    return '';
  }

  FastingSafetyProfile copyWith({
    bool? isPregnantOrNursing,
    bool? isUnder18,
    bool? hasDiabetesOnMedication,
    bool? hasEatingDisorderHistory,
    bool? confirmedLongFastDoctorAdvice,
  }) {
    return FastingSafetyProfile(
      isPregnantOrNursing: isPregnantOrNursing ?? this.isPregnantOrNursing,
      isUnder18: isUnder18 ?? this.isUnder18,
      hasDiabetesOnMedication: hasDiabetesOnMedication ?? this.hasDiabetesOnMedication,
      hasEatingDisorderHistory: hasEatingDisorderHistory ?? this.hasEatingDisorderHistory,
      confirmedLongFastDoctorAdvice: confirmedLongFastDoctorAdvice ?? this.confirmedLongFastDoctorAdvice,
    );
  }

  Map<String, dynamic> toJson() => {
        'pregnant_or_nursing': isPregnantOrNursing,
        'under_18': isUnder18,
        'diabetes_on_meds': hasDiabetesOnMedication,
        'eating_disorder_history': hasEatingDisorderHistory,
        'confirmed_long_fast_doctor': confirmedLongFastDoctorAdvice,
      };

  factory FastingSafetyProfile.fromJson(Map<String, dynamic> json) {
    return FastingSafetyProfile(
      isPregnantOrNursing: json['pregnant_or_nursing'] as bool? ?? false,
      isUnder18: json['under_18'] as bool? ?? false,
      hasDiabetesOnMedication: json['diabetes_on_meds'] as bool? ?? false,
      hasEatingDisorderHistory: json['eating_disorder_history'] as bool? ?? false,
      confirmedLongFastDoctorAdvice: json['confirmed_long_fast_doctor'] as bool? ?? false,
    );
  }
}
