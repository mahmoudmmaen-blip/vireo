import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/revenue_cat_service.dart';
import 'package:vireo/core/services/supabase_service.dart';
import 'package:vireo/features/subscription/providers/subscription_provider.dart';

/// Tracks bootstrap status for core services.
enum AppInitStatus { loading, ready, error }

class AppInitNotifier extends AsyncNotifier<AppInitStatus> {
  @override
  Future<AppInitStatus> build() async {
    return _initialize();
  }

  Future<AppInitStatus> _initialize() async {
    try {
      if (!HiveService.isInitialized) {
        await HiveService.init();
      }
      await SupabaseService.init();
      await RevenueCatService.init();
      return AppInitStatus.ready;
    } catch (_) {
      return AppInitStatus.error;
    }
  }

  Future<void> retry() async {
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
