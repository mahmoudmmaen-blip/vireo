import 'package:vireo/data/demo/exercise_demo_catalog.dart';
import 'package:vireo/features/workout/domain/exercise_detail.dart';
import 'package:vireo/features/workout/domain/exercise_media.dart';

/// Offline catalog of 50+ exercises with bilingual coaching content.
abstract final class ExerciseDetailCatalog {
  static final List<ExerciseDetail> all = [
    ...ExerciseDemoCatalog.seedRows.map(_fromDemoRow),
    ..._extraCompoundLifts,
  ];

  static ExerciseDetail? byId(String id) {
    for (final e in all) {
      if (e.id == id) return e;
    }
    return null;
  }

  static ExerciseDetail _fromDemoRow(Map<String, dynamic> row) {
    final name = row['name'] as String;
    final muscle = row['target_muscle'] as String;
    final media = ExerciseMediaResolver.resolve(row['id'] as String);
    final diff = _difficulty(row['difficulty'] as String? ?? 'beginner');
    final compound = _isCompound(name, muscle);

    return ExerciseDetail(
      id: row['id'] as String,
      name: name,
      nameAr: row['name_ar'] as String? ?? name,
      muscleGroups: [_normalizeMuscle(muscle)],
      secondaryMuscles: _secondaryFor(muscle, name),
      instructions: _instructions(name, muscle),
      commonMistakes: _mistakes(name),
      tips: _tips(name, muscle),
      equipment: _equipment(name, row),
      difficulty: diff,
      mediaPath: media.path,
      mediaType: media.type,
      targetSets: row['sets'] as int? ?? 3,
      targetReps: row['reps'] as int? ?? 10,
      restSeconds: row['rest_seconds'] as int? ?? 60,
      isCompound: compound,
      vitalityBoost: compound,
    );
  }

  static final List<ExerciseDetail> _extraCompoundLifts = [
    _compound(
      id: 'vireo-ex-barbell-squat',
      name: 'Barbell Back Squat',
      nameAr: 'سكوات بالبار',
      muscles: ['quads', 'glutes'],
      secondary: ['core', 'hamstrings'],
      slug: 'squat',
      sets: 4,
      reps: 8,
      rest: 90,
    ),
    _compound(
      id: 'vireo-ex-conventional-deadlift',
      name: 'Conventional Deadlift',
      nameAr: 'ديدليفت تقليدي',
      muscles: ['hamstrings', 'glutes'],
      secondary: ['back', 'core'],
      slug: 'deadlift',
      sets: 4,
      reps: 6,
      rest: 120,
    ),
    _compound(
      id: 'vireo-ex-barbell-ohp',
      name: 'Barbell Overhead Press',
      nameAr: 'ضغط كتف بالبار',
      muscles: ['shoulders'],
      secondary: ['triceps', 'core'],
      slug: 'overhead_press',
      sets: 4,
      reps: 8,
      rest: 90,
    ),
    _compound(
      id: 'vireo-ex-barbell-row',
      name: 'Barbell Bent-over Row',
      nameAr: 'روينج بالبار',
      muscles: ['back'],
      secondary: ['biceps', 'core'],
      slug: 'row',
      sets: 4,
      reps: 10,
      rest: 75,
    ),
    _compound(
      id: 'vireo-ex-romanian-deadlift',
      name: 'Romanian Deadlift',
      nameAr: 'ديدليفت روماني',
      muscles: ['hamstrings', 'glutes'],
      secondary: ['back'],
      slug: 'deadlift',
      sets: 3,
      reps: 10,
      rest: 75,
    ),
    _compound(
      id: 'vireo-ex-incline-bench',
      name: 'Incline Bench Press',
      nameAr: 'بنش مائل',
      muscles: ['chest'],
      secondary: ['shoulders', 'triceps'],
      slug: 'bench_press',
      sets: 4,
      reps: 8,
      rest: 90,
    ),
    _compound(
      id: 'vireo-ex-hip-thrust',
      name: 'Barbell Hip Thrust',
      nameAr: 'هيب ثرست',
      muscles: ['glutes'],
      secondary: ['hamstrings', 'core'],
      slug: 'squat',
      sets: 4,
      reps: 12,
      rest: 60,
    ),
    _compound(
      id: 'vireo-ex-front-squat',
      name: 'Front Squat',
      nameAr: 'سكوات أمامي',
      muscles: ['quads'],
      secondary: ['core', 'glutes'],
      slug: 'squat',
      sets: 4,
      reps: 8,
      rest: 90,
    ),
    _compound(
      id: 'vireo-ex-chin-up',
      name: 'Chin-up',
      nameAr: 'عقلة قبضة',
      muscles: ['back', 'biceps'],
      secondary: ['core'],
      slug: 'pullup',
      sets: 3,
      reps: 8,
      rest: 90,
    ),
    _compound(
      id: 'vireo-ex-walking-lunge',
      name: 'Walking Lunge',
      nameAr: 'لانج مشي',
      muscles: ['quads', 'glutes'],
      secondary: ['core'],
      slug: 'lunge',
      sets: 3,
      reps: 12,
      rest: 60,
    ),
    _compound(
      id: 'vireo-ex-farmer-walk',
      name: 'Farmer Walk',
      nameAr: 'مشي المزارع',
      muscles: ['core'],
      secondary: ['shoulders'],
      slug: 'row',
      sets: 3,
      reps: 40,
      rest: 60,
      diff: ExerciseDifficulty.intermediate,
    ),
    _compound(
      id: 'vireo-ex-t-bar-row',
      name: 'T-Bar Row',
      nameAr: 'رو T بار',
      muscles: ['back'],
      secondary: ['biceps'],
      slug: 'row',
      sets: 4,
      reps: 10,
      rest: 75,
    ),
    _compound(
      id: 'vireo-ex-leg-press-compound',
      name: 'Leg Press (Compound)',
      nameAr: 'ليج برس مركب',
      muscles: ['quads', 'glutes'],
      secondary: ['hamstrings'],
      slug: 'squat',
      sets: 4,
      reps: 12,
      rest: 75,
    ),
    _compound(
      id: 'vireo-ex-push-press',
      name: 'Push Press',
      nameAr: 'ضغط اندفاعي',
      muscles: ['shoulders'],
      secondary: ['triceps', 'quads'],
      slug: 'overhead_press',
      sets: 4,
      reps: 6,
      rest: 90,
      diff: ExerciseDifficulty.advanced,
    ),
    _compound(
      id: 'vireo-ex-sumo-deadlift',
      name: 'Sumo Deadlift',
      nameAr: 'ديدليفت سومو',
      muscles: ['glutes', 'quads'],
      secondary: ['back', 'hamstrings'],
      slug: 'deadlift',
      sets: 4,
      reps: 6,
      rest: 120,
      diff: ExerciseDifficulty.advanced,
    ),
  ];

  static ExerciseDetail _compound({
    required String id,
    required String name,
    required String nameAr,
    required List<String> muscles,
    required List<String> secondary,
    required String slug,
    required int sets,
    required int reps,
    required int rest,
    ExerciseDifficulty diff = ExerciseDifficulty.intermediate,
  }) {
    final mediaType = ExerciseMediaResolver.mediaTypeForSlug(slug);
    return ExerciseDetail(
      id: id,
      name: name,
      nameAr: nameAr,
      muscleGroups: muscles,
      secondaryMuscles: secondary,
      instructions: _instructions(name, muscles.first),
      commonMistakes: _mistakes(name),
      tips: _tips(name, muscles.first),
      equipment: const ['Barbell', 'Rack'],
      difficulty: diff,
      mediaPath: ExerciseMediaResolver.assetPathForSlug(slug, mediaType),
      mediaType: mediaType,
      targetSets: sets,
      targetReps: reps,
      restSeconds: rest,
      isCompound: true,
      vitalityBoost: true,
    );
  }

  static ExerciseDifficulty _difficulty(String raw) {
    return switch (raw) {
      'advanced' => ExerciseDifficulty.advanced,
      'moderate' || 'intermediate' => ExerciseDifficulty.intermediate,
      _ => ExerciseDifficulty.beginner,
    };
  }

  static String _normalizeMuscle(String muscle) {
    return switch (muscle) {
      'posterior_chain' => 'hamstrings',
      'legs' => 'quads',
      'full_body' => 'core',
      _ => muscle,
    };
  }

  static List<String> _secondaryFor(String muscle, String name) {
    final lower = name.toLowerCase();
    if (lower.contains('squat') || muscle == 'legs') {
      return const ['glutes', 'core'];
    }
    if (lower.contains('press') && muscle == 'chest') {
      return const ['shoulders', 'triceps'];
    }
    if (lower.contains('row') || muscle == 'back') {
      return const ['biceps', 'core'];
    }
    if (lower.contains('curl')) return const ['forearms'];
    if (muscle == 'core') return const ['hip_flexors'];
    return const [];
  }

  static bool _isCompound(String name, String muscle) {
    const compounds = [
      'squat',
      'deadlift',
      'press',
      'row',
      'pull',
      'lunge',
      'burpee',
      'thrust',
      'swing',
    ];
    final n = name.toLowerCase();
    return compounds.any(n.contains) || muscle == 'full_body';
  }

  static List<String> _equipment(String name, Map<String, dynamic> row) {
    final envs = (row['environments'] as List?)?.cast<String>() ?? [];
    if (envs.contains('home_no_equipment')) return const ['Bodyweight'];
    if (envs.contains('home_light_equipment')) {
      return const ['Dumbbells'];
    }
    if (name.toLowerCase().contains('barbell')) {
      return const ['Barbell', 'Rack'];
    }
    return const ['Gym machine'];
  }

  static List<String> _instructions(String name, String muscle) {
    return [
      'Warm up 5 minutes and activate $muscle with light reps.',
      'Set a stable base — brace your core before each rep of $name.',
      'Move through full range with control; avoid bouncing at the bottom.',
      'Exhale on the effort phase; inhale on the return.',
      'Rest the prescribed time and maintain form on every set.',
    ];
  }

  static List<String> _mistakes(String name) {
    return [
      'Using momentum instead of muscle control during $name.',
      'Letting your lower back round or arch excessively.',
      'Holding your breath through the entire rep — breathe rhythmically.',
    ];
  }

  static List<String> _tips(String name, String muscle) {
    return [
      'Focus on mind-muscle connection in the $muscle.',
      'Increase load only when you can complete all reps with perfect form.',
      'Pair $name with adequate protein to support recovery.',
    ];
  }

  /// Breathing cue tailored to exercise mechanics and localized.
  static String breathingCueFor(String id, String name, String locale) {
    final lower = name.toLowerCase();
    final isArEg = locale == 'ar_EG';
    final isAr = locale.startsWith('ar');

    if (lower.contains('plank') || lower.contains('hold')) {
      if (isArEg) return 'اتنفس براحة وبانتظام وماتكتمش نفسك أبداً طول ما عضلات بطنك شادة.';
      if (isAr) return 'تنفس بعمق وبانتظام ولا تحبس أنفاسك أثناء شد عضلات البطن.';
      return 'Breathe steadily and deeply — avoid holding your breath while bracing.';
    }
    if (lower.contains('squat') || lower.contains('press') || lower.contains('push-up') || lower.contains('dips')) {
      if (isArEg) return 'خد نفس عميق وأنت نازل، واطلع بالنفس بقوة وأنت بتزق لفوق.';
      if (isAr) return 'استنشق بعمق أثناء النزول، وازفر بقوة أثناء الدفع لأعلى.';
      return 'Inhale deeply as you lower down, then exhale forcefully as you drive up.';
    }
    if (lower.contains('deadlift') || lower.contains('row') || lower.contains('pull') || lower.contains('curl')) {
      if (isArEg) return 'خد نفس وأنت بتثبت جسمك، وازفر وأنت بتسحب الوزن ناحيتك.';
      if (isAr) return 'استنشق أثناء التثبيت، وازفر بقوة أثناء سحب الوزن.';
      return 'Inhale to brace your trunk, then exhale as you pull the load.';
    }
    if (isArEg) return 'اتنفس برتم مظبوط: شهيق مع الرجوع وزفير مع المجهود.';
    if (isAr) return 'تنفس بانتظام: شهيق مع مرحلة الرجوع وزفير مع المجهود.';
    return 'Maintain a controlled breathing cadence: inhale on the eccentric, exhale on exertion.';
  }

  /// Easier progressive regression for beginner scaling.
  static String easierVariationFor(String id, String name, String locale) {
    final lower = name.toLowerCase();
    final isArEg = locale == 'ar_EG';
    final isAr = locale.startsWith('ar');

    if (lower.contains('push-up') || lower.contains('ضغط')) {
      if (isArEg) return 'ضغط على الركبتين أو على حرف كنبة أو ترابيزة مرتفعة.';
      if (isAr) return 'تمرين الضغط على الركبتين أو بالاستناد على سطح مرتفع.';
      return 'Incline push-ups against a bench or knee-supported push-ups.';
    }
    if (lower.contains('pull-up') || lower.contains('عقلة')) {
      if (isArEg) return 'استخدم أستك مقاومة تحت رجلك أو ابدأ بنزول بطيء (Negative pull-ups).';
      if (isAr) return 'استخدم حزام المقاومة أو ركّز على مرحلة الهبوط التدريجي.';
      return 'Resistance band assisted pull-ups or eccentric slow-lowering reps.';
    }
    if (lower.contains('squat') || lower.contains('سكوات')) {
      if (isArEg) return 'سكوات على كرسي (Box Squat) بلمسة خفيفة للمقعد والوقوف.';
      if (isAr) return 'سكوات إلى كرسي مع لمس المقعد والنهوض.';
      return 'Box squats onto a bench or chair with bodyweight.';
    }
    if (lower.contains('burpee')) {
      if (isArEg) return 'خطوة بخطوة من غير نطة ومن غير لمس الصدر للأرض.';
      if (isAr) return 'أداء الحركة خطوة بخطوة بدون قفزة وبدون نزول الصدر.';
      return 'Step-back burpees without the push-up or jump.';
    }
    if (lower.contains('plank') || lower.contains('بلانك')) {
      if (isArEg) return 'بلانك على الكوع والركبتين بدل مشط الرجل.';
      if (isAr) return 'بلانك مع الارتكاز على الركبتين.';
      return 'Knee plank on forearms to build initial core endurance.';
    }
    if (isArEg) return 'قلل الوزن أو المدى الحركي وركّز على التكنيك الصح.';
    if (isAr) return 'تقليل الوزن أو مدى الحركة للتركيز على الأداء السليم.';
    return 'Reduce the load or range of motion to master proper mechanics.';
  }

  /// Harder progressive overload variation.
  static String harderVariationFor(String id, String name, String locale) {
    final lower = name.toLowerCase();
    final isArEg = locale == 'ar_EG';
    final isAr = locale.startsWith('ar');

    if (lower.contains('push-up') || lower.contains('ضغط')) {
      if (isArEg) return 'ضغط برجلين مرفوعين على دكة (Decline) أو ثبات ثانيتين تحت.';
      if (isAr) return 'ضغط مع رفع القدمين أو ثبات لثانيتين في القاع.';
      return 'Feet-elevated decline push-ups or pause at the bottom.';
    }
    if (lower.contains('pull-up') || lower.contains('عقلة')) {
      if (isArEg) return 'عقلة بوزن إضافي أو ثبات 3 ثواني فوق مع لمس الصدر للبار.';
      if (isAr) return 'عقلة بأوزان إضافية أو ثبات 3 ثوانٍ في الأعلى.';
      return 'Weighted pull-ups or chest-to-bar pauses for 3 seconds.';
    }
    if (lower.contains('squat') || lower.contains('سكوات')) {
      if (isArEg) return 'سكوات بثبات ثانيتين في القاع أو سكوات برجل واحدة (Pistol).';
      if (isAr) return 'سكوات مع التوقف لثانيتين بالأسفل أو سكوات بساق واحدة.';
      return 'Pause squats (2-sec pause at depth) or single-leg pistol squats.';
    }
    if (lower.contains('plank') || lower.contains('بلانك')) {
      if (isArEg) return 'بلانك مع رفع رجل واحدة بالتناوب أو بلانك ديناميكي.';
      if (isAr) return 'بلانك مع رفع ساق بالتناوب أو التبديل للساعد والكف.';
      return 'Single-leg elevated plank or walking plank transfers.';
    }
    if (isArEg) return 'زود زمن الشد (Tempo بطيء: 3 ثواني نزول) أو زود الوزن.';
    if (isAr) return 'زيادة وقت التوتر العضلي (3 ثوانٍ نزول) أو زيادة الحمل.';
    return 'Increase time-under-tension (3-second eccentric tempo) or add weight.';
  }

  /// Safety precautions and joint protection.
  static String safetyNoteFor(String id, String name, String locale) {
    final lower = name.toLowerCase();
    final isArEg = locale == 'ar_EG';
    final isAr = locale.startsWith('ar');

    if (lower.contains('deadlift') || lower.contains('ديدليفت')) {
      if (isArEg) return 'حافظ على استقامة ضهرك وماتقوسش أبداً. البار دايماً قريب من قصبة رجلك.';
      if (isAr) return 'حافظ على استقامة العمود الفقري وتجنب تقوس أسفل الظهر. أبقِ الثقل قريباً من الساق.';
      return 'Keep your spine neutral and never round your lower back. Keep the bar close to your shins.';
    }
    if (lower.contains('squat') || lower.contains('سكوات') || lower.contains('lunge') || lower.contains('لانج')) {
      if (isArEg) return 'ماتخليش ركبك تضم لجوه وأنت طالع، وركز إن كعب رجلك ثابت على الأرض.';
      if (isAr) return 'تجنب انحناء الركبتين للداخل أثناء الصعود، وثبت الكعبين بإحكام على الأرض.';
      return 'Avoid letting knees cave inward upon ascent; distribute weight firmly across the midfoot and heel.';
    }
    if (lower.contains('press') || lower.contains('بنش') || lower.contains('كتف')) {
      if (isArEg) return 'ثبت كتافك لورا وماتقفلش كوعك للآخر في قمة الحركة لحماية المفاصل.';
      if (isAr) return 'اسحب لوحي الكتف للخلف وتجنب قفل مفصل الكوع بالكامل في القمة لحماية المفصل.';
      return 'Retract your scapulae and avoid aggressive lockout at the top to protect the elbow joint.';
    }
    if (isArEg) return 'لو حسيت بأي وخز أو وجع في المفاصل وقف فوراً، الألم العضلي طبيعي لكن وجع المفاصل خطر.';
    if (isAr) return 'إذا شعرت بألم حاد في المفاصل توقف فوراً. إجهاد العضلة طبيعي أما ألم المفصل فيتطلب إيقاف الحركة.';
    return 'Stop immediately if you experience sharp joint pain. Muscular fatigue is normal, but joint pain is a warning signal.';
  }
}
