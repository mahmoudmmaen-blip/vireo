import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/features/ramadan/domain/ramadan_prayer_city.dart';
import 'package:vireo/features/ramadan/services/ramadan_schedule_service.dart';

const _ramadanEnabledKey = 'ramadan_mode_enabled';
const _ramadanCalcMethodKey = 'ramadan_calculation_method';
const _ramadanCityKey = 'ramadan_city_name';
const _ramadanCityIdKey = 'ramadan_city_preset_id';
const _ramadanLatKey = 'ramadan_lat';
const _ramadanLngKey = 'ramadan_lng';

class RamadanSettingsState {
  const RamadanSettingsState({
    required this.isEnabled,
    required this.calculationMethod,
    required this.cityPresetId,
    required this.cityName,
    required this.latitude,
    required this.longitude,
    required this.isAutoSuggested,
  });

  final bool isEnabled;
  final RamadanCalculationMethod calculationMethod;
  final String cityPresetId;
  final String cityName;
  final double latitude;
  final double longitude;
  final bool isAutoSuggested;

  RamadanSettingsState copyWith({
    bool? isEnabled,
    RamadanCalculationMethod? calculationMethod,
    String? cityPresetId,
    String? cityName,
    double? latitude,
    double? longitude,
    bool? isAutoSuggested,
  }) {
    return RamadanSettingsState(
      isEnabled: isEnabled ?? this.isEnabled,
      calculationMethod: calculationMethod ?? this.calculationMethod,
      cityPresetId: cityPresetId ?? this.cityPresetId,
      cityName: cityName ?? this.cityName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isAutoSuggested: isAutoSuggested ?? this.isAutoSuggested,
    );
  }
}

class RamadanSettingsNotifier extends StateNotifier<RamadanSettingsState> {
  RamadanSettingsNotifier() : super(_initial());

  static RamadanSettingsState _initial() {
    final box = HiveService.isInitialized ? HiveService.settingsBox : null;
    final isRamadan = RamadanScheduleService.isRamadanNow();
    final savedEnabled = box?.get(_ramadanEnabledKey) as bool?;
    final methodKey = box?.get(_ramadanCalcMethodKey) as String?;
    var method = RamadanCalculationMethod.fromKey(methodKey);

    final cityIdRaw = box?.get(_ramadanCityIdKey) as String?;
    final latStored = (box?.get(_ramadanLatKey) as num?)?.toDouble();
    final lngStored = (box?.get(_ramadanLngKey) as num?)?.toDouble();
    final cityNameStored = box?.get(_ramadanCityKey) as String?;

    String cityId;
    String city;
    double lat;
    double lng;

    if (cityIdRaw == RamadanPrayerCityIds.custom) {
      cityId = RamadanPrayerCityIds.custom;
      city = cityNameStored ?? method.defaultCity;
      lat = latStored ?? method.defaultLat;
      lng = lngStored ?? method.defaultLng;
    } else if (cityIdRaw != null && cityIdRaw.isNotEmpty) {
      final preset = RamadanPrayerCities.presetById(cityIdRaw);
      cityId = preset.id;
      city = preset.nameAr;
      lat = latStored ?? preset.latitude;
      lng = lngStored ?? preset.longitude;
      method = preset.calculationMethod;
    } else {
      // Migrate legacy saves (method + coordinates only).
      final matched = latStored != null && lngStored != null
          ? RamadanPrayerCities.matchCoordinates(latStored, lngStored)
          : null;
      if (matched != null) {
        cityId = matched.id;
        city = matched.localizedName('ar');
        lat = matched.latitude;
        lng = matched.longitude;
        method = matched.calculationMethod;
      } else {
        final preset = RamadanPrayerCities.presetById(
          method.key == RamadanCalculationMethod.egyptian.key
              ? RamadanPrayerCityIds.cairo
              : RamadanPrayerCityIds.riyadh,
        );
        cityId = preset.id;
        city = cityNameStored ?? preset.nameAr;
        lat = latStored ?? preset.latitude;
        lng = lngStored ?? preset.longitude;
        method = preset.calculationMethod;
      }
    }

    final enabled = savedEnabled ?? isRamadan;

    return RamadanSettingsState(
      isEnabled: enabled,
      calculationMethod: method,
      cityPresetId: cityId,
      cityName: city,
      latitude: lat,
      longitude: lng,
      isAutoSuggested: isRamadan && savedEnabled == null,
    );
  }

  Future<void> toggleEnabled([bool? value]) async {
    final next = value ?? !state.isEnabled;
    state = state.copyWith(isEnabled: next);
    if (HiveService.isInitialized) {
      await HiveService.settingsBox.put(_ramadanEnabledKey, next);
    }
  }

  Future<void> setCityPreset(RamadanPrayerCityPreset preset) async {
    state = state.copyWith(
      cityPresetId: preset.id,
      calculationMethod: preset.calculationMethod,
      cityName: preset.nameAr,
      latitude: preset.latitude,
      longitude: preset.longitude,
      isAutoSuggested: false,
    );
    await _persistLocation();
  }

  /// Legacy API — maps old method picker to the default city for that method.
  Future<void> setCalculationMethod(RamadanCalculationMethod method) async {
    final preset = RamadanPrayerCities.presets.firstWhere(
      (p) => p.calculationMethod == method,
      orElse: () => RamadanPrayerCities.presets.first,
    );
    await setCityPreset(preset);
  }

  Future<void> setCustomLocation({
    required String cityName,
    required double lat,
    required double lng,
  }) async {
    state = state.copyWith(
      cityPresetId: RamadanPrayerCityIds.custom,
      cityName: cityName,
      latitude: lat,
      longitude: lng,
      isAutoSuggested: false,
    );
    await _persistLocation();
  }

  Future<void> _persistLocation() async {
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.put(_ramadanCalcMethodKey, state.calculationMethod.key);
    await HiveService.settingsBox.put(_ramadanCityIdKey, state.cityPresetId);
    await HiveService.settingsBox.put(_ramadanCityKey, state.cityName);
    await HiveService.settingsBox.put(_ramadanLatKey, state.latitude);
    await HiveService.settingsBox.put(_ramadanLngKey, state.longitude);
  }
}

final ramadanSettingsProvider =
    StateNotifierProvider<RamadanSettingsNotifier, RamadanSettingsState>((ref) {
  return RamadanSettingsNotifier();
});

/// Computes current prayer times and fasting countdown based on active Ramadan settings.
final ramadanPrayerTimesProvider = Provider<RamadanPrayerTimes?>((ref) {
  final settings = ref.watch(ramadanSettingsProvider);
  if (!settings.isEnabled) return null;

  return RamadanPrayerTimes.calculate(
    lat: settings.latitude,
    lng: settings.longitude,
    method: settings.calculationMethod,
  );
});

/// Provider checking if food & water reminders/interstitials should be suppressed right now (during Ramadan fasting hours).
final isFastingHoursNowProvider = Provider<bool>((ref) {
  final prayer = ref.watch(ramadanPrayerTimesProvider);
  if (prayer == null) return false;
  return prayer.isFasting;
});
