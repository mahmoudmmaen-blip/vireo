abstract final class DateUtilsVireo {
  static int isoWeekNumber(DateTime date) {
    final d = DateTime.utc(date.year, date.month, date.day);
    final jsDay = d.weekday % 7;
    final thursday = d.add(Duration(days: 4 - (jsDay == 0 ? 7 : jsDay)));
    final yearStart = DateTime.utc(thursday.year, 1, 1);
    return ((thursday.difference(yearStart).inDays + 1) / 7).ceil();
  }

  static int todayDayIndex() {
    return DateTime.now().weekday - 1;
  }
}
