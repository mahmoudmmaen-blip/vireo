import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/notifications/domain/notification_type.dart';
import 'package:vireo/features/notifications/providers/notification_settings_provider.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  Future<void> _handleToggle(
    BuildContext context,
    WidgetRef ref,
    NotificationType type,
  ) async {
    final settings = ref.read(notificationSettingsProvider);
    final willEnable = !settings.isEnabled(type);
    final service = ref.read(notificationServiceProvider);

    if (willEnable) {
      final hasPerm = await service.hasPermission();
      if (!hasPerm && context.mounted) {
        final l10n = AppLocalizations.of(context);
        final shouldAsk = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(l10n.notificationsPermissionDialogTitle),
            content: Text(l10n.notificationsPermissionDialogBody),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(l10n.notificationsPermissionNotNow),
              ),
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text(l10n.notificationsPermissionAllow),
              ),
            ],
          ),
        );

        if (shouldAsk == true) {
          await service.requestPermission();
        }
      }
    }

    await ref.read(notificationSettingsProvider.notifier).toggleType(type);
  }

  Future<void> _pickTimeFor(
    BuildContext context,
    WidgetRef ref,
    NotificationType type,
    TimeOfDay current,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: current,
    );
    if (picked != null) {
      await ref
          .read(notificationSettingsProvider.notifier)
          .setReminderTime(type, picked);
    }
  }

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
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 32),
        children: [
          // ── Reminders List ──
          _ReminderTile(
            icon: '💧',
            title: l10n.notificationsWater,
            subtitle: l10n.notificationsWaterSubtitle,
            value: settings.isEnabled(NotificationType.waterReminder),
            timeLabel: '08:00 - 22:00',
            activeColor: colors.ember,
            onToggle: () => _handleToggle(context, ref, NotificationType.waterReminder),
          ),
          _ReminderTile(
            icon: '🍳',
            title: l10n.notificationsBreakfast,
            subtitle: _formatTime(context, settings.timeFor(NotificationType.mealBreakfastReminder)),
            value: settings.isEnabled(NotificationType.mealBreakfastReminder),
            timeLabel: _formatTime(context, settings.timeFor(NotificationType.mealBreakfastReminder)),
            activeColor: colors.ember,
            onToggle: () => _handleToggle(context, ref, NotificationType.mealBreakfastReminder),
            onPickTime: () => _pickTimeFor(
              context,
              ref,
              NotificationType.mealBreakfastReminder,
              settings.timeFor(NotificationType.mealBreakfastReminder),
            ),
          ),
          _ReminderTile(
            icon: '🍛',
            title: l10n.notificationsLunch,
            subtitle: _formatTime(context, settings.timeFor(NotificationType.mealLunchReminder)),
            value: settings.isEnabled(NotificationType.mealLunchReminder),
            timeLabel: _formatTime(context, settings.timeFor(NotificationType.mealLunchReminder)),
            activeColor: colors.ember,
            onToggle: () => _handleToggle(context, ref, NotificationType.mealLunchReminder),
            onPickTime: () => _pickTimeFor(
              context,
              ref,
              NotificationType.mealLunchReminder,
              settings.timeFor(NotificationType.mealLunchReminder),
            ),
          ),
          _ReminderTile(
            icon: '🍽️',
            title: l10n.notificationsDinner,
            subtitle: _formatTime(context, settings.timeFor(NotificationType.mealDinnerReminder)),
            value: settings.isEnabled(NotificationType.mealDinnerReminder),
            timeLabel: _formatTime(context, settings.timeFor(NotificationType.mealDinnerReminder)),
            activeColor: colors.ember,
            onToggle: () => _handleToggle(context, ref, NotificationType.mealDinnerReminder),
            onPickTime: () => _pickTimeFor(
              context,
              ref,
              NotificationType.mealDinnerReminder,
              settings.timeFor(NotificationType.mealDinnerReminder),
            ),
          ),
          _ReminderTile(
            icon: '✨',
            title: l10n.notificationsFastingOpen,
            subtitle: l10n.notificationsFastingOpenSubtitle,
            value: settings.isEnabled(NotificationType.fastingWindowOpenReminder),
            timeLabel: _formatTime(context, settings.timeFor(NotificationType.fastingWindowOpenReminder)),
            activeColor: colors.ember,
            onToggle: () => _handleToggle(context, ref, NotificationType.fastingWindowOpenReminder),
            onPickTime: () => _pickTimeFor(
              context,
              ref,
              NotificationType.fastingWindowOpenReminder,
              settings.timeFor(NotificationType.fastingWindowOpenReminder),
            ),
          ),
          _ReminderTile(
            icon: '🌙',
            title: l10n.notificationsFastingClose,
            subtitle: l10n.notificationsFastingCloseSubtitle,
            value: settings.isEnabled(NotificationType.fastingWindowCloseReminder),
            timeLabel: _formatTime(context, settings.timeFor(NotificationType.fastingWindowCloseReminder)),
            activeColor: colors.ember,
            onToggle: () => _handleToggle(context, ref, NotificationType.fastingWindowCloseReminder),
            onPickTime: () => _pickTimeFor(
              context,
              ref,
              NotificationType.fastingWindowCloseReminder,
              settings.timeFor(NotificationType.fastingWindowCloseReminder),
            ),
          ),
          _ReminderTile(
            icon: '🏋️',
            title: l10n.notificationsPreWorkout,
            subtitle: l10n.notificationsPreWorkoutSubtitle,
            value: settings.isEnabled(NotificationType.workoutReminder),
            timeLabel: _formatTime(context, settings.timeFor(NotificationType.workoutReminder)),
            activeColor: colors.ember,
            enabled: hasWorkout,
            onToggle: () => _handleToggle(context, ref, NotificationType.workoutReminder),
            onPickTime: () => _pickTimeFor(
              context,
              ref,
              NotificationType.workoutReminder,
              settings.timeFor(NotificationType.workoutReminder),
            ),
          ),
          _ReminderTile(
            icon: '🚶‍♂️',
            title: l10n.notificationsStepsNudge,
            subtitle: l10n.notificationsStepsNudgeSubtitle,
            value: settings.isEnabled(NotificationType.stepsNudgeReminder),
            timeLabel: _formatTime(context, settings.timeFor(NotificationType.stepsNudgeReminder)),
            activeColor: colors.ember,
            onToggle: () => _handleToggle(context, ref, NotificationType.stepsNudgeReminder),
            onPickTime: () => _pickTimeFor(
              context,
              ref,
              NotificationType.stepsNudgeReminder,
              settings.timeFor(NotificationType.stepsNudgeReminder),
            ),
          ),
          _ReminderTile(
            icon: '😴',
            title: l10n.notificationsSleep,
            subtitle: l10n.notificationsSleepSubtitle,
            value: settings.isEnabled(NotificationType.bedtimeReminder),
            timeLabel: _formatTime(context, settings.timeFor(NotificationType.bedtimeReminder)),
            activeColor: colors.ember,
            onToggle: () => _handleToggle(context, ref, NotificationType.bedtimeReminder),
            onPickTime: () => _pickTimeFor(
              context,
              ref,
              NotificationType.bedtimeReminder,
              settings.timeFor(NotificationType.bedtimeReminder),
            ),
          ),
          _ReminderTile(
            icon: '📊',
            title: l10n.notificationsWeeklyReport,
            subtitle: l10n.notificationsWeeklyReportSubtitle,
            value: settings.isEnabled(NotificationType.weeklyCheckInReminder),
            timeLabel: 'Sun ${_formatTime(context, settings.timeFor(NotificationType.weeklyCheckInReminder))}',
            activeColor: colors.ember,
            onToggle: () => _handleToggle(context, ref, NotificationType.weeklyCheckInReminder),
            onPickTime: () => _pickTimeFor(
              context,
              ref,
              NotificationType.weeklyCheckInReminder,
              settings.timeFor(NotificationType.weeklyCheckInReminder),
            ),
          ),
          _ReminderTile(
            icon: '🔥',
            title: l10n.notificationsStreakProtection,
            subtitle: l10n.notificationsStreakProtectionSubtitle,
            value: settings.isEnabled(NotificationType.streakProtectionReminder),
            timeLabel: _formatTime(context, settings.timeFor(NotificationType.streakProtectionReminder)),
            activeColor: colors.ember,
            onToggle: () => _handleToggle(context, ref, NotificationType.streakProtectionReminder),
            onPickTime: () => _pickTimeFor(
              context,
              ref,
              NotificationType.streakProtectionReminder,
              settings.timeFor(NotificationType.streakProtectionReminder),
            ),
          ),

          const Divider(height: 32),

          // ── Quiet Hours & Daily Cap Section ──
          ListTile(
            leading: const Icon(Icons.bedtime_outlined),
            title: Text(l10n.notificationsQuietHoursTitle),
            subtitle: Text(
              l10n.notificationsQuietHoursSubtitle(
                _formatTime(
                  context,
                  TimeOfDay(
                    hour: settings.quietHoursStartHour,
                    minute: settings.quietHoursStartMinute,
                  ),
                ),
                _formatTime(
                  context,
                  TimeOfDay(
                    hour: settings.quietHoursEndHour,
                    minute: settings.quietHoursEndMinute,
                  ),
                ),
              ),
            ),
            trailing: const Icon(Icons.edit_outlined),
            onTap: () async {
              final start = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(
                  hour: settings.quietHoursStartHour,
                  minute: settings.quietHoursStartMinute,
                ),
                helpText: 'Quiet Hours Start',
              );
              if (start == null || !context.mounted) return;

              final end = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(
                  hour: settings.quietHoursEndHour,
                  minute: settings.quietHoursEndMinute,
                ),
                helpText: 'Quiet Hours End',
              );
              if (end == null) return;

              await ref
                  .read(notificationSettingsProvider.notifier)
                  .setQuietHours(
                    startHour: start.hour,
                    startMinute: start.minute,
                    endHour: end.hour,
                    endMinute: end.minute,
                  );
            },
          ),

          ListTile(
            leading: const Icon(Icons.notifications_paused_outlined),
            title: Text(l10n.notificationsMaxDailyTitle),
            subtitle: Text(l10n.notificationsMaxDailySubtitle(settings.maxDailyNotifications)),
            trailing: DropdownButton<int>(
              value: settings.maxDailyNotifications,
              underline: const SizedBox.shrink(),
              items: [3, 4, 5, 6, 8, 10].map((count) {
                return DropdownMenuItem<int>(
                  value: count,
                  child: Text('$count'),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  ref
                      .read(notificationSettingsProvider.notifier)
                      .setMaxDailyNotifications(val);
                }
              },
            ),
          ),

          const SizedBox(height: 20),

          // ── Test Button ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: () async {
                final granted = await service.requestPermission();
                if (!granted && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 3),
                      content: Text(l10n.notificationsPermissionBanner),
                    ),
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

  static String _formatTime(BuildContext context, TimeOfDay time) {
    return time.format(context);
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.timeLabel,
    required this.activeColor,
    required this.onToggle,
    this.onPickTime,
    this.enabled = true,
  });

  final String icon;
  final String title;
  final String subtitle;
  final bool value;
  final String timeLabel;
  final Color activeColor;
  final VoidCallback onToggle;
  final VoidCallback? onPickTime;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Text(icon, style: const TextStyle(fontSize: 22)),
        title: Row(
          children: [
            Expanded(child: Text(title)),
            if (onPickTime != null)
              InkWell(
                onTap: enabled ? onPickTime : null,
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        timeLabel,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: Switch(
          value: value,
          activeThumbColor: activeColor,
          activeTrackColor: activeColor.withValues(alpha: 0.45),
          onChanged: enabled ? (_) => onToggle() : null,
        ),
      ),
    );
  }
}
