import 'package:vireo/core/services/user_sex_provider.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/features/notifications/domain/notification_type.dart';

class NotificationMessage {
  const NotificationMessage({
    required this.title,
    required this.body,
    required this.payload,
  });

  final String title;
  final String body;
  final String payload;
}

abstract final class NotificationMessages {
  static NotificationMessage forType(
    NotificationType type, {
    required String localeCode,
    MealType? mealType,
    int? weeklyDeficitKcal,
  }) {
    // Standardize Arabic vs Egyptian Arabic
    final isArEg = localeCode == 'ar_EG' || localeCode == 'ar-EG';
    final isAr = localeCode.startsWith('ar');
    final isFemale = UserSexNotifier.isFemaleSaved();
    final champWord = isFemale ? 'بطلة' : 'بطل';

    return switch (type) {
      NotificationType.waterReminder => NotificationMessage(
          title: isAr
              ? (isArEg ? '💧 اشرب شوية مية' : '💧 اشرب ماء')
              : '💧 Water check',
          body: isAr
              ? (isArEg
                  ? 'كوباية مية هترطب جسمك وتصحصحك — متنساش نفسك.'
                  : 'وقت كوب ماء منعش — حافظ على ترطيب جسمك وطاقتك.')
              : 'Time for a fresh glass of water — stay hydrated and energized.',
          payload: 'vireo://quick_log/water',
        ),

      NotificationType.mealBreakfastReminder => NotificationMessage(
          title: isAr
              ? (isArEg ? '🍳 صباح الفل! وقت الفطار' : '🍳 صباح الخير! وقت الإفطار')
              : '🍳 Morning fuel! Breakfast time',
          body: isAr
              ? (isArEg
                  ? 'فطارك المتوازن هيديك طاقة تكمل بيها باقي اليوم.'
                  : 'ابدأ يومك بوجبة متوازنة تمنحك النشاط والحيوية.')
              : 'Start your day with a balanced meal to stay sharp and energized.',
          payload: 'vireo://nutrition/breakfast',
        ),

      NotificationType.mealLunchReminder => NotificationMessage(
          title: isAr
              ? (isArEg ? '🍛 وقت الغدا يا $champWord' : '🍛 وقت وجبة الغداء')
              : '🍛 Lunchtime fuel',
          body: isAr
              ? (isArEg
                  ? 'جدد طاقتك بوجبة غدا مغذية وكمل أهداف البروتين.'
                  : 'جدد طاقتك بوجبة غداء مغذية لدعم عضلاتك ويومك.')
              : 'Refuel with a nourishing lunch to keep your momentum going.',
          payload: 'vireo://nutrition/lunch',
        ),

      NotificationType.mealDinnerReminder => NotificationMessage(
          title: isAr
              ? (isArEg ? '🍽️ وقت العشا' : '🍽️ وقت وجبة العشاء')
              : '🍽️ Nourishing dinner',
          body: isAr
              ? (isArEg
                  ? 'عشا خفيف ومغذي يساعد جسمك يتعافى وأنت نايم.'
                  : 'عشاء خفيف ومغذٍ يساعد جسمك على التعافي أثناء النوم.')
              : 'A light, wholesome dinner to nourish and recover tonight.',
          payload: 'vireo://nutrition/dinner',
        ),

      NotificationType.fastingWindowOpenReminder => NotificationMessage(
          title: isAr
              ? (isArEg ? '✨ نافذة الأكل بدأت' : '✨ بدأت نافذة تناول الطعام')
              : '✨ Eating window open',
          body: isAr
              ? (isArEg
                  ? 'تقدر تبدأ وجباتك دلوقتي بهدوء وتستمتع بأكلك.'
                  : 'يمكنك الآن بدء وجباتك المتوازنة براحة واعتدال.')
              : 'Your eating window is now open — enjoy your nourishing meals mindfully.',
          payload: 'vireo://home/fasting',
        ),

      NotificationType.fastingWindowCloseReminder => NotificationMessage(
          title: isAr
              ? (isArEg ? '🌙 نافذة الأكل بتنتهي' : '🌙 نافذة الصيام تبدأ قريباً')
              : '🌙 Fasting window begins',
          body: isAr
              ? (isArEg
                  ? 'وقت الصيام هيبدأ — اشرب مية وريح جهازك الهضمي.'
                  : 'حان وقت إراحة جهازك الهضمي — اشرب ماء واستعد للنوم.')
              : 'Fasting window starts soon — hydrate well and let your body rest.',
          payload: 'vireo://home/fasting',
        ),

      NotificationType.workoutReminder => NotificationMessage(
          title: isAr
              ? (isArEg ? '🏋️ تمرينك قرب يا $champWord' : '🏋️ اقترب موعد تمرينك')
              : '🏋️ Workout time coming up',
          body: isAr
              ? (isArEg
                  ? 'نص ساعة وتمرينك يبدأ — جهز لبسك والمية وخليك جاهز.'
                  : '30 دقيقة تفصلك عن التمرين — جهّز نفسك واستمتع بحركتك اليوم.')
              : '30 minutes until workout — hydrate and get ready to move.',
          payload: 'vireo://workout/today',
        ),

      NotificationType.stepsNudgeReminder => NotificationMessage(
          title: isAr
              ? (isArEg ? '🚶‍♂️ نتمشى شوية سوا؟' : '🚶‍♂️ مشية خفيفة لتجديد طاقتك')
              : '🚶‍♂️ Time for a refreshing walk',
          body: isAr
              ? (isArEg
                  ? 'مشية ربع ساعة في الهوا هتجدد نشاطك وتقربك من هدف خطواتك.'
                  : 'مشية خفيفة لمدة 15 دقيقة ستنعش يومك وتقربك من هدفك.')
              : 'A gentle 15-minute walk will refresh your mind and boost your step goal.',
          payload: 'vireo://activity/steps',
        ),

      NotificationType.bedtimeReminder => NotificationMessage(
          title: isAr
              ? (isArEg ? '😴 وقت الراحة والنوم' : '😴 وقت الاسترخاء والنوم')
              : '😴 Wind down for sleep',
          body: isAr
              ? (isArEg
                  ? 'اطفي الشاشات واسترخي — نومك هو سر تعافيك وطاقتك بكرة.'
                  : 'ابتعد عن الشاشات واسترخِ — النوم العميق أساس تعافيك وصحتك.')
              : 'Dim the screens and unwind — quality sleep is the foundation of recovery.',
          payload: 'vireo://home/bedtime',
        ),

      NotificationType.weeklyCheckInReminder => NotificationMessage(
          title: isAr
              ? (isArEg ? '📊 تقريرك الأسبوعي جاهز' : '📊 تقريرك الأسبوعي')
              : '📊 Your weekly check-in',
          body: _weeklyBody(isAr, isArEg, weeklyDeficitKcal, champWord),
          payload: 'vireo://progress/weekly',
        ),

      NotificationType.weeklyWrappedReminder => NotificationMessage(
          title: isAr
              ? (isArEg ? '🎁 ملخص أسبوعك جاهز!' : '🎁 ملخص أسبوعك جاهز!')
              : '🎁 Your Weekly Wrapped is ready!',
          body: isAr
              ? (isArEg
                  ? 'شوف إنجازاتك في الخطوات والتمارين وحرق الدهون وشاركها مع أصحابك!'
                  : 'شاهد إنجازاتك في الخطوات والتمارين وحرق الدهون وشاركها!')
              : 'See your weekly steps, workouts, and fat burn milestones and share your story!',
          payload: 'vireo://progress/weekly_wrapped',
        ),

      NotificationType.streakProtectionReminder => NotificationMessage(
          title: isAr
              ? (isArEg ? '🔥 حافظ على سلسلتك الحلوة' : '🔥 حافظ على تقدمك اليومي')
              : '🔥 Protect today’s streak',
          body: isAr
              ? (isArEg
                  ? 'دقيقة واحدة تسجل فيها وجبة أو كوباية مية وهتفضل سلسلتك مستمرة.'
                  : 'دقيقة واحدة لتسجيل يومك تضمن استمرار تقدمك وسلسلتك.')
              : 'Just a quick tap to log water or a meal keeps your awesome streak going.',
          payload: 'vireo://diary/today',
        ),
    };
  }

  static String _weeklyBody(bool isAr, bool isArEg, int? kcal, [String champWord = 'بطل']) {
    if (kcal == null) {
      if (isAr) {
        return isArEg
            ? 'تعالى نلقي نظرة سريعة على إنجازاتك في الأسبوع اللي فات.'
            : 'ألقِ نظرة على إنجازاتك وتقدمك خلال الأسبوع الماضي.';
      }
      return 'Take a friendly look back at your progress this past week.';
    }
    if (kcal >= 0) {
      if (isAr) {
        return isArEg
            ? 'عجزك الأسبوعي: $kcal سعرة — عاش يا $champWord، خطوة رائعة لقدام!'
            : 'عجزك الأسبوعي: $kcal سعرة حرارية — أسبوع رائع من الالتزام!';
      }
      return 'Weekly deficit: $kcal kcal — fantastic consistency and dedication!';
    }
    if (isAr) {
      return isArEg
          ? 'فائضك الأسبوعي: ${kcal.abs()} سعرة — كل أسبوع فرصة جديدة وجميلة.'
          : 'فائضك الأسبوعي: ${kcal.abs()} سعرة حرارية — كل أسبوع بداية جديدة.';
    }
    return 'Weekly surplus: ${kcal.abs()} kcal — every week is a fresh opportunity to reset.';
  }
}
