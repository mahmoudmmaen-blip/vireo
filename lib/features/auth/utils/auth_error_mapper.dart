import 'package:vireo/core/boot/boot_log.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';

void logAuthError(Object error) {
  if (error is AuthException) {
    BootLog.warn(
      'Auth error code=${error.code ?? error.statusCode} message=${error.message}',
    );
    return;
  }
  BootLog.warn('Auth error', error);
}

/// Maps Auth/network exceptions to short friendly copy. Never returns raw text.
String mapAuthError(Object error, AppLocalizations l10n) {
  logAuthError(error);

  if (error is AuthException) {
    final code = '${error.code ?? ''} ${error.message}'.toLowerCase();
    if (code.contains('over_email_send_rate_limit')) {
      return l10n.authErrorEmailRateLimit;
    }
  }

  final msg = error.toString().toLowerCase();
  if (msg.contains('over_email_send_rate_limit')) {
    return l10n.authErrorEmailRateLimit;
  }
  if (msg.contains('cancel') || msg.contains('canceled') || msg.contains('cancelled')) {
    return l10n.authErrorCancelled;
  }
  if (msg.contains('socket') ||
      msg.contains('network') ||
      msg.contains('connection') ||
      msg.contains('failed host lookup') ||
      msg.contains('offline') ||
      msg.contains('not configured') ||
      msg.contains('unavailable')) {
    return l10n.authErrorOffline;
  }
  if (msg.contains('rate') ||
      msg.contains('too many') ||
      msg.contains('over_request') ||
      msg.contains('429')) {
    return l10n.authErrorTooMany;
  }
  if (msg.contains('otp') ||
      msg.contains('token') ||
      msg.contains('invalid') ||
      msg.contains('expired') ||
      msg.contains('wrong')) {
    return l10n.authErrorWrongCode;
  }
  if (msg.contains('email') && msg.contains('valid')) {
    return l10n.authErrorInvalidEmail;
  }
  return l10n.authErrorGeneric;
}
