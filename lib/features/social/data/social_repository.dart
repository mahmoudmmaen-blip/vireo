import 'dart:math';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/supabase_service.dart';
import 'package:vireo/features/social/domain/social_models.dart';

class SocialRepository {
  const SocialRepository();

  static const _cachedProfileKey = 'social_cached_profile';
  static const _blockedUsersKey = 'social_blocked_users';

  // ── 1. Public Profile ──

  Future<PublicProfile?> getMyPublicProfile(String userId) async {
    if (!SupabaseService.isInitialized) {
      final cached = HiveService.settingsBox.get(_cachedProfileKey) as Map?;
      if (cached != null) {
        return PublicProfile(
          userId: userId,
          displayName: cached['display_name'] as String? ?? 'You',
          avatarSeed: cached['avatar_seed'] as String? ?? 'seed_you',
        );
      }
      return PublicProfile(userId: userId, displayName: 'You', avatarSeed: 'seed_you');
    }

    try {
      final data = await SupabaseService.client
          .from('profiles_public')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (data == null) {
        // Create default profile
        final defaultProfile = PublicProfile(
          userId: userId,
          displayName: 'Vireo Member',
          avatarSeed: 'seed_${userId.hashCode.abs() % 1000}',
        );
        await upsertPublicProfile(defaultProfile);
        return defaultProfile;
      }
      return PublicProfile.fromJson(data);
    } catch (_) {
      return PublicProfile(userId: userId, displayName: 'You', avatarSeed: 'seed_you');
    }
  }

  Future<void> upsertPublicProfile(PublicProfile profile) async {
    await HiveService.settingsBox.put(_cachedProfileKey, profile.toJson());
    if (!SupabaseService.isInitialized) return;

    try {
      await SupabaseService.client.from('profiles_public').upsert({
        'user_id': profile.userId,
        'display_name': profile.displayName,
        'avatar_seed': profile.avatarSeed,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (_) {}
  }

  // ── 2. Daily Shared Stats (Steps, Streak, Logged-Today ONLY) ──

  Future<void> syncDailySharedStats({
    required String userId,
    required int steps,
    required bool hasLoggedToday,
    required int streak,
  }) async {
    if (!SupabaseService.isInitialized) return;

    final todayStr = DateTime.now().toIso8601String().substring(0, 10);
    try {
      await SupabaseService.client.from('daily_shared_stats').upsert({
        'user_id': userId,
        'day': todayStr,
        'steps': steps,
        'logged': hasLoggedToday,
        'streak': streak,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'user_id, day');
    } catch (_) {}
  }

  // ── 3. Friends & Friendships ──

  Future<List<FriendSummary>> getFriends(String userId) async {
    if (!SupabaseService.isInitialized) {
      // Local demo friends
      return [
        const FriendSummary(
          userId: 'demo_friend_1',
          displayName: 'Omar K.',
          avatarSeed: 'seed_omar',
          todaySteps: 7420,
          hasLoggedToday: true,
          currentStreak: 5,
          status: FriendshipStatus.accepted,
        ),
        const FriendSummary(
          userId: 'demo_friend_2',
          displayName: 'Nour E.',
          avatarSeed: 'seed_nour',
          todaySteps: 10250,
          hasLoggedToday: true,
          currentStreak: 12,
          status: FriendshipStatus.accepted,
        ),
      ];
    }

    try {
      final rows = await SupabaseService.client
          .from('friendships')
          .select('friend_id, status, profiles_public!friendships_friend_id_fkey(display_name, avatar_seed)')
          .eq('user_id', userId)
          .neq('status', 'blocked');

      final todayStr = DateTime.now().toIso8601String().substring(0, 10);
      final friends = <FriendSummary>[];

      for (final r in (rows as List<dynamic>)) {
        final fId = r['friend_id'] as String;
        final profile = r['profiles_public'] as Map<String, dynamic>? ?? {};
        final status = FriendshipStatus.fromString(r['status'] as String? ?? 'accepted');

        // Fetch today's stats for this friend
        final stats = await SupabaseService.client
            .from('daily_shared_stats')
            .select('steps, logged, streak')
            .eq('user_id', fId)
            .eq('day', todayStr)
            .maybeSingle();

        friends.add(
          FriendSummary(
            userId: fId,
            displayName: profile['display_name'] as String? ?? 'Friend',
            avatarSeed: profile['avatar_seed'] as String? ?? 'seed_friend',
            todaySteps: stats?['steps'] as int? ?? 0,
            hasLoggedToday: stats?['logged'] as bool? ?? false,
            currentStreak: stats?['streak'] as int? ?? 0,
            status: status,
          ),
        );
      }
      return friends;
    } catch (_) {
      return const [];
    }
  }

  Future<bool> addFriendByCode({
    required String currentUserId,
    required String friendUserId,
  }) async {
    if (currentUserId == friendUserId) return false;
    if (!SupabaseService.isInitialized) return true;

    try {
      await SupabaseService.client.from('friendships').upsert([
        {
          'user_id': currentUserId,
          'friend_id': friendUserId,
          'status': 'accepted',
        },
        {
          'user_id': friendUserId,
          'friend_id': currentUserId,
          'status': 'accepted',
        },
      ]);
      return true;
    } catch (_) {
      return false;
    }
  }

  // ── 4. Challenges & Leaderboards ──

  Future<List<ChallengeModel>> getMyChallenges(String userId) async {
    if (!SupabaseService.isInitialized) {
      return [
        ChallengeModel(
          id: 'demo_c1',
          ownerId: userId,
          title: 'Vireo Cairo Steps Challenge',
          type: ChallengeType.weeklySteps,
          startsAt: DateTime.now().subtract(const Duration(days: 2)),
          endsAt: DateTime.now().add(const Duration(days: 5)),
          inviteCode: 'VIREO77',
          isFamily: false,
          maxMembers: 10,
          members: const [
            ChallengeLeaderboardEntry(
              userId: 'demo_friend_2',
              displayName: 'Nour E.',
              avatarSeed: 'seed_nour',
              score: 28400,
              rank: 1,
            ),
            ChallengeLeaderboardEntry(
              userId: 'current_user',
              displayName: 'You',
              avatarSeed: 'seed_you',
              score: 21500,
              rank: 2,
            ),
            ChallengeLeaderboardEntry(
              userId: 'demo_friend_1',
              displayName: 'Omar K.',
              avatarSeed: 'seed_omar',
              score: 18900,
              rank: 3,
            ),
          ],
        ),
      ];
    }

    try {
      final memberships = await SupabaseService.client
          .from('challenge_members')
          .select('challenge_id')
          .eq('user_id', userId);

      final challengeIds = (memberships as List)
          .map((m) => m['challenge_id'] as String)
          .toList();

      if (challengeIds.isEmpty) return const [];

      final challengesData = await SupabaseService.client
          .from('challenges')
          .select()
          .inFilter('id', challengeIds);

      final result = <ChallengeModel>[];
      for (final cJson in (challengesData as List)) {
        final cId = cJson['id'] as String;
        final leaderboard = await getChallengeLeaderboard(cId);
        result.add(ChallengeModel.fromJson(cJson as Map<String, dynamic>, members: leaderboard));
      }
      return result;
    } catch (_) {
      return const [];
    }
  }

  Future<List<ChallengeLeaderboardEntry>> getChallengeLeaderboard(String challengeId) async {
    if (!SupabaseService.isInitialized) return const [];

    try {
      final membersData = await SupabaseService.client
          .from('challenge_members')
          .select('user_id, profiles_public!challenge_members_user_id_fkey(display_name, avatar_seed)')
          .eq('challenge_id', challengeId);

      final memberIds = (membersData as List).map((m) => m['user_id'] as String).toList();
      if (memberIds.isEmpty) return const [];

      // Sum weekly steps
      final weekAgoStr = DateTime.now().subtract(const Duration(days: 7)).toIso8601String().substring(0, 10);
      final stats = await SupabaseService.client
          .from('daily_shared_stats')
          .select('user_id, steps')
          .inFilter('user_id', memberIds)
          .gte('day', weekAgoStr);

      final scoreMap = <String, int>{};
      for (final s in (stats as List)) {
        final uId = s['user_id'] as String;
        final st = s['steps'] as int? ?? 0;
        scoreMap[uId] = (scoreMap[uId] ?? 0) + st;
      }

      final entries = <ChallengeLeaderboardEntry>[];
      for (final m in membersData) {
        final uId = m['user_id'] as String;
        final profile = m['profiles_public'] as Map<String, dynamic>? ?? {};
        entries.add(
          ChallengeLeaderboardEntry(
            userId: uId,
            displayName: profile['display_name'] as String? ?? 'Member',
            avatarSeed: profile['avatar_seed'] as String? ?? 'seed_member',
            score: scoreMap[uId] ?? 0,
            rank: 0,
          ),
        );
      }

      entries.sort((a, b) => b.score.compareTo(a.score));
      return [
        for (var i = 0; i < entries.length; i++)
          ChallengeLeaderboardEntry(
            userId: entries[i].userId,
            displayName: entries[i].displayName,
            avatarSeed: entries[i].avatarSeed,
            score: entries[i].score,
            rank: i + 1,
          ),
      ];
    } catch (_) {
      return const [];
    }
  }

  Future<ChallengeModel?> createChallenge({
    required String ownerId,
    required String title,
    required ChallengeType type,
    bool isFamily = false,
  }) async {
    final code = _generateInviteCode();
    final startsAt = DateTime.now();
    final endsAt = startsAt.add(const Duration(days: 7));
    final maxMembers = isFamily ? 6 : 20;

    if (!SupabaseService.isInitialized) {
      return ChallengeModel(
        id: 'local_${DateTime.now().millisecondsSinceEpoch}',
        ownerId: ownerId,
        title: title,
        type: type,
        startsAt: startsAt,
        endsAt: endsAt,
        inviteCode: code,
        isFamily: isFamily,
        maxMembers: maxMembers,
      );
    }

    try {
      final inserted = await SupabaseService.client
          .from('challenges')
          .insert({
            'owner_id': ownerId,
            'title': title,
            'type': type.dbValue,
            'starts_at': startsAt.toIso8601String(),
            'ends_at': endsAt.toIso8601String(),
            'invite_code': code,
            'is_family': isFamily,
            'max_members': maxMembers,
          })
          .select()
          .single();

      final challengeId = inserted['id'] as String;
      // Auto-join owner
      await SupabaseService.client.from('challenge_members').insert({
        'challenge_id': challengeId,
        'user_id': ownerId,
      });

      return ChallengeModel.fromJson(inserted);
    } catch (_) {
      return null;
    }
  }

  Future<bool> joinChallengeByCode({
    required String userId,
    required String inviteCode,
  }) async {
    if (!SupabaseService.isInitialized) return true;

    try {
      final challenge = await SupabaseService.client
          .from('challenges')
          .select('id, max_members')
          .eq('invite_code', inviteCode.trim().toUpperCase())
          .maybeSingle();

      if (challenge == null) return false;
      final cId = challenge['id'] as String;
      final maxM = challenge['max_members'] as int? ?? 20;

      // Check current members count
      final countRes = await SupabaseService.client
          .from('challenge_members')
          .select('id')
          .eq('challenge_id', cId);

      if ((countRes as List).length >= maxM) {
        return false; // full (e.g. family cap 6)
      }

      await SupabaseService.client.from('challenge_members').upsert({
        'challenge_id': cId,
        'user_id': userId,
      }, onConflict: 'challenge_id, user_id');

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> leaveChallenge({
    required String userId,
    required String challengeId,
  }) async {
    if (!SupabaseService.isInitialized) return;
    try {
      await SupabaseService.client
          .from('challenge_members')
          .delete()
          .eq('challenge_id', challengeId)
          .eq('user_id', userId);
    } catch (_) {}
  }

  // ── 5. Block, Report, Delete ──

  Future<void> reportUser({
    required String reporterId,
    required String reportedUserId,
    required String reason,
    String? details,
  }) async {
    if (!SupabaseService.isInitialized) return;
    try {
      await SupabaseService.client.from('user_reports').insert({
        'reporter_id': reporterId,
        'reported_user_id': reportedUserId,
        'reason': reason,
        'details': details,
      });
      // Automatically block the user as well
      await blockUser(currentUserId: reporterId, targetUserId: reportedUserId);
    } catch (_) {}
  }

  Future<void> blockUser({
    required String currentUserId,
    required String targetUserId,
  }) async {
    final blocked = Set<String>.from(
      HiveService.settingsBox.get(_blockedUsersKey, defaultValue: <dynamic>[]) as List,
    );
    blocked.add(targetUserId);
    await HiveService.settingsBox.put(_blockedUsersKey, blocked.toList());

    if (!SupabaseService.isInitialized) return;
    try {
      await SupabaseService.client.from('friendships').upsert({
        'user_id': currentUserId,
        'friend_id': targetUserId,
        'status': 'blocked',
      }, onConflict: 'user_id, friend_id');
    } catch (_) {}
  }

  Future<void> deleteAllSocialData(String userId) async {
    HiveService.settingsBox.delete(_cachedProfileKey);
    HiveService.settingsBox.delete(_blockedUsersKey);

    if (!SupabaseService.isInitialized) return;
    try {
      await SupabaseService.client.from('daily_shared_stats').delete().eq('user_id', userId);
      await SupabaseService.client.from('challenge_members').delete().eq('user_id', userId);
      await SupabaseService.client.from('challenges').delete().eq('owner_id', userId);
      await SupabaseService.client.from('friendships').delete().or('user_id.eq.$userId,friend_id.eq.$userId');
      await SupabaseService.client.from('profiles_public').delete().eq('user_id', userId);
    } catch (_) {}
  }

  static String _generateInviteCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rand = Random();
    return List.generate(6, (_) => chars[rand.nextInt(chars.length)]).join();
  }
}
