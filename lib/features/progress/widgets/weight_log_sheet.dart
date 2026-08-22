import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/utils/unit_converter.dart';
import 'package:vireo/features/progress/providers/progress_provider.dart';

Future<void> showWeightLogSheet(BuildContext context, WidgetRef ref) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
      child: const _WeightLogSheet(),
    ),
  );
}

class _WeightLogSheet extends ConsumerStatefulWidget {
  const _WeightLogSheet();

  @override
  ConsumerState<_WeightLogSheet> createState() => _WeightLogSheetState();
}

class _WeightLogSheetState extends ConsumerState<_WeightLogSheet> {
  final _weightCtrl = TextEditingController();
  DateTime _date = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    _weightCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final value = double.tryParse(_weightCtrl.text.replaceAll(',', '.'));
    if (value == null || value <= 0) return;

    setState(() => _saving = true);
    try {
      final unit = ref.read(unitPreferenceProvider);
      final kg = UnitConverter.inputWeightToKg(value, unit);
      await ref.read(progressRepositoryProvider).logWeight(
            weightKg: kg,
            loggedAt: _date,
          );
      ref.invalidate(weightLogsProvider);
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).authErrorGeneric)),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final unit = ref.watch(unitPreferenceProvider);
    final unitLabel = UnitConverter.weightLabel(unit);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.progressLogWeight, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: _weightCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l10n.progressWeightLabel(unitLabel),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.progressLogDate),
              subtitle: Text(DateFormat.yMMMd().format(_date)),
              trailing: const Icon(Icons.calendar_today_outlined),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now(),
                );
                if (picked != null) setState(() => _date = picked);
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.progressSaveWeight),
            ),
          ],
        ),
      ),
    );
  }
}
