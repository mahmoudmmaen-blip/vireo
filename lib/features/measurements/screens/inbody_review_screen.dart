import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_snackbar.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/ai_coach/screens/ai_coach_screen.dart';
import 'package:vireo/features/home/widgets/inbody_plan_update_card.dart';
import 'package:vireo/features/measurements/domain/body_composition_insights.dart';
import 'package:vireo/features/measurements/domain/body_composition_report.dart';
import 'package:vireo/features/measurements/providers/body_composition_provider.dart';
import 'package:vireo/features/nutrition/providers/calorie_goal_provider.dart';
import 'package:vireo/core/theme/vireo_bridge.dart';

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

  // Basics
  late final TextEditingController _height;
  late final TextEditingController _age;
  late final TextEditingController _weight;
  String? _selectedSex;

  // Composition
  late final TextEditingController _smm;
  late final TextEditingController _fatMass;
  late final TextEditingController _pbf;
  late final TextEditingController _bmi;
  late final TextEditingController _visceral;
  late final TextEditingController _bmr;
  late final TextEditingController _whr;

  // Segmental Lean
  late final TextEditingController _leanRA;
  late final TextEditingController _leanLA;
  late final TextEditingController _leanTrunk;
  late final TextEditingController _leanRL;
  late final TextEditingController _leanLL;

  // Segmental Fat
  late final TextEditingController _fatRA;
  late final TextEditingController _fatLA;
  late final TextEditingController _fatTrunk;
  late final TextEditingController _fatRL;
  late final TextEditingController _fatLL;

  // Advanced
  late final TextEditingController _score;
  late final TextEditingController _fatControl;
  late final TextEditingController _muscleControl;
  late final TextEditingController _phaseAngle;
  late final TextEditingController _water;
  late final TextEditingController _protein;
  late final TextEditingController _minerals;

  @override
  void initState() {
    super.initState();
    _report = widget.report;

    _height = TextEditingController(text: _fmt(_report.heightCm));
    _age = TextEditingController(text: _report.age == null ? '' : _report.age.toString());
    _weight = TextEditingController(text: _fmt(_report.weightKg));
    _selectedSex = _report.sex;

    _smm = TextEditingController(text: _fmt(_report.skeletalMuscleMassKg));
    _fatMass = TextEditingController(text: _fmt(_report.bodyFatMassKg));
    _pbf = TextEditingController(text: _fmt(_report.percentBodyFat));
    _bmi = TextEditingController(text: _fmt(_report.bmi));
    _visceral = TextEditingController(text: _fmt(_report.visceralFatLevel));
    _bmr = TextEditingController(text: _fmt(_report.bmrKcal));
    _whr = TextEditingController(text: _fmt(_report.waistHipRatio));

    _leanRA = TextEditingController(text: _fmt(_report.segmentalLean.rightArm.kg?.value));
    _leanLA = TextEditingController(text: _fmt(_report.segmentalLean.leftArm.kg?.value));
    _leanTrunk = TextEditingController(text: _fmt(_report.segmentalLean.trunk.kg?.value));
    _leanRL = TextEditingController(text: _fmt(_report.segmentalLean.rightLeg.kg?.value));
    _leanLL = TextEditingController(text: _fmt(_report.segmentalLean.leftLeg.kg?.value));

    _fatRA = TextEditingController(text: _fmt(_report.segmentalFat.rightArm.kg?.value));
    _fatLA = TextEditingController(text: _fmt(_report.segmentalFat.leftArm.kg?.value));
    _fatTrunk = TextEditingController(text: _fmt(_report.segmentalFat.trunk.kg?.value));
    _fatRL = TextEditingController(text: _fmt(_report.segmentalFat.rightLeg.kg?.value));
    _fatLL = TextEditingController(text: _fmt(_report.segmentalFat.leftLeg.kg?.value));

    _score = TextEditingController(text: _fmt(_report.inbodyScore));
    _fatControl = TextEditingController(text: _fmt(_report.fatControlKg));
    _muscleControl = TextEditingController(text: _fmt(_report.muscleControlKg));
    _phaseAngle = TextEditingController(text: _fmt(_report.phaseAngle));
    _water = TextEditingController(text: _fmt(_report.totalBodyWaterL));
    _protein = TextEditingController(text: _fmt(_report.proteinKg));
    _minerals = TextEditingController(text: _fmt(_report.mineralsKg));
  }

  String _fmt(double? v) => v == null ? '' : v.toStringAsFixed(1);
  double? _parse(String s) => double.tryParse(s.trim().replaceAll(',', '.'));
  int? _parseInt(String s) => int.tryParse(s.trim());

  @override
  void dispose() {
    _height.dispose();
    _age.dispose();
    _weight.dispose();
    _smm.dispose();
    _fatMass.dispose();
    _pbf.dispose();
    _bmi.dispose();
    _visceral.dispose();
    _bmr.dispose();
    _whr.dispose();
    _leanRA.dispose();
    _leanLA.dispose();
    _leanTrunk.dispose();
    _leanRL.dispose();
    _leanLL.dispose();
    _fatRA.dispose();
    _fatLA.dispose();
    _fatTrunk.dispose();
    _fatRL.dispose();
    _fatLL.dispose();
    _score.dispose();
    _fatControl.dispose();
    _muscleControl.dispose();
    _phaseAngle.dispose();
    _water.dispose();
    _protein.dispose();
    _minerals.dispose();
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
    HapticFeedback.mediumImpact();

    final updatedLean = SegmentalMap(
      rightArm: SegmentalPart(kg: ConfidenceValue(value: _parse(_leanRA.text), confidence: 1)),
      leftArm: SegmentalPart(kg: ConfidenceValue(value: _parse(_leanLA.text), confidence: 1)),
      trunk: SegmentalPart(kg: ConfidenceValue(value: _parse(_leanTrunk.text), confidence: 1)),
      rightLeg: SegmentalPart(kg: ConfidenceValue(value: _parse(_leanRL.text), confidence: 1)),
      leftLeg: SegmentalPart(kg: ConfidenceValue(value: _parse(_leanLL.text), confidence: 1)),
    );

    final updatedFat = SegmentalMap(
      rightArm: SegmentalPart(kg: ConfidenceValue(value: _parse(_fatRA.text), confidence: 1)),
      leftArm: SegmentalPart(kg: ConfidenceValue(value: _parse(_fatLA.text), confidence: 1)),
      trunk: SegmentalPart(kg: ConfidenceValue(value: _parse(_fatTrunk.text), confidence: 1)),
      rightLeg: SegmentalPart(kg: ConfidenceValue(value: _parse(_fatRL.text), confidence: 1)),
      leftLeg: SegmentalPart(kg: ConfidenceValue(value: _parse(_fatLL.text), confidence: 1)),
    );

    final next = _report.copyWith(
      heightCm: _parse(_height.text) ?? _report.heightCm,
      age: _parseInt(_age.text) ?? _report.age,
      sex: _selectedSex ?? _report.sex,
      weightKg: _parse(_weight.text) ?? _report.weightKg,
      skeletalMuscleMassKg: _parse(_smm.text) ?? _report.skeletalMuscleMassKg,
      bodyFatMassKg: _parse(_fatMass.text) ?? _report.bodyFatMassKg,
      percentBodyFat: _parse(_pbf.text) ?? _report.percentBodyFat,
      bmi: _parse(_bmi.text) ?? _report.bmi,
      visceralFatLevel: _parse(_visceral.text) ?? _report.visceralFatLevel,
      bmrKcal: _parse(_bmr.text) ?? _report.bmrKcal,
      waistHipRatio: _parse(_whr.text) ?? _report.waistHipRatio,
      inbodyScore: _parse(_score.text) ?? _report.inbodyScore,
      fatControlKg: _parse(_fatControl.text) ?? _report.fatControlKg,
      muscleControlKg: _parse(_muscleControl.text) ?? _report.muscleControlKg,
      phaseAngle: _parse(_phaseAngle.text) ?? _report.phaseAngle,
      totalBodyWaterL: _parse(_water.text) ?? _report.totalBodyWaterL,
      proteinKg: _parse(_protein.text) ?? _report.proteinKg,
      mineralsKg: _parse(_minerals.text) ?? _report.mineralsKg,
      segmentalLean: updatedLean,
      segmentalFat: updatedFat,
    );

    await ref.read(bodyCompositionListProvider.notifier).save(next);
    ref.invalidate(calorieGoalProvider);
    ref.read(inbodyPlanUpdateVisibleProvider.notifier).state = true;

    if (!mounted) return;

    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');
    final insights = BodyCompositionInsights.generate(next, isArabic: isArabic);

    // Show celebratory bottom sheet with insights
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _InBodySavedInsightsSheet(report: next, insights: insights),
    );

    if (!mounted) return;
    VireoSnackBar.showText(context, isArabic ? 'تم حفظ تقرير InBody وتحديث الخطة بنجاح ✓' : 'InBody report saved and plan updated ✓');
    Navigator.of(context).pop(true);
  }

  void _showAddManualFieldSheet() {
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.vireoColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isArabic ? 'إضافة قيمة يدوياً' : 'Add Field Manually',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Text(
                isArabic
                    ? 'تقدر تكتب أو تعدل أي قيمة مباشرة في الحقول أعلاه، أو تختار القسم اللي حابب تضيف له.'
                    : 'You can directly edit any field in the sections above.',
                style: TextStyle(color: context.vireoColors.textMute, fontSize: 13),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(isArabic ? 'تمام' : 'Got it'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');
    final conf = _report.fieldConfidence;

    final brandLabel = _report.deviceBrand ?? (_report.deviceModel != null ? 'InBody' : 'InBody');

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(isArabic ? 'مراجعة وتأكيد التقرير' : 'Review Body Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            tooltip: isArabic ? 'ضيف قيمة يدوي' : 'Add manual field',
            onPressed: _showAddManualFieldSheet,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(VSpace.lg, VSpace.sm, VSpace.lg, 100),
        children: [
          // Source Brand Chip + Model header
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: colors.ember.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: colors.ember.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified_outlined, size: 14, color: VBridge.cFFF97316),
                        const SizedBox(width: 5),
                        Text(
                          brandLabel,
                          style: TextStyle(
                            color: colors.ember,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_report.deviceModel != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      _report.deviceModel!,
                      style: TextStyle(color: colors.textMute, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ],
              ),
              TextButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.edit_calendar_outlined, size: 16),
                label: Text(DateFormat.yMMMd().format(_report.testDate)),
                style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Group 1: Basics (البيانات الأساسية)
          _SectionCard(
            title: isArabic ? '1. البيانات الأساسية' : '1. Basics',
            icon: Icons.person_outline_rounded,
            children: [
              _Field(
                label: isArabic ? 'الوزن (كجم)' : 'Weight (kg)',
                controller: _weight,
                low: (conf['weight_kg'] ?? 1) < 0.65,
                unit: 'kg',
              ),
              Row(
                children: [
                  Expanded(
                    child: _Field(
                      label: isArabic ? 'الطول (سم)' : 'Height (cm)',
                      controller: _height,
                      low: (conf['height_cm'] ?? 1) < 0.65,
                      unit: 'cm',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _Field(
                      label: isArabic ? 'العمر' : 'Age',
                      controller: _age,
                      low: (conf['age'] ?? 1) < 0.65,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text(
                      isArabic ? 'الجنس: ' : 'Sex: ',
                      style: TextStyle(fontWeight: FontWeight.w700, color: colors.textMute, fontSize: 13),
                    ),
                    ChoiceChip(
                      label: Text(isArabic ? 'ذكر' : 'Male'),
                      selected: _selectedSex == 'male' || _selectedSex == 'ذكر',
                      onSelected: (val) => setState(() => _selectedSex = 'male'),
                    ),
                    ChoiceChip(
                      label: Text(isArabic ? 'أنثى' : 'Female'),
                      selected: _selectedSex == 'female' || _selectedSex == 'أنثى',
                      onSelected: (val) => setState(() => _selectedSex = 'female'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Group 2: Composition (تركيب الجسم)
          _SectionCard(
            title: isArabic ? '2. تركيب الجسم (Composition)' : '2. Body Composition',
            icon: Icons.fitness_center_rounded,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _Field(
                      label: isArabic ? 'كتلة العضلات (SMM)' : 'Muscle Mass (SMM)',
                      controller: _smm,
                      low: (conf['skeletal_muscle_mass_kg'] ?? 1) < 0.65,
                      unit: 'kg',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _Field(
                      label: isArabic ? 'كتلة الدهون' : 'Fat Mass',
                      controller: _fatMass,
                      low: (conf['body_fat_mass_kg'] ?? 1) < 0.65,
                      unit: 'kg',
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _Field(
                      label: isArabic ? 'نسبة الدهون (PBF %)' : 'Body Fat %',
                      controller: _pbf,
                      low: (conf['percent_body_fat'] ?? 1) < 0.65,
                      unit: '%',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _Field(
                      label: isArabic ? 'مؤشر الكتلة (BMI)' : 'BMI',
                      controller: _bmi,
                      low: (conf['bmi'] ?? 1) < 0.65,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _Field(
                      label: isArabic ? 'الأيض الأساسي (BMR)' : 'BMR (kcal)',
                      controller: _bmr,
                      low: (conf['bmr_kcal'] ?? 1) < 0.65,
                      unit: 'kcal',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _Field(
                      label: isArabic ? 'الدهون الحشوية' : 'Visceral Fat',
                      controller: _visceral,
                      low: (conf['visceral_fat_level'] ?? 1) < 0.65,
                    ),
                  ),
                ],
              ),
              _Field(
                label: isArabic ? 'معدل الخصر/الورك (WHR)' : 'Waist-Hip Ratio (WHR)',
                controller: _whr,
                low: (conf['waist_hip_ratio'] ?? 1) < 0.65,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Group 3: Segmental (التحليل المقطعي)
          _SectionCard(
            title: isArabic ? '3. التحليل المقطعي (عضل ودهون)' : '3. Segmental Analysis',
            icon: Icons.accessibility_new_rounded,
            children: [
              Text(
                isArabic ? 'كتلة العضلات بالأطراف والجذع (كجم):' : 'Segmental Lean Mass (kg):',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _Field(label: isArabic ? 'ذراع يمين' : 'RA Lean', controller: _leanRA, low: false)),
                  const SizedBox(width: 6),
                  Expanded(child: _Field(label: isArabic ? 'ذراع شمال' : 'LA Lean', controller: _leanLA, low: false)),
                  const SizedBox(width: 6),
                  Expanded(child: _Field(label: isArabic ? 'الجذع' : 'Trunk', controller: _leanTrunk, low: false)),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _Field(label: isArabic ? 'ساق يمين' : 'RL Lean', controller: _leanRL, low: false)),
                  const SizedBox(width: 10),
                  Expanded(child: _Field(label: isArabic ? 'ساق شمال' : 'LL Lean', controller: _leanLL, low: false)),
                ],
              ),
              const SizedBox(height: 6),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Text(
                isArabic ? 'كتلة الدهون بالأطراف والجذع (كجم):' : 'Segmental Fat Mass (kg):',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _Field(label: isArabic ? 'دهون ذراع ي' : 'RA Fat', controller: _fatRA, low: false)),
                  const SizedBox(width: 6),
                  Expanded(child: _Field(label: isArabic ? 'دهون ذراع ش' : 'LA Fat', controller: _fatLA, low: false)),
                  const SizedBox(width: 6),
                  Expanded(child: _Field(label: isArabic ? 'دهون الجذع' : 'Trunk Fat', controller: _fatTrunk, low: false)),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _Field(label: isArabic ? 'دهون ساق ي' : 'RL Fat', controller: _fatRL, low: false)),
                  const SizedBox(width: 10),
                  Expanded(child: _Field(label: isArabic ? 'دهون ساق ش' : 'LL Fat', controller: _fatLL, low: false)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Group 4: Advanced (القياسات المتقدمة)
          _SectionCard(
            title: isArabic ? '4. قياسات متقدمة والتحكم' : '4. Advanced & Control',
            icon: Icons.speed_rounded,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _Field(
                      label: isArabic ? 'درجة InBody' : 'InBody Score',
                      controller: _score,
                      low: (conf['inbody_score'] ?? 1) < 0.65,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _Field(
                      label: isArabic ? 'زاوية الطور (°)' : 'Phase Angle (°)',
                      controller: _phaseAngle,
                      low: (conf['phase_angle'] ?? 1) < 0.65,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _Field(
                      label: isArabic ? 'التحكم بالدهون' : 'Fat Control (kg)',
                      controller: _fatControl,
                      low: (conf['fat_control_kg'] ?? 1) < 0.65,
                      unit: 'kg',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _Field(
                      label: isArabic ? 'التحكم بالعضلات' : 'Muscle Control',
                      controller: _muscleControl,
                      low: (conf['muscle_control_kg'] ?? 1) < 0.65,
                      unit: 'kg',
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _Field(
                      label: isArabic ? 'ماء الجسم (لتر)' : 'Body Water (L)',
                      controller: _water,
                      low: (conf['total_body_water_l'] ?? 1) < 0.65,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _Field(
                      label: isArabic ? 'بروتين (كجم)' : 'Protein',
                      controller: _protein,
                      low: (conf['protein_kg'] ?? 1) < 0.65,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _Field(
                      label: isArabic ? 'معادن (كجم)' : 'Minerals',
                      controller: _minerals,
                      low: (conf['minerals_kg'] ?? 1) < 0.65,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Primary Save Button
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.check_circle_outline_rounded),
            label: Text(
              isArabic ? 'تأكيد وحفظ التقرير' : l10n.inbodySave,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: colors.ember,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: colors.ember),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
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
    this.unit,
  });

  final String label;
  final TextEditingController controller;
  final bool low;
  final String? unit;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                fontSize: 12,
                color: low ? colors.ember : null,
                fontWeight: low ? FontWeight.bold : null,
              ),
              suffixText: unit,
              filled: low,
              fillColor: low ? colors.ember.withValues(alpha: 0.12) : null,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              enabledBorder: low
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: colors.ember, width: 1.5),
                    )
                  : null,
              suffixIcon: low
                  ? Tooltip(
                      message: isArabic ? 'اتأكد من الرقم ده' : 'Verify this value',
                      child: Icon(Icons.warning_amber_rounded, color: colors.ember, size: 20),
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
          if (low) ...[
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                isArabic ? '⚠️ اتأكد من الرقم ده' : '⚠️ Verify this value',
                style: TextStyle(color: colors.ember, fontSize: 10.5, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InBodySavedInsightsSheet extends StatelessWidget {
  const _InBodySavedInsightsSheet({
    required this.report,
    required this.insights,
  });

  final BodyCompositionReport report;
  final List<BodyReportInsight> insights;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.line,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('🎉', style: TextStyle(fontSize: 26)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isArabic ? 'تقريرك جاهز وخِطتك اتظبطت!' : 'Report Ready & Plan Tuned!',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                        ),
                        Text(
                          isArabic ? 'أهم الملاحظات من قراءة جسمك اليوم' : 'Key insights from your body scan',
                          style: TextStyle(color: colors.textMute, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              for (final insight in insights) ...[
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: insight.isAlert
                        ? colors.ember.withValues(alpha: 0.1)
                        : colors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: insight.isAlert
                          ? colors.ember.withValues(alpha: 0.4)
                          : colors.line,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(insight.emoji, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              insight.title,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              insight.description,
                              style: TextStyle(
                                color: colors.text,
                                fontSize: 12,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AiCoachScreen(
                        initialPrompt: 'فسّرلي أرقام تقرير الـ InBody ده وإزاي أستفيد منها في خطتي؟',
                        autoSendInitialPrompt: true,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.auto_awesome_rounded, size: 16),
                label: Text(
                  isArabic ? 'اسأل كوتش Vireo عن التقرير' : 'Ask Vireo Coach about report',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(44),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(
                  backgroundColor: colors.ember,
                  minimumSize: const Size.fromHeight(44),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  isArabic ? 'تم، العودة للرئيسية' : 'Done, Back to Home',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
