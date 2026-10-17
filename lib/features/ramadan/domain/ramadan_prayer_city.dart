import 'package:flutter/foundation.dart';
import 'package:vireo/features/ramadan/services/ramadan_schedule_service.dart';

/// Offline prayer-time city preset (no GPS permission).
@immutable
class RamadanPrayerCityPreset {
  const RamadanPrayerCityPreset({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.latitude,
    required this.longitude,
    required this.calculationMethod,
  });

  final String id;
  final String nameAr;
  final String nameEn;
  final double latitude;
  final double longitude;
  final RamadanCalculationMethod calculationMethod;

  String localizedName(String localeCode) =>
      localeCode.startsWith('ar') ? nameAr : nameEn;
}

/// Preset ids stored in Hive.
abstract final class RamadanPrayerCityIds {
  static const cairo = 'cairo';
  static const alexandria = 'alexandria';
  static const riyadh = 'riyadh';
  static const jeddah = 'jeddah';
  static const dammam = 'dammam';
  static const dubai = 'dubai';
  static const abuDhabi = 'abu_dhabi';
  static const kuwait = 'kuwait';
  static const doha = 'doha';
  static const manama = 'manama';
  static const muscat = 'muscat';
  static const custom = 'custom';
}

abstract final class RamadanPrayerCities {
  static const List<RamadanPrayerCityPreset> presets = [
    RamadanPrayerCityPreset(
      id: RamadanPrayerCityIds.cairo,
      nameAr: 'القاهرة',
      nameEn: 'Cairo',
      latitude: 30.0444,
      longitude: 31.2357,
      calculationMethod: RamadanCalculationMethod.egyptian,
    ),
    RamadanPrayerCityPreset(
      id: RamadanPrayerCityIds.alexandria,
      nameAr: 'الإسكندرية',
      nameEn: 'Alexandria',
      latitude: 31.2001,
      longitude: 29.9187,
      calculationMethod: RamadanCalculationMethod.egyptian,
    ),
    RamadanPrayerCityPreset(
      id: RamadanPrayerCityIds.riyadh,
      nameAr: 'الرياض',
      nameEn: 'Riyadh',
      latitude: 24.7136,
      longitude: 46.6753,
      calculationMethod: RamadanCalculationMethod.ummAlQura,
    ),
    RamadanPrayerCityPreset(
      id: RamadanPrayerCityIds.jeddah,
      nameAr: 'جدة',
      nameEn: 'Jeddah',
      latitude: 21.4858,
      longitude: 39.1925,
      calculationMethod: RamadanCalculationMethod.ummAlQura,
    ),
    RamadanPrayerCityPreset(
      id: RamadanPrayerCityIds.dammam,
      nameAr: 'الدمام',
      nameEn: 'Dammam',
      latitude: 26.3927,
      longitude: 49.9777,
      calculationMethod: RamadanCalculationMethod.ummAlQura,
    ),
    RamadanPrayerCityPreset(
      id: RamadanPrayerCityIds.dubai,
      nameAr: 'دبي',
      nameEn: 'Dubai',
      latitude: 25.2048,
      longitude: 55.2708,
      calculationMethod: RamadanCalculationMethod.dubai,
    ),
    RamadanPrayerCityPreset(
      id: RamadanPrayerCityIds.abuDhabi,
      nameAr: 'أبوظبي',
      nameEn: 'Abu Dhabi',
      latitude: 24.4539,
      longitude: 54.3773,
      calculationMethod: RamadanCalculationMethod.dubai,
    ),
    RamadanPrayerCityPreset(
      id: RamadanPrayerCityIds.kuwait,
      nameAr: 'الكويت',
      nameEn: 'Kuwait City',
      latitude: 29.3759,
      longitude: 47.9774,
      calculationMethod: RamadanCalculationMethod.kuwait,
    ),
    RamadanPrayerCityPreset(
      id: RamadanPrayerCityIds.doha,
      nameAr: 'الدوحة',
      nameEn: 'Doha',
      latitude: 25.2854,
      longitude: 51.5310,
      calculationMethod: RamadanCalculationMethod.qatar,
    ),
    RamadanPrayerCityPreset(
      id: RamadanPrayerCityIds.manama,
      nameAr: 'المنامة',
      nameEn: 'Manama',
      latitude: 26.2235,
      longitude: 50.5876,
      calculationMethod: RamadanCalculationMethod.dubai,
    ),
    RamadanPrayerCityPreset(
      id: RamadanPrayerCityIds.muscat,
      nameAr: 'مسقط',
      nameEn: 'Muscat',
      latitude: 23.5880,
      longitude: 58.3829,
      calculationMethod: RamadanCalculationMethod.dubai,
    ),
  ];

  static RamadanPrayerCityPreset presetById(String? id) {
    if (id == null || id.isEmpty) return presets.first;
    return presets.firstWhere(
      (p) => p.id == id,
      orElse: () => presets.first,
    );
  }

  static RamadanPrayerCityPreset? matchCoordinates(double lat, double lng) {
    const tolerance = 0.05;
    for (final p in presets) {
      if ((p.latitude - lat).abs() < tolerance &&
          (p.longitude - lng).abs() < tolerance) {
        return p;
      }
    }
    return null;
  }
}
