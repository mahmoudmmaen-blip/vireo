import 'package:flutter/material.dart';
import 'package:vireo/core/theme/vireo_bridge.dart';

enum FastingStage {
  anabolic(
    id: 'anabolic',
    startHour: 0,
    endHour: 4,
    titleAr: 'هضم وامتصاص الوجبة (Anabolic)',
    titleEn: 'Digestion & Anabolic',
    scienceAr: 'الجسم يقوم بهضم الوجبة الأخيرة وامتصاص المغذيات. يرتفع الأنسولين بشكل طبيعي ومؤقت لتخزين الجلوكوز والأحماض الأمينية.',
    scienceEn: 'Body digests and absorbs the last meal. Insulin temporarily rises to transport glucose and nutrients to cells.',
    badgeLabelAr: '0 - 4 ساعات',
    badgeLabelEn: '0 - 4 hrs',
    accentColor: VBridge.cFF3B82F6, // Blue
  ),
  catabolic(
    id: 'catabolic',
    startHour: 4,
    endHour: 12,
    titleAr: 'استهلاك مخزون الجليكوجين (Catabolic)',
    titleEn: 'Glycogen Utilization',
    scienceAr: 'يبدأ سكر الدم والأنسولين في الاستقرار والانخفاض تدريجياً. يبدأ الجسم في استهلاك الجليكوجين المخزن في الكبد لتأمين الطاقة.',
    scienceEn: 'Blood sugar and insulin gradually stabilize. The liver begins breaking down stored glycogen to supply steady energy.',
    badgeLabelAr: '4 - 12 ساعة',
    badgeLabelEn: '4 - 12 hrs',
    accentColor: VBridge.cFF10B981, // Emerald
  ),
  fatBurning(
    id: 'fat_burning',
    startHour: 12,
    endHour: 18,
    titleAr: 'زيادة أكسدة وحرق الدهون (غالباً / تقريباً)',
    titleEn: 'Increased Fat Oxidation (Estimated)',
    scienceAr: 'مع انخفاض مخازن الجليكوجين، يبدأ الجسم (غالباً / تقريباً) في الاعتماد بنسبة أعلى على تفكيك الدهون المخزنة كوقود رئيسي.',
    scienceEn: 'As liver glycogen declines, the body typically shifts towards using stored triglycerides for metabolic fuel.',
    badgeLabelAr: '12 - 18 ساعة',
    badgeLabelEn: '12 - 18 hrs',
    accentColor: VBridge.cFFF59E0B, // Amber
  ),
  ketosis(
    id: 'ketosis',
    startHour: 18,
    endHour: 24,
    titleAr: 'بداية الحالة الكيتونية (تقريباً / حسب النشاط)',
    titleEn: 'Early Ketosis (Approximate)',
    scienceAr: 'تقريباً وبحسب طبيعة الجسم ونشاطه وحجم آخر وجبة، يبدأ الكبد بإنتاج أجسام كيتونية كمصدر طاقة بديل للدماغ والعضلات.',
    scienceEn: 'Depending on individual metabolism and activity level, the liver begins producing ketone bodies as alternative fuel.',
    badgeLabelAr: '18 - 24 ساعة',
    badgeLabelEn: '18 - 24 hrs',
    accentColor: VBridge.cFF8B5CF6, // Purple
  ),
  autophagy(
    id: 'autophagy',
    startHour: 24,
    endHour: 72,
    titleAr: 'التجديد الخلوي والالتهام الذاتي (أبحاث خلوية)',
    titleEn: 'Cellular Cleanup & Autophagy',
    scienceAr: 'تشير الأبحاث الخلوية إلى تنشيط آليات إعادة تدوير البروتينات والمكونات الخلوية التالفة. التوقيت والعمق يختلفان بشدة بين الأشخاص.',
    scienceEn: 'Cellular biology indicates activation of self-clearing mechanisms for cellular debris. Timing and depth vary by individual.',
    badgeLabelAr: '24+ ساعة',
    badgeLabelEn: '24+ hrs',
    accentColor: VBridge.cFFEC4899, // Pink
  );

  const FastingStage({
    required this.id,
    required this.startHour,
    required this.endHour,
    required this.titleAr,
    required this.titleEn,
    required this.scienceAr,
    required this.scienceEn,
    required this.badgeLabelAr,
    required this.badgeLabelEn,
    required this.accentColor,
  });

  final String id;
  final int startHour;
  final int endHour;
  final String titleAr;
  final String titleEn;
  final String scienceAr;
  final String scienceEn;
  final String badgeLabelAr;
  final String badgeLabelEn;
  final Color accentColor;

  String title(bool isArabic) => isArabic ? titleAr : titleEn;
  String science(bool isArabic) => isArabic ? scienceAr : scienceEn;
  String badgeLabel(bool isArabic) => isArabic ? badgeLabelAr : badgeLabelEn;

  String shortTitle(bool isArabic) {
    if (!isArabic) {
      switch (this) {
        case FastingStage.anabolic:
          return 'Anabolic';
        case FastingStage.catabolic:
          return 'Catabolic';
        case FastingStage.fatBurning:
          return 'Fat Burning';
        case FastingStage.ketosis:
          return 'Ketosis';
        case FastingStage.autophagy:
          return 'Autophagy';
      }
    }
    switch (this) {
      case FastingStage.anabolic:
        return 'هضم الطعام';
      case FastingStage.catabolic:
        return 'استهلاك الجليكوجين';
      case FastingStage.fatBurning:
        return 'حرق الدهون';
      case FastingStage.ketosis:
        return 'الحالة الكيتونية';
      case FastingStage.autophagy:
        return 'التجديد الخلوي';
    }
  }

  /// Returns the current fasting stage based on elapsed duration.
  static FastingStage fromElapsed(Duration elapsed) {
    final hours = elapsed.inMinutes / 60.0;
    if (hours < 4.0) return FastingStage.anabolic;
    if (hours < 12.0) return FastingStage.catabolic;
    if (hours < 18.0) return FastingStage.fatBurning;
    if (hours < 24.0) return FastingStage.ketosis;
    return FastingStage.autophagy;
  }
}
