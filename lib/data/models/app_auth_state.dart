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

class AppAuthGuest extends AppAuthState {
  const AppAuthGuest();
}

class AppAuthAuthenticated extends AppAuthState {
  const AppAuthAuthenticated(this.user);

  final User user;
}

extension AppAuthStateX on AppAuthState {
  bool get isGuest => this is AppAuthGuest;

  bool get isAuthenticated => this is AppAuthAuthenticated;

  bool get hasAccountAccess => isAuthenticated;

  User? get user =>
      this is AppAuthAuthenticated ? (this as AppAuthAuthenticated).user : null;
}
