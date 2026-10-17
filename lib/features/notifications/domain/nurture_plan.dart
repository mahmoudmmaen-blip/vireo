import 'package:flutter/foundation.dart';
import 'package:vireo/core/services/install_date.dart';
import 'package:vireo/features/notifications/domain/reminder_scheduler.dart';

/// What each nurture notification is about (P40 §7, "Day 0–7 plan").
enum NurtureKind {
  weightLog,
  repeatMeal,
  burnBalance,
  fastingIntro,
  fingerprint,
  shareCard,
  weeklySummary,
}

/// Title + body ready to show.
@immutable
class NurtureText {
  const NurtureText({required this.title, required this.body});

  final String title;
  final String body;
}

/// Masculine / feminine variants of one Arabic string.
/// When both are identical the text is gender-neutral.
@immutable
class GenderedText {
  const GenderedText(this.masculine, [String? feminine])
      : feminine = feminine ?? masculine;

  final String masculine;
  final String feminine;

  String resolve({required bool isFemale}) => isFemale ? feminine : masculine;
}

/// One step of the first-week plan.
@immutable
class NurtureStep {
  const NurtureStep({
    required this.day,
    required this.kind,
    required this.payload,
    required this.defaultMinutes,
    required this.titleAr,
    required this.bodyAr,
    required this.titleEn,
    required this.bodyEn,
    this.requiresGoalHit = false,
    this.ramadanTitleAr,
    this.ramadanBodyAr,
    this.ramadanTitleEn,
    this.ramadanBodyEn,
  });

  /// Days after the first open (1..7).
  final int day;
  final NurtureKind kind;

  /// Deep link handled by the notification tap router.
  final String payload;

  /// Default local time of day, in minutes since midnight.
  final int defaultMinutes;

  /// D6 (share card) only fires when the user actually hit a goal.
  final bool requiresGoalHit;

  final GenderedText titleAr;
  final GenderedText bodyAr;
  final String titleEn;
  final String bodyEn;

  /// Optional Ramadan variant (D4 fasting intro becomes a Ramadan welcome).
  final GenderedText? ramadanTitleAr;
  final GenderedText? ramadanBodyAr;
  final String? ramadanTitleEn;
  final String? ramadanBodyEn;
}

/// The first-week "nurture" plan: copy + the rules for WHEN each message goes out.
///
/// Copy rules (AGENTS.md §3.7): warm Egyptian Arabic, gender-aware, never
/// blaming, no Latin words in Arabic text.
abstract final class NurturePlan {
  static const int firstDay = 1;
  static const int lastDay = 7;

  /// Local-notification id range reserved for nurture messages (7001..7007).
  /// The regular reminder scheduler must never cancel these.
  static const int idBase = 7000;
  static const int idMin = idBase + firstDay;
  static const int idMax = idBase + lastDay;

  static int notificationId(int day) => idBase + day;

  /// True while nurture messages are still pending for this install
  /// (install day … day 7). The regular reminder scheduler then keeps one
  /// of the user's daily slots free so the total never exceeds the daily cap.
  static bool isActiveWindow(DateTime installDate, DateTime now) =>
      InstallDate.dayAge(installDate, now) <= lastDay;

  static bool isNurtureId(int id) => id >= idMin && id <= idMax;

  /// Minimum distance kept from the quiet-hours edges when shifting a message.
  static const int quietEdgeMarginMinutes = 30;

  static const List<NurtureStep> steps = [
    // D1: weight-log prompt (morning weigh-in).
    NurtureStep(
      day: 1,
      kind: NurtureKind.weightLog,
      payload: 'vireo://progress/weight',
      defaultMinutes: 8 * 60 + 30,
      titleAr: GenderedText('صباح الخير يا بطل ☀️', 'صباح الخير يا بطلة ☀️'),
      bodyAr: GenderedText(
        'خد ثانيتين وسجّل وزنك النهارده — بيه بنظبط خطتك على مقاسك.',
        'خدي ثانيتين وسجّلي وزنك النهارده — بيه بنظبط خطتك على مقاسك.',
      ),
      titleEn: 'Good morning ☀️',
      bodyEn: 'Take two seconds to log your weight today — it tunes your plan to you.',
    ),
    // D2: repeat-meal tip.
    NurtureStep(
      day: 2,
      kind: NurtureKind.repeatMeal,
      payload: 'vireo://nutrition/lunch',
      defaultMinutes: 12 * 60 + 40,
      titleAr: GenderedText('وفّر وقتك 😊'),
      bodyAr: GenderedText(
        'لو أكلتك النهارده زي امبارح، دوس "زي امبارح" وخلّصها في تانيتين.',
        'لو أكلتك النهارده زي امبارح، دوسي "زي امبارح" وخلّصيها في تانيتين.',
      ),
      titleEn: 'Save your time 😊',
      bodyEn: 'Eating the same as yesterday? Tap "Same as yesterday" and you are done in two taps.',
    ),
    // D3: first Burn Balance teaser.
    NurtureStep(
      day: 3,
      kind: NurtureKind.burnBalance,
      payload: 'vireo://home/burn_balance',
      defaultMinutes: 17 * 60 + 30,
      titleAr: GenderedText('رصيد حرقك بيكبر 🔥'),
      bodyAr: GenderedText(
        'خطواتك النهارده شغّالة لحسابك. تعالى شوف رصيدك لحد دلوقتي.',
        'خطواتك النهارده شغّالة لحسابك. تعالي شوفي رصيدك لحد دلوقتي.',
      ),
      titleEn: 'Your burn balance is growing 🔥',
      bodyEn: 'Your steps are working for you today. Come see your balance so far.',
    ),
    // D4: fasting intro (Ramadan variant when Ramadan mode is on).
    NurtureStep(
      day: 4,
      kind: NurtureKind.fastingIntro,
      payload: 'vireo://home/fasting',
      defaultMinutes: 11 * 60,
      titleAr: GenderedText('جرّب الصيام براحتك ⏳'),
      bodyAr: GenderedText(
        'من غير ضغط — نافذة أكل مريحة تناسب يومك. عايز تشوفها؟',
        'من غير ضغط — نافذة أكل مريحة تناسب يومك. عايزة تشوفيها؟',
      ),
      titleEn: 'Try fasting at your own pace ⏳',
      bodyEn: 'No pressure — a comfortable eating window that fits your day. Want a look?',
      ramadanTitleAr: GenderedText('رمضان كريم 🌙'),
      ramadanBodyAr: GenderedText(
        'تابع فطارك وسحورك معانا من غير تعقيد — مواعيد الأذان جاهزة.',
        'تابعي فطارك وسحورك معانا من غير تعقيد — مواعيد الأذان جاهزة.',
      ),
      ramadanTitleEn: 'Ramadan Kareem 🌙',
      ramadanBodyEn: 'Track iftar and suhoor with us, no fuss — prayer times are ready.',
    ),
    // D5: first "بصمتك" insight.
    NurtureStep(
      day: 5,
      kind: NurtureKind.fingerprint,
      payload: 'vireo://progress/fingerprint',
      defaultMinutes: 19 * 60 + 30,
      titleAr: GenderedText('بصمتك الأولى جاهزة ✨'),
      bodyAr: GenderedText(
        'بقالك كام يوم بتسجّل وبدأنا نشوف نمط أكلك. تعالى شوف أول بصمة ليك.',
        'بقالك كام يوم بتسجّلي وبدأنا نشوف نمط أكلك. تعالي شوفي أول بصمة ليكي.',
      ),
      titleEn: 'Your first fingerprint is ready ✨',
      bodyEn: 'A few days of logging and we can see your eating pattern. Come take a look.',
    ),
    // D6: share card — ONLY when a goal was hit.
    NurtureStep(
      day: 6,
      kind: NurtureKind.shareCard,
      payload: 'vireo://progress/weekly_share',
      defaultMinutes: 20 * 60,
      requiresGoalHit: true,
      titleAr: GenderedText('حقّقت هدفك — عاش! 🎉', 'حقّقتي هدفك — عاش! 🎉'),
      bodyAr: GenderedText(
        'كارت أسبوعك جاهز. لو حابب تشاركه مع صحابك، هو تحت إيدك.',
        'كارت أسبوعك جاهز. لو حابة تشاركيه مع صحابك، هو تحت إيدك.',
      ),
      titleEn: 'You hit your goal — well done! 🎉',
      bodyEn: 'Your weekly card is ready. Share it with friends if you like.',
    ),
    // D7: weekly summary.
    NurtureStep(
      day: 7,
      kind: NurtureKind.weeklySummary,
      payload: 'vireo://progress/weekly',
      defaultMinutes: 10 * 60,
      titleAr: GenderedText('أسبوعك الأول خلص 💪'),
      bodyAr: GenderedText(
        'شوف ملخّص أسبوعك — كل خطوة فيه كانت إضافة ليك.',
        'شوفي ملخّص أسبوعك — كل خطوة فيه كانت إضافة ليكي.',
      ),
      titleEn: 'Your first week is done 💪',
      bodyEn: 'See your weekly summary — every step in it was a win.',
    ),
  ];

  static NurtureStep? forDay(int day) {
    for (final s in steps) {
      if (s.day == day) return s;
    }
    return null;
  }

  /// Renders the copy for [step].
  /// Arabic locales get gendered Egyptian copy; everything else gets English.
  static NurtureText resolve(
    NurtureStep step, {
    required String localeCode,
    required bool isFemale,
    bool isRamadan = false,
  }) {
    final isAr = localeCode.startsWith('ar');
    final useRamadan = isRamadan && step.ramadanTitleAr != null;
    if (isAr) {
      final title = useRamadan ? step.ramadanTitleAr! : step.titleAr;
      final body = useRamadan ? step.ramadanBodyAr! : step.bodyAr;
      return NurtureText(
        title: title.resolve(isFemale: isFemale),
        body: body.resolve(isFemale: isFemale),
      );
    }
    return NurtureText(
      title: useRamadan ? step.ramadanTitleEn! : step.titleEn,
      body: useRamadan ? step.ramadanBodyEn! : step.bodyEn,
    );
  }

  // ── WHEN to schedule ─────────────────────────────────────────────────────

  /// Preferred time of day (minutes since midnight) for [step].
  ///
  /// - Adaptive: D2 lands ~20 min before the user's usual lunch log, D5 ~30 min
  ///   after their usual dinner log (clamped to sensible hours).
  /// - Ramadan: D4 (fasting intro) goes out 30 min before iftar.
  static int preferredMinutes(
    NurtureStep step, {
    int? usualLunchLogMinutes,
    int? usualDinnerLogMinutes,
    bool isRamadan = false,
    int? iftarMinutes,
  }) {
    switch (step.kind) {
      case NurtureKind.repeatMeal:
        if (usualLunchLogMinutes != null) {
          return (usualLunchLogMinutes - 20).clamp(10 * 60, 15 * 60);
        }
      case NurtureKind.fingerprint:
        if (usualDinnerLogMinutes != null) {
          return (usualDinnerLogMinutes + 30).clamp(18 * 60, 21 * 60 + 30);
        }
      case NurtureKind.fastingIntro:
        if (isRamadan) {
          final iftar = iftarMinutes ?? (18 * 60);
          return (iftar - 30).clamp(0, 24 * 60 - 1);
        }
      default:
        break;
    }
    return step.defaultMinutes;
  }

  /// Moves [minutes] out of the quiet-hours window.
  ///
  /// Returns null when no valid time exists (window covers the whole day).
  /// Times inside the window are pushed to just after it ends; if that would
  /// roll past midnight they are pulled to just before it starts instead.
  static int? avoidQuietHours(
    int minutes, {
    required int startHour,
    required int startMinute,
    required int endHour,
    required int endMinute,
  }) {
    bool quiet(int m) => ReminderScheduler.isInQuietHours(
          hour: m ~/ 60,
          minute: m % 60,
          startHour: startHour,
          startMinute: startMinute,
          endHour: endHour,
          endMinute: endMinute,
        );

    if (!quiet(minutes)) return minutes;

    final startMin = startHour * 60 + startMinute;
    final endMin = endHour * 60 + endMinute;
    final after = endMin + quietEdgeMarginMinutes;
    final before = startMin - quietEdgeMarginMinutes;
    bool ok(int m) => m >= 0 && m < 24 * 60 && !quiet(m);

    // Late-evening part of a window that wraps midnight → move EARLIER.
    final inLatePart = startMin > endMin && minutes >= startMin;
    if (inLatePart) {
      if (ok(before)) return before;
      if (ok(after)) return after;
    } else {
      if (ok(after)) return after;
      if (ok(before)) return before;
    }
    return null;
  }
}
