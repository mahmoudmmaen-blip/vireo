import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/activity/providers/wearable_health_provider.dart';

Future<void> showManualSleepSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.vireoColors.surface,
    builder: (ctx) => const _ManualSleepSheet(),
  );
}

class _ManualSleepSheet extends StatefulWidget {
  const _ManualSleepSheet();

  @override
  State<_ManualSleepSheet> createState() => _ManualSleepSheetState();
}

class _ManualSleepSheetState extends State<_ManualSleepSheet> {
  TimeOfDay _bed = const TimeOfDay(hour: 23, minute: 0);
  TimeOfDay _wake = const TimeOfDay(hour: 7, minute: 0);
  double _quality = 3;

  Future<void> _save() async {
    final now = DateTime.now();
    final bed = DateTime(now.year, now.month, now.day, _bed.hour, _bed.minute)
        .subtract(const Duration(hours: 8));
    final wake = DateTime(now.year, now.month, now.day, _wake.hour, _wake.minute);
    final key =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    await saveManualSleep(
      ManualSleepEntry(
        dateKey: key,
        bedtime: bed,
        wakeTime: wake,
        quality: _quality.round(),
      ),
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.healthManualSleepTitle, style: Theme.of(context).textTheme.titleLarge),
          ListTile(
            title: Text(l10n.healthBedtime),
            trailing: Text(_bed.format(context)),
            onTap: () async {
              final p = await showTimePicker(context: context, initialTime: _bed);
              if (p != null) setState(() => _bed = p);
            },
          ),
          ListTile(
            title: Text(l10n.healthWakeTime),
            trailing: Text(_wake.format(context)),
            onTap: () async {
              final p = await showTimePicker(context: context, initialTime: _wake);
              if (p != null) setState(() => _wake = p);
            },
          ),
          Text(l10n.healthSleepQuality),
          Slider(
            value: _quality,
            min: 1,
            max: 5,
            divisions: 4,
            label: _quality.round().toString(),
            onChanged: (v) => setState(() => _quality = v),
          ),
          FilledButton(onPressed: _save, child: Text(l10n.profileSaveBodyMetrics)),
        ],
      ),
    );
  }
}
