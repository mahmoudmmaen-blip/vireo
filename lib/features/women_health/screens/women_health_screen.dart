import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/women_health/models/cycle_data.dart';
import 'package:vireo/features/women_health/providers/women_health_provider.dart';
import 'package:vireo/core/theme/vireo_bridge.dart';

class WomenHealthScreen extends ConsumerStatefulWidget {
  const WomenHealthScreen({super.key});

  @override
  ConsumerState<WomenHealthScreen> createState() => _WomenHealthScreenState();
}

class _WomenHealthScreenState extends ConsumerState<WomenHealthScreen> {
  DateTime _selectedDate = DateTime.now();
  int _cycleLength = 28;
  int _periodLength = 5;
  final Set<String> _selectedSymptoms = {};

  final _availableSymptoms = const [
    ('تقلصات', 'Cramps', Icons.waves_rounded),
    ('انتفاخ', 'Bloating', Icons.water_rounded),
    ('رغبة في الأكل', 'Cravings', Icons.restaurant_rounded),
    ('إرهاق', 'Fatigue', Icons.battery_charging_full_rounded),
    ('تقلبات مزاجية', 'Mood Swings', Icons.sentiment_neutral_rounded),
    ('صداع', 'Headache', Icons.psychology_rounded),
  ];

  @override
  void initState() {
    super.initState();
    final latest = ref.read(latestCycleEntryProvider);
    if (latest != null) {
      _selectedDate = latest.startDate;
      _cycleLength = latest.cycleLength;
      _periodLength = latest.periodLength;
      _selectedSymptoms.addAll(latest.symptoms);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 120)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveCycle() async {
    HapticFeedback.selectionClick();
    final entry = CycleLogEntry(
      startDate: _selectedDate,
      cycleLength: _cycleLength,
      periodLength: _periodLength,
      symptoms: _selectedSymptoms.toList(),
    );
    await ref.read(cycleEntriesProvider.notifier).logEntry(entry);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حفظ بيانات الدورة بنجاح ✨'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _confirmClearData() async {
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isArabic ? 'مسح بيانات الدورة' : 'Clear Cycle Data'),
        content: Text(
          isArabic
              ? 'هل أنتِ متأكدة من مسح جميع بيانات الدورة الشهرية والأعراض نهائياً من هذا الجهاز؟'
              : 'Are you sure you want to delete all menstrual cycle and symptom data permanently from this device?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(isArabic ? 'نعم، امسحي البيانات' : 'Delete Data'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(cycleEntriesProvider.notifier).clearAll();
      setState(() {
        _selectedSymptoms.clear();
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isArabic ? 'تم مسح بيانات الدورة بنجاح.' : 'Cycle data cleared.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');
    final mode = ref.watch(womenHealthModeProvider);
    final trimester = ref.watch(pregnancyTrimesterProvider);
    final currentPhase = ref.watch(currentCyclePhaseProvider);
    final daysUntilNext = ref.watch(daysUntilNextPeriodProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(isArabic ? 'صحتك والدورة الشهرية' : 'Women\'s Health & Cycle'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // ── MODE SELECTION ──
          Text(
            isArabic ? 'الوضع الحالي:' : 'Current Status:',
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
          ),
          const SizedBox(height: 8),
          SegmentedButton<WomenMode>(
            segments: [
              ButtonSegment(
                value: WomenMode.standard,
                label: Text(isArabic ? 'متابعة الدورة' : 'Cycle'),
                icon: const Icon(Icons.calendar_month_rounded, size: 16),
              ),
              ButtonSegment(
                value: WomenMode.pregnant,
                label: Text(isArabic ? 'حامل' : 'Pregnancy'),
                icon: const Icon(Icons.child_care_rounded, size: 16),
              ),
              ButtonSegment(
                value: WomenMode.breastfeeding,
                label: Text(isArabic ? 'مرضعة' : 'Nursing'),
                icon: const Icon(Icons.favorite_rounded, size: 16),
              ),
            ],
            selected: {mode},
            onSelectionChanged: (set) {
              if (set.isNotEmpty) {
                ref.read(womenHealthModeProvider.notifier).setMode(set.first);
              }
            },
          ),
          const SizedBox(height: 16),

          // ── PREGNANCY / BREASTFEEDING CONTENT ──
          if (mode == WomenMode.pregnant) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.gold.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.gold.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.child_care_rounded, color: colors.gold, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        isArabic ? 'وضع الحمل: إرشادات الثلث الحالي' : 'Pregnancy Mode',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isArabic
                        ? 'تم إيقاف عجز السعرات الحرارية وتوقعات خسارة الوزن لحماية صحتك وصحة الجنين. يرجى اختيار الثلث الحالي لضبط السعرات المناسبة:'
                        : 'Calorie deficits and weight loss projections are disabled. Choose your current trimester for proper calorie guidance:',
                    style: TextStyle(fontSize: 13, color: colors.text, height: 1.4),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: PregnancyTrimester.values.map((t) {
                      final isSelected = trimester == t;
                      return ChoiceChip(
                        label: Text(t.displayNameAr),
                        selected: isSelected,
                        onSelected: (val) {
                          if (val) {
                            ref.read(pregnancyTrimesterProvider.notifier).setTrimester(t);
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.medical_services_outlined, size: 18, color: Colors.amber),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            isArabic
                                ? 'استشيري طبيبتك دائماً لمتابعة نمو الجنين والفيتامينات والنشاط البدني الآمن.'
                                : 'Always consult your obstetrician for safe activity and nutrient supplements.',
                            style: TextStyle(fontSize: 11.5, color: colors.textMute, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ] else if (mode == WomenMode.breastfeeding) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.ember.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.ember.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.favorite_rounded, color: colors.ember, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        isArabic ? 'وضع الرضاعة الطبيعية' : 'Breastfeeding Mode',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isArabic
                        ? 'تم إيقاف عجز السعرات وإضافة +350 سعرة حرارية يومياً لتغذية إنتاج الحليب والحفاظ على طاقتك. ركزي على ترطيب جسمك الكافي بالماء والبروتين.'
                        : 'Calorie deficit disabled with +350 kcal added for milk production. Stay well hydrated with plenty of water and protein.',
                    style: TextStyle(fontSize: 13, color: colors.text, height: 1.4),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isArabic ? '⚠️ استشيري طبيبتك بخصوص المكملات الغذائية.' : '⚠️ Consult your physician regarding dietary supplements.',
                    style: TextStyle(fontSize: 12, color: colors.textMute, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ] else ...[
            // ── CYCLE LOGGING CARD ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surfaceRaised,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic ? 'تسجيل بداية آخر دورة شهرية:' : 'Last Period Start Date:',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickDate,
                          icon: const Icon(Icons.event_rounded),
                          label: Text(DateFormat('yyyy/MM/dd').format(_selectedDate)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      FilledButton(
                        onPressed: _saveCycle,
                        child: Text(isArabic ? 'حفظ' : 'Save'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isArabic
                        ? 'طول الدورة المتوقع: $_cycleLength يوم'
                        : 'Cycle Length: $_cycleLength days',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                  Slider(
                    value: _cycleLength.toDouble(),
                    min: 21,
                    max: 42,
                    divisions: 21,
                    label: '$_cycleLength',
                    onChanged: (v) => setState(() => _cycleLength = v.round()),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isArabic ? 'الأعراض الملاحظة:' : 'Observed Symptoms:',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableSymptoms.map((s) {
                      final label = isArabic ? s.$1 : s.$2;
                      final isSelected = _selectedSymptoms.contains(s.$1);
                      return FilterChip(
                        avatar: Icon(s.$3, size: 14),
                        label: Text(label),
                        selected: isSelected,
                        onSelected: (val) {
                          setState(() {
                            if (val) {
                              _selectedSymptoms.add(s.$1);
                            } else {
                              _selectedSymptoms.remove(s.$1);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── PHASE & WATER RETENTION REASSURANCE ──
            if (currentPhase != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: VBridge.cFFF43F5E.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: VBridge.cFFF43F5E.withValues(alpha: 0.25)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.insights_rounded, color: VBridge.cFFF43F5E),
                        const SizedBox(width: 8),
                        Text(
                          currentPhase.displayNameAr,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: VBridge.cFFF43F5E,
                          ),
                        ),
                        const Spacer(),
                        if (daysUntilNext != null)
                          Text(
                            isArabic ? 'باقي $daysUntilNext يوم' : '$daysUntilNext d left',
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.textMute,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isArabic
                          ? '💧 احتباس سوائل طبيعي: إذا لاحظتِ زيادة في وزن الميزان خلال المرحلة الصفرية أو أثناء الدورة، فهذا تغير هرموني مؤقت ناتج عن حبس السوائل وليس دهوناً.'
                          : '💧 Natural Water Retention: Weight fluctuations during luteal and menstrual phases are fluid retention, not fat gain.',
                      style: TextStyle(fontSize: 12.5, color: colors.text, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // ── NUTRIENTS TO WATCH ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surfaceRaised,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic ? 'عناصر غذائية هامة لصحتك:' : 'Essential Nutrients:',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  _NutrientRow(
                    title: isArabic ? 'الحديد (Iron)' : 'Iron',
                    desc: isArabic
                        ? 'يعوض الفاقد ويدعم الطاقة: كبدة، سبانخ، لحم بقري خالي دهن، عدس.'
                        : 'Compensates loss: spinach, lean beef, lentils.',
                    icon: Icons.grass_rounded,
                  ),
                  const Divider(height: 16),
                  _NutrientRow(
                    title: isArabic ? 'الكالسيوم (Calcium)' : 'Calcium',
                    desc: isArabic
                        ? 'لصحة العظام وتخفيف التقلصات: لبن، زبادي يوناني، بذور السمسم، لوز.'
                        : 'For bones & cramp relief: dairy, sesame seeds, almonds.',
                    icon: Icons.local_drink_rounded,
                  ),
                  const Divider(height: 16),
                  _NutrientRow(
                    title: isArabic ? 'حمض الفوليك (Folate)' : 'Folate',
                    desc: isArabic
                        ? 'تجدد الخلايا وتوازن الهرمونات: هليون، أفوكادو، خضار ورقي، حمص.'
                        : 'Cell renewal: asparagus, avocado, leafy greens.',
                    icon: Icons.energy_savings_leaf_rounded,
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),

          // ── PRIVACY NOTE & CLEAR DATA BUTTON ──
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.surfaceRaised.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.line.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.lock_outline_rounded, size: 18, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isArabic
                        ? 'خصوصية تامة: بيانات الدورة والأعراض تُحفظ مشفرة محلياً على جهازك فقط، ولا يتم رفعها أو استخدامها لأي إعلانات.'
                        : 'Complete Privacy: Cycle and symptom data is saved locally on your device only.',
                    style: TextStyle(fontSize: 11.5, color: colors.textMute, height: 1.35),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.redAccent,
              side: const BorderSide(color: Colors.redAccent),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: _confirmClearData,
            icon: const Icon(Icons.delete_outline_rounded, size: 18),
            label: Text(
              isArabic ? 'امسحي بيانات الدورة' : 'Clear Cycle Data',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _NutrientRow extends StatelessWidget {
  const _NutrientRow({
    required this.title,
    required this.desc,
    required this.icon,
  });

  final String title;
  final String desc;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: colors.ember.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: colors.ember, size: 16),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: TextStyle(fontSize: 12, color: colors.textMute, height: 1.35),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
