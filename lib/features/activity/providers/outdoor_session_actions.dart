import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/data/models/app_auth_state.dart';
import 'package:vireo/features/activity/data/outdoor_workout_repository.dart';
import 'package:vireo/features/activity/domain/outdoor_workout_models.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';

Future<void> persistOutdoorSession(WidgetRef ref, OutdoorWorkoutSession session) async {
  final repo = ref.read(outdoorWorkoutRepositoryProvider);
  await repo.save(session);
  ref.read(outdoorWorkoutRevisionProvider.notifier).state++;
  final auth = ref.read(authProvider).valueOrNull;
  final userId = auth is AppAuthAuthenticated && !auth.user.isAnonymous
      ? auth.user.id
      : null;
  await repo.syncIfSignedIn(session, userId: userId);
}
