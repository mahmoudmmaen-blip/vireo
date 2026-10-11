import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_snackbar.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/measurements/domain/body_composition_report.dart';
import 'package:vireo/features/measurements/providers/body_composition_provider.dart';
import 'package:vireo/features/nutrition/providers/calorie_goal_provider.dart';

class InBodyReviewScreen extends ConsumerStatefulWidget {
  const InBodyReviewScreen({super.key, required this.report});

  final BodyCompositionReport report;

  static Future<bool?> open(BuildContext context, BodyCompositionReport report) {
    return Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => InBodyReviewScreen(report: report)),
    );
  }

  @override
  ConsumerState<InBodyReviewScreen> createState() => _InBodyReviewScreenState();
}

class _InBodyReviewScreenState extends ConsumerState<InBodyReviewScreen> {
  late BodyCompositionReport _report;
  late final TextEditingController _weight;
  late final TextEditingController _smm;
  late final TextEditingController _fatMass;
  late final TextEditingController _pbf;
  late final TextEditingController _bmi;
  late final TextEditingController _visceral;
  late final TextEditingController _bmr;
  late final TextEditingController _score;

  @override
  void initState() {
    super.initState();
    _report = widget.report;
    _weight = TextEditingController(text: _fmt(_report.weightKg));
    _smm = TextEditingController(text: _fmt(_report.skeletalMuscleMassKg));
    _fatMass = TextEditingController(text: _fmt(_report.bodyFatMassKg));
    _pbf = TextEditingController(text: _fmt(_report.percentBodyFat));
    _bmi = TextEditingController(text: _fmt(_report.bmi));
    _visceral = TextEditingController(text: _fmt(_report.visceralFatLevel));
    _bmr = TextEditingController(text: _fmt(_report.bmrKcal));
    _score = TextEditingController(text: _fmt(_report.inbodyScore));
  }

  String _fmt(double? v) => v == null ? '' : v.toStringAsFixed(1);

  double? _parse(String s) => double.tryParse(s.trim().replaceAll(',', '.'));

  @override
  void dispose() {
    _weight.dispose();
    _smm.dispose();
    _fatMass.dispose();
    _pbf.dispose();
    _bmi.dispose();
    _visceral.dispose();
    _bmr.dispose();
    _score.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _report.testDate,
      firstDate: DateTime(2015),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) setState(() => _report = _report.copyWith(testDate: picked));
  }

  Future<void> _save() async {
    final next = _report.copyWith(
      weightKg: _parse(_weight.text) ?? _report.weightKg,
      skeletalMuscleMassKg: _parse(_smm.text) ?? _report.skeletalMuscleMassKg,
      bodyFatMassKg: _parse(_fatMass.text) ?? _report.bodyFatMassKg,
      percentBodyFat: _parse(_pbf.text) ?? _report.percentBodyFat,
      bmi: _parse(_bmi.text) ?? _report.bmi,
      visceralFatLevel: _parse(_visceral.text) ?? _report.visceralFatLevel,
      bmrKcal: _parse(_bmr.text) ?? _report.bmrKcal,
      inbodyScore: _parse(_score.text) ?? _report.inbodyScore,
    );
    await ref.read(bodyCompositionListProvider.notifier).save(next);
    ref.invalidate(calorieGoalProvider);
    if (!mounted) return;
    VireoSnackBar.showText(context, AppLocalizations.of(context).inbodySaved);
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final conf = _report.fieldConfidence;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: Text(l10n.inbodyReviewTitle)),
      body: ListView(
        padding: const EdgeInsets.all(VSpace.lg),
        children: [
          Text(l10n.inbodyMedicalNote,
              style: TextStyle(color: colors.textMute, fontSize: 12)),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.inbodyTestDate),
            subtitle: Text(DateFormat.yMMMd().format(_report.testDate)),
            trailing: const Icon(Icons.edit_calendar_outlined),
            onTap: _pickDate,
          ),
          if (_report.deviceModel != null)
            Text('${l10n.inbodyDevice}: ${_report.deviceModel}'),
          const SizedBox(height: 8),
          _Field(
            label: l10n.inbodyWeight,
            controller: _weight,
            low: (conf['weight_kg'] ?? 1) < 0.6,
          ),
          _Field(
            label: l10n.inbodySmm,
            controller: _smm,
            low: (conf['skeletal_muscle_mass_kg'] ?? 1) < 0.6,
          ),
          _Field(
            label: l10n.inbodyFatMass,
            controller: _fatMass,
            low: (conf['body_fat_mass_kg'] ?? 1) < 0.6,
          ),
          _Field(
            label: l10n.inbodyPbf,
            controller: _pbf,
            low: (conf['percent_body_fat'] ?? 1) < 0.6,
          ),
          _Field(
            label: l10n.inbodyBmi,
            controller: _bmi,
            low: (conf['bmi'] ?? 1) < 0.6,
          ),
          _Field(
            label: l10n.inbodyVisceral,
            controller: _visceral,
            low: (conf['visceral_fat_level'] ?? 1) < 0.6,
          ),
          _Field(
            label: l10n.inbodyBmr,
            controller: _bmr,
            low: (conf['bmr_kcal'] ?? 1) < 0.6,
          ),
          _Field(
            label: l10n.inbodyScore,
            controller: _score,
            low: (conf['inbody_score'] ?? 1) < 0.6,
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: _save, child: Text(l10n.inbodySave)),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    required this.low,
  });

  final String label;
  final TextEditingController controller;
  final bool low;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          filled: low,
          fillColor: low ? colors.ember.withValues(alpha: 0.12) : null,
          border: const OutlineInputBorder(),
          suffixIcon: low
              ? Icon(Icons.warning_amber_rounded, color: colors.ember, size: 18)
              : null,
        ),
      ),
    );
  }
}
