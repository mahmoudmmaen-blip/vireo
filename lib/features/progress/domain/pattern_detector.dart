import 'package:flutter/foundation.dart';

enum PatternKind {
  weekendOvereating,
  lateNightSnacking,
  lowProteinBreakfast,
  workdayStepDip,
  loggingGaps,
  plateau,
}

@immutable
class PatternInsight {
  const PatternInsight({
    required this.kind,
    required this.titleAr,
    required this.fixAr,
    required this.reminderLabelAr,
  });

  final PatternKind kind;
  final String titleAr;
  final String fixAr;
  final String reminderLabelAr;
}

@immutable
class DayNutritionSample {
  const DayNutritionSample({
    required this.date,
    required this.intakeKcal,
    required this.targetKcal,
    required this.breakfastProteinG,
    required this.proteinTargetG,
    required this.lateNightKcal,
    required this.steps,
    required this.stepGoal,
    required this.hasLog,
  });

  final DateTime date;
  final int intakeKcal;
  final int targetKcal;
  final int breakfastProteinG;
  final int proteinTargetG;
  final int lateNightKcal;
  final int steps;
  final int stepGoal;
  final bool hasLog;

  bool get isWeekend => date.weekday == DateTime.saturday || date.weekday == DateTime.friday;
  bool get isWorkday => !isWeekend;
}

/// Local deterministic patterns from ≥ 2 weeks of data. Max one insight/day.
abstract final class PatternDetector {
  static const int minDays = 14;

  static PatternInsight? detect({
    required List<DayNutritionSample> days,
    required double? trendSlopeKgPerDay,
    required double adherenceRatio,
    DateTime? now,
  }) {
    if (days.length < minDays) return null;
    final sorted = [...days]..sort((a, b) => a.date.compareTo(b.date));

    // Weekend overeating
    final weekend = sorted.where((d) => d.isWeekend && d.hasLog).toList();
    final weekday = sorted.where((d) => d.isWorkday && d.hasLog).toList();
    if (weekend.length >= 2 && weekday.length >= 4) {
      final wAvg = _avg(weekend.map((d) => d.intakeKcal - d.targetKcal));
      final dAvg = _avg(weekday.map((d) => d.intakeKcal - d.targetKcal));
      if (wAvg > dAvg + 200) {
        return const PatternInsight(
          kind: PatternKind.weekendOvereating,
          titleAr: 'الويكند بيزيد عن الأسبوع',
          fixAr: 'جهّز وجبة خفيفة قبل الخروجات',
          reminderLabelAr: 'اعملها تذكير',
        );
      }
    }

    // Late-night snacking
    final late = sorted.where((d) => d.lateNightKcal > 250).length;
    if (late >= 4) {
      return const PatternInsight(
        kind: PatternKind.lateNightSnacking,
        titleAr: 'سناك متأخر كتير',
        fixAr: 'حدّد آخر أكل قبل النوم بساعتين',
        reminderLabelAr: 'اعملها تذكير',
      );
    }

    // Low protein breakfast
    final lowB = sorted
        .where(
          (d) =>
              d.proteinTargetG > 0 &&
              d.breakfastProteinG < d.proteinTargetG * 0.15,
        )
        .length;
    if (lowB >= 5) {
      return const PatternInsight(
        kind: PatternKind.lowProteinBreakfast,
        titleAr: 'الفطار قليل البروتين',
        fixAr: 'زود بيضة أو زبادي على الفطار',
        reminderLabelAr: 'اعملها تذكير',
      );
    }

    // Workday step dips
    if (weekday.length >= 5) {
      final wSteps = _avg(weekend.map((d) => d.steps.toDouble()));
      final dSteps = _avg(weekday.map((d) => d.steps.toDouble()));
      if (wSteps > 0 && dSteps < wSteps * 0.6) {
        return const PatternInsight(
          kind: PatternKind.workdayStepDip,
          titleAr: 'خطوات الشغل أقل من الويكند',
          fixAr: 'مشي ١٠ دقايق بعد الغدا',
          reminderLabelAr: 'اعملها تذكير',
        );
      }
    }

    // Logging gaps
    final gaps = sorted.where((d) => !d.hasLog).length;
    if (gaps >= 4) {
      return const PatternInsight(
        kind: PatternKind.loggingGaps,
        titleAr: 'في أيام من غير تسجيل',
        fixAr: 'سجّل وجبة واحدة بسرعة كل يوم',
        reminderLabelAr: 'اعملها تذكير',
      );
    }

    // Plateau: flat trend 14+ days, adherence ≥ 80%
    if (trendSlopeKgPerDay != null &&
        trendSlopeKgPerDay.abs() < 0.01 / 7 &&
        adherenceRatio >= 0.80) {
      return const PatternInsight(
        kind: PatternKind.plateau,
        titleAr: 'الوزن واقف من أسبوعين',
        fixAr: 'استراحة دايت، أو −١٠٠ سعرة، أو +٢٠٠٠ خطوة',
        reminderLabelAr: 'اعملها تذكير',
      );
    }

    return null;
  }

  static double _avg(Iterable<num> xs) {
    final list = xs.toList();
    if (list.isEmpty) return 0;
    return list.fold<double>(0, (s, e) => s + e) / list.length;
  }
}

/// Notification budget: max 3/day, quiet hours, stop type ignored 3×.
abstract final class NotificationBudget {
  static const int maxPerDay = 3;
  static const int quietStartHour = 22;
  static const int quietEndHour = 8;
  static const int ignoreStopCount = 3;

  static bool canSend({
    required int sentToday,
    required int hour,
    required int ignoredCountForType,
    bool isRamadan = false,
  }) {
    if (sentToday >= maxPerDay) return false;
    if (ignoredCountForType >= ignoreStopCount) return false;
    final quietStart = isRamadan ? 1 : quietStartHour;
    final quietEnd = isRamadan ? 9 : quietEndHour;
    if (hour >= quietStart || hour < quietEnd) return false;
    return true;
  }
}
