import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/boot/boot_log.dart';
import 'package:vireo/core/services/catalog_seed_service.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/revenue_cat_service.dart';
import 'package:vireo/core/services/supabase_service.dart';
import 'package:vireo/features/subscription/providers/subscription_provider.dart';

/// Tracks bootstrap status for core services.
enum AppInitStatus { loading, ready, error }

class AppInitNotifier extends AsyncNotifier<AppInitStatus> {
  @override
  Future<AppInitStatus> build() async {
    BootLog.step('AppInitNotifier.build');
    final status = await _initialize();
    BootLog.ok('AppInitNotifier.build → $status');
    return status;
  }

  Future<AppInitStatus> _initialize() async {
    try {
      if (!HiveService.isInitialized) {
        try {
          await HiveService.init();
        } catch (e) {
          BootLog.warn('AppInitNotifier Hive unavailable — continuing degraded', e);
        }
      } else {
        BootLog.step('AppInitNotifier: Hive already initialized');
      }

      await SupabaseService.init();
      await CatalogSeedService.seedIfNeeded();
      await RevenueCatService.init();

      BootLog.ok('AppInitNotifier services');
      return AppInitStatus.ready;
    } catch (e) {
      BootLog.warn('AppInitNotifier failed', e);
      return AppInitStatus.error;
    }
  }

  Future<void> retry() async {
    BootLog.step('AppInitNotifier.retry');
    state = const AsyncLoading();
    state = await AsyncValue.guard(_initialize);
  }
}

final appInitProvider = AsyncNotifierProvider<AppInitNotifier, AppInitStatus>(
  AppInitNotifier.new,
);

final supabaseAuthProvider = StreamProvider((ref) {
  if (!SupabaseService.isInitialized) {
    return Stream.value(null);
  }
  return SupabaseService.auth.onAuthStateChange.map((event) => event.session);
});

final isPremiumProvider = Provider<bool>((ref) {
  return ref.watch(hasPremiumAccessProvider);
});
