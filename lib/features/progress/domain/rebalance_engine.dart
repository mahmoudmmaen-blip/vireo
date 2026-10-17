import 'package:flutter/foundation.dart';
import 'package:vireo/features/activity/domain/acsm_net_energy.dart';
import 'package:vireo/features/progress/domain/adaptive_tdee_engine.dart';

enum RebalanceKind {
  safeSurplus,
  surplusOptions,
  exceptionalDay,
  largeDeficitSnack,
  chronicUnderEating,
  proteinGap,
  stepsBehind,
  none,
}

enum RebalanceOptionId { walkOff, spread, lighterMeal, proteinSnack, reminderWalk }

@immutable
class RebalanceOption {
  const RebalanceOption({
    required this.id,
    required this.titleAr,
    required this.detailAr,
    required this.payload,
  });

  final RebalanceOptionId id;
  final String titleAr;
  final String detailAr;

  /// Deterministic numbers for the UI / apply action. Never applied automatically.
  final Map<String, num> payload;
}

@immutable
class RebalanceResult {
  const RebalanceResult({
    required this.kind,
    required this.messageAr,
    required this.options,
    required this.surplusKcal,
    required this.deficitKcal,
    required this.requiresUserTap,
  });

  final RebalanceKind kind;
  final String messageAr;
  final List<RebalanceOption> options;
  final int surplusKcal;
  final int deficitKcal;
  final bool requiresUserTap;

  static const none = RebalanceResult(
    kind: RebalanceKind.none,
    messageAr: '',
    options: [],
    surplusKcal: 0,
    deficitKcal: 0,
    requiresUserTap: true,
  );
}

/// Deterministic rebalance after every log and at 6 PM / 9 PM.
/// Nothing changes without the user's tap.
abstract final class RebalanceEngine {
  static const int safeSurplusKcal = 150;
  static const int hugeSurplusKcal = 1000;
  static const int largeDeficitBy8pm = 400;
  static const double proteinGapRatio = 0.70;
  static const double chronicUnderRatio = 0.80;
  static const int maxSpreadPerDay = 250;
  static const int maxExceptionalSpreadWeek = 500;

  /// Local hour for scheduling windows (Ramadan-aware).
  static ({int stepsBehindHour, int proteinHour, int deficitHour, int eveningHour})
      scheduleHours({required bool isRamadan}) {
    if (isRamadan) {
      // After iftar / taraweeh windows (Egypt approx).
      return (
        stepsBehindHour: 21,
        proteinHour: 20,
        deficitHour: 22,
        eveningHour: 23,
      );
    }
    return (
      stepsBehindHour: 17,
      proteinHour: 18,
      deficitHour: 20,
      eveningHour: 21,
    );
  }

  static RebalanceResult evaluate({
    required int intakeKcal,
    required int targetKcal,
    required int proteinG,
    required int proteinTargetG,
    required int steps,
    required int stepGoal,
    required double weightKg,
    required double strideMeters,
    required bool isFemale,
    required bool isPregnancy,
    required bool isUnder18,
    required int hourOfDay,
    required bool isRamadan,
    int consecutiveDaysBelow80pct = 0,
    List<({String nameAr, int saveKcal})> lighterMealSwaps = const [],
  }) {
    final surplus = intakeKcal - targetKcal;
    final deficit = targetKcal - intakeKcal;
    final hours = scheduleHours(isRamadan: isRamadan);
    final floor = SafetyFloors.forSex(
      isFemale: isFemale,
      isPregnancy: isPregnancy,
      isUnder18: isUnder18,
    );

    // Protein gap by 6 PM (or Ramadan protein hour).
    if (hourOfDay >= hours.proteinHour &&
        proteinTargetG > 0 &&
        proteinG < proteinTargetG * proteinGapRatio) {
      final need = (proteinTargetG * proteinGapRatio - proteinG).ceil();
      return RebalanceResult(
        kind: RebalanceKind.proteinGap,
        messageAr: 'البروتين لسه ناقص — جرّب حاجة سريعة دلوقتي',
        surplusKcal: surplus > 0 ? surplus : 0,
        deficitKcal: deficit > 0 ? deficit : 0,
        requiresUserTap: true,
        options: [
          RebalanceOption(
            id: RebalanceOptionId.proteinSnack,
            titleAr: 'زبادي يوناني',
            detailAr: '≈ ${need.clamp(10, 40)} ج بروتين',
            payload: {'protein_g': need.clamp(10, 40)},
          ),
          RebalanceOption(
            id: RebalanceOptionId.proteinSnack,
            titleAr: 'بيضتين مسلوقين',
            detailAr: '≈ 12 ج بروتين',
            payload: {'protein_g': 12},
          ),
        ],
      );
    }

    // Steps behind at 5 PM.
    if (hourOfDay >= hours.stepsBehindHour &&
        stepGoal > 0 &&
        steps < stepGoal * 0.5) {
      final remaining = stepGoal - steps;
      final walk = AcsmNetEnergy.walkOffSurplus(
        surplusKcal: AcsmNetEnergy.stepsNetKcal(
          steps: remaining,
          weightKg: weightKg,
          strideMeters: strideMeters,
        ).round(),
        weightKg: weightKg,
        strideMeters: strideMeters,
      );
      final mins = walk.minutes > 0
          ? walk.minutes
          : (remaining / 100).round().clamp(10, 90);
      return RebalanceResult(
        kind: RebalanceKind.stepsBehind,
        messageAr:
            'فاضلك ${_fmt(remaining)} خطوة ≈ $mins دقيقة مشي — تمشي بعد العصر؟',
        surplusKcal: 0,
        deficitKcal: 0,
        requiresUserTap: true,
        options: [
          RebalanceOption(
            id: RebalanceOptionId.reminderWalk,
            titleAr: 'ذكّرني بعد شوية',
            detailAr: '${_fmt(remaining)} خطوة',
            payload: {'steps': remaining, 'minutes': mins},
          ),
        ],
      );
    }

    // Large deficit by 8 PM.
    if (hourOfDay >= hours.deficitHour && deficit > largeDeficitBy8pm) {
      final chronic = consecutiveDaysBelow80pct >= 3;
      return RebalanceResult(
        kind: chronic
            ? RebalanceKind.chronicUnderEating
            : RebalanceKind.largeDeficitSnack,
        messageAr: chronic
            ? 'الحرمان بيبطّأ الحرق ويضيّع العضل — خلّي النهاردة أقرب للهدف'
            : 'لسه فاضلك عجز كبير — جرّب سناك فيه بروتين',
        surplusKcal: 0,
        deficitKcal: deficit,
        requiresUserTap: true,
        options: [
          RebalanceOption(
            id: RebalanceOptionId.proteinSnack,
            titleAr: 'سناك بروتين',
            detailAr: 'يقفل ≈ ${deficit.clamp(100, 400)} سعرة',
            payload: {'kcal': deficit.clamp(100, 400)},
          ),
        ],
      );
    }

    // Surplus paths.
    if (surplus <= 0) return RebalanceResult.none;

    if (surplus <= safeSurplusKcal) {
      return RebalanceResult(
        kind: RebalanceKind.safeSurplus,
        messageAr: 'عادي — يومك لسه في الأمان',
        options: const [],
        surplusKcal: surplus,
        deficitKcal: 0,
        requiresUserTap: true,
      );
    }

    if (surplus > hugeSurplusKcal) {
      final spread = _spreadPlan(
        surplus: surplus.clamp(0, maxExceptionalSpreadWeek),
        days: 7,
        targetKcal: targetKcal,
        floor: floor,
        maxPerDay: maxSpreadPerDay,
      );
      return RebalanceResult(
        kind: RebalanceKind.exceptionalDay,
        messageAr: 'يوم استثنائي — استمتع، وبكرة نكمّل عادي 💪',
        surplusKcal: surplus,
        deficitKcal: 0,
        requiresUserTap: true,
        options: [
          RebalanceOption(
            id: RebalanceOptionId.spread,
            titleAr: 'وزّع بحد أقصى 500 على الأسبوع',
            detailAr: spread.detailAr,
            payload: spread.payload,
          ),
        ],
      );
    }

    // Normal surplus options (pick one).
    final walk = AcsmNetEnergy.walkOffSurplus(
      surplusKcal: surplus,
      weightKg: weightKg,
      strideMeters: strideMeters,
    );
    final spread3 = _spreadPlan(
      surplus: surplus,
      days: 3,
      targetKcal: targetKcal,
      floor: floor,
      maxPerDay: maxSpreadPerDay,
    );
    final options = <RebalanceOption>[
      RebalanceOption(
        id: RebalanceOptionId.walkOff,
        titleAr: 'امشِها',
        detailAr:
            'مشي ${walk.minutes} دقيقة ≈ ${_fmt(walk.steps)} خطوة يعوّض $surplus سعرة',
        payload: {
          'minutes': walk.minutes,
          'steps': walk.steps,
          'kcal': surplus,
        },
      ),
      RebalanceOption(
        id: RebalanceOptionId.spread,
        titleAr: 'وزّعها على الأيام الجاية',
        detailAr: spread3.detailAr,
        payload: spread3.payload,
      ),
    ];
    if (lighterMealSwaps.isNotEmpty) {
      final s = lighterMealSwaps.first;
      options.add(
        RebalanceOption(
          id: RebalanceOptionId.lighterMeal,
          titleAr: 'وجبة أخف',
          detailAr: '${s.nameAr} يوفّر ≈ ${s.saveKcal} سعرة',
          payload: {'save_kcal': s.saveKcal},
        ),
      );
    }

    return RebalanceResult(
      kind: RebalanceKind.surplusOptions,
      messageAr: 'زيادة النهاردة $surplus سعرة — اختار طريقة تظبطها',
      options: options.take(3).toList(),
      surplusKcal: surplus,
      deficitKcal: 0,
      requiresUserTap: true,
    );
  }

  static ({String detailAr, Map<String, num> payload}) _spreadPlan({
    required int surplus,
    required int days,
    required int targetKcal,
    required int floor,
    required int maxPerDay,
  }) {
    final perDayRaw = (surplus / days).ceil();
    final perDay = perDayRaw.clamp(0, maxPerDay);
    final targets = <int>[];
    for (var i = 0; i < days; i++) {
      final t = (targetKcal - perDay).clamp(floor, targetKcal);
      targets.add(t);
    }
    return (
      detailAr: 'كل يوم −$perDay سعرة (حد أدنى $floor)',
      payload: {
        'per_day': perDay,
        'days': days,
        for (var i = 0; i < targets.length; i++) 'day_${i + 1}': targets[i],
      },
    );
  }

  static String _fmt(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}
