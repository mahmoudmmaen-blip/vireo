/// Cardio activity types with standard MET values (Compendium of Physical Activities).
enum CardioActivityType {
  briskWalking(3.5),
  running(8.0),
  cycling(6.8),
  swimming(7.0),
  jumpRope(11.0),
  hiit(10.0),
  elliptical(5.0);

  const CardioActivityType(this.met);
  final double met;

  String get storageKey => name;

  static CardioActivityType fromStorage(String? value) {
    return CardioActivityType.values.firstWhere(
      (e) => e.storageKey == value,
      orElse: () => CardioActivityType.briskWalking,
    );
  }
}

class CardioLogEntry {
  const CardioLogEntry({
    required this.id,
    required this.activity,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.loggedAt,
  });

  final String id;
  final CardioActivityType activity;
  final int durationMinutes;
  final int caloriesBurned;
  final DateTime loggedAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'activity': activity.storageKey,
        'duration_minutes': durationMinutes,
        'calories_burned': caloriesBurned,
        'logged_at': loggedAt.toIso8601String(),
      };

  factory CardioLogEntry.fromJson(Map<String, dynamic> json) {
    return CardioLogEntry(
      id: json['id'] as String? ?? '',
      activity: CardioActivityType.fromStorage(json['activity'] as String?),
      durationMinutes: json['duration_minutes'] as int? ?? 0,
      caloriesBurned: json['calories_burned'] as int? ?? 0,
      loggedAt: DateTime.tryParse(json['logged_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

/// kcal = MET × weightKg × hours
abstract final class CardioCalorieCalculator {
  static int burn({
    required CardioActivityType activity,
    required int durationMinutes,
    required double weightKg,
  }) {
    final hours = durationMinutes.clamp(1, 300) / 60.0;
    final kcal = activity.met * weightKg.clamp(40, 200) * hours;
    return kcal.round().clamp(1, 3000);
  }
}
