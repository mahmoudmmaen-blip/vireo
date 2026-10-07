import 'package:vireo/features/vitality/domain/vitality_models.dart';

/// Google Play–safe educational articles on men's vitality and hormonal health.
abstract final class VitalityArticlesData {
  static const _pmid19585417 = 'https://pubmed.ncbi.nlm.nih.gov/19585417/';
  static const _pmid21154195 = 'https://pubmed.ncbi.nlm.nih.gov/21154195/';
  static const _nihZinc =
      'https://ods.od.nih.gov/factsheets/Zinc-HealthProfessional/';
  static const _nihVitD =
      'https://ods.od.nih.gov/factsheets/VitaminD-HealthProfessional/';
  static const _acsm =
      'https://www.acsm.org/education-resources/trending-topics-resources/physical-activity-guidelines';
  static const _cdcSleep = 'https://www.cdc.gov/sleep/about/index.html';

  static List<VitalityArticle> all() => [
        ..._nutrition,
        ..._training,
        ..._lifestyle,
        ..._environmental,
        ..._advanced,
      ];

  static final _nutrition = [
    _article(
      id: 'zinc_vitamin_d_protocol',
      category: VitalityCategory.nutrition,
      readingTime: 6,
      titleEn:
          'The Zinc–Vitamin D Protocol: Essential building blocks for natural hormonal balance',
      titleAr:
          'بروتوكول الزنك وفيتامين D: لبنات أساسية للتوازن الهرموني الطبيعي',
      summaryEn:
          'Research suggests zinc and vitamin D may support healthy testosterone within normal clinical ranges when intake is adequate.',
      summaryAr:
          'تشير الأبحاث إلى أن الزنك وفيتامين D قد يدعمان التستوستيرون الصحي ضمن النطاقات الطبيعية عند كفاية التناول.',
      protocolItems: const [
        VitalityProtocolItem(
          id: 'zinc_30mg',
          textEn: 'Include ~30 mg zinc daily from food or supplements (with medical guidance)',
          textAr: 'تناول نحو 30 مجم زنك يومياً من الغذاء أو المكملات (بإشراف طبي)',
        ),
        VitalityProtocolItem(
          id: 'vitd_2000',
          textEn: 'Aim for 2000–4000 IU vitamin D3 if labs indicate insufficiency',
          textAr: 'استهدف 2000–4000 وحدة فيتامين D3 إذا أظهرت التحاليل نقصاً',
        ),
        VitalityProtocolItem(
          id: 'sun_20min',
          textEn: 'Get 20 minutes of safe sun exposure when possible',
          textAr: 'تعرّض لأشعة الشمس الآمنة 20 دقيقة يومياً عند الإمكان',
        ),
        VitalityProtocolItem(
          id: 'squat_3x',
          textEn: 'Perform compound squats 3× per week',
          textAr: 'مارس السكوات المركب 3 مرات أسبوعياً',
        ),
      ],
      blocks: [
        _block(
          headingEn: 'Why these nutrients matter',
          headingAr: 'لماذا هذه المغذيات مهمة',
          bulletsEn: [
            'Zinc supports enzymes involved in hormone synthesis.',
            'Vitamin D receptors exist in tissues linked to hormonal balance.',
            'Food sources: oysters, beef, pumpkin seeds, eggs.',
          ],
          bulletsAr: [
            'يدعم الزنك إنزيمات تصنيع الهرمونات.',
            'مستقبلات فيتامين D موجودة في أنسجة التوازن الهرموني.',
            'مصادر غذائية: المحار، اللحم، بذور اليقطين، البيض.',
          ],
          keyTakeawayEn:
              'Food-first nutrition and safe sun may help optimize vitality with medical monitoring.',
          keyTakeawayAr:
              'الغذاء أولاً والشمس الآمنة قد يدعمان الحيوية مع المتابعة الطبية.',
        ),
        _block(
          headingEn: 'Daily protocol (food-first)',
          headingAr: 'البروتوكول اليومي (الغذاء أولاً)',
          protocolStepsEn: [
            'Breakfast: 2–3 eggs + pumpkin seeds or beef portion.',
            'Midday: 20 minutes safe sun or D3 with meals containing fat.',
            'Evening: log zinc-rich foods; avoid mega-doses without labs.',
          ],
          protocolStepsAr: [
            'الفطور: 2–3 بيضات + بذور يقطين أو حصة لحم.',
            'منتصف النهار: 20 دقيقة شمس آمنة أو D3 مع وجبة تحتوي دهوناً.',
            'المساء: سجّل أطعمة غنية بالزنك؛ تجنب الجرعات العالية دون تحاليل.',
          ],
        ),
      ],
      sources: [
        _src('Prasad AS — Zinc and testosterone (PMID 19585417)',
            'Prasad AS — الزنك (PMID 19585417)', _pmid19585417),
        _src('Nimptsch K — Vitamin D and testosterone (PMID 21154195)',
            'Nimptsch K — فيتامين D (PMID 21154195)', _pmid21154195),
        _src('NIH ODS — Zinc', 'NIH — الزنك', _nihZinc),
        _src('NIH ODS — Vitamin D', 'NIH — فيتامين D', _nihVitD),
      ],
    ),
    _article(
      id: 'cholesterol_hormone_fuel',
      category: VitalityCategory.nutrition,
      readingTime: 5,
      titleEn: 'Cholesterol as Hormone Fuel: Why eggs and healthy fats are foundational',
      titleAr: 'الكوليسترول وقود الهرمونات: لماذا البيض والدهون الصحية أساسية',
      summaryEn:
          'Cholesterol is a precursor for steroid hormones — balanced intake may support vitality.',
      summaryAr:
          'الكوليسترول مادة أساسية للهرمونات الستيرويدية — التناول المتوازن قد يدعم الحيوية.',
      blocks: [
        _block(
          bulletsEn: [
            '3–4 eggs daily provide fats, choline, and protein.',
            'Olive oil, avocados, and grass-fed butter support cell membranes.',
            'Avoid extreme low-fat diets without medical supervision.',
          ],
          bulletsAr: [
            '3–4 بيضات يومياً توفر دهوناً وكولين وبروتيناً.',
            'زيت الزيتون والأفوكادو وزبدة العشب تدعم أغشية الخلايا.',
            'تجنب الحميات شديدة انخفاض الدهون دون إشراف.',
          ],
          keyTakeawayEn:
              'Healthy fats may help optimize hormonal health as part of a balanced diet.',
          keyTakeawayAr:
              'الدهون الصحية قد تساعد على تحسين الصحة الهرمونية ضمن نظام متوازن.',
        ),
      ],
      sources: [
        _src('NIH — Dietary fats overview', 'NIH — الدهون الغذائية',
            'https://www.ncbi.nlm.nih.gov/books/NBK56068/'),
      ],
    ),
    _article(
      id: 'anti_estrogen_diet',
      category: VitalityCategory.nutrition,
      readingTime: 5,
      titleEn: 'The Anti-Estrogen Diet: Cruciferous vegetables and lignans',
      titleAr: 'النظام الداعم للتوازن: الخضار الصليبية وال lignans',
      summaryEn:
          'Plant compounds may support healthy estrogen metabolism in men.',
      summaryAr:
          'مركبات نباتية قد تدعم أيض الإستروجين الصحي لدى الرجال.',
      blocks: [
        _block(
          headingEn: 'Cruciferous vegetables (DIM pathway)',
          headingAr: 'الخضار الصليبية (مسار DIM)',
          bulletsEn: [
            'Broccoli, cauliflower, Brussels sprouts (DIM-related compounds).',
            'Ground flaxseeds and green tea polyphenols.',
            '2–3 cups cruciferous vegetables daily.',
          ],
          bulletsAr: [
            'بروكلي وقرنبيط وكرنب بروكسل (مركبات مرتبطة بـ DIM).',
            'بذور الكتان المطحونة ومركبات polyphénols في الشاي الأخضر.',
            '2–3 أكواب خضار صليبي يومياً.',
          ],
          keyTakeawayEn:
              'A plant-forward plate may help optimize hormonal balance alongside training.',
          keyTakeawayAr:
              'طبق غني بالنباتات قد يساعد على تحسين التوازن الهرموني مع التمرين.',
        ),
      ],
      sources: [
        _src('NIH NCI — Cruciferous vegetables', 'NIH — الخضار الصليبية',
            'https://www.cancer.gov/about-cancer/causes-prevention/risk/diet/cruciferous-vegetables-fact-sheet'),
        _src('Zeligs MA — DIM research overview', 'Zeligs MA — DIM',
            'https://pubmed.ncbi.nlm.nih.gov/12913341/'),
      ],
    ),
    _article(
      id: 'magnesium_recovery',
      category: VitalityCategory.nutrition,
      readingTime: 4,
      titleEn: 'Magnesium & Deep Recovery: The mineral active men often lack',
      titleAr: 'المغنيسيوم والتعافي العميق: معدن ينقص الرجال النشطين',
      summaryEn: 'Magnesium may support sleep, recovery, and stress balance.',
      summaryAr: 'قد يدعم المغنيسيوم النوم والتعافي وتوازن الإجهاد.',
      protocolItems: const [
        VitalityProtocolItem(
          id: 'mag_400mg',
          textEn: 'Take 400–500 mg magnesium glycinate (with medical guidance)',
          textAr: 'تناول 400–500 مجم مغنيسيوم glycinate (بإشراف طبي)',
        ),
        VitalityProtocolItem(
          id: 'mag_foods',
          textEn: 'Include dark leafy greens and nuts daily',
          textAr: 'تناول خضاراً ورقية ومكسرات يومياً',
        ),
        VitalityProtocolItem(
          id: 'epsom_bath',
          textEn: 'Epsom salt bath 2× weekly for recovery',
          textAr: 'حمام ملح Epsom مرتين أسبوعياً للتعافي',
        ),
      ],
      blocks: [
        _block(
          headingEn: 'Why magnesium matters',
          headingAr: 'لماذا المغنيسيوم مهم',
          bulletsEn: [
            '400–500 mg magnesium glycinate (consult provider).',
            'Dark leafy greens, nuts, Epsom salt baths.',
          ],
          bulletsAr: [
            '400–500 مجم مغنيسيوم glycinate (استشر الطبيب).',
            'خضار ورقية داكنة، مكسرات، حمامات ملح Epsom.',
          ],
          keyTakeawayEn:
              'Magnesium may support deep sleep and recovery when intake is adequate.',
          keyTakeawayAr:
              'قد يدعم المغنيسيوم النوم العميق والتعافي عند كفاية التناول.',
        ),
      ],
      sources: [
        _src('NIH ODS — Magnesium', 'NIH — المغنيسيوم',
            'https://ods.od.nih.gov/factsheets/Magnesium-HealthProfessional/'),
        _src('Abbasi B — Magnesium and insomnia (PMID 23853635)',
            'Abbasi B — المغنيسيوم والأرق (PMID 23853635)',
            'https://pubmed.ncbi.nlm.nih.gov/23853635/'),
      ],
    ),
    _article(
      id: 'adaptogens_stress',
      category: VitalityCategory.nutrition,
      readingTime: 5,
      titleEn:
          'Ashwagandha & Tongkat Ali: Adaptogens for stress resilience and recovery',
      titleAr: 'نباتات تكيفية للإجهاد: Ashwagandha وTongkat Ali',
      summaryEn:
          'Adaptogens may support cortisol management — stress and recovery support only.',
      summaryAr:
          'النباتات التكيفية قد تدعم إدارة الكورتيزول — دعم الإجهاد والتعافي فقط.',
      protocolItems: const [
        VitalityProtocolItem(
          id: 'ashwagandha_am',
          textEn: 'KSM-66 Ashwagandha 300 mg with breakfast (if approved by provider)',
          textAr: 'KSM-66 Ashwagandha 300 مجم مع الفطور (بموافقة الطبيب)',
        ),
        VitalityProtocolItem(
          id: 'breathing_pm',
          textEn: '5 minutes box breathing before bed',
          textAr: '5 دقائق تنفس صندوقي قبل النوم',
        ),
      ],
      blocks: [
        _block(
          headingEn: 'Evidence-based dosing (consult provider)',
          headingAr: 'جرعات مبنية على الأدلة (استشر الطبيب)',
          bulletsEn: [
            'KSM-66 Ashwagandha 300–600 mg studied for stress markers.',
            'Tongkat Ali 200–400 mg studied for vitality support.',
            'Use only with quality products and medical guidance.',
          ],
          bulletsAr: [
            'KSM-66 Ashwagandha 300–600 مجم لعلامات الإجهاد.',
            'Tongkat Ali 200–400 مجم لدعم الحيوية.',
            'استخدم منتجات موثوقة وإشرافاً طبياً.',
          ],
          keyTakeawayEn:
              'Adaptogens may support stress resilience — not a substitute for sleep and training.',
          keyTakeawayAr:
              'النباتات التكيفية قد تدعم مرونة الإجهاد — لا تغني عن النوم والتمرين.',
        ),
      ],
      sources: [
        _src('Chandrasekhar K — Ashwagandha (PMID 23439798)',
            'Chandrasekhar K — Ashwagandha (PMID 23439798)',
            'https://pubmed.ncbi.nlm.nih.gov/23439798/'),
        _src('Talbott SM — Tongkat Ali stress study (PMID 23754792)',
            'Talbott SM — Tongkat Ali (PMID 23754792)',
            'https://pubmed.ncbi.nlm.nih.gov/23754792/'),
        _src('NIH ODS — Botanical supplements', 'NIH — المكملات النباتية',
            'https://ods.od.nih.gov/factsheets/list-all/'),
      ],
    ),
  ];

  static final _training = [
    _article(
      id: 'big_5_compound_lifts',
      category: VitalityCategory.training,
      readingTime: 7,
      titleEn: 'The Big 5 Compound Lifts: Squats, deadlifts, presses, rows, pull-ups',
      titleAr: 'الرفعات المركبة الخمس: سكوات، ديدليفت، ضغط، تجديف، عقلة',
      summaryEn:
          'Compound lifts may support anabolic hormone responses and physical performance.',
      summaryAr:
          'الرفعات المركبة قد تدعم الاستجابات الهرمونية البنائية والأداء البدني.',
      protocolItems: const [
        VitalityProtocolItem(
          id: 'squat_3x',
          textEn: '3 squat sessions per week',
          textAr: '3 جلسات سكوات أسبوعياً',
        ),
        VitalityProtocolItem(
          id: 'deadlift_2x',
          textEn: '2 deadlift/hinge sessions per week',
          textAr: 'جلستان ديدليفت أسبوعياً',
        ),
      ],
      blocks: [
        _block(
          bulletsEn: [
            'Large muscle mass recruitment may support testosterone and GH pulses.',
            'Train 3–4× weekly with progressive overload.',
          ],
          bulletsAr: [
            'استهداف كتلة عضلية كبيرة قد يدعم نبضات التستوستيرون وGH.',
            'تدرّب 3–4 مرات أسبوعياً بتحميل تدريجي.',
          ],
        ),
      ],
      sources: [_src('ACSM — Resistance training', 'ACSM — المقاومة', _acsm)],
    ),
    _article(
      id: 'progressive_overload',
      category: VitalityCategory.training,
      readingTime: 4,
      titleEn: 'Progressive Overload: Intensity beats volume for hormonal adaptation',
      titleAr: 'التحميل التدريجي: الشدة تتفوق على الحجم',
      summaryEn: 'Increasing load may support anabolic signaling better than excess volume.',
      summaryAr: 'زيادة الحمل قد تدعم الإشارات البنائية أفضل من الحجم الزائد.',
      blocks: [
        _block(
          bulletsEn: [
            'Add 2.5–5 kg when top reps are achieved with good form.',
            'Deload every 4–6 weeks.',
          ],
          bulletsAr: [
            'أضف 2.5–5 كجم عند تحقيق أعلى تكرارات بشكل صحيح.',
            'خفّف كل 4–6 أسابيع.',
          ],
        ),
      ],
      sources: [_src('ACSM guidelines', 'ACSM', _acsm)],
    ),
    _article(
      id: 'sprint_training_gh',
      category: VitalityCategory.training,
      readingTime: 4,
      titleEn: 'Sprint Training: HIIT for natural growth hormone release',
      titleAr: 'تدريب السرعة: HIIT لتحفيز هرمون النمو',
      summaryEn: 'Short sprints may support GH pulses and metabolic vitality.',
      summaryAr: 'ال sprint القصير قد يدعم نبضات GH والحيوية الأيضية.',
      blocks: [
        _block(
          bulletsEn: ['6×30 s sprints, 90 s rest, 2× weekly.'],
          bulletsAr: ['6×30 ثانية sprint، 90 ثانية راحة، مرتين أسبوعياً.'],
        ),
      ],
      sources: [
        _src('Godfrey RJ — Exercise and GH', 'Godfrey RJ — GH',
            'https://pubmed.ncbi.nlm.nih.gov/16506862/'),
      ],
    ),
    _article(
      id: 'training_frequency',
      category: VitalityCategory.training,
      readingTime: 4,
      titleEn: 'Training Frequency: The 3–4× sweet spot',
      titleAr: 'تكرار التمرين: 3–4 مرات نقطة التوازن',
      summaryEn: '3–4 resistance sessions weekly may optimize adaptation and recovery.',
      summaryAr: '3–4 جلسات مقاومة أسبوعياً قد تحسّن التكيف والتعافي.',
      blocks: [
        _block(
          bulletsEn: ['Upper/lower or full-body splits with rest days.'],
          bulletsAr: ['تقسيم علوي/سفلي أو جسم كامل مع أيام راحة.'],
        ),
      ],
      sources: [_src('ACSM', 'ACSM', _acsm)],
    ),
    _article(
      id: 'overtraining_trap',
      category: VitalityCategory.training,
      readingTime: 5,
      titleEn: 'The Overtraining Trap: Chronic cardio and cortisol',
      titleAr: 'فخ الإفراط: الكاردio المزمن والكورتيزول',
      summaryEn: 'Excess endurance volume may lower testosterone and raise cortisol.',
      summaryAr: 'حجم التحمل الزائد قد يخفض التستوستيرون ويرفع الكورتيزول.',
      blocks: [
        _block(
          bulletsEn: [
            'Cap steady-state cardio; prioritize resistance and sleep.',
          ],
          bulletsAr: [
            'حدِّ الكاردio المستمر؛ أولِّ المقاومة والنوم.',
          ],
        ),
      ],
      sources: [
        _src('Hackney AC — Endurance hormones', 'Hackney AC',
            'https://pubmed.ncbi.nlm.nih.gov/8889928/'),
      ],
    ),
  ];

  static final _lifestyle = [
    _article(
      id: 'sleep_architecture',
      category: VitalityCategory.lifestyle,
      readingTime: 6,
      titleEn: 'Sleep Architecture: Deep sleep and REM for hormonal reset',
      titleAr: 'بنية النوم: النوم العميق وREM للضبط الهرموني',
      summaryEn: '7–9 hours supports testosterone rhythm and cortisol regulation.',
      summaryAr: '7–9 ساعات تدعم إيقاع التستوستيرون وتنظيم الكورتيزول.',
      protocolItems: const [
        VitalityProtocolItem(
          id: 'sleep_8h',
          textEn: 'In bed 8 hours (7.5+ hours actual sleep)',
          textAr: 'في السرير 8 ساعات (7.5+ ساعات نوم فعلي)',
        ),
        VitalityProtocolItem(
          id: 'sleep_dark',
          textEn: 'Blackout curtains + room 18–20°C',
          textAr: 'ستائر معتمة + غرفة 18–20°م',
        ),
        VitalityProtocolItem(
          id: 'sleep_no_screens',
          textEn: 'No screens 60 minutes before bed',
          textAr: 'بلا شاشات قبل 60 دقيقة من النوم',
        ),
      ],
      blocks: [
        _block(
          headingEn: 'Sleep hygiene checklist',
          headingAr: 'قائمة نظافة النوم',
          bulletsEn: [
            'Room 18–20°C, blackout curtains, no screens 1 h before bed.',
          ],
          bulletsAr: [
            'غرفة 18–20°م، ستائر معتمة، بلا شاشات قبل ساعة من النوم.',
          ],
          keyTakeawayEn:
              'Deep sleep and REM may support nightly hormonal reset and recovery.',
          keyTakeawayAr:
              'النوم العميق وREM قد يدعمان إعادة ضبط الهرمونات والتعافي ليلاً.',
        ),
      ],
      sources: [
        _src('CDC Sleep', 'CDC النوم', _cdcSleep),
        _src('Leproult R — Sleep restriction and testosterone (PMID 17520786)',
            'Leproult R — قلة النوم (PMID 17520786)',
            'https://pubmed.ncbi.nlm.nih.gov/17520786/'),
        _src('NIH NHLBI — Sleep deprivation', 'NIH — الحرمان من النوم',
            'https://www.nhlbi.nih.gov/health/sleep-deprivation'),
      ],
    ),
    _article(
      id: 'cortisol_management',
      category: VitalityCategory.lifestyle,
      readingTime: 5,
      titleEn: 'Cortisol Management: Stress and hormonal balance',
      titleAr: 'إدارة الكورتيزول: الإجهاد والتوازن الهرموني',
      summaryEn: 'Chronic stress may disrupt recovery and hormonal profiles.',
      summaryAr: 'الإجهاد المزمن قد يعطل التعافي والملف الهرموني.',
      protocolItems: const [
        VitalityProtocolItem(
          id: 'breath_5min',
          textEn: '5 minutes box breathing (4-4-4-4)',
          textAr: '5 دقائق تنفس صندوقي (4-4-4-4)',
        ),
        VitalityProtocolItem(
          id: 'nature_walk',
          textEn: '20-minute nature walk without phone',
          textAr: '20 دقيقة مشي في الطبيعة بلا هاتف',
        ),
        VitalityProtocolItem(
          id: 'caffeine_cutoff',
          textEn: 'No caffeine after 2 PM',
          textAr: 'لا كافيين بعد الساعة 2 مساءً',
        ),
      ],
      blocks: [
        _block(
          headingEn: 'Daily cortisol management',
          headingAr: 'إدارة الكورتيزول اليومية',
          bulletsEn: [
            'Meditation, breathing, nature walks; limit caffeine after 2 PM.',
          ],
          bulletsAr: [
            'تأمل، تنفس، مشي في الطبيعة؛ قلل الكافيين بعد 2 مساءً.',
          ],
          keyTakeawayEn:
              'Managing stress may help optimize hormonal balance and energy levels.',
          keyTakeawayAr:
              'إدارة الإجهاد قد تساعد على تحسين التوازن الهرموني ومستويات الطاقة.',
        ),
      ],
      sources: [
        _src('APA Stress resources', 'APA الإجهاد',
            'https://www.apa.org/topics/stress'),
        _src('Brown RP — Breathing and stress (PMID 27995346)',
            'Brown RP — التنفس والإجهاد (PMID 27995346)',
            'https://pubmed.ncbi.nlm.nih.gov/27995346/'),
      ],
    ),
    _article(
      id: 'sunlight_exposure',
      category: VitalityCategory.lifestyle,
      readingTime: 4,
      titleEn: 'Sunlight Exposure: Vitamin D and circadian rhythm',
      titleAr: 'التعرض للشمس: فيتامين D والساعة البيولوجية',
      summaryEn: 'Morning light may support vitamin D and sleep-wake hormones.',
      summaryAr: 'ضوء الصباح قد يدعم فيتامين D وهرمونات النوم.',
      blocks: [
        _block(
          bulletsEn: ['10–30 min outdoor light within 1 h of waking.'],
          bulletsAr: ['10–30 دقيقة ضوء خارجي خلال ساعة من الاستيقاظ.'],
        ),
      ],
      sources: [_src('NIH Vitamin D', 'NIH', _nihVitD)],
    ),
    _article(
      id: 'cold_exposure',
      category: VitalityCategory.lifestyle,
      readingTime: 4,
      titleEn: 'Cold Exposure: Recovery optimization',
      titleAr: 'التعرض للبرودة: تحسين التعافي',
      summaryEn: 'Cold showers may support recovery when used safely.',
      summaryAr: 'الدش البارد قد يدعم التعافي عند الاستخدام الآمن.',
      blocks: [
        _block(
          bulletsEn: ['Start 30–60 s cold finish; seek medical clearance if needed.'],
          bulletsAr: ['ابدأ 30–60 ثانية؛ استشر الطبيب عند الحاجة.'],
        ),
      ],
      sources: [
        _src('Shevchuk NA (PMID 17990202)', 'Shevchuk NA',
            'https://pubmed.ncbi.nlm.nih.gov/17990202/'),
      ],
    ),
    _article(
      id: 'alcohol_hormones',
      category: VitalityCategory.lifestyle,
      readingTime: 5,
      titleEn: 'Alcohol & Hormones: Impact of moderate drinking',
      titleAr: 'الكحول والهرمونات: تأثير الشرب المعتدل',
      summaryEn: 'Alcohol may affect testosterone metabolism, sleep, and cortisol.',
      summaryAr: 'الكحول قد يؤثر على أيض التستوستيرون والنوم والكورتيزول.',
      blocks: [
        _block(
          bulletsEn: [
            'May increase aromatization; disrupts REM; raises next-day cortisol.',
          ],
          bulletsAr: [
            'قد يزيد aromatization؛ يعطل REM؛ يرفع كورتيزول اليوم التالي.',
          ],
        ),
      ],
      sources: [
        _src('NIAAA Alcohol facts', 'NIAAA',
            'https://www.niaaa.nih.gov/publications/brochures-and-fact-sheets/alcohol-facts-and-statistics'),
      ],
    ),
  ];

  static final _environmental = [
    _article(
      id: 'endocrine_disruptors',
      category: VitalityCategory.environmental,
      readingTime: 5,
      titleEn: 'Endocrine Disruptors: BPA, phthalates, microplastics',
      titleAr: 'مُعطّلات الغدد: BPA والفthalates والبلاستيك الدقيق',
      summaryEn: 'Reduce chemical exposure that may affect hormone signaling.',
      summaryAr: 'قلل التعرض للمواد التي قد تؤثر على الإشارات الهرمونية.',
      blocks: [
        _block(
          bulletsEn: ['Glass/stainless storage; avoid heating plastic.'],
          bulletsAr: ['تخزين زجاج/ستانلس؛ لا تسخّن البلاستيك.'],
          keyTakeawayEn:
              'Reducing endocrine disruptors may support long-term hormonal health.',
          keyTakeawayAr:
              'تقليل مُعطّلات الغدد قد يدعم الصحة الهرمونية على المدى الطويل.',
        ),
      ],
      sources: [
        _src('NIEHS Endocrine disruptors', 'NIEHS',
            'https://www.niehs.nih.gov/health/topics/agents/endocrine'),
        _src('FDA BPA information', 'FDA — BPA',
            'https://www.fda.gov/food/food-additives-petitions/bisphenol-bpa'),
        _src('Endocrine Society — EDC overview', 'Endocrine Society',
            'https://www.endocrine.org/patient-engagement/endocrine-library/edcs'),
      ],
    ),
    _article(
      id: 'water_quality',
      category: VitalityCategory.environmental,
      readingTime: 4,
      titleEn: 'Water Quality: Filtered water',
      titleAr: 'جودة الماء: ماء مفلتر',
      summaryEn: 'Filtration may reduce trace contaminants.',
      summaryAr: 'الفلترة قد تقلل الملوثات الشائعة.',
      blocks: [
        _block(
          bulletsEn: ['Carbon or RO filters; avoid hot plastic bottles.'],
          bulletsAr: ['فلاتر carbon أو RO؛ تجنب زجاجات بلاستيكية ساخنة.'],
        ),
      ],
      sources: [
        _src('EPA Drinking water', 'EPA',
            'https://www.epa.gov/ground-water-and-drinking-water'),
      ],
    ),
    _article(
      id: 'personal_care',
      category: VitalityCategory.environmental,
      readingTime: 4,
      titleEn: 'Personal Care: Parabens and synthetic fragrances',
      titleAr: 'العناية الشخصية: تجنب parabens والعطور الصناعية',
      summaryEn: 'Choose cleaner personal-care products when possible.',
      summaryAr: 'اختر منتجات عناية أنظف عند الإمكان.',
      blocks: [
        _block(
          bulletsEn: ['Avoid parabens/phthalates in fragrance lists.'],
          bulletsAr: ['تجنب parabens/phthalates في قائمة العطر.'],
        ),
      ],
      sources: [
        _src('FDA Parabens', 'FDA',
            'https://www.fda.gov/cosmetics/cosmetic-ingredients/parabens-cosmetics'),
      ],
    ),
  ];

  static final _advanced = [
    _article(
      id: 'intermittent_fasting',
      category: VitalityCategory.advanced,
      readingTime: 5,
      titleEn: 'Intermittent Fasting: 16:8 protocol',
      titleAr: 'الصيام المتقطع: بروتوكول 16:8',
      summaryEn: 'Time-restricted eating may support metabolic health.',
      summaryAr: 'تقييد وقت الأكل قد يدعم الصحة الأيضية.',
      blocks: [
        _block(
          bulletsEn: ['16 h fast, 8 h eating window; maintain protein intake.'],
          bulletsAr: ['16 ساعة صيام، 8 ساعات أكل؛ حافظ على البروتين.'],
        ),
      ],
      sources: [
        _src('NIH NIA — Intermittent fasting', 'NIH NIA',
            'https://www.nia.nih.gov/news/research-intermittent-fasting-shows-health-benefits'),
      ],
    ),
    _article(
      id: 'body_fat_aromatase',
      category: VitalityCategory.advanced,
      readingTime: 5,
      titleEn: 'Body Fat & Aromatase: The 10–15% vitality range',
      titleAr: 'دهون الجسم وAromatase: نطاق 10–15% للحيوية',
      summaryEn: 'Moderate leanness may support hormonal balance.',
      summaryAr: 'الاعتدال في النحافة قد يدعم التوازن الهرموني.',
      blocks: [
        _block(
          bulletsEn: [
            'Adipose tissue contains aromatase; aim for sustainable composition.',
          ],
          bulletsAr: [
            'النسيج الدهني يحتوي aromatase؛ استهدف تركيباً مستداماً.',
          ],
        ),
      ],
      sources: [
        _src('Finkelstein JS — Adiposity (PMID 21154195)', 'Finkelstein JS',
            _pmid21154195),
      ],
    ),
  ];

  static VitalityArticle _article({
    required String id,
    required VitalityCategory category,
    required int readingTime,
    required String titleEn,
    required String titleAr,
    required String summaryEn,
    required String summaryAr,
    required List<VitalityContentBlock> blocks,
    required List<VitalityScientificSource> sources,
    List<VitalityProtocolItem> protocolItems = const [],
  }) =>
      VitalityArticle(
        id: id,
        category: category,
        readingTimeMinutes: readingTime,
        titleEn: titleEn,
        titleAr: titleAr,
        summaryEn: summaryEn,
        summaryAr: summaryAr,
        blocks: blocks,
        scientificSources: sources,
        protocolItems: protocolItems,
      );

  static VitalityContentBlock _block({
    String? headingEn,
    String? headingAr,
    List<String> bulletsEn = const [],
    List<String> bulletsAr = const [],
    String? keyTakeawayEn,
    String? keyTakeawayAr,
    List<String> protocolStepsEn = const [],
    List<String> protocolStepsAr = const [],
  }) =>
      VitalityContentBlock(
        headingEn: headingEn,
        headingAr: headingAr,
        bulletsEn: bulletsEn,
        bulletsAr: bulletsAr,
        keyTakeawayEn: keyTakeawayEn,
        keyTakeawayAr: keyTakeawayAr,
        protocolStepsEn: protocolStepsEn,
        protocolStepsAr: protocolStepsAr,
      );

  static VitalityScientificSource _src(
    String titleEn,
    String titleAr,
    String url,
  ) =>
      VitalityScientificSource(
        titleEn: titleEn,
        titleAr: titleAr,
        url: url,
      );
}
