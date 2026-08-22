/// Runtime configuration loaded via `--dart-define` at build time.
abstract final class AppConfig {
  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );

  static const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  static const revenueCatAppleApiKey = String.fromEnvironment(
    'REVENUECAT_APPLE_API_KEY',
    defaultValue: '',
  );

  static const revenueCatGoogleApiKey = String.fromEnvironment(
    'REVENUECAT_GOOGLE_API_KEY',
    defaultValue: '',
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
}
