import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';

/// Shows a one-shot rationale, then requests CAMERA / MICROPHONE at the moment
/// of use (never at app startup).
abstract final class SensitivePermissionGate {
  static Future<bool> ensureCamera(BuildContext context) async {
    final status = await Permission.camera.status;
    if (status.isGranted) return true;
    if (!context.mounted) return false;

    final l10n = AppLocalizations.of(context);
    final proceed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.cameraPermissionRationaleTitle),
        content: Text(l10n.cameraPermissionRationaleBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.continueButton),
          ),
        ],
      ),
    );
    if (proceed != true) return false;

    final result = await Permission.camera.request();
    if (result.isGranted) return true;
    if (result.isPermanentlyDenied && context.mounted) {
      await openAppSettings();
    }
    return false;
  }

  static Future<bool> ensureMicrophone(BuildContext context) async {
    final status = await Permission.microphone.status;
    if (status.isGranted) return true;
    if (!context.mounted) return false;

    final l10n = AppLocalizations.of(context);
    final proceed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.microphonePermissionRationaleTitle),
        content: Text(l10n.microphonePermissionRationaleBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.continueButton),
          ),
        ],
      ),
    );
    if (proceed != true) return false;

    final result = await Permission.microphone.request();
    if (result.isGranted) return true;
    if (result.isPermanentlyDenied && context.mounted) {
      await openAppSettings();
    }
    return false;
  }
}
