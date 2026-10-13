import 'package:flutter/foundation.dart';
import 'package:vireo/features/fasting/domain/fasting_plan.dart';
import 'package:vireo/features/fasting/domain/fasting_stage.dart';

@immutable
class FastingSession {
  const FastingSession({
    required this.id,
    required this.planType,
    required this.targetHours,
    required this.startTime,
    this.endTime,
    this.isCompleted = false,
    this.coinsAwarded = false,
    this.isRamadan = false,
  });

  final String id;
  final FastingPlanType planType;
  final int targetHours;
  final DateTime startTime;
  final DateTime? endTime;
  final bool isCompleted;
  final bool coinsAwarded;
  final bool isRamadan;

  /// Effective duration elapsed (or total duration if already finished).
  Duration get elapsed {
    final now = DateTime.now();
    final end = endTime ?? now;
    if (end.isBefore(startTime)) return Duration.zero;
    return end.difference(startTime);
  }

  /// Target duration of this fast.
  Duration get targetDuration => Duration(hours: targetHours);

  /// Remaining duration until target is reached.
  Duration get remaining {
    final el = elapsed;
    final tg = targetDuration;
    if (el >= tg) return Duration.zero;
    return tg - el;
  }

  /// Progress from 0.0 to 1.0 (can exceed 1.0 if fasting longer than target).
  double get progressRatio {
    final totalMinutes = targetHours * 60.0;
    if (totalMinutes <= 0) return 0.0;
    final elapsedMinutes = elapsed.inMinutes.toDouble();
    return (elapsedMinutes / totalMinutes).clamp(0.0, 3.0);
  }

  /// Whether the target hours have been achieved.
  bool get isTargetReached => elapsed >= targetDuration;

  /// Whether fast is currently active (not yet ended).
  bool get isActive => endTime == null;

  /// Current scientific stage.
  FastingStage get currentStage => FastingStage.fromElapsed(elapsed);

  /// Hard safety cap: 72 hours max.
  bool get isPastHardCap => elapsed >= const Duration(hours: 72);

  FastingSession copyWith({
    String? id,
    FastingPlanType? planType,
    int? targetHours,
    DateTime? startTime,
    DateTime? endTime,
    bool? isCompleted,
    bool? coinsAwarded,
    bool? isRamadan,
  }) {
    return FastingSession(
      id: id ?? this.id,
      planType: planType ?? this.planType,
      targetHours: targetHours ?? this.targetHours,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isCompleted: isCompleted ?? this.isCompleted,
      coinsAwarded: coinsAwarded ?? this.coinsAwarded,
      isRamadan: isRamadan ?? this.isRamadan,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'plan_type': planType.name,
        'target_hours': targetHours,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime?.toIso8601String(),
        'is_completed': isCompleted,
        'coins_awarded': coinsAwarded,
        'is_ramadan': isRamadan,
      };

  factory FastingSession.fromJson(Map<String, dynamic> json) {
    return FastingSession(
      id: json['id'] as String? ?? '',
      planType: FastingPlanType.values.firstWhere(
        (p) => p.name == json['plan_type'],
        orElse: () => FastingPlanType.p16_8,
      ),
      targetHours: json['target_hours'] as int? ?? 16,
      startTime: DateTime.tryParse(json['start_time'] as String? ?? '') ?? DateTime.now(),
      endTime: json['end_time'] != null ? DateTime.tryParse(json['end_time'] as String) : null,
      isCompleted: json['is_completed'] as bool? ?? false,
      coinsAwarded: json['coins_awarded'] as bool? ?? false,
      isRamadan: json['is_ramadan'] as bool? ?? false,
    );
  }
}
