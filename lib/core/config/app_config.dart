import 'package:flutter/foundation.dart';

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
  /// TODO(owner): set after uploading `web_legal/` to a static host, e.g.
  /// `--dart-define=LEGAL_BASE_URL=https://vireo.app/legal`
  static const legalBaseUrl = String.fromEnvironment(
    'LEGAL_BASE_URL',
    defaultValue: 'https://TODO_HOST_LEGAL_PAGES.example/legal',
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

  /// Google official test AdMob unit IDs (debug only).
  static const _testBannerId = 'ca-app-pub-3940256099942544/6300978111';
  static const _testNativeId = 'ca-app-pub-3940256099942544/2247696110';
  static const _testInterstitialId = 'ca-app-pub-3940256099942544/1033173712';
  static const _testRewardedId = 'ca-app-pub-3940256099942544/5224354917';

  /// AdMob IDs — production IDs must come from dart-defines only.
  static const admobBannerId = String.fromEnvironment(
    'ADMOB_BANNER_ID',
    defaultValue: _testBannerId,
  );

  static const admobNativeId = String.fromEnvironment(
    'ADMOB_NATIVE_ID',
    defaultValue: _testNativeId,
  );

  static const admobInterstitialId = String.fromEnvironment(
    'ADMOB_INTERSTITIAL_ID',
    defaultValue: _testInterstitialId,
  );

  static const admobRewardedId = String.fromEnvironment(
    'ADMOB_REWARDED_ID',
    defaultValue: _testRewardedId,
  );

  static bool get _hasTestAdIds =>
      admobBannerId == _testBannerId ||
      admobNativeId == _testNativeId ||
      admobInterstitialId == _testInterstitialId ||
      admobRewardedId == _testRewardedId;

  /// In release, never serve ads when only test unit IDs are configured.
  static bool get adsConfiguredForRelease {
    if (kReleaseMode && _hasTestAdIds) return false;
    return true;
  }
}
