import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vireo/core/boot/boot_log.dart';
import 'package:vireo/core/config/app_config.dart';

/// Supabase client wrapper for auth, database, and storage.
abstract final class SupabaseService {
  static bool _initialized = false;

  static bool get isInitialized => _initialized;

  static bool get isConfigured => AppConfig.isSupabaseConfigured;

  static SupabaseClient get client {
    _ensureInitialized();
    return Supabase.instance.client;
  }

  static GoTrueClient get auth {
    _ensureInitialized();
    return client.auth;
  }

  static SupabaseStorageClient get storage {
    _ensureInitialized();
    return client.storage;
  }

  static Future<void> init() async {
    if (_initialized) {
      BootLog.step('SupabaseService.init skipped (already initialized)');
      return;
    }

    if (!isConfigured) {
      BootLog.step('SupabaseService.init skipped (not configured)');
      return;
    }

    BootLog.step('SupabaseService.init');
    try {
      BootLog.step('Starting Supabase.initialize...');
      await Supabase.initialize(
        url: AppConfig.supabaseUrl,
        anonKey: AppConfig.supabaseAnonKey,
      ).timeout(
        bootServiceTimeout,
        onTimeout: () => throw TimeoutException('Supabase.initialize'),
      );
      _initialized = true;
      BootLog.ok('SupabaseService.init');
    } on TimeoutException catch (e) {
      BootLog.warn('SupabaseService.init timed out — offline mode', e);
      _initialized = false;
    } catch (e) {
      BootLog.warn('SupabaseService.init failed — offline mode', e);
      _initialized = false;
    }
  }

  static void _ensureInitialized() {
    if (!_initialized) {
      throw StateError('SupabaseService is not initialized.');
    }
  }
}
