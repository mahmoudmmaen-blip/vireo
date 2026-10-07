import 'package:vireo/features/vitality/data/vitality_articles_data.dart';
import 'package:vireo/features/vitality/domain/vitality_models.dart';

class VitalityContentRepository implements IVitalityContentRepository {
  const VitalityContentRepository();

  static final List<VitalityArticle> _articles = VitalityArticlesData.all();

  static const _tips = [
    VitalityTip(
      id: 'eggs_fats',
      textEn:
          'Include 3–4 eggs daily for healthy fats that may support hormone precursors.',
      textAr:
          'تناول 3–4 بيضات يومياً للدهون الصحية التي قد تدعم بناء الهرمونات.',
    ),
    VitalityTip(
      id: 'squat_deadlift',
      textEn:
          'Squats and deadlifts may support hormonal balance and physical performance.',
      textAr:
          'السكوات والديدليفت قد يدعمان التوازن الهرموني والأداء البدني.',
    ),
    VitalityTip(
      id: 'sleep_eight',
      textEn:
          'Aim for 8 hours of sleep — research suggests it supports recovery and energy.',
      textAr:
          'استهدف 8 ساعات نوم — الأبحاث تشير إلى أنها تدعم التعافي والطاقة.',
    ),
    VitalityTip(
      id: 'morning_sun',
      textEn:
          '10–20 minutes of morning sunlight may support vitamin D and circadian rhythm.',
      textAr:
          '10–20 دقيقة من ضوء الشمس الصباحي قد تدعم فيتامين D والإيقاع اليومي.',
    ),
    VitalityTip(
      id: 'breathing',
      textEn:
          'Two minutes of box breathing after training may help stress recovery.',
      textAr:
          'دقيقتان من تنفس الصندوق بعد التمرين قد تساعد على التعافي من الإجهاد.',
    ),
    VitalityTip(
      id: 'zinc_foods',
      textEn:
          'Pumpkin seeds and beef are zinc-rich foods that may support hormonal health.',
      textAr:
          'بذور اليقطين واللحم الأحمر غنية بالزنك وقد تدعمان الصحة الهرمونية.',
    ),
    VitalityTip(
      id: 'compound_lifts',
      textEn:
          'Compound lifts 3× weekly may support natural anabolic hormone responses.',
      textAr:
          'الرفعات المركبة 3 مرات أسبوعياً قد تدعم الاستجابات الهرمونية البنائية الطبيعية.',
    ),
    VitalityTip(
      id: 'cold_finish',
      textEn:
          'A 30-second cold shower finish may support recovery when used safely.',
      textAr:
          'إنهاء الدش بـ30 ثانية باردة قد يدعم التعافي عند الاستخدام الآمن.',
    ),
    VitalityTip(
      id: 'cruciferous',
      textEn:
          'Cruciferous vegetables may support healthy estrogen metabolism in men.',
      textAr:
          'الخضار الصليبية قد تدعم أيض الإستروجين الصحي لدى الرجال.',
    ),
  ];

  @override
  List<VitalityArticle> getArticles() => List.unmodifiable(_articles);

  int get articleCount => _articles.length;

  List<VitalityArticle> getArticlesByCategory(VitalityCategory category) {
    return _articles.where((a) => a.category == category).toList(growable: false);
  }

  @override
  VitalityArticle? getArticleById(String id) {
    for (final a in _articles) {
      if (a.id == id) return a;
    }
    return null;
  }

  @override
  List<VitalityTip> getDailyTips() => List.unmodifiable(_tips);

  @override
  VitalityTip tipForDay(DateTime date) {
    final tips = getDailyTips();
    if (tips.isEmpty) {
      return const VitalityTip(id: 'default', textEn: '', textAr: '');
    }
    final dayIndex = date.difference(DateTime(date.year)).inDays;
    return tips[dayIndex % tips.length];
  }
}
