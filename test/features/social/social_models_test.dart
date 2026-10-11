import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/social/domain/social_models.dart';

void main() {
  group('Social Models & Privacy Guarantees', () {
    test('PublicProfile serialization only contains safe public fields', () {
      final profile = PublicProfile(
        userId: 'u_123',
        displayName: 'Captain Egypt',
        avatarSeed: 'seed_pyramids',
      );

      final json = profile.toJson();
      expect(json['user_id'], 'u_123');
      expect(json['display_name'], 'Captain Egypt');
      expect(json['avatar_seed'], 'seed_pyramids');
      // Must never have sensitive health data
      expect(json.containsKey('weight'), false);
      expect(json.containsKey('calories'), false);
      expect(json.containsKey('food'), false);
    });

    test('FriendSummary only reflects steps, streak, and loggedToday', () {
      const friend = FriendSummary(
        userId: 'u_friend_1',
        displayName: 'Youssef',
        avatarSeed: 'seed_youssef',
        todaySteps: 8500,
        hasLoggedToday: true,
        currentStreak: 7,
        status: FriendshipStatus.accepted,
      );

      expect(friend.todaySteps, 8500);
      expect(friend.hasLoggedToday, true);
      expect(friend.currentStreak, 7);
      expect(friend.status, FriendshipStatus.accepted);
    });

    test('ChallengeModel leaderboard and duration calculation', () {
      final starts = DateTime.now().subtract(const Duration(days: 2));
      final ends = DateTime.now().add(const Duration(days: 5));

      final challenge = ChallengeModel(
        id: 'c_test',
        ownerId: 'u_owner',
        title: 'Weekly Steps Race',
        type: ChallengeType.weeklySteps,
        startsAt: starts,
        endsAt: ends,
        inviteCode: 'VIREO99',
        isFamily: false,
        maxMembers: 20,
        members: const [
          ChallengeLeaderboardEntry(
            userId: 'u1',
            displayName: 'A',
            avatarSeed: 's1',
            score: 30000,
            rank: 1,
          ),
          ChallengeLeaderboardEntry(
            userId: 'u2',
            displayName: 'B',
            avatarSeed: 's2',
            score: 20000,
            rank: 2,
          ),
        ],
      );

      expect(challenge.isEnded, false);
      expect(challenge.daysLeft, inInclusiveRange(4, 5));
      expect(challenge.members.first.score, 30000);
      expect(challenge.members.first.rank, 1);
    });

    test('Family Challenge enforces 6 member cap flag', () {
      final familyChallenge = ChallengeModel(
        id: 'fam_1',
        ownerId: 'u_parent',
        title: 'Family Steps',
        type: ChallengeType.weeklySteps,
        startsAt: DateTime.now(),
        endsAt: DateTime.now().add(const Duration(days: 7)),
        inviteCode: 'FAM123',
        isFamily: true,
        maxMembers: 6,
      );

      expect(familyChallenge.isFamily, true);
      expect(familyChallenge.maxMembers, 6);
    });
  });
}
