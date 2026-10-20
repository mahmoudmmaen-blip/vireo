import 'package:flutter/foundation.dart';
import 'package:vireo/core/constants/admob_constants.dart';

/// Runtime configuration. Prefer `--dart-define` overrides for CI/release builds.
abstract final class AppConfig {
  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://jzizpqriifrcgiksnddq.supabase.co',
  );

  /// Publishable (anon) key for the Vireo Supabase project.
  static const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_gM6GHFO0UFZDoa5fsMykuQ_gNcOAMJq',
  );

  static const sentryDsn = String.fromEnvironment(
    'SENTRY_DSN',
    defaultValue: '',
  );

  static const appEnvironment = String.fromEnvironment(
    'APP_ENVIRONMENT',
    defaultValue: 'production',
  );

  static const appRelease = String.fromEnvironment(
    'APP_RELEASE',
    defaultValue: 'vireo@1.0.0+2',
  );

  /// Hosted legal pages base URL (no trailing slash).
  static const legalBaseUrl = String.fromEnvironment(
    'LEGAL_BASE_URL',
    defaultValue: 'https://phenomenal-melomakarona-a67c5d.netlify.app',
  );

  static const revenueCatAppleApiKey = String.fromEnvironment(
    'REVENUECAT_APPLE_API_KEY',
    defaultValue: '',
  );

  static const revenueCatGoogleApiKey = String.fromEnvironment(
    'REVENUECAT_GOOGLE_API_KEY',
    defaultValue: '',
  );

  static const revenueCatEntitlementId = String.fromEnvironment(
    'REVENUECAT_ENTITLEMENT_ID',
    defaultValue: 'pro',
  );

  static const revenueCatMonthlyProductId = String.fromEnvironment(
    'REVENUECAT_MONTHLY_PRODUCT_ID',
    defaultValue: 'vireo_pro_monthly',
  );

  static const revenueCatAnnualProductId = String.fromEnvironment(
    'REVENUECAT_ANNUAL_PRODUCT_ID',
    defaultValue: 'vireo_pro_annual',
  );

  static const googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
    defaultValue: '',
  );

  static const googleIosClientId = String.fromEnvironment(
    'GOOGLE_IOS_CLIENT_ID',
    defaultValue: '',
  );

  static bool get isSupabaseConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  static bool get isRevenueCatConfigured =>
      revenueCatAppleApiKey.isNotEmpty || revenueCatGoogleApiKey.isNotEmpty;

  static const deleteAccountFunctionName = 'delete-account';

  static const scanFridgeVisionFunctionName = 'scan-fridge-vision';

  static const suggestRecipesFunctionName = 'suggest-recipes';

  static const generateMealPlanFunctionName = 'generate-meal-plan';

  static const generateProgramFunctionName = 'generate-program';

  static const analyzeMealFunctionName = 'analyze-meal';

  static const parseMealTextFunctionName = 'parse-meal-text';

  static const analyzeBodyReportFunctionName = 'analyze-body-report';

  static const aiCoachChatFunctionName = 'ai-coach-chat';

  static const googleAuthEnabled = bool.fromEnvironment(
    'GOOGLE_AUTH_ENABLED',
    defaultValue: false,
  );

  static const appleAuthEnabled = bool.fromEnvironment(
    'APPLE_AUTH_ENABLED',
    defaultValue: false,
  );

  static const _bannerOverride = String.fromEnvironment('ADMOB_BANNER_ID');
  static const _nativeOverride = String.fromEnvironment('ADMOB_NATIVE_ID');
  static const _interstitialOverride =
      String.fromEnvironment('ADMOB_INTERSTITIAL_ID');
  static const _rewardedOverride = String.fromEnvironment('ADMOB_REWARDED_ID');

  /// Banner unit: dart-define override, else test IDs in debug, production in release.
  static String get admobBannerId {
    if (_bannerOverride.isNotEmpty) return _bannerOverride;
    return kDebugMode
        ? AdMobConstants.testBannerAdUnitId
        : AdMobConstants.bannerAdUnitId;
  }

  /// Native unit: override or test ID (no production native unit yet).
  static String get admobNativeId {
    if (_nativeOverride.isNotEmpty) return _nativeOverride;
    return AdMobConstants.testNativeAdUnitId;
  }

  static String get admobInterstitialId {
    if (_interstitialOverride.isNotEmpty) return _interstitialOverride;
    return kDebugMode
        ? AdMobConstants.testInterstitialAdUnitId
        : AdMobConstants.interstitialAdUnitId;
  }

  static String get admobRewardedId {
    if (_rewardedOverride.isNotEmpty) return _rewardedOverride;
    return kDebugMode
        ? AdMobConstants.testRewardedAdUnitId
        : AdMobConstants.rewardedAdUnitId;
  }

  static bool get _primaryUnitsAreTest =>
      admobBannerId == AdMobConstants.testBannerAdUnitId ||
      admobInterstitialId == AdMobConstants.testInterstitialAdUnitId ||
      admobRewardedId == AdMobConstants.testRewardedAdUnitId;

  /// In release, never serve ads when banner/interstitial/rewarded are still test IDs.
  /// Native may remain a Google test unit until a production native unit exists.
  static bool get adsConfiguredForRelease {
    if (kReleaseMode && _primaryUnitsAreTest) return false;
    return true;
  }
}