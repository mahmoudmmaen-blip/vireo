import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/features/auth/auth_screen.dart';

/// Prompts guest users to create an account before cloud save or subscribe.
Future<bool> requireAccountAccess(
  BuildContext context,
  WidgetRef ref, {
  required AuthGateReason reason,
}) async {
  final l10n = AppLocalizations.of(context);
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.authGateTitle),
      content: Text(_gateMessage(l10n, reason)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(l10n.authGateNotNow),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(l10n.authGateSignUp),
        ),
      ],
    ),
  );

  if (result == true && context.mounted) {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
    return true;
  }
  return false;
}

String _gateMessage(AppLocalizations l10n, AuthGateReason reason) {
  switch (reason) {
    case AuthGateReason.saveProgress:
      return l10n.authGateSaveProgress;
    case AuthGateReason.subscribe:
      return l10n.authGateSubscribe;
  }
}

enum AuthGateReason { saveProgress, subscribe }
