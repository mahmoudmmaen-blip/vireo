import 'package:adhan/adhan.dart';
import 'package:flutter/foundation.dart';
import 'package:hijri/hijri_calendar.dart';

enum RamadanCalculationMethod {
  egyptian('egyptian', 'الهيئة المصرية العامة للمساحة', 30.0444, 31.2357, 'القاهرة'),
  ummAlQura('umm_al_qura', 'أم القرى (مكة المكرمة)', 21.4225, 39.8262, 'مكة المكرمة'),
  muslimWorldLeague('muslim_world_league', 'رابطة العالم الإسلامي', 24.4672, 39.6111, 'المدينة المنورة'),
  dubai('dubai', 'دبي والإمارات', 25.2048, 55.2708, 'دبي'),
  kuwait('kuwait', 'الكويت', 29.3759, 47.9774, 'الكويت'),
  qatar('qatar', 'قطر', 25.2854, 51.5310, 'الدوحة');

  const RamadanCalculationMethod(
    this.key,
    this.labelAr,
    this.defaultLat,
    this.defaultLng,
    this.defaultCity,
  );

  final String key;
  final String labelAr;
  final double defaultLat;
  final double defaultLng;
  final String defaultCity;

  static RamadanCalculationMethod fromKey(String? key) {
    return RamadanCalculationMethod.values.firstWhere(
      (m) => m.key == key,
      orElse: () => RamadanCalculationMethod.egyptian,
    );
  }

  CalculationParameters get parameters => switch (this) {
        RamadanCalculationMethod.egyptian => CalculationMethod.egyptian.getParameters(),
        RamadanCalculationMethod.ummAlQura => CalculationMethod.umm_al_qura.getParameters(),
        RamadanCalculationMethod.muslimWorldLeague => CalculationMethod.muslim_world_league.getParameters(),
        RamadanCalculationMethod.dubai => CalculationMethod.dubai.getParameters(),
        RamadanCalculationMethod.kuwait => CalculationMethod.kuwait.getParameters(),
        RamadanCalculationMethod.qatar => CalculationMethod.qatar.getParameters(),
      };
}

@immutable
class RamadanPrayerTimes {
  const RamadanPrayerTimes({
    required this.fajr,
    required this.maghrib,
    required this.now,
  });

  final DateTime fajr;
  final DateTime maghrib;
  final DateTime now;

  /// Whether current time is within fasting hours (Fajr to Maghrib).
  bool get isFasting => now.isAfter(fajr) && now.isBefore(maghrib);

  /// Duration until next Iftar (Maghrib). If Maghrib has passed today, computes until tomorrow's Maghrib.
  Duration get timeUntilIftar {
    if (now.isBefore(maghrib)) {
      return maghrib.difference(now);
    }
    // Already past Maghrib today -> time until next day Maghrib (approx 24h later)
    final tomorrowMaghrib = maghrib.add(const Duration(days: 1));
    return tomorrowMaghrib.difference(now);
  }

  /// Duration until next Suhoor end (Fajr). If Fajr passed today, computes until tomorrow's Fajr.
  Duration get timeUntilSuhoorEnd {
    if (now.isBefore(fajr)) {
      return fajr.difference(now);
    }
    final tomorrowFajr = fajr.add(const Duration(days: 1));
    return tomorrowFajr.difference(now);
  }

  String formatCountdown(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  static RamadanPrayerTimes calculate({
    required double lat,
    required double lng,
    required RamadanCalculationMethod method,
    DateTime? date,
  }) {
    final targetDate = date ?? DateTime.now();
    final coordinates = Coordinates(lat, lng);
    final params = method.parameters;
    final pt = PrayerTimes(
      coordinates,
      DateComponents.from(targetDate),
      params,
    );
    return RamadanPrayerTimes(
      fajr: pt.fajr,
      maghrib: pt.maghrib,
      now: targetDate,
    );
  }
}

class RamadanScheduleService {
  const RamadanScheduleService._();

  /// Check if the current Hijri month is Ramadan (Month 9).
  static bool isRamadanNow() {
    try {
      final hDate = HijriCalendar.now();
      return hDate.hMonth == 9;
    } catch (_) {
      return false;
    }
  }

  /// Split calories and protein across 3 Ramadan meal slots:
  /// - Iftar (فطار): ~45% kcal, ~40% protein
  /// - Suhoor (سحور): ~35% kcal, ~35% protein
  /// - Post-Iftar Snack (سناك بعد الفطار): ~20% kcal, ~25% protein
  static Map<String, ({int calories, int proteinG})> splitMacros({
    required int totalCalories,
    required int totalProteinG,
  }) {
    final iftarCals = (totalCalories * 0.45).round();
    final suhoorCals = (totalCalories * 0.35).round();
    final snackCals = (totalCalories - iftarCals - suhoorCals).clamp(0, totalCalories);

    final iftarProtein = (totalProteinG * 0.40).round();
    final suhoorProtein = (totalProteinG * 0.35).round();
    final snackProtein = (totalProteinG - iftarProtein - suhoorProtein).clamp(0, totalProteinG);

    return {
      'iftar': (calories: iftarCals, proteinG: iftarProtein),
      'suhoor': (calories: suhoorCals, proteinG: suhoorProtein),
      'snack': (calories: snackCals, proteinG: snackProtein),
    };
  }

  /// Distribute daily water goal across non-fasting hours:
  /// - At Iftar: 25% (e.g. 2 cups / 500ml)
  /// - Evening (between Iftar and Suhoor): 50% (e.g. 4 cups / 1000ml)
  /// - At Suhoor: 25% (e.g. 2 cups / 500ml)
  static Map<String, int> distributeWaterMl(int totalWaterMl) {
    final iftarMl = (totalWaterMl * 0.25).round();
    final suhoorMl = (totalWaterMl * 0.25).round();
    final eveningMl = (totalWaterMl - iftarMl - suhoorMl).clamp(0, totalWaterMl);

    return {
      'iftar': iftarMl,
      'evening': eveningMl,
      'suhoor': suhoorMl,
    };
  }

  /// Best workout timing tip in Ramadan:
  static String workoutTimingTip({bool isArabic = true}) {
    return isArabic
        ? 'أفضل وقت للتمرين في رمضان: بعد الإفطار بساعة ونصف إلى ساعتين لتجديد الطاقة والماء، أو مشي خفيف قبل أذان المغرب بنصف ساعة.'
        : 'Best workout timing in Ramadan: 60–90 minutes after Iftar with adequate hydration, or light walking 30 minutes before Maghrib.';
  }
}
