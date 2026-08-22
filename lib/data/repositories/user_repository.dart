import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/supabase_service.dart';

/// Example repository pattern bridging Hive cache and Supabase.
class UserRepository {
  const UserRepository();

  static const _cacheKey = 'user_profile';

  Future<Map<String, dynamic>?> fetchProfile() async {
    try {
      if (SupabaseService.isInitialized) {
        final userId = SupabaseService.auth.currentUser?.id;
        if (userId != null) {
          final data = await SupabaseService.client
              .from('profiles')
              .select()
              .eq('id', userId)
              .maybeSingle();
          if (data != null) {
            final profile = Map<String, dynamic>.from(data);
            await HiveService.cacheBox.put(_cacheKey, profile);
            return profile;
          }
        }
      }
    } catch (_) {
      // Fall through to cached profile when remote fetch fails.
    }

    final cached = HiveService.cacheBox.get(_cacheKey);
    if (cached is Map) {
      return Map<String, dynamic>.from(cached);
    }
    return null;
  }
}
