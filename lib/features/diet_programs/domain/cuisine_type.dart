import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/locale_provider.dart';

enum CuisineType {
  egyptian('egyptian'),
  saudi('saudi'),
  levantine('levantine'),
  moroccan('moroccan'),
  turkish('turkish'),
  indian('indian'),
  indonesian('indonesian'),
  western('western');

  const CuisineType(this.value);
  final String value;

  static CuisineType fromValue(String? val, {CuisineType fallback = CuisineType.egyptian}) {
    if (val == null) return fallback;
    return CuisineType.values.firstWhere(
      (e) => e.value == val,
      orElse: () => fallback,
    );
  }

  String localizedName(dynamic l10n) {
    return switch (this) {
      CuisineType.egyptian => l10n.cuisineEgyptian as String,
      CuisineType.saudi => l10n.cuisineSaudi as String,
      CuisineType.levantine => l10n.cuisineLevantine as String,
      CuisineType.moroccan => l10n.cuisineMoroccan as String,
      CuisineType.turkish => l10n.cuisineTurkish as String,
      CuisineType.indian => l10n.cuisineIndian as String,
      CuisineType.indonesian => l10n.cuisineIndonesian as String,
      CuisineType.western => l10n.cuisineWestern as String,
    };
  }

  static CuisineType defaultForLocale(String languageCode, String? countryCode) {
    final country = countryCode?.toUpperCase();
    if (country == 'EG') return CuisineType.egyptian;
    if (country == 'SA' || country == 'AE' || country == 'KW' || country == 'QA' || country == 'BH' || country == 'OM') {
      return CuisineType.saudi;
    }
    if (country == 'MA' || country == 'DZ' || country == 'TN') return CuisineType.moroccan;
    if (country == 'SY' || country == 'LB' || country == 'JO' || country == 'PS') return CuisineType.levantine;
    if (languageCode == 'tr' || country == 'TR') return CuisineType.turkish;
    if (languageCode == 'id' || country == 'ID') return CuisineType.indonesian;
    if (languageCode == 'hi' || languageCode == 'ur' || country == 'IN' || country == 'PK') {
      return CuisineType.indian;
    }
    if (languageCode == 'ar') return CuisineType.egyptian;
    return CuisineType.western;
  }
}

const _cuisineKey = 'user_selected_cuisine';

class CuisineNotifier extends Notifier<CuisineType> {
  @override
  CuisineType build() {
    if (HiveService.isInitialized) {
      final saved = HiveService.settingsBox.get(_cuisineKey) as String?;
      if (saved != null) {
        return CuisineType.fromValue(saved);
      }
    }
    final loc = ref.watch(localeProvider);
    return CuisineType.defaultForLocale(loc.languageCode, loc.countryCode);
  }

  Future<void> setCuisine(CuisineType cuisine) async {
    state = cuisine;
    if (HiveService.isInitialized) {
      await HiveService.settingsBox.put(_cuisineKey, cuisine.value);
    }
  }
}

final cuisineProvider = NotifierProvider<CuisineNotifier, CuisineType>(CuisineNotifier.new);
