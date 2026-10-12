import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/features/ramadan/services/ramadan_schedule_service.dart';

const _ramadanEnabledKey = 'ramadan_mode_enabled';
const _ramadanCalcMethodKey = 'ramadan_calculation_method';
const _ramadanCityKey = 'ramadan_city_name';
const _ramadanLatKey = 'ramadan_lat';
const _ramadanLngKey = 'ramadan_lng';

class RamadanSettingsState {
  const RamadanSettingsState({
    required this.isEnabled,
    required this.calculationMethod,
    required this.cityName,
    required this.latitude,
    required this.longitude,
    required this.isAutoSuggested,
  });

  final bool isEnabled;
  final RamadanCalculationMethod calculationMethod;
  final String cityName;
  final double latitude;
  final double longitude;
  final bool isAutoSuggested;

  RamadanSettingsState copyWith({
    bool? isEnabled,
    RamadanCalculationMethod? calculationMethod,
    String? cityName,
    double? latitude,
    double? longitude,
    bool? isAutoSuggested,
  }) {
    return RamadanSettingsState(
      isEnabled: isEnabled ?? this.isEnabled,
      calculationMethod: calculationMethod ?? this.calculationMethod,
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
    final method = RamadanCalculationMethod.fromKey(methodKey);

    final city = box?.get(_ramadanCityKey) as String? ?? method.defaultCity;
    final lat = (box?.get(_ramadanLatKey) as num?)?.toDouble() ?? method.defaultLat;
    final lng = (box?.get(_ramadanLngKey) as num?)?.toDouble() ?? method.defaultLng;

    // Default to true if currently Ramadan and user hasn't explicitly set it, or use saved
    final enabled = savedEnabled ?? isRamadan;

    return RamadanSettingsState(
      isEnabled: enabled,
      calculationMethod: method,
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

  Future<void> setCalculationMethod(RamadanCalculationMethod method) async {
    state = state.copyWith(
      calculationMethod: method,
      cityName: method.defaultCity,
      latitude: method.defaultLat,
      longitude: method.defaultLng,
    );
    if (HiveService.isInitialized) {
      await HiveService.settingsBox.put(_ramadanCalcMethodKey, method.key);
      await HiveService.settingsBox.put(_ramadanCityKey, method.defaultCity);
      await HiveService.settingsBox.put(_ramadanLatKey, method.defaultLat);
      await HiveService.settingsBox.put(_ramadanLngKey, method.defaultLng);
    }
  }

  Future<void> setCustomLocation({
    required String cityName,
    required double lat,
    required double lng,
  }) async {
    state = state.copyWith(
      cityName: cityName,
      latitude: lat,
      longitude: lng,
    );
    if (HiveService.isInitialized) {
      await HiveService.settingsBox.put(_ramadanCityKey, cityName);
      await HiveService.settingsBox.put(_ramadanLatKey, lat);
      await HiveService.settingsBox.put(_ramadanLngKey, lng);
    }
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
