import 'package:flutter/foundation.dart';

@immutable
class PublicProfile {
  const PublicProfile({
    required this.userId,
    required this.displayName,
    required this.avatarSeed,
  });

  final String userId;
  final String displayName;
  final String avatarSeed;

  factory PublicProfile.fromJson(Map<String, dynamic> json) {
    return PublicProfile(
      userId: json['user_id'] as String? ?? '',
      displayName: json['display_name'] as String? ?? 'Vireo Member',
      avatarSeed: json['avatar_seed'] as String? ?? 'vireo_default',
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'display_name': displayName,
        'avatar_seed': avatarSeed,
      };
}

enum FriendshipStatus {
  pending,
  accepted,
  blocked;

  static FriendshipStatus fromString(String val) => switch (val) {
        'pending' => FriendshipStatus.pending,
        'blocked' => FriendshipStatus.blocked,
        _ => FriendshipStatus.accepted,
      };
}

@immutable
class FriendSummary {
  const FriendSummary({
    required this.userId,
    required this.displayName,
    required this.avatarSeed,
    required this.todaySteps,
    required this.hasLoggedToday,
    required this.currentStreak,
    required this.status,
  });

  final String userId;
  final String displayName;
  final String avatarSeed;
  final int todaySteps;
  final bool hasLoggedToday;
  final int currentStreak;
  final FriendshipStatus status;
}

enum ChallengeType {
  weeklySteps,
  loggingStreak;

  static ChallengeType fromString(String val) => switch (val) {
        'logging_streak' => ChallengeType.loggingStreak,
        _ => ChallengeType.weeklySteps,
      };

  String get dbValue => switch (this) {
        ChallengeType.weeklySteps => 'weekly_steps',
        ChallengeType.loggingStreak => 'logging_streak',
      };
}

@immutable
class ChallengeModel {
  const ChallengeModel({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.type,
    required this.startsAt,
    required this.endsAt,
    required this.inviteCode,
    required this.isFamily,
    required this.maxMembers,
    this.members = const [],
  });

  final String id;
  final String ownerId;
  final String title;
  final ChallengeType type;
  final DateTime startsAt;
  final DateTime endsAt;
  final String inviteCode;
  final bool isFamily;
  final int maxMembers;
  final List<ChallengeLeaderboardEntry> members;

  bool get isEnded => DateTime.now().isAfter(endsAt);
  int get daysLeft => endsAt.difference(DateTime.now()).inDays.clamp(0, 99);

  factory ChallengeModel.fromJson(
    Map<String, dynamic> json, {
    List<ChallengeLeaderboardEntry> members = const [],
  }) {
    return ChallengeModel(
      id: json['id'] as String? ?? '',
      ownerId: json['owner_id'] as String? ?? '',
      title: json['title'] as String? ?? 'Weekly Challenge',
      type: ChallengeType.fromString(json['type'] as String? ?? 'weekly_steps'),
      startsAt: DateTime.tryParse(json['starts_at'] as String? ?? '') ?? DateTime.now(),
      endsAt: DateTime.tryParse(json['ends_at'] as String? ?? '') ??
          DateTime.now().add(const Duration(days: 7)),
      inviteCode: json['invite_code'] as String? ?? '',
      isFamily: json['is_family'] as bool? ?? false,
      maxMembers: json['max_members'] as int? ?? 20,
      members: members,
    );
  }
}

@immutable
class ChallengeLeaderboardEntry {
  const ChallengeLeaderboardEntry({
    required this.userId,
    required this.displayName,
    required this.avatarSeed,
    required this.score,
    required this.rank,
  });

  final String userId;
  final String displayName;
  final String avatarSeed;
  final int score;
  final int rank;
}
