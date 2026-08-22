import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vireo/data/models/app_auth_state.dart';
import 'package:vireo/data/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => const AuthRepository(),
);

class AuthNotifier extends AsyncNotifier<AppAuthState> {
  StreamSubscription<AuthState>? _subscription;

  @override
  Future<AppAuthState> build() async {
    final repo = ref.read(authRepositoryProvider);
    _subscription?.cancel();
    _subscription = repo.authStateChanges().listen((_) {
      ref.invalidateSelf();
    });
    ref.onDispose(() => _subscription?.cancel());
    return _resolveState(repo);
  }

  AppAuthState _resolveState(AuthRepository repo) {
    if (repo.isGuestMode) return const AppAuthGuest();
    final user = repo.currentUser;
    if (user != null) return AppAuthAuthenticated(user);
    return const AppAuthUnauthenticated();
  }

  Future<void> continueAsGuest() async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).continueAsGuest();
      state = AsyncData(const AppAuthGuest());
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> signInWithApple() => _authAction(
        () => ref.read(authRepositoryProvider).signInWithApple(),
      );

  Future<void> signInWithGoogle() => _authAction(
        () => ref.read(authRepositoryProvider).signInWithGoogle(),
      );

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) =>
      _authAction(
        () => ref.read(authRepositoryProvider).signInWithEmail(
              email: email,
              password: password,
            ),
      );

  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) =>
      _authAction(
        () => ref.read(authRepositoryProvider).signUpWithEmail(
              email: email,
              password: password,
            ),
      );

  Future<void> signOut() async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).signOut();
      state = const AsyncData(AppAuthUnauthenticated());
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> deleteAccount() async {
    try {
      await ref.read(authRepositoryProvider).deleteAccount();
      state = const AsyncData(AppAuthUnauthenticated());
    } catch (_) {
      rethrow;
    }
  }

  Future<void> _authAction(Future<void> Function() action) async {
    try {
      await action();
      final repo = ref.read(authRepositoryProvider);
      state = AsyncData(_resolveState(repo));
    } catch (_) {
      rethrow;
    }
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AppAuthState>(
  AuthNotifier.new,
);

/// Whether the user can access cloud sync and subscriptions.
final hasAccountAccessProvider = Provider<bool>((ref) {
  final auth = ref.watch(authProvider);
  return auth.maybeWhen(
    data: (s) => s.hasAccountAccess,
    orElse: () => false,
  );
});

final isGuestProvider = Provider<bool>((ref) {
  final auth = ref.watch(authProvider);
  return auth.maybeWhen(
    data: (s) => s.isGuest,
    orElse: () => ref.read(authRepositoryProvider).isGuestMode,
  );
});
