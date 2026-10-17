import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/config/app_config.dart';
import 'package:vireo/core/constants/legal_urls.dart';
import 'package:vireo/features/subscription/feature_gates.dart';

void main() {
  test('LEGAL_BASE_URL default is TODO placeholder for owner hosting', () {
    expect(AppConfig.legalBaseUrl, contains('TODO'));
    expect(LegalUrls.baseUrl, AppConfig.legalBaseUrl);
    expect(LegalUrls.deleteAccountUrl(), contains('delete-account'));
  });

  test('AdMob IDs come from dart-defines / test defaults only', () {
    expect(AppConfig.admobBannerId.startsWith('ca-app-pub-'), isTrue);
    expect(AppConfig.admobNativeId.startsWith('ca-app-pub-'), isTrue);
    expect(AppConfig.admobInterstitialId.startsWith('ca-app-pub-'), isTrue);
    expect(AppConfig.admobRewardedId.startsWith('ca-app-pub-'), isTrue);
  });

  test('coin Pro unlock helper exists for ad-free days', () {
    // Without Hive init, coin unlock is false — ads remain eligible only for free users.
    expect(FeatureGates.isCoinProUnlocked(), isFalse);
  });
}
