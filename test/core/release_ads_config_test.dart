import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/config/app_config.dart';
import 'package:vireo/core/constants/admob_constants.dart';
import 'package:vireo/core/constants/legal_urls.dart';
import 'package:vireo/features/subscription/feature_gates.dart';

void main() {
  test('LEGAL_BASE_URL default is TODO placeholder for owner hosting', () {
    expect(AppConfig.legalBaseUrl, contains('TODO'));
    expect(LegalUrls.baseUrl, AppConfig.legalBaseUrl);
    expect(LegalUrls.deleteAccountUrl(), contains('delete-account'));
  });

  test('AdMob IDs resolve to ca-app-pub units (debug uses Google test IDs)', () {
    expect(AppConfig.admobBannerId.startsWith('ca-app-pub-'), isTrue);
    expect(AppConfig.admobNativeId.startsWith('ca-app-pub-'), isTrue);
    expect(AppConfig.admobInterstitialId.startsWith('ca-app-pub-'), isTrue);
    expect(AppConfig.admobRewardedId.startsWith('ca-app-pub-'), isTrue);
    // Widget tests run in debug → Google official test units.
    expect(AppConfig.admobBannerId, AdMobConstants.testBannerAdUnitId);
    expect(AppConfig.admobInterstitialId, AdMobConstants.testInterstitialAdUnitId);
    expect(AppConfig.admobRewardedId, AdMobConstants.testRewardedAdUnitId);
  });

  test('production AdMob constants are configured (not Google test app)', () {
    expect(AdMobConstants.appId, isNot(AdMobConstants.testAppId));
    expect(AdMobConstants.bannerAdUnitId, isNot(AdMobConstants.testBannerAdUnitId));
    expect(
      AdMobConstants.interstitialAdUnitId,
      isNot(AdMobConstants.testInterstitialAdUnitId),
    );
    expect(AdMobConstants.rewardedAdUnitId, isNot(AdMobConstants.testRewardedAdUnitId));
  });

  test('coin Pro unlock helper exists for ad-free days', () {
    // Without Hive init, coin unlock is false — ads remain eligible only for free users.
    expect(FeatureGates.isCoinProUnlocked(), isFalse);
  });
}
