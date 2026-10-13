import 'dart:convert';
import 'package:flutter/foundation.dart';

enum PlanActionType {
  changeTargets,
  changeStepGoal,
  swapMeal,
  addWorkout,
  setFasting,
  addReminder,
}

@immutable
class PlanAction {
  const PlanAction({
    required this.type,
    required this.title,
    required this.description,
    required this.data,
    this.applied = false,
  });

  final PlanActionType type;
  final String title;
  final String description;
  final Map<String, dynamic> data;
  final bool applied;

  PlanAction copyWith({bool? applied}) {
    return PlanAction(
      type: type,
      title: title,
      description: description,
      data: data,
      applied: applied ?? this.applied,
    );
  }

  /// Extracts plan action from message text.
  /// Returns a record with clean display text and the parsed PlanAction (or null).
  static (String cleanText, PlanAction? action) extractFromMessage(String text) {
    const startTag = '```plan_action';
    const endTag = '```';

    final startIdx = text.indexOf(startTag);
    if (startIdx == -1) return (text.trim(), null);

    final afterStart = startIdx + startTag.length;
    final endIdx = text.indexOf(endTag, afterStart);
    if (endIdx == -1) return (text.trim(), null);

    final rawJson = text.substring(afterStart, endIdx).trim();
    final clean = (text.substring(0, startIdx) + text.substring(endIdx + endTag.length)).trim();

    try {
      final decoded = jsonDecode(rawJson);
      if (decoded is! Map) return (clean, null);
      final map = Map<String, dynamic>.from(decoded);

      final typeStr = map['type']?.toString();
      final type = switch (typeStr) {
        'change_targets' => PlanActionType.changeTargets,
        'change_step_goal' => PlanActionType.changeStepGoal,
        'swap_meal' => PlanActionType.swapMeal,
        'add_workout' => PlanActionType.addWorkout,
        'set_fasting' => PlanActionType.setFasting,
        'add_reminder' => PlanActionType.addReminder,
        _ => null,
      };

      if (type == null) return (clean, null);

      final action = PlanAction(
        type: type,
        title: map['title']?.toString() ?? 'تعديل الخطة',
        description: map['description']?.toString() ?? '',
        data: Map<String, dynamic>.from(map['data'] as Map? ?? {}),
      );
      return (clean, action);
    } catch (_) {
      return (clean, null);
    }
  }

  /// Applies safety rails to `target_kcal` and `target_protein_g`.
  /// - Minimum floor: 1200 kcal (women), 1500 kcal (men).
  /// - Pregnancy / under-18: never below 1800 kcal (no deficits).
  /// - Protein: clamped 80g .. 280g.
  static (int safeKcal, int safeProtein) clampTargets({
    required int requestedKcal,
    required int requestedProtein,
    required bool isFemale,
    bool isPregnancy = false,
    bool isUnder18 = false,
  }) {
    int floor = isFemale ? 1200 : 1500;
    if (isPregnancy || isUnder18) {
      floor = 1800; // No starvation or aggressive deficit for pregnancy/youth
    }

    final safeKcal = requestedKcal < floor ? floor : requestedKcal;
    final safeProtein = requestedProtein.clamp(80, 280);
    return (safeKcal, safeProtein);
  }
}
