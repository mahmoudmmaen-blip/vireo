import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/theme/vireo_decorations.dart';
import 'package:vireo/features/notifications/providers/notification_settings_provider.dart';

class NotificationBanner extends ConsumerWidget {
  const NotificationBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final permissionAsync = ref.watch(notificationPermissionProvider);

    return permissionAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (error, _) => const SizedBox.shrink(),
      data: (granted) {
        if (granted) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors.gold.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(VireoDecorations.cardRadius),
            border: Border.all(color: colors.gold.withValues(alpha: 0.45)),
          ),
          child: Row(
            children: [
              Icon(Icons.notifications_off_outlined, color: colors.gold),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.notificationsPermissionBanner,
                  style: TextStyle(color: colors.text, height: 1.35),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => openAppSettings(),
                child: Text(l10n.notificationsOpenSettings),
              ),
            ],
          ),
        );
      },
    );
  }
}
