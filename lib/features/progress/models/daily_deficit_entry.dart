import 'package:flutter/foundation.dart';

@immutable
class DailyDeficitEntry {
  const DailyDeficitEntry({
    required this.date,
    required this.tdee,
    required this.consumed,
    required this.burned,
  });

  final DateTime date;
  final int tdee;
  final int consumed;
  final int burned;

  /// Positive = calorie deficit, negative = surplus.
  int get netBalance => tdee - consumed + burned;

  bool get hasActivity => consumed > 0 || burned > 0;
}

@immutable
class WeeklyDeficitSummary {
  const WeeklyDeficitSummary({
    required this.days,
    required this.totalNetKcal,
    required this.hasData,
  });

  final List<DailyDeficitEntry> days;
  final int totalNetKcal;
  final bool hasData;
}
