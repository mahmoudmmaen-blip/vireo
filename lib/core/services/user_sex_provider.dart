import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';

const userSexKey = 'user_sex_preference';

/// Single source of truth for user sex across Vireo ('male' or 'female').
class UserSexNotifier extends StateNotifier<String> {
  UserSexNotifier() : super(_readInitial());

  static String _readInitial() {
    if (HiveService.isInitialized) {
      final stored = HiveService.settingsBox.get(userSexKey);
      if (stored is String && (stored == 'female' || stored == 'male')) {
        return stored;
      }

      final guest = HiveService.cacheBox.get('guest_profile');
      if (guest is Map) {
        final sex = (guest['sex'] as String? ?? guest['gender'] as String?)?.toLowerCase();
        if (sex == 'female' || sex == 'f') return 'female';
        if (sex == 'male' || sex == 'm') return 'male';
      }
    }
    return 'male';
  }

  static bool isFemaleSaved() => _readInitial() == 'female';

  Future<void> setSex(String sex) async {
    final normalized = (sex.toLowerCase().startsWith('f')) ? 'female' : 'male';
    state = normalized;
    if (HiveService.isInitialized) {
      await HiveService.settingsBox.put(userSexKey, normalized);

      final guest = HiveService.cacheBox.get('guest_profile');
      if (guest is Map) {
        final updated = Map<String, dynamic>.from(guest);
        updated['sex'] = normalized;
        updated['gender'] = normalized;
        await HiveService.cacheBox.put('guest_profile', updated);
      }
    }
  }
}

final userSexProvider = StateNotifierProvider<UserSexNotifier, String>((ref) {
  return UserSexNotifier();
});

final isFemaleUserProvider = Provider<bool>((ref) {
  return ref.watch(userSexProvider) == 'female';
});
