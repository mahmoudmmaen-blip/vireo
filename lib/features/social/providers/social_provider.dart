import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/data/models/app_auth_state.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';
import 'package:vireo/features/social/data/social_repository.dart';
import 'package:vireo/features/social/domain/social_models.dart';
import 'package:vireo/features/walking/providers/live_steps_provider.dart';

final socialRepositoryProvider = Provider<SocialRepository>((ref) {
  return const SocialRepository();
});

final myPublicProfileProvider = FutureProvider<PublicProfile?>((ref) async {
  final auth = ref.watch(authProvider).valueOrNull;
  final userId = auth?.user?.id;
  if (userId == null) return null;

  return ref.read(socialRepositoryProvider).getMyPublicProfile(userId);
});

final friendsListProvider = FutureProvider<List<FriendSummary>>((ref) async {
  final auth = ref.watch(authProvider).valueOrNull;
  final userId = auth?.user?.id ?? 'guest_user';
  return ref.read(socialRepositoryProvider).getFriends(userId);
});

final myChallengesProvider = FutureProvider<List<ChallengeModel>>((ref) async {
  final auth = ref.watch(authProvider).valueOrNull;
  final userId = auth?.user?.id ?? 'guest_user';
  return ref.read(socialRepositoryProvider).getMyChallenges(userId);
});

/// Automatically syncs user's steps and today's activity to daily_shared_stats when online
final syncDailyStatsProvider = FutureProvider<void>((ref) async {
  final auth = ref.watch(authProvider).valueOrNull;
  final userId = auth?.user?.id;
  if (userId == null) return;

  final steps = ref.watch(todayStepsProvider);
  await ref.read(socialRepositoryProvider).syncDailySharedStats(
        userId: userId,
        steps: steps,
        hasLoggedToday: steps > 0,
        streak: 1,
      );
});
