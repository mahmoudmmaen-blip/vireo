import 'package:vireo/features/diet_programs/domain/diet_program.dart';

/// Evidence-based weight-loss programs.
///
/// Content rules:
/// - Every program works through a calorie deficit. No program "burns fat
///   without counting" or replaces medical treatment.
/// - Never tell users to stop or change medication.
/// - Programs with medical risks are locked behind doctor approval for the
///   relevant conditions (see `requiresDoctorIf`).
abstract final class DietProgramsCatalog {
  static const _dietfits = EvidenceSource(
    title: 'DIETFITS — low-fat vs low-carb, 12-month RCT (JAMA 2018)',
    url: 'https://clinicaltrials.gov/study/NCT01826591',
  );
  static const _treReview = EvidenceSource(
    title: 'Time-restricted eating for weight loss — evidence review (Frontiers in Nutrition 2024)',
    url: 'https://pmc.ncbi.nlm.nih.gov/articles/PMC11236600/',
  );
  static const _issnProtein = EvidenceSource(
    title: 'ISSN Position Stand: Protein and exercise (JISSN 2017)',
    url: 'https://jissn.biomedcentral.com/articles/10.1186/s12970-017-0177-8',
  );
  static const _ketoSafety = EvidenceSource(
    title: 'The ketogenic diet is not for everyone: contraindications, side effects, drug interactions (Annals of Medicine 2026)',
    url: 'https://pmc.ncbi.nlm.nih.gov/articles/PMC12777878/',
  );
  static const _sglt2 = EvidenceSource(
    title: 'SGLT2 inhibition and ketoacidosis (British Journal of Diabetes)',
    url: 'https://bjd-abcd.com/index.php/bjd/article/view/104',
  );
  static const _whoHealthyDiet = EvidenceSource(
    title: 'WHO — Healthy diet fact sheet',
    url: 'https://www.who.int/news-room/fact-sheets/detail/healthy-diet',
  );

  // Conditions shared by several programs.
  static const _diabetesMeds = {
    HealthCondition.type1Diabetes,
    HealthCondition.diabetesOnMedication,
  };

  static const List<DietProgram> all = [
    _balancedDeficit,
    _highProtein,
    _intermittentFasting,
    _lowCarb,
    _keto,
    _fastingLowCarb,
    _egyptianClean,
  ];

  static DietProgram byId(DietProgramId id) => all.firstWhere((p) => p.id == id);

  // ───────────────────────── 1. Balanced deficit ─────────────────────────
  static const _balancedDeficit = DietProgram(
    id: DietProgramId.balancedDeficit,
    deficitFactor: 1.0,
    emoji: '⚖️',
    difficulty: 1,
    name: L10nText('تقليل السعرات المتوازن', 'Balanced calorie deficit'),
    tagline: L10nText(
      'كُل كل حاجة بكميات محسوبة — الأساس العلمي لأي تخسيس',
      'Eat everything in measured portions — the science behind all fat loss',
    ),
    howItWorks: L10nText(
      'جسمك بيخس لما ياخد سعرات أقل من اللي بيحرقها. البرنامج بيحسبلك عجز آمن (حوالي 20% أقل من احتياجك) مع بروتين كفاية يحافظ على عضلك. مفيش أكل ممنوع — المهم الكمية والمجموع في آخر اليوم.',
      'You lose fat when you eat fewer calories than you burn. The plan sets a safe deficit (about 20% below maintenance) with enough protein to protect muscle. No food is banned — portions and the daily total are what matter.',
    ),
    bestFor: [
      L10nText('أول مرة تعمل دايت', 'First-time dieters'),
      L10nText('بتحب تاكل عيش ورز ومش عايز تحرم نفسك', 'You love bread and rice and hate restriction'),
      L10nText('بتاكل برا البيت كتير', 'You eat out often'),
    ],
    notIdealFor: [
      L10nText('لو بتحتاج قواعد صارمة عشان تلتزم', 'People who need strict rules to stay on track'),
    ],
    rules: [
      L10nText('التزم برقم السعرات اليومي (±100 سعرة مقبول)', 'Hit your daily calorie target (±100 kcal is fine)'),
      L10nText('بروتين في كل وجبة', 'Protein at every meal'),
      L10nText('نص الطبق خضار', 'Fill half your plate with vegetables'),
      L10nText('سجّل كل حاجة — حتى الزيت والسكر في الشاي', 'Log everything — including cooking oil and sugar in tea'),
    ],
    allowedFoods: [
      L10nText('كل الأكل مسموح بكميات محسوبة', 'All foods, in measured portions'),
      L10nText('عيش بلدي، رز، مكرونة، بطاطس (بحساب)', 'Baladi bread, rice, pasta, potatoes (counted)'),
      L10nText('فراخ، لحمة، سمك، بيض، فول، عدس', 'Chicken, beef, fish, eggs, fava beans, lentils'),
    ],
    limitFoods: [
      L10nText('المقليات والحلويات والعصاير والمشروبات الغازية', 'Fried food, sweets, juices and soft drinks'),
    ],
    sampleDay: [
      SampleMeal(
        time: L10nText('فطار', 'Breakfast'),
        name: L10nText('فول وبيض', 'Fava beans & eggs'),
        items: L10nText('150 جم فول بملعقة زيت صغيرة + 2 بيضة مسلوقة + نص رغيف بلدي + خيار وطماطم', '150 g foul with 1 tsp oil + 2 boiled eggs + ½ baladi bread + cucumber & tomato'),
      ),
      SampleMeal(
        time: L10nText('غدا', 'Lunch'),
        name: L10nText('فراخ ورز', 'Chicken & rice'),
        items: L10nText('150 جم صدور فراخ مشوية + 150 جم رز مطبوخ + سلطة كبيرة', '150 g grilled chicken breast + 150 g cooked rice + large salad'),
      ),
      SampleMeal(
        time: L10nText('سناك', 'Snack'),
        name: L10nText('زبادي وفاكهة', 'Yogurt & fruit'),
        items: L10nText('علبة زبادي لايت + تفاحة', '1 light yogurt + 1 apple'),
      ),
      SampleMeal(
        time: L10nText('عشا', 'Dinner'),
        name: L10nText('جبنة وخضار', 'Cheese & veggies'),
        items: L10nText('100 جم جبنة قريش + ربع رغيف + خضار', '100 g cottage cheese + ¼ bread + vegetables'),
      ),
    ],
    sideEffects: [
      L10nText('جوع خفيف أول أسبوع — طبيعي وبيقل', 'Mild hunger in week 1 — normal and fades'),
    ],
    tips: [
      L10nText('اشرب كوبايتين مية قبل الأكل', 'Drink 2 glasses of water before meals'),
      L10nText('وزن الأكل بالميزان أول أسبوعين بيعلمك الكميات', 'Weighing food for 2 weeks teaches you portions'),
    ],
    evidenceSummary: L10nText(
      'في دراسة DIETFITS (سنة كاملة) نتائج الكيتو/اللو كارب والقليل الدهون كانت متقاربة جداً. اللي بيفرق فعلاً هو العجز في السعرات والالتزام.',
      'In the 12-month DIETFITS trial, low-carb and low-fat diets produced very similar weight loss. The deficit and adherence matter most.',
    ),
    sources: [_dietfits, _whoHealthyDiet],
    macroRule: MacroRule(proteinGPerKg: 1.6, fatPercent: 0.30),
    cautionIf: {HealthCondition.eatingDisorderHistory},
  );

  // ───────────────────────── 2. High protein ─────────────────────────
  static const _highProtein = DietProgram(
    id: DietProgramId.highProtein,
    deficitFactor: 1.05,
    emoji: '💪',
    difficulty: 2,
    name: L10nText('عجز + بروتين عالي (تنشيف)', 'High-protein cut'),
    tagline: L10nText(
      'اخسر دهون واحتفظ بعضلك — للي بيلعب حديد',
      'Lose fat, keep muscle — for people who lift',
    ),
    howItWorks: L10nText(
      'نفس فكرة العجز، بس البروتين أعلى (حوالي 2 جم لكل كيلو من وزنك المرجعي). البروتين بيشبّع أكتر وبيحمي العضل وقت الدايت، خصوصاً مع تمارين المقاومة.',
      'Same deficit, higher protein (~2 g per kg of reference weight). Protein is more filling and protects muscle while dieting, especially with resistance training.',
    ),
    bestFor: [
      L10nText('بتتمرن حديد 3 مرات أو أكتر في الأسبوع', 'You lift weights 3+ times a week'),
      L10nText('عايز شكل مشدود مش بس رقم أقل', 'You want a lean look, not just a lower number'),
    ],
    notIdealFor: [
      L10nText('مرضى الكلى (لازم دكتور)', 'Kidney disease (doctor needed)'),
    ],
    rules: [
      L10nText('حقق هدف البروتين كل يوم — ده أهم رقم', 'Hit your protein target daily — the most important number'),
      L10nText('وزّع البروتين على 3–5 وجبات (25–40 جم لكل وجبة)', 'Spread protein over 3–5 meals (25–40 g each)'),
      L10nText('اتمرن مقاومة 3–4 مرات أسبوعياً', 'Resistance train 3–4× per week'),
    ],
    allowedFoods: [
      L10nText('صدور فراخ، تونة، سمك، لحمة حمرا قليلة الدهن، بيض، جبنة قريش، زبادي يوناني', 'Chicken breast, tuna, fish, lean beef, eggs, cottage cheese, Greek yogurt'),
      L10nText('رز وبطاطس وشوفان حوالين التمرين', 'Rice, potatoes and oats around training'),
    ],
    limitFoods: [
      L10nText('اللحوم المصنعة (لانشون، سجق)', 'Processed meats (luncheon, sausages)'),
    ],
    sampleDay: [
      SampleMeal(
        time: L10nText('فطار', 'Breakfast'),
        name: L10nText('أومليت بروتين', 'Protein omelette'),
        items: L10nText('3 بيض + 2 بياض + 50 جم شوفان + فاكهة', '3 eggs + 2 whites + 50 g oats + fruit'),
      ),
      SampleMeal(
        time: L10nText('غدا', 'Lunch'),
        name: L10nText('فراخ ورز', 'Chicken & rice'),
        items: L10nText('200 جم صدور فراخ مشوية + 150 جم رز + سلطة', '200 g grilled chicken + 150 g rice + salad'),
      ),
      SampleMeal(
        time: L10nText('بعد التمرين', 'Post-workout'),
        name: L10nText('زبادي يوناني', 'Greek yogurt'),
        items: L10nText('200 جم زبادي يوناني + موزة', '200 g Greek yogurt + banana'),
      ),
      SampleMeal(
        time: L10nText('عشا', 'Dinner'),
        name: L10nText('تونة وسلطة', 'Tuna salad'),
        items: L10nText('علبة تونة مصفّاة + سلطة كبيرة + ربع رغيف', '1 can drained tuna + large salad + ¼ bread'),
      ),
    ],
    sideEffects: [
      L10nText('ممكن إمساك لو الألياف والمية قليلين', 'Constipation if fibre and water are low'),
    ],
    tips: [
      L10nText('اشرب 3 لتر مية على الأقل', 'Drink at least 3 L of water'),
      L10nText('لو مش عارف تكمل البروتين: زبادي يوناني أو جبنة قريش', 'Short on protein? Greek yogurt or cottage cheese'),
    ],
    evidenceSummary: L10nText(
      'الجمعية الدولية للتغذية الرياضية بتوصي بـ 1.4–2.0 جم بروتين/كجم للي بيتمرن، وأعلى شوية وقت الدايت للحفاظ على العضل.',
      'The ISSN recommends 1.4–2.0 g/kg protein for exercising people, and somewhat higher during a deficit to preserve muscle.',
    ),
    sources: [_issnProtein],
    macroRule: MacroRule(proteinGPerKg: 2.0, fatPercent: 0.25),
    requiresDoctorIf: {HealthCondition.kidneyDisease, HealthCondition.liverDisease},
    cautionIf: {HealthCondition.goutHistory, HealthCondition.eatingDisorderHistory},
  );

  // ───────────────────────── 3. Intermittent fasting 16:8 ─────────────────────────
  static const _intermittentFasting = DietProgram(
    id: DietProgramId.intermittentFasting,
    deficitFactor: 0.95,
    emoji: '⏱️',
    difficulty: 2,
    name: L10nText('الصيام المتقطع 16:8', 'Intermittent fasting 16:8'),
    tagline: L10nText(
      'صيام 16 ساعة وأكل في 8 ساعات — بيسهّل التحكم في السعرات',
      'Fast 16 hours, eat within 8 — makes the deficit easier',
    ),
    howItWorks: L10nText(
      'بتاكل كل وجباتك في 8 ساعات (مثلاً من 12 الضهر لـ 8 بالليل) وتصوم الباقي (مية وشاي وقهوة من غير سكر مسموحين). ميزته إنه بيقلل عدد الوجبات فبيسهل العجز. مهم: الصيام لوحده مش سحر — لازم تحافظ على رقم السعرات.',
      'You eat all meals within 8 hours (e.g. 12 pm–8 pm) and fast the rest (water, unsweetened tea and coffee are fine). Fewer meals makes the deficit easier. Important: fasting is not magic — you still need to hit your calorie target.',
    ),
    bestFor: [
      L10nText('مش بتجوع الصبح أو بتنسى الفطار أصلاً', 'You are not hungry in the morning anyway'),
      L10nText('بتحب قاعدة بسيطة: "مفيش أكل قبل الساعة كذا"', 'You like one simple rule: "no food before X o’clock"'),
    ],
    notIdealFor: [
      L10nText('مرضى السكر على أنسولين أو أقراص بتنزّل السكر (خطر هبوط)', 'Diabetes on insulin or sugar-lowering pills (hypoglycaemia risk)'),
      L10nText('أي حد عنده تاريخ اضطرابات أكل', 'Anyone with a history of eating disorders'),
    ],
    rules: [
      L10nText('أول وجبة الساعة 12 الضهر وآخر وجبة 8 بالليل (تقدر تغيّر التوقيت)', 'First meal 12 pm, last meal 8 pm (you can shift it)'),
      L10nText('وقت الصيام: مية، شاي وقهوة سادة فقط', 'Fasting window: water, plain tea/coffee only'),
      L10nText('افطر بوجبة فيها بروتين عالي', 'Break the fast with a high-protein meal'),
      L10nText('ابدأ بـ 12:12 أول أسبوع، بعدين 14:10، بعدين 16:8', 'Start with 12:12 in week 1, then 14:10, then 16:8'),
    ],
    allowedFoods: [
      L10nText('أي أكل متوازن في وقت الأكل وبحساب السعرات', 'Any balanced food within the window, counted'),
    ],
    limitFoods: [
      L10nText('التعويض بأكل كتير في وقت الأكل', 'Over-eating to "make up" in the window'),
    ],
    sampleDay: [
      SampleMeal(
        time: L10nText('12:00 الضهر', '12:00 pm'),
        name: L10nText('فطار متأخر', 'Late breakfast'),
        items: L10nText('3 بيض + 100 جم جبنة قريش + نص رغيف + خضار', '3 eggs + 100 g cottage cheese + ½ bread + veggies'),
      ),
      SampleMeal(
        time: L10nText('4:00 العصر', '4:00 pm'),
        name: L10nText('الغدا', 'Lunch'),
        items: L10nText('150 جم لحمة أو فراخ + 150 جم رز + سلطة', '150 g beef or chicken + 150 g rice + salad'),
      ),
      SampleMeal(
        time: L10nText('7:30 بالليل', '7:30 pm'),
        name: L10nText('آخر وجبة', 'Last meal'),
        items: L10nText('زبادي يوناني + حفنة مكسرات صغيرة + فاكهة', 'Greek yogurt + small handful of nuts + fruit'),
      ),
    ],
    sideEffects: [
      L10nText('جوع وصداع خفيف أول أيام', 'Hunger and mild headache in the first days'),
      L10nText('دوخة — لو حصلت اكسر الصيام فوراً', 'Dizziness — if it happens, break the fast immediately'),
    ],
    tips: [
      L10nText('القهوة السادة الصبح بتقلل الجوع', 'Black coffee in the morning reduces hunger'),
      L10nText('نام كويس — قلة النوم بتزود الجوع', 'Sleep well — poor sleep increases hunger'),
    ],
    evidenceSummary: L10nText(
      'الأبحاث بتقول إن الصيام المتقطع بيخسّس بشكل مقارب لتقليل السعرات العادي، وفايدته الأساسية إنه بيسهّل الالتزام لبعض الناس. الأدلة على ميزة إضافية لسه مش محسومة.',
      'Research shows time-restricted eating produces weight loss broadly similar to standard calorie restriction; its main benefit is easier adherence for some people. Evidence for an extra advantage is still debated.',
    ),
    sources: [_treReview],
    window: EatingWindow(fastingHours: 16, eatingHours: 8, defaultStartHour: 12),
    macroRule: MacroRule(proteinGPerKg: 1.6, fatPercent: 0.30),
    requiresDoctorIf: {
      ..._diabetesMeds,
      HealthCondition.eatingDisorderHistory,
      HealthCondition.medicationWithFood,
    },
    cautionIf: {
      HealthCondition.faintingOrLowBloodPressure,
      HealthCondition.bloodPressureMedication,
      HealthCondition.goutHistory,
    },
  );

  // ───────────────────────── 4. Low carb ─────────────────────────
  static const _lowCarb = DietProgram(
    id: DietProgramId.lowCarb,
    deficitFactor: 1.1,
    emoji: '🥩',
    difficulty: 2,
    name: L10nText('لو كارب معتدل', 'Moderate low-carb'),
    tagline: L10nText(
      'نشويات أقل (حوالي 100 جم) — بروتين وخضار ودهون صحية أكتر',
      'Fewer carbs (~100 g) — more protein, vegetables and healthy fats',
    ),
    howItWorks: L10nText(
      'بتقلل النشويات لحوالي 100 جم في اليوم بدل 250–300. ده بيقلل السعرات تلقائياً وبيخلي ناس كتير أقل جوعاً. مش كيتو — لسه مسموح بشوية عيش أو رز أو فاكهة يومياً.',
      'You cut carbs to about 100 g/day instead of 250–300. That lowers calories automatically and many people feel less hungry. It is not keto — some bread, rice or fruit is still allowed daily.',
    ),
    bestFor: [
      L10nText('بتجوع بسرعة بعد الأكل النشوي', 'Starchy meals leave you hungry fast'),
      L10nText('عايز تقلل السكر والعيش من غير ما تمنعهم خالص', 'You want less sugar and bread without banning them'),
    ],
    notIdealFor: [
      L10nText('مرضى السكر على علاج (لازم الدكتور يظبط الجرعات)', 'Diabetes on medication (doctor must adjust doses)'),
    ],
    rules: [
      L10nText('النشويات حوالي 100 جم في اليوم — التطبيق بيعدّها لك', 'Carbs ~100 g/day — the app counts them for you'),
      L10nText('حصة نشويات واحدة في اليوم (ربع رغيف أو 100 جم رز)', 'One starch portion a day (¼ bread or 100 g rice)'),
      L10nText('خضار غير نشوية بدون حدود تقريباً', 'Non-starchy vegetables almost unlimited'),
      L10nText('لسه لازم تلتزم بالسعرات', 'You still need to hit your calorie target'),
    ],
    allowedFoods: [
      L10nText('لحوم، فراخ، سمك، بيض، جبن، زبادي', 'Meat, chicken, fish, eggs, cheese, yogurt'),
      L10nText('خضار ورقية، كوسة، باذنجان، فلفل، بروكلي', 'Leafy greens, zucchini, eggplant, peppers, broccoli'),
      L10nText('زيت زيتون، مكسرات، أفوكادو (بحساب)', 'Olive oil, nuts, avocado (counted)'),
    ],
    limitFoods: [
      L10nText('السكر والحلويات والعصاير', 'Sugar, sweets and juices'),
      L10nText('العيش والرز والمكرونة الكتير', 'Large portions of bread, rice and pasta'),
    ],
    sampleDay: [
      SampleMeal(
        time: L10nText('فطار', 'Breakfast'),
        name: L10nText('بيض وجبنة', 'Eggs & cheese'),
        items: L10nText('3 بيض بملعقة زيت زيتون + 50 جم جبنة بيضا + خيار وفلفل', '3 eggs in 1 tsp olive oil + 50 g white cheese + cucumber & peppers'),
      ),
      SampleMeal(
        time: L10nText('غدا', 'Lunch'),
        name: L10nText('سمك وخضار', 'Fish & vegetables'),
        items: L10nText('200 جم سمك مشوي + خضار سوتيه + 100 جم رز', '200 g grilled fish + sautéed vegetables + 100 g rice'),
      ),
      SampleMeal(
        time: L10nText('عشا', 'Dinner'),
        name: L10nText('فراخ وسلطة', 'Chicken salad'),
        items: L10nText('150 جم فراخ + سلطة كبيرة بزيت زيتون + زبادي', '150 g chicken + large salad with olive oil + yogurt'),
      ),
    ],
    sideEffects: [
      L10nText('تعب خفيف أول أسبوع لحد ما الجسم يتعود', 'Mild fatigue in week 1 while adapting'),
    ],
    tips: [
      L10nText('زوّد الملح شوية والمية أول أسبوع', 'Slightly more salt and water in week 1'),
    ],
    evidenceSummary: L10nText(
      'على المدى الطويل اللو كارب بيدي نتايج قريبة من الأنظمة التانية لما السعرات تبقى متقاربة. اختاره لو بيريحك وبيقلل جوعك.',
      'Long-term, low-carb gives results similar to other diets when calories are matched. Choose it if it suits you and curbs hunger.',
    ),
    sources: [_dietfits],
    macroRule: MacroRule(proteinGPerKg: 1.8, carbsGrams: 100, carbsMaxGrams: 130),
    requiresDoctorIf: {..._diabetesMeds, HealthCondition.kidneyDisease},
    cautionIf: {
      HealthCondition.bloodPressureMedication,
      HealthCondition.goutHistory,
      HealthCondition.eatingDisorderHistory,
    },
  );

  // ───────────────────────── 5. Keto ─────────────────────────
  static const _keto = DietProgram(
    id: DietProgramId.keto,
    deficitFactor: 1.15,
    emoji: '🥑',
    difficulty: 3,
    name: L10nText('الكيتو', 'Keto'),
    tagline: L10nText(
      'نشويات أقل من 50 جم — الجسم بيعتمد على الدهون كوقود',
      'Under 50 g carbs — the body runs on fat for fuel',
    ),
    howItWorks: L10nText(
      'بتقلل النشويات جداً (20–50 جم في اليوم) فالجسم بيدخل حالة "كيتوزس" وبيستخدم الدهون والكيتونات كطاقة. ناس كتير بتلاحظ نزول سريع أول أسبوعين — ده أغلبه مية مش دهون. الخسارة الحقيقية للدهون بتيجي من العجز في السعرات زي أي نظام.',
      'Carbs are cut very low (20–50 g/day) so the body enters ketosis and uses fat and ketones for energy. Many people see a fast drop in the first 2 weeks — mostly water, not fat. Real fat loss still comes from the calorie deficit, like any diet.',
    ),
    bestFor: [
      L10nText('بتحب اللحوم والبيض والجبن ومش متعلق بالعيش والرز', 'You love meat, eggs and cheese and can live without bread and rice'),
      L10nText('بتحب القواعد الواضحة: "مسموح / ممنوع"', 'You like clear allowed / not-allowed rules'),
    ],
    notIdealFor: [
      L10nText('مرضى السكر على أي علاج (خصوصاً أدوية SGLT2 والأنسولين) — خطر حموضة كيتونية', 'Diabetes on any treatment (especially SGLT2 drugs and insulin) — ketoacidosis risk'),
      L10nText('أمراض الكلى أو الكبد أو البنكرياس أو المرارة', 'Kidney, liver, pancreas or gallbladder disease'),
      L10nText('الكوليسترول العائلي العالي', 'Familial high cholesterol'),
      L10nText('أدوية الضغط أو المدرّات أو أدوية الصرع — لازم الدكتور', 'Blood-pressure drugs, diuretics or epilepsy drugs — doctor needed'),
    ],
    rules: [
      L10nText('النشويات الصافية أقل من 50 جم (الأفضل 20–30 جم)', 'Net carbs under 50 g (ideally 20–30 g)'),
      L10nText('بروتين معتدل — مش لحمة بلا حساب', 'Moderate protein — not unlimited meat'),
      L10nText('ملح ومية وماغنسيوم كفاية عشان "إنفلونزا الكيتو"', 'Enough salt, water and magnesium to avoid "keto flu"'),
      L10nText('لسه لازم تلتزم بالسعرات — الدهون سعراتها عالية', 'Still hit your calories — fat is calorie-dense'),
      L10nText('حلّل دهون الدم بعد 3 شهور', 'Check your blood lipids after 3 months'),
    ],
    allowedFoods: [
      L10nText('لحوم، فراخ، سمك، بيض', 'Meat, chicken, fish, eggs'),
      L10nText('جبن، زبدة، زيت زيتون، أفوكادو، مكسرات', 'Cheese, butter, olive oil, avocado, nuts'),
      L10nText('خضار ورقية، كوسة، بروكلي، قرنبيط، خيار', 'Leafy greens, zucchini, broccoli, cauliflower, cucumber'),
    ],
    limitFoods: [
      L10nText('ممنوع تقريباً: عيش، رز، مكرونة، بطاطس، سكر، فاكهة (غير التوت)، فول وعدس، عصاير', 'Practically none: bread, rice, pasta, potatoes, sugar, fruit (except berries), beans & lentils, juices'),
    ],
    sampleDay: [
      SampleMeal(
        time: L10nText('فطار', 'Breakfast'),
        name: L10nText('بيض بالجبنة', 'Cheese eggs'),
        items: L10nText('3 بيض بالزبدة + 40 جم جبنة رومي + خيار', '3 eggs in butter + 40 g aged cheese + cucumber'),
      ),
      SampleMeal(
        time: L10nText('غدا', 'Lunch'),
        name: L10nText('لحمة وخضار', 'Beef & greens'),
        items: L10nText('180 جم لحمة مشوية + بروكلي وكوسة بزيت زيتون', '180 g grilled beef + broccoli & zucchini in olive oil'),
      ),
      SampleMeal(
        time: L10nText('عشا', 'Dinner'),
        name: L10nText('سلطة تونة', 'Tuna salad'),
        items: L10nText('علبة تونة + خس وخيار + زيت زيتون + 10 حبات لوز', '1 can tuna + lettuce & cucumber + olive oil + 10 almonds'),
      ),
    ],
    sideEffects: [
      L10nText('"إنفلونزا الكيتو" أول أسبوع: صداع، تعب، غثيان', '"Keto flu" in week 1: headache, fatigue, nausea'),
      L10nText('إمساك وكثرة تبول', 'Constipation and frequent urination'),
      L10nText('ممكن ارتفاع الكوليسترول الضار عند بعض الناس', 'LDL cholesterol may rise in some people'),
    ],
    tips: [
      L10nText('شوربة بملح أو مرقة يومياً أول أسبوع', 'A cup of salted broth daily in week 1'),
      L10nText('ماتبدأش الكيتو أسبوع امتحانات أو شغل تقيل', 'Don’t start keto during a high-stress week'),
    ],
    evidenceSummary: L10nText(
      'الكيتو ممكن يخسّس، لكن مراجعة علمية حديثة بتأكد إنه "مش لكل الناس": له موانع مع أمراض الكلى والكبد والبنكرياس والكوليسترول العائلي، وتداخلات مع أدوية السكر (خصوصاً SGLT2) والضغط والمدرّات.',
      'Keto can work, but a recent review stresses it is "not for everyone": it is contraindicated with kidney, liver, pancreatic disease and familial hypercholesterolaemia, and interacts with diabetes drugs (especially SGLT2), blood-pressure drugs and diuretics.',
    ),
    sources: [_ketoSafety, _sglt2, _dietfits],
    macroRule: MacroRule(proteinGPerKg: 1.6, carbsGrams: 30, carbsMaxGrams: 50),
    requiresDoctorIf: {
      ..._diabetesMeds,
      HealthCondition.kidneyDisease,
      HealthCondition.liverDisease,
      HealthCondition.pancreatitisOrGallbladder,
      HealthCondition.highCholesterolFamilial,
      HealthCondition.heartDiseaseOrArrhythmia,
      HealthCondition.bloodPressureMedication,
      HealthCondition.eatingDisorderHistory,
    },
    cautionIf: {
      HealthCondition.goutHistory,
      HealthCondition.faintingOrLowBloodPressure,
    },
  );

  // ───────────────────────── 6. Fasting + low carb (mix) ─────────────────────────
  static const _fastingLowCarb = DietProgram(
    id: DietProgramId.fastingLowCarb,
    deficitFactor: 1.1,
    emoji: '🔥',
    difficulty: 3,
    name: L10nText('المزيج: صيام متقطع + لو كارب', 'Mix: Fasting + low-carb'),
    tagline: L10nText(
      'وجبتين أو تلاتة في 8 ساعات، ونشويات حوالي 100 جم',
      '2–3 meals in 8 hours, with ~100 g carbs',
    ),
    howItWorks: L10nText(
      'بيجمع قاعدتين: الأكل في 8 ساعات بس، والنشويات حوالي 100 جم. ناس كتير بتلاقيه أسهل في التحكم في الجوع. هو أصعب نظام هنا، فمناسب للي جرّب الصيام أو اللو كارب ونجح معاه.',
      'Combines two rules: eat within 8 hours, and keep carbs around 100 g. Many people find hunger easier to control. It is the most demanding plan here — best if you have already done fasting or low-carb successfully.',
    ),
    bestFor: [
      L10nText('جرّبت الصيام المتقطع أو اللو كارب قبل كده وارتحت', 'You have done fasting or low-carb before and liked it'),
      L10nText('مش بتجوع الصبح ومش متعلق بالنشويات', 'Not hungry in the morning and not attached to starch'),
    ],
    notIdealFor: [
      L10nText('أول دايت ليك — ابدأ بنظام أبسط', 'Your first diet — start simpler'),
      L10nText('مرضى السكر على علاج', 'Diabetes on medication'),
    ],
    rules: [
      L10nText('وقت الأكل 8 ساعات (مثلاً 12–8)', '8-hour eating window (e.g. 12–8 pm)'),
      L10nText('النشويات حوالي 100 جم في اليوم', 'Carbs about 100 g/day'),
      L10nText('أول وجبة بعد الصيام: بروتين + خضار', 'First meal after the fast: protein + vegetables'),
      L10nText('لو حسيت بدوخة أو تعب شديد اكسر الصيام وارجع لنظام أبسط', 'If dizzy or very weak, break the fast and switch to a simpler plan'),
    ],
    allowedFoods: [
      L10nText('بروتين، خضار، دهون صحية، حصة نشويات صغيرة', 'Protein, vegetables, healthy fats, one small starch portion'),
    ],
    limitFoods: [
      L10nText('السكر والعصاير والعيش الكتير', 'Sugar, juices and lots of bread'),
    ],
    sampleDay: [
      SampleMeal(
        time: L10nText('12:30 الضهر', '12:30 pm'),
        name: L10nText('أول وجبة', 'First meal'),
        items: L10nText('3 بيض + 100 جم جبنة قريش + خضار + ربع رغيف', '3 eggs + 100 g cottage cheese + veggies + ¼ bread'),
      ),
      SampleMeal(
        time: L10nText('4:30 العصر', '4:30 pm'),
        name: L10nText('الوجبة الرئيسية', 'Main meal'),
        items: L10nText('200 جم فراخ أو سمك + خضار + 100 جم رز', '200 g chicken or fish + vegetables + 100 g rice'),
      ),
      SampleMeal(
        time: L10nText('7:45 بالليل', '7:45 pm'),
        name: L10nText('آخر وجبة', 'Last meal'),
        items: L10nText('زبادي يوناني + 10 حبات مكسرات', 'Greek yogurt + 10 nuts'),
      ),
    ],
    sideEffects: [
      L10nText('جوع وصداع أول أسبوع', 'Hunger and headache in week 1'),
      L10nText('دوخة لو المية والملح قليلين', 'Dizziness if water and salt are low'),
    ],
    tips: [
      L10nText('ابدأ باللو كارب أسبوع، وبعدين ضيف الصيام', 'Start with low-carb for a week, then add fasting'),
    ],
    evidenceSummary: L10nText(
      'مفيش دليل قوي إن المزيج بيخسّس أكتر من أي نظام عجز تاني لو السعرات واحدة. فايدته في سهولة الالتزام لبعض الناس.',
      'There is no strong evidence the combination beats any other deficit at equal calories; its value is easier adherence for some people.',
    ),
    sources: [_treReview, _dietfits],
    window: EatingWindow(fastingHours: 16, eatingHours: 8, defaultStartHour: 12),
    macroRule: MacroRule(proteinGPerKg: 1.8, carbsGrams: 100, carbsMaxGrams: 130),
    requiresDoctorIf: {
      ..._diabetesMeds,
      HealthCondition.kidneyDisease,
      HealthCondition.eatingDisorderHistory,
      HealthCondition.medicationWithFood,
      HealthCondition.faintingOrLowBloodPressure,
    },
    cautionIf: {
      HealthCondition.bloodPressureMedication,
      HealthCondition.goutHistory,
      HealthCondition.heartDiseaseOrArrhythmia,
    },
  );

  // ───────────────────────── 7. Egyptian clean eating ─────────────────────────
  static const _egyptianClean = DietProgram(
    id: DietProgramId.egyptianClean,
    deficitFactor: 0.9,
    emoji: '🫓',
    difficulty: 1,
    name: L10nText('الأكل النضيف المصري', 'Egyptian clean eating'),
    tagline: L10nText(
      'أكل البيت الطبيعي بكميات محسوبة — من غير أكل جاهز ولا سكر',
      'Natural home food in measured portions — no junk, no added sugar',
    ),
    howItWorks: L10nText(
      'نظام مبني على الأكل المصري اللي متعود عليه: فول، بيض، جبنة قريش، فراخ، سمك، خضار، عيش بلدي ورز بحساب. بتشيل الأكل المصنّع والسكر والمقليات، وبتلتزم بالسعرات اللي التطبيق محددها. مفيش مجموعات غذائية ممنوعة.',
      'Built on the Egyptian food you already eat: foul, eggs, cottage cheese, chicken, fish, vegetables, baladi bread and rice in measured portions. Remove processed food, added sugar and fried food, and hit the calories the app sets. No food groups are banned.',
    ),
    bestFor: [
      L10nText('عايز نظام يمشي مع أكل البيت والعيلة', 'You want a plan that fits family home cooking'),
      L10nText('بتحب العيش والرز', 'You love bread and rice'),
    ],
    notIdealFor: [
      L10nText('لو محتاج نتيجة سريعة جداً (مفيش نظام صحي بيدي ده)', 'If you want very fast results (no healthy plan does)'),
    ],
    rules: [
      L10nText('3 وجبات + سناك واحد بحد أقصى', '3 meals + at most 1 snack'),
      L10nText('رغيف بلدي واحد في اليوم مقسّم على الوجبات', 'One baladi loaf per day, split across meals'),
      L10nText('طبخ بملعقة زيت واحدة للطبخة — مش مغرّق', 'One spoon of oil per dish — not drowning in it'),
      L10nText('لا للمشروبات الغازية والعصاير المعلبة والحلويات الشرقية إلا مرة في الأسبوع', 'No soft drinks, packaged juices or oriental sweets except once a week'),
    ],
    allowedFoods: [
      L10nText('فول، عدس، بيض، جبنة قريش، زبادي', 'Foul, lentils, eggs, cottage cheese, yogurt'),
      L10nText('فراخ وسمك ولحمة مشوية أو مسلوقة', 'Grilled or boiled chicken, fish and beef'),
      L10nText('خضار مطبوخة (بامية، ملوخية، كوسة) بزيت قليل', 'Cooked vegetables (okra, molokhia, zucchini) with little oil'),
      L10nText('عيش بلدي، رز، مكرونة بكميات محسوبة', 'Baladi bread, rice, pasta in measured portions'),
    ],
    limitFoods: [
      L10nText('الطعمية والبطاطس المقلية والكشري الكبير', 'Falafel, fries and large koshari portions'),
      L10nText('الحلويات الشرقية والبسكويت والشيبسي', 'Oriental sweets, biscuits and crisps'),
    ],
    sampleDay: [
      SampleMeal(
        time: L10nText('فطار', 'Breakfast'),
        name: L10nText('فطار مصري', 'Egyptian breakfast'),
        items: L10nText('150 جم فول + بيضة + 50 جم جبنة قريش + ثلث رغيف + سلطة', '150 g foul + 1 egg + 50 g cottage cheese + ⅓ bread + salad'),
      ),
      SampleMeal(
        time: L10nText('غدا', 'Lunch'),
        name: L10nText('غدا البيت', 'Home lunch'),
        items: L10nText('طبق ملوخية أو بامية بزيت قليل + 150 جم فراخ + 100 جم رز', 'Molokhia or okra (little oil) + 150 g chicken + 100 g rice'),
      ),
      SampleMeal(
        time: L10nText('عشا', 'Dinner'),
        name: L10nText('عشا خفيف', 'Light dinner'),
        items: L10nText('زبادي + ثلث رغيف + 100 جم تونة أو جبنة قريش + خيار', 'Yogurt + ⅓ bread + 100 g tuna or cottage cheese + cucumber'),
      ),
    ],
    sideEffects: [
      L10nText('عادةً مفيش — أسهل نظام على الجسم', 'Usually none — the gentlest plan'),
    ],
    tips: [
      L10nText('اطبخ لنفسك في حلة صغيرة لوحدك لو العيلة بتاكل بسمن كتير', 'Cook your portion separately if the family uses lots of ghee'),
      L10nText('صوّر طبقك بالـ AI عشان تعرف سعرات أكل البيت', 'Scan your plate with AI to learn home-food calories'),
    ],
    evidenceSummary: L10nText(
      'منظمة الصحة العالمية بتوصي بأكل متنوع قليل السكر المضاف والملح والدهون المصنّعة. ومع عجز في السعرات بيخسّس بنفس كفاءة الأنظمة التانية مع سهولة التزام أعلى.',
      'The WHO recommends a varied diet low in added sugar, salt and industrial fats. With a calorie deficit it works as well as other diets, with easier adherence.',
    ),
    sources: [_whoHealthyDiet, _dietfits],
    macroRule: MacroRule(proteinGPerKg: 1.6, fatPercent: 0.28),
    cautionIf: {HealthCondition.eatingDisorderHistory},
  );
}

/// Mandatory medical text shown before starting ANY program, and in the
/// footer of every program screen.
abstract final class DietSafetyCopy {
  static const disclaimer = L10nText(
    'المحتوى ده للتثقيف العام ومش بديل عن الدكتور. لو عندك أي مرض مزمن أو بتاخد أدوية، اعرض البرنامج على دكتورك قبل ما تبدأ. ماتوقفش ولا تغيّر أي دوا من غير دكتورك.',
    'This content is general education, not a substitute for a doctor. If you have any chronic condition or take medication, show this program to your doctor before starting. Never stop or change medication without your doctor.',
  );

  static const stopSigns = L10nText(
    'وقّف البرنامج وكلّم دكتور فوراً لو حصل: دوخة شديدة أو إغماء، خفقان في القلب، ألم في البطن أو الصدر، قيء مستمر، أو سكر الدم نزل/طلع بشكل غير طبيعي.',
    'Stop and contact a doctor immediately if you get: severe dizziness or fainting, palpitations, abdominal or chest pain, persistent vomiting, or abnormal blood sugar readings.',
  );

  static const doctorGate = L10nText(
    'بسبب إجاباتك في أسئلة الصحة، البرنامج ده محتاج موافقة دكتورك الأول. اعرضه عليه، ولو وافق أكّد هنا.',
    'Based on your health answers, this program needs your doctor’s approval first. Show it to your doctor and confirm here if they agree.',
  );

  static const doctorConfirm = L10nText(
    'أؤكد إن دكتوري راجع البرنامج ده ووافق عليه',
    'I confirm my doctor reviewed and approved this program',
  );

  static const minorGate = L10nText(
    'برامج التخسيس لأقل من 18 سنة لازم تكون تحت إشراف دكتور وولي أمر.',
    'Weight-loss programs for under-18s must be supervised by a doctor and a parent.',
  );

  static const floorNote = L10nText(
    'رفعنا سعراتك للحد الأدنى الآمن (1500) — أقل من كده محتاج إشراف طبي.',
    'We raised your calories to the safe minimum (1500) — going lower needs medical supervision.',
  );

  /// Health screening questions (one per [HealthCondition]).
  static const questions = <HealthCondition, L10nText>{
    HealthCondition.type1Diabetes: L10nText('عندك سكر من النوع الأول؟', 'Do you have type 1 diabetes?'),
    HealthCondition.diabetesOnMedication: L10nText('عندك سكر وبتاخد أنسولين أو أقراص للسكر؟', 'Do you have diabetes treated with insulin or tablets?'),
    HealthCondition.kidneyDisease: L10nText('عندك أي مرض في الكلى؟', 'Do you have any kidney disease?'),
    HealthCondition.liverDisease: L10nText('عندك مرض في الكبد (غير الدهون البسيطة)؟', 'Do you have liver disease (beyond mild fatty liver)?'),
    HealthCondition.pancreatitisOrGallbladder: L10nText('عندك أو كان عندك التهاب بنكرياس أو مشاكل في المرارة؟', 'Have you had pancreatitis or gallbladder problems?'),
    HealthCondition.heartDiseaseOrArrhythmia: L10nText('عندك مرض في القلب أو اضطراب في ضربات القلب؟', 'Do you have heart disease or an irregular heartbeat?'),
    HealthCondition.highCholesterolFamilial: L10nText('عندك كوليسترول عالي وراثي في العيلة؟', 'Do you have inherited (familial) high cholesterol?'),
    HealthCondition.bloodPressureMedication: L10nText('بتاخد أدوية ضغط أو مدرّات للبول؟', 'Do you take blood-pressure drugs or diuretics?'),
    HealthCondition.goutHistory: L10nText('عندك نقرس أو حمض يوريك عالي؟', 'Do you have gout or high uric acid?'),
    HealthCondition.eatingDisorderHistory: L10nText('عانيت قبل كده من اضطرابات أكل (زي الشره أو التقيؤ بعد الأكل)؟', 'Have you ever had an eating disorder (e.g. bingeing or purging)?'),
    HealthCondition.faintingOrLowBloodPressure: L10nText('بيحصلك إغماء أو ضغطك واطي غالباً؟', 'Do you faint or often have low blood pressure?'),
    HealthCondition.medicationWithFood: L10nText('بتاخد أدوية لازم تتاخد مع الأكل في مواعيد ثابتة؟', 'Do you take medicines that must be taken with food at fixed times?'),
  };
}
