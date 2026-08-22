import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/config/app_config.dart';
import 'package:vireo/core/l10n/generated/app_localizations_en.dart';
import 'package:vireo/core/l10n/generated/app_localizations_ar.dart';
import 'package:vireo/data/models/app_auth_state.dart';

void main() {
  group('AppAuthState §2.3 access levels', () {
    test('guest has no account access', () {
      const state = AppAuthGuest();
      expect(state.isGuest, isTrue);
      expect(state.isAuthenticated, isFalse);
      expect(state.hasAccountAccess, isFalse);
      expect(state.user, isNull);
    });

    test('unauthenticated has no account access', () {
      const state = AppAuthUnauthenticated();
      expect(state.isGuest, isFalse);
      expect(state.hasAccountAccess, isFalse);
    });
  });

  group('Delete account §2.3 — double confirmation words', () {
    test('English confirmation word is DELETE', () {
      expect(AppLocalizationsEn().deleteConfirmationWord, 'DELETE');
    });

    test('Arabic confirmation word is حذف', () {
      expect(AppLocalizationsAr().deleteConfirmationWord, 'حذف');
    });
  });

  group('Delete account §2.3 — edge function config', () {
    test('deleteAccountFunctionName matches Supabase function', () {
      expect(AppConfig.deleteAccountFunctionName, 'delete-account');
    });
  });
}
