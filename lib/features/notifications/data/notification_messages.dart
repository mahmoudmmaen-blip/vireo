import 'package:vireo/features/notifications/domain/notification_type.dart';

class NotificationMessage {
  const NotificationMessage({required this.title, required this.body});

  final String title;
  final String body;
}

abstract final class NotificationMessages {
  static NotificationMessage forType(
    NotificationType type, {
    required String localeCode,
    int? weeklyDeficitKcal,
  }) {
    final isAr = localeCode == 'ar';
    return switch (type) {
      NotificationType.waterReminder => NotificationMessage(
          title: isAr ? '💧 اشرب ماء' : '💧 Hydration check',
          body: isAr
              ? 'حان وقت كوب ماء — حافظ على ترطيب جسمك.'
              : 'Time for a glass of water — stay hydrated.',
        ),
      NotificationType.breakfastReminder => NotificationMessage(
          title: isAr ? '🍳 وقت الإفطار' : '🍳 Breakfast time',
          body: isAr
              ? 'ابدأ يومك بوجبة متوازنة.'
              : 'Start your day with a balanced meal.',
        ),
      NotificationType.lunchReminder => NotificationMessage(
          title: isAr ? '🍛 وقت الغداء' : '🍛 Lunch time',
          body: isAr
              ? 'لا تنسَ تناول غدائك وتحقيق أهداف البروتين.'
              : 'Fuel up — keep your protein on track.',
        ),
      NotificationType.dinnerReminder => NotificationMessage(
          title: isAr ? '🍽️ وقت العشاء' : '🍽️ Dinner time',
          body: isAr
              ? 'خطّط لعشاء خفيف ومغذٍ قبل النوم.'
              : 'Plan a light, nourishing dinner.',
        ),
      NotificationType.preWorkoutReminder => NotificationMessage(
          title: isAr ? '🏋️ التمرين قريب' : '🏋️ Workout soon',
          body: isAr
              ? '30 دقيقة حتى تمرينك — جهّز نفسك واشرب ماء.'
              : '30 minutes until your workout — hydrate and get ready.',
        ),
      NotificationType.sleepReminder => NotificationMessage(
          title: isAr ? '😴 وقت النوم' : '😴 Bedtime reminder',
          body: isAr
              ? '22:30 — ابدأ روتين النوم للتعافي الأمثل.'
              : 'Wind down for quality sleep and recovery.',
        ),
      NotificationType.weeklyReportReminder => NotificationMessage(
          title: isAr ? '📊 تقريرك الأسبوعي' : '📊 Weekly report',
          body: _weeklyBody(isAr, weeklyDeficitKcal),
        ),
    };
  }

  static String _weeklyBody(bool isAr, int? kcal) {
    if (kcal == null) {
      return isAr
          ? 'راجع تقدمك الأسبوعي في Vireo.'
          : 'Review your weekly progress in Vireo.';
    }
    if (kcal >= 0) {
      return isAr
          ? 'عجزك الأسبوعي: $kcal kcal — أسبوع قوي!'
          : 'Weekly deficit: $kcal kcal — strong week!';
    }
    return isAr
        ? 'فائضك الأسبوعي: ${kcal.abs()} kcal — راجع خطتك.'
        : 'Weekly surplus: ${kcal.abs()} kcal — review your plan.';
  }
}
