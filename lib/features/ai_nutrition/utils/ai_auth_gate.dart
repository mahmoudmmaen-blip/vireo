import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/data/models/app_auth_state.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';
import 'package:vireo/features/auth/widgets/guest_auth_gate.dart';

/// Ensures the user is signed in before AI Edge Function calls.
Future<bool> ensureSignedInForAi(BuildContext context, WidgetRef ref) async {
  final auth = ref.read(authProvider).valueOrNull;
  if (auth is AppAuthAuthenticated) return true;
  if (!context.mounted) return false;
  await requireAccountAccess(
    context,
    ref,
    reason: AuthGateReason.aiFeatures,
  );
  if (!context.mounted) return false;
  return ref.read(authProvider).valueOrNull is AppAuthAuthenticated;
}
