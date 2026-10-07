import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/notifications/domain/notification_type.dart';
import 'package:vireo/features/notifications/providers/notification_settings_provider.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final settings = ref.watch(notificationSettingsProvider);
    final hasWorkout = ref.watch(hasWorkoutScheduledProvider);
    final service = ref.read(notificationServiceProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.notificationsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
        children: [
          _NotificationSwitchTile(
            icon: '💧',
            title: l10n.notificationsWater,
            subtitle: l10n.notificationsWaterSubtitle,
            value: settings.isEnabled(NotificationType.waterReminder),
            activeColor: colors.ember,
            onChanged: (_) => ref
                .read(notificationSettingsProvider.notifier)
                .toggleType(NotificationType.waterReminder),
          ),
          _NotificationSwitchTile(
            icon: '🍳',
            title: l10n.notificationsBreakfast,
            subtitle: '08:30',
            value: settings.isEnabled(NotificationType.breakfastReminder),
            activeColor: colors.ember,
            onChanged: (_) => ref
                .read(notificationSettingsProvider.notifier)
                .toggleType(NotificationType.breakfastReminder),
          ),
          _NotificationSwitchTile(
            icon: '🍛',
            title: l10n.notificationsLunch,
            subtitle: '13:00',
            value: settings.isEnabled(NotificationType.lunchReminder),
            activeColor: colors.ember,
            onChanged: (_) => ref
                .read(notificationSettingsProvider.notifier)
                .toggleType(NotificationType.lunchReminder),
          ),
          _NotificationSwitchTile(
            icon: '🍽️',
            title: l10n.notificationsDinner,
            subtitle: '19:30',
            value: settings.isEnabled(NotificationType.dinnerReminder),
            activeColor: colors.ember,
            onChanged: (_) => ref
                .read(notificationSettingsProvider.notifier)
                .toggleType(NotificationType.dinnerReminder),
          ),
          _NotificationSwitchTile(
            icon: '🏋️',
            title: l10n.notificationsPreWorkout,
            subtitle: l10n.notificationsPreWorkoutSubtitle,
            value: settings.isEnabled(NotificationType.preWorkoutReminder),
            activeColor: colors.ember,
            enabled: hasWorkout,
            onChanged: hasWorkout
                ? (_) => ref
                    .read(notificationSettingsProvider.notifier)
                    .toggleType(NotificationType.preWorkoutReminder)
                : null,
          ),
          if (hasWorkout)
            ListTile(
              leading: const Icon(Icons.schedule_outlined),
              title: Text(l10n.notificationWorkoutTime),
              subtitle: Text(
                settings.workoutTime?.format(context) ??
                    readPreferredWorkoutTimeFromProfile()?.format(context) ??
                    l10n.notificationNotSet,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final initial = settings.workoutTime ??
                    readPreferredWorkoutTimeFromProfile() ??
                    const TimeOfDay(hour: 18, minute: 0);
                final picked = await showTimePicker(
                  context: context,
                  initialTime: initial,
                );
                if (picked != null) {
                  await ref
                      .read(notificationSettingsProvider.notifier)
                      .setWorkoutTime(picked);
                }
              },
            ),
          _NotificationSwitchTile(
            icon: '😴',
            title: l10n.notificationsSleep,
            subtitle: l10n.notificationsSleepSubtitle,
            value: settings.isEnabled(NotificationType.sleepReminder),
            activeColor: colors.ember,
            onChanged: (_) => ref
                .read(notificationSettingsProvider.notifier)
                .toggleType(NotificationType.sleepReminder),
          ),
          _NotificationSwitchTile(
            icon: '📊',
            title: l10n.notificationsWeeklyReport,
            subtitle: l10n.notificationsWeeklyReportSubtitle,
            value: settings.isEnabled(NotificationType.weeklyReportReminder),
            activeColor: colors.ember,
            onChanged: (_) => ref
                .read(notificationSettingsProvider.notifier)
                .toggleType(NotificationType.weeklyReportReminder),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: () async {
                final granted = await service.requestPermission();
                if (!granted && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.notificationsPermissionBanner)),
                  );
                  return;
                }
                await service.showInstant(
                  l10n.notificationsTest,
                  l10n.notificationsTestBody,
                  NotificationType.waterReminder,
                );
              },
              icon: const Icon(Icons.notifications_active_outlined),
              label: Text(l10n.notificationsTest),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationSwitchTile extends StatelessWidget {
  const _NotificationSwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.activeColor,
    required this.onChanged,
    this.enabled = true,
  });

  final String icon;
  final String title;
  final String subtitle;
  final bool value;
  final Color activeColor;
  final ValueChanged<bool>? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: Text(icon, style: const TextStyle(fontSize: 22)),
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      activeThumbColor: activeColor,
      activeTrackColor: activeColor.withValues(alpha: 0.45),
      onChanged: enabled ? onChanged : null,
    );
  }
}
