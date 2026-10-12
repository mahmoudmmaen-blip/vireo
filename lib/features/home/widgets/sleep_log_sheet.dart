import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/health_steps_service.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/vitality/providers/vitality_provider.dart';

Future<void> showSleepLogSheet(BuildContext context, WidgetRef ref) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _SleepLogSheet(ref: ref),
  );
}

class _SleepLogSheet extends ConsumerStatefulWidget {
  const _SleepLogSheet({required this.ref});
  final WidgetRef ref;

  @override
  ConsumerState<_SleepLogSheet> createState() => _SleepLogSheetState();
}

class _SleepLogSheetState extends ConsumerState<_SleepLogSheet> {
  TimeOfDay _bedTime = const TimeOfDay(hour: 23, minute: 0);
  TimeOfDay _wakeTime = const TimeOfDay(hour: 7, minute: 0);
  double _quality = 4;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _checkHealthConnect();
  }

  Future<void> _checkHealthConnect() async {
    try {
      if (HealthStepsService.isSupported) {
        // If Health data is connected, auto populate default
      }
    } catch (_) {}
  }

  double get _hoursSlept {
    final bedMinutes = _bedTime.hour * 60 + _bedTime.minute;
    var wakeMinutes = _wakeTime.hour * 60 + _wakeTime.minute;
    if (wakeMinutes <= bedMinutes) {
      wakeMinutes += 24 * 60; // Crosses midnight
    }
    final diff = (wakeMinutes - bedMinutes) / 60.0;
    return (diff * 10).round() / 10.0;
  }

  Future<void> _pickBedTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _bedTime,
    );
    if (picked != null) {
      setState(() => _bedTime = picked);
    }
  }

  Future<void> _pickWakeTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _wakeTime,
    );
    if (picked != null) {
      setState(() => _wakeTime = picked);
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    HapticFeedback.mediumImpact();
    final hours = _hoursSlept;
    await ref.read(vitalityDailyLogProvider.notifier).setSleepHours(hours);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final hours = _hoursSlept;
    final isTargetMet = hours >= 7.0;

    return Container(
      padding: EdgeInsets.only(
        top: VSpace.md,
        left: VSpace.lg,
        right: VSpace.lg,
        bottom: MediaQuery.paddingOf(context).bottom + VSpace.lg,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(VRadius.xl)),
        border: Border(top: BorderSide(color: colors.line.withValues(alpha: 0.6))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colors.line,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: VSpace.md),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.recovery.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.bedtime_rounded, color: colors.recovery, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.todayPlanSleepLogTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    Text(
                      l10n.todayPlanSleepDuration(hours.toStringAsFixed(1)),
                      style: TextStyle(
                        color: isTargetMet ? colors.success : colors.textMute,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              if (isTargetMet)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.success.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(VRadius.pill),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_rounded, size: 14, color: colors.success),
                      const SizedBox(width: 4),
                      Text(
                        '≥ 7h',
                        style: TextStyle(
                          color: colors.success,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: VSpace.lg),
          Row(
            children: [
              Expanded(
                child: _TimePickTile(
                  title: l10n.healthBedtime,
                  time: _bedTime.format(context),
                  icon: Icons.nightlight_round,
                  onTap: _pickBedTime,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _TimePickTile(
                  title: l10n.healthWakeTime,
                  time: _wakeTime.format(context),
                  icon: Icons.wb_sunny_rounded,
                  onTap: _pickWakeTime,
                ),
              ),
            ],
          ),
          const SizedBox(height: VSpace.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.vitalitySleepHint,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              Text(
                '${_quality.round()} / 5 ★',
                style: TextStyle(
                  color: colors.gold,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Slider(
            value: _quality,
            min: 1,
            max: 5,
            divisions: 4,
            activeColor: colors.recovery,
            onChanged: (v) => setState(() => _quality = v),
          ),
          const SizedBox(height: VSpace.sm),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Text(l10n.progressSaveWeight),
          ),
        ],
      ),
    );
  }
}

class _TimePickTile extends StatelessWidget {
  const _TimePickTile({
    required this.title,
    required this.time,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String time;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(VRadius.md),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: BorderRadius.circular(VRadius.md),
          border: Border.all(color: colors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: colors.recovery),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: TextStyle(color: colors.textMute, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              time,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
