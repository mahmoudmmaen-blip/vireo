import 'package:flutter/foundation.dart';
import 'package:vireo/features/measurements/domain/body_composition_report.dart';

@immutable
class BodyReportInsight {
  const BodyReportInsight({
    required this.emoji,
    required this.title,
    required this.description,
    this.isAlert = false,
  });

  final String emoji;
  final String title;
  final String description;
  final bool isAlert;
}

/// Generates authentic Egyptian Arabic insights from any BodyCompositionReport.
abstract final class BodyCompositionInsights {
  static List<BodyReportInsight> generate(
    BodyCompositionReport report, {
    bool isArabic = true,
  }) {
    final insights = <BodyReportInsight>[];

    // 1. Fat % & Fat loss goal
    final pbf = report.percentBodyFat;
    final isMale = report.sex == null || report.sex == 'male' || report.sex == 'ذكر';
    final normalPbfMin = isMale ? 10.0 : 18.0;
    final normalPbfMax = isMale ? 20.0 : 28.0;

    if (pbf != null) {
      final fatControl = report.fatControlKg;
      if (fatControl != null && fatControl < 0) {
        final toLose = fatControl.abs();
        insights.add(
          BodyReportInsight(
            emoji: '🎯',
            title: isArabic ? 'خطة خسارة الدهون' : 'Fat Loss Target',
            description: isArabic
                ? 'الدهون ${pbf.toStringAsFixed(1)}% (الطبيعي $normalPbfMin–$normalPbfMax%) → هدفك تخسر ≈ ${toLose.toStringAsFixed(1)} كجم دهون مع الحفاظ على العضل.'
                : 'Body fat is ${pbf.toStringAsFixed(1)}% (Normal: $normalPbfMin–$normalPbfMax%). Target: lose ≈ ${toLose.toStringAsFixed(1)} kg fat while preserving muscle.',
          ),
        );
      } else if (pbf > normalPbfMax) {
        insights.add(
          BodyReportInsight(
            emoji: '🎯',
            title: isArabic ? 'نسبة الدهون' : 'Body Fat',
            description: isArabic
                ? 'الدهون ${pbf.toStringAsFixed(1)}% (الطبيعي $normalPbfMin–$normalPbfMax%) → ركّز على عجز سعرات خفيف مع رفع البروتين للحفاظ على العضل.'
                : 'Body fat is ${pbf.toStringAsFixed(1)}% (Normal: $normalPbfMin–$normalPbfMax%). Maintain moderate calorie deficit with high protein.',
          ),
        );
      } else {
        insights.add(
          BodyReportInsight(
            emoji: '💪',
            title: isArabic ? 'نسبة دهون مثالية' : 'Optimal Body Fat',
            description: isArabic
                ? 'نسبة الدهون ${pbf.toStringAsFixed(1)}% ممتازة وضمن النطاق الصحي والرياضي الطبيعي ✓'
                : 'Body fat is ${pbf.toStringAsFixed(1)}%, within optimal athletic & healthy range ✓',
          ),
        );
      }
    }

    // 2. Visceral Fat Level
    final visceral = report.visceralFatLevel;
    if (visceral != null) {
      if (visceral > 9) {
        insights.add(
          BodyReportInsight(
            emoji: '⚠️',
            title: isArabic ? 'الدهون الحشوية' : 'Visceral Fat',
            description: isArabic
                ? 'الدهون الحشوية $visceral (أعلى من 9): الدهون المحيطة بالأعضاء محتاجة تركيز في المشي اليومي (7000+ خطوة) وتقليل السكريات والمقليات لحماية القلب والنشاط.'
                : 'Visceral fat is $visceral (>9). Prioritize daily walks (7,000+ steps) and cut refined sugars to protect cardiovascular health.',
            isAlert: true,
          ),
        );
      } else {
        insights.add(
          BodyReportInsight(
            emoji: '🫀',
            title: isArabic ? 'الدهون الحشوية صحية' : 'Healthy Visceral Fat',
            description: isArabic
                ? 'الدهون الحشوية $visceral ممتازة وضمن النطاق الآمن (أقل من 9) ✓'
                : 'Visceral fat is $visceral, safely under 9 ✓',
          ),
        );
      }
    }

    // 3. Segmental Balance (Left vs Right)
    final rArm = report.segmentalLean.rightArm.kg?.value;
    final lArm = report.segmentalLean.leftArm.kg?.value;
    final rLeg = report.segmentalLean.rightLeg.kg?.value;
    final lLeg = report.segmentalLean.leftLeg.kg?.value;

    if (rArm != null && lArm != null) {
      final armDiff = (rArm - lArm).abs();
      final armMax = (rArm > lArm ? rArm : lArm);
      final armPercentDiff = armMax > 0 ? (armDiff / armMax) * 100 : 0.0;

      if (armPercentDiff > 8.0) {
        insights.add(
          BodyReportInsight(
            emoji: '⚖️',
            title: isArabic ? 'توازن عضلات الذراعين' : 'Arm Symmetry',
            description: isArabic
                ? 'فرق بسيط بين الذراعين (${(armPercentDiff).toStringAsFixed(0)}%). التمارين الفردية بالدمبلز (Unilateral) هتساعدك تساوي القوة والكتلة.'
                : 'Slight asymmetry between arms (~${(armPercentDiff).toStringAsFixed(0)}%). Unilateral dumbbell training is recommended.',
          ),
        );
      } else {
        insights.add(
          BodyReportInsight(
            emoji: '⚖️',
            title: isArabic ? 'توازن متناسق' : 'Symmetric Balance',
            description: isArabic
                ? 'توزيع العضلات بين الجانب الأيمن والأيسر متناسق جداً وممتاز ✓'
                : 'Muscle distribution between right and left sides is well balanced ✓',
          ),
        );
      }
    } else if (rLeg != null && lLeg != null) {
      final legDiff = (rLeg - lLeg).abs();
      final legMax = (rLeg > lLeg ? rLeg : lLeg);
      final legPercentDiff = legMax > 0 ? (legDiff / legMax) * 100 : 0.0;
      if (legPercentDiff > 8.0) {
        insights.add(
          BodyReportInsight(
            emoji: '⚖️',
            title: isArabic ? 'توازن الساقين' : 'Leg Symmetry',
            description: isArabic
                ? 'فرق بسيط بين الساقين. ركّز على تمارين الطعنات (Lunges) والسكوات الفردي لضبط التوازن.'
                : 'Slight difference in leg mass. Single-leg squats and lunges will help balance them.',
          ),
        );
      }
    }

    // 4. Phase Angle (general, non-medical)
    final phaseAngle = report.phaseAngle;
    if (phaseAngle != null) {
      insights.add(
        BodyReportInsight(
          emoji: '⚡',
          title: isArabic ? 'زاوية طور الخلايا (Phase Angle)' : 'Phase Angle',
          description: isArabic
              ? 'زاوية طور الجسم ${phaseAngle.toStringAsFixed(1)}°: مؤشر عام لصحة ونشاط الخلايا وجودة الترطيب (النطاق الطبيعي 5.0–7.5°).'
              : 'Whole-body phase angle is ${phaseAngle.toStringAsFixed(1)}°, reflecting cellular integrity and hydration (normal range: 5.0–7.5°).',
        ),
      );
    }

    return insights;
  }
}
