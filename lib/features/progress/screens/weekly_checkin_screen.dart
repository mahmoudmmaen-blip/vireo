import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/progress/providers/weekly_checkin_provider.dart';

class WeeklyCheckInScreen extends ConsumerStatefulWidget {
  const WeeklyCheckInScreen({super.key});

  @override
  ConsumerState<WeeklyCheckInScreen> createState() => _WeeklyCheckInScreenState();
}

class _WeeklyCheckInScreenState extends ConsumerState<WeeklyCheckInScreen> {
  final _weightCtrl = TextEditingController(text: '75');
  final _waistCtrl = TextEditingController(text: '85');
  int _energy = 3;
  int _adherence = 70;
  bool _submitting = false;

  @override
  void dispose() {
    _weightCtrl.dispose();
    _waistCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final weight = double.tryParse(_weightCtrl.text.replaceAll(',', '.'));
    final waist = double.tryParse(_waistCtrl.text.replaceAll(',', '.'));
    if (weight == null || weight <= 0 || waist == null || waist <= 0) return;

    setState(() => _submitting = true);
    try {
      final result = await ref.read(weeklyCheckInProvider.notifier).submit(
            WeeklyCheckInInput(
              weightKg: weight,
              waistCm: waist,
              energyLevel: _energy,
              adherencePct: _adherence,
            ),
          );
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.weeklyCheckInDoneTitle),
          content: Text(
            l10n.weeklyCheckInDoneBody(
              result.previousCalories,
              result.target.calories,
              result.target.proteinG,
              result.target.carbsG,
              result.target.fatG,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.continueButton),
            ),
          ],
        ),
      );
      if (mounted) Navigator.of(context).pop(true);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).authErrorGeneric)),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: Text(l10n.weeklyCheckInTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            l10n.weeklyCheckInSubtitle,
            style: TextStyle(color: colors.textMute),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _weightCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: l10n.weeklyCheckInWeight,
              suffixText: 'kg',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _waistCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: l10n.weeklyCheckInWaist,
              suffixText: 'cm',
            ),
          ),
          const SizedBox(height: 20),
          Text(l10n.weeklyCheckInEnergy, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (i) {
              final level = i + 1;
              final selected = _energy == level;
              return ChoiceChip(
                label: Text('$level'),
                selected: selected,
                onSelected: (_) => setState(() => _energy = level),
              );
            }),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.weeklyCheckInAdherence(_adherence),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Slider(
            value: _adherence.toDouble(),
            min: 0,
            max: 100,
            divisions: 20,
            label: '$_adherence%',
            onChanged: (v) => setState(() => _adherence = v.round()),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.weeklyCheckInSubmit),
          ),
        ],
      ),
    );
  }
}
