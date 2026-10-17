import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/ramadan/domain/ramadan_prayer_city.dart';
import 'package:vireo/features/ramadan/services/ramadan_schedule_service.dart';

void main() {
  test('includes all P40 Gulf and Egypt/KSA city presets', () {
    expect(RamadanPrayerCities.presets.length, 11);
    final ids = RamadanPrayerCities.presets.map((p) => p.id).toSet();
    expect(ids, containsAll([
      RamadanPrayerCityIds.cairo,
      RamadanPrayerCityIds.alexandria,
      RamadanPrayerCityIds.riyadh,
      RamadanPrayerCityIds.jeddah,
      RamadanPrayerCityIds.dammam,
      RamadanPrayerCityIds.dubai,
      RamadanPrayerCityIds.abuDhabi,
      RamadanPrayerCityIds.kuwait,
      RamadanPrayerCityIds.doha,
      RamadanPrayerCityIds.manama,
      RamadanPrayerCityIds.muscat,
    ]));
  });

  test('calculation methods match region rules', () {
    final cairo = RamadanPrayerCities.presetById(RamadanPrayerCityIds.cairo);
    final riyadh = RamadanPrayerCities.presetById(RamadanPrayerCityIds.riyadh);
    final dubai = RamadanPrayerCities.presetById(RamadanPrayerCityIds.dubai);
    expect(cairo.calculationMethod, RamadanCalculationMethod.egyptian);
    expect(riyadh.calculationMethod, RamadanCalculationMethod.ummAlQura);
    expect(dubai.calculationMethod, RamadanCalculationMethod.dubai);
  });
}
