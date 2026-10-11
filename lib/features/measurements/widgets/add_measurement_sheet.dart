import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/theme/vireo_decorations.dart';
import 'package:vireo/features/measurements/application/measurement_calculators.dart';
import 'package:vireo/features/measurements/data/measurement_repository_impl.dart';
import 'package:vireo/features/measurements/domain/body_measurement.dart';
import 'package:vireo/features/measurements/providers/measurement_provider.dart';

Future<void> showAddMeasurementSheet(
  BuildContext context, {
  BodyMeasurement? existing,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => AddMeasurementSheet(existing: existing),
  );
}

class AddMeasurementSheet extends ConsumerStatefulWidget {
  const AddMeasurementSheet({super.key, this.existing});

  final BodyMeasurement? existing;

  @override
  ConsumerState<AddMeasurementSheet> createState() => _AddMeasurementSheetState();
}

class _AddMeasurementSheetState extends ConsumerState<AddMeasurementSheet> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _date;
  late TextEditingController _weightCtrl;
  late TextEditingController _waistCtrl;
  late TextEditingController _chestCtrl;
  late TextEditingController _armsCtrl;
  late TextEditingController _thighsCtrl;
  late TextEditingController _bodyFatCtrl;
  late TextEditingController _notesCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _date = e?.date ?? DateTime.now();
    _weightCtrl = TextEditingController(
      text: e != null ? e.weightKg.toStringAsFixed(1) : '',
    );
    _waistCtrl = TextEditingController(text: _fmt(e?.waistCm));
    _chestCtrl = TextEditingController(text: _fmt(e?.chestCm));
    _armsCtrl = TextEditingController(text: _fmt(e?.armsCm));
    _thighsCtrl = TextEditingController(text: _fmt(e?.thighsCm));
    _bodyFatCtrl = TextEditingController(text: _fmt(e?.bodyFatPercent));
    _notesCtrl = TextEditingController(text: e?.notes ?? '');
  }

  String _fmt(double? v) => v == null ? '' : v.toStringAsFixed(1);

  @override
  void dispose() {
    _weightCtrl.dispose();
    _waistCtrl.dispose();
    _chestCtrl.dispose();
    _armsCtrl.dispose();
    _thighsCtrl.dispose();
    _bodyFatCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  double? _parseOptional(String text) {
    final t = text.trim();
    if (t.isEmpty) return null;
    return double.tryParse(t.replaceAll(',', '.'));
  }

  void _updateAutoBodyFat() {
    final waist = _parseOptional(_waistCtrl.text);
    if (waist == null) return;

    final ctx = readMeasurementProfileContext();
    final bf = BodyFatCalculator.calculateUsNavy(
      waistCm: waist,
      heightCm: ctx.heightCm,
      isFemale: ctx.isFemale,
      neckCm: ctx.neckCm,
      hipCm: ctx.hipCm,
    );
    if (bf != null && _bodyFatCtrl.text.trim().isEmpty) {
      _bodyFatCtrl.text = bf.toStringAsFixed(1);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      final measurement = BodyMeasurement(
        id: widget.existing?.id ?? newMeasurementId(),
        date: _date,
        weightKg: double.parse(_weightCtrl.text.trim().replaceAll(',', '.')),
        waistCm: _parseOptional(_waistCtrl.text),
        chestCm: _parseOptional(_chestCtrl.text),
        armsCm: _parseOptional(_armsCtrl.text),
        thighsCm: _parseOptional(_thighsCtrl.text),
        bodyFatPercent: _parseOptional(_bodyFatCtrl.text),
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      );

      if (widget.existing != null) {
        await ref.read(measurementRepositoryProvider).delete(widget.existing!.id);
      }
      await ref.read(measurementListProvider.notifier).addMeasurement(measurement);

      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(duration: const Duration(seconds: 3), persist: false, content: Text(AppLocalizations.of(context).authErrorGeneric)),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final locale = Localizations.localeOf(context).languageCode;
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: VireoDecorations.premiumCard(colors),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.measurementsAdd,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.measurementsDate),
                  subtitle: Text(DateFormat.yMMMd(locale).format(_date)),
                  trailing: const Icon(Icons.calendar_today_outlined),
                  onTap: _pickDate,
                ),
                const SizedBox(height: 8),
                _field(
                  controller: _weightCtrl,
                  label: l10n.measurementsWeight,
                  required: true,
                  validator: (v) {
                    final n = double.tryParse(v?.trim().replaceAll(',', '.') ?? '');
                    if (n == null || n <= 20 || n >= 300) {
                      return l10n.measurementsWeightInvalid;
                    }
                    return null;
                  },
                ),
                _field(
                  controller: _waistCtrl,
                  label: l10n.measurementsWaist,
                  onChanged: (_) => _updateAutoBodyFat(),
                ),
                _field(controller: _chestCtrl, label: l10n.measurementsChest),
                _field(controller: _armsCtrl, label: l10n.measurementsArms),
                _field(controller: _thighsCtrl, label: l10n.measurementsThighs),
                _field(controller: _bodyFatCtrl, label: l10n.measurementsBodyFat),
                _field(
                  controller: _notesCtrl,
                  label: l10n.measurementsNotes,
                  maxLines: 2,
                  keyboard: TextInputType.multiline,
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
                      : Text(l10n.measurementsSave),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    bool required = false,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    int maxLines = 1,
    TextInputType keyboard = const TextInputType.numberWithOptions(decimal: true),
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        maxLines: maxLines,
        inputFormatters: keyboard == const TextInputType.numberWithOptions(decimal: true)
            ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d{0,1}'))]
            : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: required
            ? validator
            : null,
        onChanged: onChanged,
      ),
    );
  }
}
