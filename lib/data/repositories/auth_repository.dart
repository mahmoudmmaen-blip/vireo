import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vireo/core/config/app_config.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/supabase_service.dart';

class AuthRepository {
  const AuthRepository();

  static const _guestModeKey = 'guest_mode';

  bool get isGuestMode =>
      HiveService.settingsBox.get(_guestModeKey, defaultValue: false) as bool;

  Stream<AuthState> authStateChanges() {
    if (!SupabaseService.isInitialized) {
      return Stream.value(const AuthState(AuthChangeEvent.initialSession, null));
    }
    return SupabaseService.auth.onAuthStateChange;
  }

  User? get currentUser =>
      SupabaseService.isInitialized ? SupabaseService.auth.currentUser : null;

  Future<void> continueAsGuest() async {
    try {
      await _clearGuestMode();
      await signOut(silent: true);
      await HiveService.settingsBox.put(_guestModeKey, true);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    _ensureSupabase();
    try {
      await SupabaseService.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      await _clearGuestMode();
    } catch (_) {
      rethrow;
    }
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    _ensureSupabase();
    try {
      await SupabaseService.auth.signUp(
        email: email.trim(),
        password: password,
      );
      await _clearGuestMode();
    } catch (_) {
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    _ensureSupabase();
    try {
      final googleSignIn = GoogleSignIn(
        clientId: AppConfig.googleIosClientId.isEmpty
            ? null
            : AppConfig.googleIosClientId,
        serverClientId: AppConfig.googleWebClientId.isEmpty
            ? null
            : AppConfig.googleWebClientId,
      );

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw const AuthException('Google sign-in was cancelled.');
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        throw const AuthException('Missing Google ID token.');
      }

      await SupabaseService.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: googleAuth.accessToken,
      );
      await _clearGuestMode();
    } catch (_) {
      rethrow;
    }
  }

  Future<void> signInWithApple() async {
    _ensureSupabase();
    try {
      final rawNonce = _generateNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      final idToken = credential.identityToken;
      if (idToken == null) {
        throw const AuthException('Missing Apple identity token.');
      }

      await SupabaseService.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: idToken,
        nonce: rawNonce,
      );
      await _clearGuestMode();
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        throw const AuthException('Apple sign-in was cancelled.');
      }
      rethrow;
    } catch (_) {
      rethrow;
    }
  }

  Future<void> signOut({bool silent = false}) async {
    try {
      if (SupabaseService.isInitialized) {
        await SupabaseService.auth.signOut();
      }
      if (!silent) {
        await _clearGuestMode();
      }
      if (!Platform.isIOS && !Platform.isAndroid) return;
      try {
        await GoogleSignIn().signOut();
      } catch (_) {
        // Non-fatal when Google was never used.
      }
    } catch (_) {
      rethrow;
    }
  }

  /// Hard-deletes the account via Supabase Edge Function, then revokes session.
  Future<void> deleteAccount() async {
    _ensureSupabase();
    try {
      final response = await SupabaseService.client.functions.invoke(
        AppConfig.deleteAccountFunctionName,
      );

      if (response.status >= 400) {
        final message = response.data is Map
            ? (response.data as Map)['error']?.toString()
            : null;
        throw AuthException(message ?? 'Account deletion failed.');
      }

      await signOut(silent: true);
      await _clearGuestMode();
    } catch (_) {
      rethrow;
    }
  }

  Future<void> _clearGuestMode() async {
    await HiveService.settingsBox.put(_guestModeKey, false);
  }

  void _ensureSupabase() {
    if (!SupabaseService.isInitialized) {
      throw const AuthException(
        'Sign-in is unavailable. Supabase is not configured.',
      );
    }
  }

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }
}
