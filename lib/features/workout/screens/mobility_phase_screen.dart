import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/locale_provider.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/data/models/exercise.dart';
import 'package:vireo/features/workout/widgets/exercise_video_player.dart';
import 'package:vireo/features/workout/widgets/medical_banner.dart';

class MobilityPhaseScreen extends ConsumerWidget {
  const MobilityPhaseScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.exercises,
    required this.continueLabel,
    required this.onContinue,
    required this.showMedicalBanner,
  });

  final String title;
  final String subtitle;
  final List<Exercise> exercises;
  final String continueLabel;
  final VoidCallback onContinue;
  final bool showMedicalBanner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider).languageCode;
    final colors = context.vireoColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showMedicalBanner) const MedicalBanner(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: colors.textMute)),
              const SizedBox(height: 20),
              ...exercises.map(
                (exercise) => _MobilityCard(exercise: exercise, locale: locale),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: onContinue,
            child: Text(continueLabel),
          ),
        ),
      ],
    );
  }
}

class _MobilityCard extends StatelessWidget {
  const _MobilityCard({required this.exercise, required this.locale});

  final Exercise exercise;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return Card(
      color: colors.surfaceRaised,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExerciseVideoPlayer(
              videoUrl: exercise.videoUrl,
              aspectRatio: exercise.videoAspectRatio,
            ),
            const SizedBox(height: 12),
            Text(
              exercise.localizedName(locale),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              exercise.localizedTargetMuscle(locale),
              style: TextStyle(color: colors.textMute),
            ),
          ],
        ),
      ),
    );
  }
}
