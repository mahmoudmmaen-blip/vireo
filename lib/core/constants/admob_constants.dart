/// Production AdMob App ID and ad unit IDs for Vireo.
///
/// Debug builds use Google's official test units via [AppConfig].
/// Do not log these values in release.
abstract final class AdMobConstants {
  static const appId = 'ca-app-pub-9991756921251214~5695541111';

  static const bannerAdUnitId = 'ca-app-pub-9991756921251214/6267306626';
  static const interstitialAdUnitId =
      'ca-app-pub-9991756921251214/4382459444';
  static const rewardedAdUnitId = 'ca-app-pub-9991756921251214/7364765877';

  /// No production native unit yet — disabled until created in AdMob Console.
  static const nativeAdUnitId = '';

  static const testAppId = 'ca-app-pub-3940256099942544~3347511713';
  static const testBannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111';
  static const testNativeAdUnitId =
      'ca-app-pub-3940256099942544/2247696110';
  static const testInterstitialAdUnitId =
      'ca-app-pub-3940256099942544/1033173712';
  static const testRewardedAdUnitId =
      'ca-app-pub-3940256099942544/5224354917';
}