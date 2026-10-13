import 'package:flutter/foundation.dart';

enum CyclePhase {
  menstrual,
  follicular,
  ovulatory,
  luteal;

  String get displayNameAr => switch (this) {
        CyclePhase.menstrual => 'مرحلة الحيض (Menstrual)',
        CyclePhase.follicular => 'المرحلة الجريبية (Follicular)',
        CyclePhase.ovulatory => 'مرحلة التبويض (Ovulatory)',
        CyclePhase.luteal => 'المرحلة الصفرية (Luteal)',
      };

  String get displayNameEn => switch (this) {
        CyclePhase.menstrual => 'Menstrual Phase',
        CyclePhase.follicular => 'Follicular Phase',
        CyclePhase.ovulatory => 'Ovulatory Phase',
        CyclePhase.luteal => 'Luteal Phase',
      };

  String get tipBodyAr => switch (this) {
        CyclePhase.luteal =>
          '💡 زيادة الشهية (+100-300 سعرة) طبيعية في المرحلة الصفرية. أي زيادة على الميزان هي احتباس سوائل طبيعي مؤقت.',
        CyclePhase.menstrual =>
          '🩸 تمارين خفيفة وتمدد هي الأنسب لجسمك اليوم، وركزي على أطعمة غنية بالحديد.',
        CyclePhase.follicular =>
          '✨ طاقتك ونشاطك في تصاعد مستمر، وقت مثالي لتمارين المقاومة والقوة.',
        CyclePhase.ovulatory =>
          '🔥 قمة الحيوية والنشاط، حافظي على ترطيب جسمك بالمياه.',
      };

  String get tipBodyEn => switch (this) {
        CyclePhase.luteal =>
          'Appetite +100-300 kcal is normal. Scale jumps are water retention.',
        CyclePhase.menstrual =>
          'Light workouts and stretching advised. Prioritize iron-rich foods.',
        CyclePhase.follicular =>
          'High energy phase! Great time for strength and cardio.',
        CyclePhase.ovulatory =>
          'Peak vitality and motivation. Stay hydrated.',
      };
}

enum WomenMode {
  standard,
  pregnant,
  breastfeeding;

  String get displayNameAr => switch (this) {
        WomenMode.standard => 'الوضع القياسي',
        WomenMode.pregnant => 'حامل (Pregnancy)',
        WomenMode.breastfeeding => 'مرضعة (Breastfeeding)',
      };
}

enum PregnancyTrimester {
  first,
  second,
  third;

  String get displayNameAr => switch (this) {
        PregnancyTrimester.first => 'الثلث الأول (الأسابيع 1-12)',
        PregnancyTrimester.second => 'الثلث الثاني (الأسابيع 13-26)',
        PregnancyTrimester.third => 'الثلث الثالث (الأسابيع 27-40)',
      };

  int get surplusKcal => switch (this) {
        PregnancyTrimester.first => 0, // No extra calories needed in 1st trimester
        PregnancyTrimester.second => 340,
        PregnancyTrimester.third => 450,
      };
}

@immutable
class CycleLogEntry {
  const CycleLogEntry({
    required this.startDate,
    this.endDate,
    this.cycleLength = 28,
    this.periodLength = 5,
    this.symptoms = const [],
    this.notes,
  });

  final DateTime startDate;
  final DateTime? endDate;
  final int cycleLength;
  final int periodLength;
  final List<String> symptoms;
  final String? notes;

  Map<String, dynamic> toJson() => {
        'start_date': startDate.toIso8601String(),
        'end_date': endDate?.toIso8601String(),
        'cycle_length': cycleLength,
        'period_length': periodLength,
        'symptoms': symptoms,
        'notes': notes,
      };

  factory CycleLogEntry.fromJson(Map<dynamic, dynamic> map) {
    return CycleLogEntry(
      startDate: DateTime.parse(map['start_date'] as String),
      endDate: map['end_date'] != null
          ? DateTime.tryParse(map['end_date'] as String)
          : null,
      cycleLength: map['cycle_length'] as int? ?? 28,
      periodLength: map['period_length'] as int? ?? 5,
      symptoms: (map['symptoms'] as List?)?.cast<String>() ?? const [],
      notes: map['notes'] as String?,
    );
  }
}
