import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vireo/core/boot/boot_log.dart';
import 'package:vireo/core/services/app_init_provider.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/supabase_service.dart';
import 'package:vireo/data/models/app_auth_state.dart';
import 'package:vireo/data/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => const AuthRepository(),
);

class AuthNotifier extends AsyncNotifier<AppAuthState> {
  StreamSubscription<AuthState>? _subscription;
  var _listenerActive = false;

  @override
  Future<AppAuthState> build() async {
    BootLog.step('AuthNotifier.build');
    await ref.watch(appInitProvider.future);

    final repo = ref.read(authRepositoryProvider);
    await repo.ensureAnonymousSession();
    final resolved = _resolveState(repo);

    ref.onDispose(() {
      BootLog.step('AuthNotifier.dispose');
      _listenerActive = false;
      unawaited(_subscription?.cancel());
      _subscription = null;
    });

    _listenerActive = true;
    Future.microtask(_attachAuthListener);

    BootLog.ok('AuthNotifier.build → ${resolved.runtimeType}');
    return resolved;
  }

  void _attachAuthListener() {
    if (!_listenerActive) return;

    if (!SupabaseService.isInitialized) {
      BootLog.step('AuthNotifier skipping auth listener (Supabase offline)');
      return;
    }

    final repo = ref.read(authRepositoryProvider);
    unawaited(_subscription?.cancel());
    _subscription = repo.authStateChanges().listen(
      (_) => _refreshIfChanged(repo),
      onError: (Object error, StackTrace stackTrace) {
        BootLog.warn('AuthNotifier auth stream error', error);
      },
    );
    BootLog.ok('AuthNotifier auth listener attached');
  }

  void _refreshIfChanged(AuthRepository repo) {
    if (!_listenerActive) return;

    final next = _resolveState(repo);
    final current = state.asData?.value;
    if (current != null && _sameAuthState(current, next)) {
      return;
    }

    BootLog.step('AuthNotifier auth state changed — refreshing');
    ref.invalidateSelf();
  }

  bool _sameAuthState(AppAuthState current, AppAuthState next) {
    if (current.runtimeType != next.runtimeType) return false;
    if (current is AppAuthAuthenticated && next is AppAuthAuthenticated) {
      return current.user.id == next.user.id &&
          current.user.isAnonymous == next.user.isAnonymous &&
          current.user.email == next.user.email;
    }
    return true;
  }

  AppAuthState _resolveState(AuthRepository repo) {
    final user = repo.currentUser;
    if (user != null) return AppAuthAuthenticated(user);
    if (repo.isGuestMode) return const AppAuthGuest();
    return const AppAuthUnauthenticated();
  }

  Future<void> continueAsGuest() async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).continueAsGuest();
      state = AsyncData(_resolveState(ref.read(authRepositoryProvider)));
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

  Future<void> sendEmailCode(String email) =>
      ref.read(authRepositoryProvider).sendEmailCode(email);

  Future<void> verifyEmailCode({
    required String email,
    required String token,
  }) =>
      _authAction(
        () => ref.read(authRepositoryProvider).verifyEmailCode(
              email: email,
              token: token,
            ),
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
      // Immediately restore anonymous so the app stays usable.
      await ref.read(authRepositoryProvider).ensureAnonymousSession();
      state = AsyncData(_resolveState(ref.read(authRepositoryProvider)));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> deleteAccount() async {
    try {
      await ref.read(authRepositoryProvider).deleteAccount();
      await ref.read(authRepositoryProvider).ensureAnonymousSession();
      state = AsyncData(_resolveState(ref.read(authRepositoryProvider)));
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
    orElse: () {
      if (!HiveService.isInitialized) return false;
      return ref.read(authRepositoryProvider).isGuestMode;
    },
  );
});
