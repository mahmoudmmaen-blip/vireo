import 'package:supabase_flutter/supabase_flutter.dart';

/// High-level auth status for routing and gated actions.
sealed class AppAuthState {
  const AppAuthState();
}

class AppAuthLoading extends AppAuthState {
  const AppAuthLoading();
}

class AppAuthUnauthenticated extends AppAuthState {
  const AppAuthUnauthenticated();
}

/// Offline-only guest (no Supabase session). Prefer anonymous sessions.
class AppAuthGuest extends AppAuthState {
  const AppAuthGuest();
}

class AppAuthAuthenticated extends AppAuthState {
  const AppAuthAuthenticated(this.user);

  final User user;
}

extension AppAuthStateX on AppAuthState {
  /// Anonymous JWT sessions and legacy offline guests share the same UX.
  bool get isGuest {
    if (this is AppAuthGuest) return true;
    if (this is AppAuthAuthenticated) {
      return (this as AppAuthAuthenticated).user.isAnonymous;
    }
    return false;
  }

  bool get isAuthenticated => this is AppAuthAuthenticated;

  /// Signed-in with a real identity (not anonymous) — cloud save / subscribe.
  bool get hasAccountAccess {
    if (this is! AppAuthAuthenticated) return false;
    return !(this as AppAuthAuthenticated).user.isAnonymous;
  }

  User? get user =>
      this is AppAuthAuthenticated ? (this as AppAuthAuthenticated).user : null;
}
