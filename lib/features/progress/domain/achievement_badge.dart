import 'package:flutter/foundation.dart';
import 'package:vireo/core/services/hive_service.dart';

enum AchievementId {
  streak3('streak_3', 3),
  streak7('streak_7', 7),
  streak30('streak_30', 30),
  firstScan('first_scan', 1),
  workouts10('workouts_10', 10),
  steps100kWeek('steps_100k_week', 100000),
  proteinGoal7Days('protein_goal_7_days', 7);

  const AchievementId(this.id, this.targetValue);
  final String id;
  final int targetValue;

  static AchievementId? fromId(String id) {
    for (final a in AchievementId.values) {
      if (a.id == id) return a;
    }
    return null;
  }
}

@immutable
class AchievementBadge {
  const AchievementBadge({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.descEn,
    required this.descAr,
    required this.icon,
    required this.isUnlocked,
    this.unlockedAt,
    this.progress = 0.0,
  });

  final AchievementId id;
  final String titleEn;
  final String titleAr;
  final String descEn;
  final String descAr;
  final String icon;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final double progress; // 0.0 to 1.0

  String title(String languageCode) => languageCode.startsWith('ar') ? titleAr : titleEn;
  String desc(String languageCode) => languageCode.startsWith('ar') ? descAr : descEn;
}

class ProgressBadgeCatalog {
  static const badges = <AchievementId, ({String titleEn, String titleAr, String descEn, String descAr, String icon})>{
    AchievementId.streak3: (
      titleEn: '3-Day Streak',
      titleAr: 'استمرار ٣ أيام',
      descEn: 'Log activity or nutrition 3 days in a row',
      descAr: 'سجّل التغذية أو النشاط ٣ أيام متتالية',
      icon: '🔥',
    ),
    AchievementId.streak7: (
      titleEn: '7-Day Momentum',
      titleAr: 'زخم ٧ أيام',
      descEn: 'Consistent healthy habits for a full week',
      descAr: 'التزام كامل وعادات صحية لأسبوع متواصل',
      icon: '⚡',
    ),
    AchievementId.streak30: (
      titleEn: '30-Day Master',
      titleAr: 'سيد الالتزام ٣٠ يوم',
      descEn: 'One full month of dedication and growth',
      descAr: 'شهر كامل من الانضباط والتحول الحقيقي',
      icon: '👑',
    ),
    AchievementId.firstScan: (
      titleEn: 'First Scan',
      titleAr: 'أول فحص ذكي',
      descEn: 'Scan your first meal or InBody report',
      descAr: 'قم بفحص أول وجبة أو تقرير إن بادي بالذكاء الاصطناعي',
      icon: '📸',
    ),
    AchievementId.workouts10: (
      titleEn: '10 Workouts',
      titleAr: '١٠ تمارين مكتملة',
      descEn: 'Crush 10 complete training sessions',
      descAr: 'أكملت ١٠ حصص تدريبية بنجاح',
      icon: '💪',
    ),
    AchievementId.steps100kWeek: (
      titleEn: '100k Steps Week',
      titleAr: '١٠٠ ألف خطوة بأسبوع',
      descEn: 'Walk over 100,000 steps in 7 days',
      descAr: 'تجاوزت حاجز ١٠٠,٠٠٠ خطوة خلال أسبوع واحد',
      icon: '👟',
    ),
    AchievementId.proteinGoal7Days: (
      titleEn: 'Protein Power 7D',
      titleAr: 'بطل البروتين ٧ أيام',
      descEn: 'Hit your daily protein target 7 days in total',
      descAr: 'حققت هدف البروتين اليومي لـ ٧ أيام',
      icon: '🥩',
    ),
  };

  static const _boxKey = 'progress_unlocked_badges';

  static Set<String> readUnlocked() {
    if (!HiveService.isInitialized) return {};
    final list = HiveService.cacheBox.get(_boxKey);
    if (list is List) {
      return list.map((e) => e.toString()).toSet();
    }
    return {};
  }

  static Future<void> saveUnlocked(Set<String> unlocked) async {
    if (!HiveService.isInitialized) return;
    await HiveService.cacheBox.put(_boxKey, unlocked.toList());
  }
}
