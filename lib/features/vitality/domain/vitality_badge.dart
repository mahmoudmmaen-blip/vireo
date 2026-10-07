import 'package:flutter/material.dart';

/// Educational vitality badges — no medical claims.
class VitalityBadge {
  const VitalityBadge({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.icon,
    required this.unlockConditionKey,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final IconData icon;
  final String unlockConditionKey;

  String titleFor(String locale) => locale == 'ar' ? titleAr : titleEn;
  String descriptionFor(String locale) =>
      locale == 'ar' ? descriptionAr : descriptionEn;
}

abstract final class VitalityBadgeCatalog {
  static const badges = <VitalityBadge>[
    VitalityBadge(
      id: 'squat_master',
      titleEn: 'Squat Master',
      titleAr: 'بطل السكوات',
      descriptionEn: 'Completed the squat protocol for 4 consecutive weeks.',
      descriptionAr: 'أكملت بروتوكول السكوات لمدة 4 أسابيع متتالية.',
      icon: Icons.fitness_center,
      unlockConditionKey: 'squat_protocol_4_weeks',
    ),
    VitalityBadge(
      id: 'deep_sleeper',
      titleEn: 'Deep Sleeper',
      titleAr: 'نوم عميق',
      descriptionEn: 'Logged 8 hours of sleep for 7 consecutive days.',
      descriptionAr: 'سجّلت 8 ساعات نوم لمدة 7 أيام متتالية.',
      icon: Icons.bedtime,
      unlockConditionKey: 'sleep_8h_7_days',
    ),
    VitalityBadge(
      id: 'stress_warrior',
      titleEn: 'Stress Warrior',
      titleAr: 'محارب الإجهاد',
      descriptionEn: 'Completed 10 breathing exercise sessions.',
      descriptionAr: 'أكملت 10 جلسات تمارين تنفس.',
      icon: Icons.self_improvement,
      unlockConditionKey: 'breathing_10_sessions',
    ),
    VitalityBadge(
      id: 'protein_king',
      titleEn: 'Protein King',
      titleAr: 'ملك البروتين',
      descriptionEn: 'Hit your daily protein goal for 14 consecutive days.',
      descriptionAr: 'حققت هدف البروتين اليومي لمدة 14 يوماً متتالياً.',
      icon: Icons.restaurant,
      unlockConditionKey: 'protein_14_days',
    ),
    VitalityBadge(
      id: 'zinc_champion',
      titleEn: 'Zinc Champion',
      titleAr: 'بطل الزنك',
      descriptionEn: 'Completed the zinc protocol checklist for 30 days.',
      descriptionAr: 'أكملت قائمة بروتوكول الزنك لمدة 30 يوماً.',
      icon: Icons.emoji_events,
      unlockConditionKey: 'zinc_protocol_30_days',
    ),
  ];

  static VitalityBadge? byId(String id) {
    for (final b in badges) {
      if (b.id == id) return b;
    }
    return null;
  }
}

/// Tracks progress toward badge unlock conditions.
@immutable
class VitalityBadgeProgress {
  const VitalityBadgeProgress({
    this.unlockedBadgeIds = const {},
    this.squatProtocolWeeks = 0,
    this.sleep8DayStreak = 0,
    this.proteinGoalDayStreak = 0,
    this.zincProtocolDayStreak = 0,
    this.totalBreathingSessions = 0,
  });

  final Set<String> unlockedBadgeIds;
  final int squatProtocolWeeks;
  final int sleep8DayStreak;
  final int proteinGoalDayStreak;
  final int zincProtocolDayStreak;
  final int totalBreathingSessions;

  VitalityBadgeProgress copyWith({
    Set<String>? unlockedBadgeIds,
    int? squatProtocolWeeks,
    int? sleep8DayStreak,
    int? proteinGoalDayStreak,
    int? zincProtocolDayStreak,
    int? totalBreathingSessions,
  }) {
    return VitalityBadgeProgress(
      unlockedBadgeIds: unlockedBadgeIds ?? this.unlockedBadgeIds,
      squatProtocolWeeks: squatProtocolWeeks ?? this.squatProtocolWeeks,
      sleep8DayStreak: sleep8DayStreak ?? this.sleep8DayStreak,
      proteinGoalDayStreak: proteinGoalDayStreak ?? this.proteinGoalDayStreak,
      zincProtocolDayStreak: zincProtocolDayStreak ?? this.zincProtocolDayStreak,
      totalBreathingSessions:
          totalBreathingSessions ?? this.totalBreathingSessions,
    );
  }

  Map<String, dynamic> toJson() => {
        'unlocked': unlockedBadgeIds.toList(),
        'squat_weeks': squatProtocolWeeks,
        'sleep_streak': sleep8DayStreak,
        'protein_streak': proteinGoalDayStreak,
        'zinc_streak': zincProtocolDayStreak,
        'breathing_total': totalBreathingSessions,
      };

  factory VitalityBadgeProgress.fromJson(Map<String, dynamic> json) {
    return VitalityBadgeProgress(
      unlockedBadgeIds: (json['unlocked'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toSet(),
      squatProtocolWeeks: json['squat_weeks'] as int? ?? 0,
      sleep8DayStreak: json['sleep_streak'] as int? ?? 0,
      proteinGoalDayStreak: json['protein_streak'] as int? ?? 0,
      zincProtocolDayStreak: json['zinc_streak'] as int? ?? 0,
      totalBreathingSessions: json['breathing_total'] as int? ?? 0,
    );
  }
}

/// Per-article protocol checklist progress.
@immutable
class ProtocolTrackerState {
  const ProtocolTrackerState({
    this.checkedItemIds = const {},
    this.consecutiveDays = 0,
    this.lastCompletedDateKey,
  });

  final Set<String> checkedItemIds;
  final int consecutiveDays;
  final String? lastCompletedDateKey;

  bool get allChecked => checkedItemIds.isNotEmpty;

  ProtocolTrackerState copyWith({
    Set<String>? checkedItemIds,
    int? consecutiveDays,
    String? lastCompletedDateKey,
  }) {
    return ProtocolTrackerState(
      checkedItemIds: checkedItemIds ?? this.checkedItemIds,
      consecutiveDays: consecutiveDays ?? this.consecutiveDays,
      lastCompletedDateKey: lastCompletedDateKey ?? this.lastCompletedDateKey,
    );
  }

  Map<String, dynamic> toJson() => {
        'checked': checkedItemIds.toList(),
        'streak': consecutiveDays,
        'last_date': lastCompletedDateKey,
      };

  factory ProtocolTrackerState.fromJson(Map<String, dynamic> json) {
    return ProtocolTrackerState(
      checkedItemIds: (json['checked'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toSet(),
      consecutiveDays: json['streak'] as int? ?? 0,
      lastCompletedDateKey: json['last_date'] as String?,
    );
  }
}
