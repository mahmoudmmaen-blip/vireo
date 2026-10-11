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
    defaultValue: 'vireo@1.0.0+1',
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
}
