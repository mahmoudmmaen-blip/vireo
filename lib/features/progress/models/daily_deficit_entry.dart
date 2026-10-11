import 'package:flutter/foundation.dart';

@immutable
class DailyDeficitEntry {
  const DailyDeficitEntry({
    required this.date,
    required this.tdee,
    required this.consumed,
    required this.burned,
    this.isToday = false,
  });

  final DateTime date;
  final int tdee;
  final int consumed;
  final int burned;
  final bool isToday;

  /// True when at least one meal was logged that day.
  bool get hasFoodLogged => consumed > 0;

  /// Positive = calorie deficit, negative = surplus.
  /// Only meaningful when [hasFoodLogged] is true.
  int get netBalance => tdee - consumed + burned;

  bool get hasActivity => hasFoodLogged || burned > 0;

  /// Partial day — show as in-progress, exclude from weekly total.
  bool get isInProgress => isToday;
}

@immutable
class WeeklyDeficitSummary {
  const WeeklyDeficitSummary({
    required this.days,
    required this.totalNetKcal,
    required this.hasData,
  });

  final List<DailyDeficitEntry> days;

  /// Sum of deficits for completed days with food logged (today excluded).
  final int totalNetKcal;

  /// True when at least one completed day in the window has food logged.
  final bool hasData;
}
