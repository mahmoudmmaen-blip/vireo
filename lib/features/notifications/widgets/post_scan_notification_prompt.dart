import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/features/notifications/providers/notification_settings_provider.dart';
import 'package:vireo/features/notifications/services/nurture_scheduler.dart';

/// Shows the meal-reminder permission dialog once, after the first successful scan.
Future<void> maybePromptMealRemindersAfterScan(
  BuildContext context,
  WidgetRef ref, {
  required int scanCountAfterSave,
}) async {
  if (scanCountAfterSave != 1) return;
  if (!HiveService.isInitialized) return;
  if (HiveService.settingsBox.get(notificationPermissionRequestedKey) == true) {
    return;
  }

  final service = ref.read(notificationServiceProvider);
  if (await service.hasPermission()) {
    await HiveService.settingsBox.put(notificationPermissionRequestedKey, true);
    return;
  }

  if (!context.mounted) return;
  final l10n = AppLocalizations.of(context);

  final accept = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.notificationPostScanTitle),
      content: Text(l10n.notificationPostScanBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(l10n.notificationPostScanNotNow),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(l10n.notificationPostScanYes),
        ),
      ],
    ),
  );

  await HiveService.settingsBox.put(notificationPermissionRequestedKey, true);

  if (accept == true) {
    final granted = await service.requestPermission();
    if (granted) {
      await ref.read(notificationSettingsProvider.notifier).reschedule();
      await ref.read(nurtureSchedulerProvider).reschedule();
    }
  }
}
