import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vireo/core/config/app_config.dart';

/// Supabase client wrapper for auth, database, and storage.
abstract final class SupabaseService {
  static bool _initialized = false;

  static bool get isInitialized => _initialized;

  static bool get isConfigured => AppConfig.isSupabaseConfigured;

  static SupabaseClient get client => Supabase.instance.client;

  static GoTrueClient get auth => client.auth;

  static SupabaseStorageClient get storage => client.storage;

  static Future<void> init() async {
    if (_initialized) return;
    if (!isConfigured) return;

    try {
      await Supabase.initialize(
        url: AppConfig.supabaseUrl,
        anonKey: AppConfig.supabaseAnonKey,
      );
      _initialized = true;
    } catch (_) {
      rethrow;
    }
  }
}
