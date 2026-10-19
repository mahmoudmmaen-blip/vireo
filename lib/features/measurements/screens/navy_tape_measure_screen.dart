import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_snackbar.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/measurements/domain/navy_tape_calculator.dart';
import 'package:vireo/features/measurements/providers/body_composition_provider.dart';
import 'package:vireo/features/nutrition/providers/calorie_goal_provider.dart';
import 'package:vireo/features/walking/domain/walking_calculations.dart';
import 'package:vireo/core/theme/vireo_bridge.dart';

class NavyTapeMeasureScreen extends ConsumerStatefulWidget {
  const NavyTapeMeasureScreen({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const NavyTapeMeasureScreen()),
    );
  }

  @override
  ConsumerState<NavyTapeMeasureScreen> createState() => _NavyTapeMeasureScreenState();
}

class _NavyTapeMeasureScreenState extends ConsumerState<NavyTapeMeasureScreen> {
  bool _isFemale = false;
  late final TextEditingController _heightCtrl;
  late final TextEditingController _weightCtrl;
  late final TextEditingController _ageCtrl;
  final _neckCtrl = TextEditingController(text: '38');
  final _waistCtrl = TextEditingController(text: '86');
  final _hipCtrl = TextEditingController(text: '98');

  NavyTapeResult? _result;

  @override
  void initState() {
    super.initState();
    final profile = WalkingCalculations.readProfileMetrics();
    _isFemale = profile.isFemale;
    _heightCtrl = TextEditingController(text: profile.heightCm.round().toString());
    _weightCtrl = TextEditingController(text: profile.weightKg.round().toString());
    _ageCtrl = TextEditingController(text: '28');
    _recalculate();
  }

  @override
  void dispose() {
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    _ageCtrl.dispose();
    _neckCtrl.dispose();
    _waistCtrl.dispose();
    _hipCtrl.dispose();
    super.dispose();
  }

  void _recalculate() {
    final waist = double.tryParse(_waistCtrl.text) ?? 0;
    final neck = double.tryParse(_neckCtrl.text) ?? 0;
    final height = double.tryParse(_heightCtrl.text) ?? 0;
    final weight = double.tryParse(_weightCtrl.text) ?? 0;
    final hip = double.tryParse(_hipCtrl.text);
    final age = int.tryParse(_ageCtrl.text) ?? 28;

    setState(() {
      _result = NavyTapeMeasureCalculator.compute(
        waistCm: waist,
        neckCm: neck,
        heightCm: height,
        weightKg: weight,
        isFemale: _isFemale,
        hipCm: hip,
        age: age,
      );
    });
  }

  Future<void> _save() async {
    if (_result == null) return;
    final weight = double.tryParse(_weightCtrl.text) ?? 75.0;
    final report = _result!.toReport(weightKg: weight);

    await ref.read(bodyCompositionListProvider.notifier).save(report);
    ref.invalidate(calorieGoalProvider);

    if (!mounted) return;
    VireoSnackBar.showText(
      context,
      Localizations.localeOf(context).languageCode.startsWith('ar')
          ? 'تم حفظ نتيجة تحليل الجسم بنجاح'
          : 'Body composition saved successfully',
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final locale = Localizations.localeOf(context).languageCode;
    final isArabic = locale.startsWith('ar');

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          isArabic ? 'قياس المازورة (طريقة البحرية)' : 'Navy Tape Measure',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(VSpace.md),
          children: [
            // Guided measurement instructions & visual guide
            _MeasuringGuideCard(isFemale: _isFemale, isArabic: isArabic, colors: colors),
            const SizedBox(height: 16),

            // Gender Segmented Button
            SegmentedButton<bool>(
              segments: [
                ButtonSegment<bool>(
                  value: false,
                  label: Text(isArabic ? 'ذكر' : 'Male'),
                  icon: const Icon(Icons.male),
                ),
                ButtonSegment<bool>(
                  value: true,
                  label: Text(isArabic ? 'أنثى' : 'Female'),
                  icon: const Icon(Icons.female),
                ),
              ],
              selected: {_isFemale},
              onSelectionChanged: (set) {
                setState(() {
                  _isFemale = set.first;
                  _recalculate();
                });
              },
            ),
            const SizedBox(height: 16),

            // Height, Weight & Age row
            Row(
              children: [
                Expanded(
                  child: _InputField(
                    label: isArabic ? 'الطول (سم)' : 'Height (cm)',
                    controller: _heightCtrl,
                    onChanged: (_) => _recalculate(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _InputField(
                    label: isArabic ? 'الوزن (كجم)' : 'Weight (kg)',
                    controller: _weightCtrl,
                    onChanged: (_) => _recalculate(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _InputField(
                    label: isArabic ? 'العمر' : 'Age',
                    controller: _ageCtrl,
                    onChanged: (_) => _recalculate(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Circumference Inputs
            Row(
              children: [
                Expanded(
                  child: _InputField(
                    label: isArabic ? 'الرقبة (سم)' : 'Neck (cm)',
                    controller: _neckCtrl,
                    onChanged: (_) => _recalculate(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _InputField(
                    label: isArabic ? 'الوسط/الخصر (سم)' : 'Waist (cm)',
                    controller: _waistCtrl,
                    onChanged: (_) => _recalculate(),
                  ),
                ),
                if (_isFemale) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: _InputField(
                      label: isArabic ? 'الأرداف (سم)' : 'Hips (cm)',
                      controller: _hipCtrl,
                      onChanged: (_) => _recalculate(),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),

            // Results Display
            if (_result != null) ...[
              _ResultDisplayCard(result: _result!, isArabic: isArabic, colors: colors),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save_rounded),
                label: Text(isArabic ? 'حفظ في السجل' : 'Save to History'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor: colors.ember,
                ),
              ),
            ] else ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  isArabic
                  ? 'برجاء إدخال قياسات صحيحة (محيط الخصر أكبر من الرقبة)'
                  : 'Please enter valid measurements (waist must exceed neck)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colors.textMute, fontSize: 13),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MeasuringGuideCard extends StatelessWidget {
  const _MeasuringGuideCard({
    required this.isFemale,
    required this.isArabic,
    required this.colors,
  });

  final bool isFemale;
  final bool isArabic;
  final VireoColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.straighten_rounded, color: colors.ember, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isArabic ? 'طريقة أخذ القياسات بدقة:' : 'How to measure accurately:',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _stepRow(
            '1',
            isArabic
                ? 'الرقبة: تحت تفاحة آدم مباشرة، شريط القياس أفقي ومريح.'
                : 'Neck: Just below larynx (Adam’s apple), horizontal and snug.',
          ),
          const SizedBox(height: 6),
          _stepRow(
            '2',
            isFemale
                ? (isArabic
                    ? 'الخصر: عند أضيق نقطة (فوق السرة بـ 2-3 سم)، بعد زفير طبيعي.'
                    : 'Waist: Narrowest point (above navel), after normal exhale.')
                : (isArabic
                    ? 'الوسط: عند مستوى السرة مباشرة، بعد زفير طبيعي بدون شفط البطن.'
                    : 'Waist: Directly across navel, after normal exhale without sucking in.'),
          ),
          if (isFemale) ...[
            const SizedBox(height: 6),
            _stepRow(
              '3',
              isArabic
                  ? 'الأرداف: عند أوسع نقطة في الحوض/الأرداف أفقياً.'
                  : 'Hips: Widest point of hips/buttocks horizontally.',
            ),
          ],
        ],
      ),
    );
  }

  Widget _stepRow(String num, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 18,
          height: 18,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.ember.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Text(
            num,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: colors.ember,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 12, color: colors.textMute, height: 1.3),
          ),
        ),
      ],
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.label,
    required this.controller,
    required this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
    );
  }
}

class _ResultDisplayCard extends StatelessWidget {
  const _ResultDisplayCard({
    required this.result,
    required this.isArabic,
    required this.colors,
  });

  final NavyTapeResult result;
  final bool isArabic;
  final VireoColors colors;

  String _categoryLabel(BodyFatCategory c) {
    if (isArabic) {
      return switch (c) {
        BodyFatCategory.athletic => 'رياضي (Athletic)',
        BodyFatCategory.fit => 'لياقة جيدة (Fit)',
        BodyFatCategory.average => 'متوسط (Average)',
        BodyFatCategory.high => 'مرتفع (High)',
      };
    }
    return switch (c) {
      BodyFatCategory.athletic => 'Athletic',
      BodyFatCategory.fit => 'Fitness',
      BodyFatCategory.average => 'Average',
      BodyFatCategory.high => 'High',
    };
  }

  Color _categoryColor(BodyFatCategory c) {
    return switch (c) {
      BodyFatCategory.athletic => VBridge.cFF10B981,
      BodyFatCategory.fit => VBridge.cFF3B82F6,
      BodyFatCategory.average => VBridge.cFFF59E0B,
      BodyFatCategory.high => VBridge.cFFEF4444,
    };
  }

  @override
  Widget build(BuildContext context) {
    final catColor = _categoryColor(result.category);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.ember.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  isArabic ? 'نسبة الدهون المقدرة' : 'Estimated Body Fat',
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colors.line,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  result.accuracyLabel,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: colors.textMute,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                '${result.bodyFatPercent}%',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: colors.ember,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: catColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: catColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  _categoryLabel(result.category),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: catColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _MetricBox(
                  label: isArabic ? 'كتلة الدهون' : 'Fat Mass',
                  val: '${result.fatMassKg} كجم',
                  colors: colors,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricBox(
                  label: isArabic ? 'الكتلة العضلية/الصافية' : 'Lean Mass',
                  val: '${result.leanMassKg} كجم',
                  colors: colors,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _MetricBox(
                  label: isArabic ? 'مؤشر كتلة الجسم' : 'BMI',
                  val: '${result.bmi}',
                  colors: colors,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricBox(
                  label: isArabic ? 'الحرق الأساسي (Katch)' : 'BMR (Katch)',
                  val: '${result.bmrKcal.round()} سعرة',
                  colors: colors,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({
    required this.label,
    required this.val,
    required this.colors,
  });

  final String label;
  final String val;
  final VireoColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.line.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 10.5, color: colors.textMute, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 3),
          Text(
            val,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
