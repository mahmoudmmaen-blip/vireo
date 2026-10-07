import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/workout/domain/exercise_detail.dart';
import 'package:vireo/features/workout/domain/exercise_media.dart';
import 'package:vireo/features/workout/widgets/exercise_media_placeholder.dart';
import 'package:vireo/features/workout/widgets/muscle_map.dart';

class ExerciseMediaPlayer extends StatefulWidget {
  const ExerciseMediaPlayer({
    super.key,
    required this.detail,
    this.heightFactor = 0.4,
    this.showMuscleOverlay = true,
    this.heroTag,
    this.compact = false,
    this.onLoadingChanged,
  });

  final ExerciseDetail detail;
  final double heightFactor;
  final bool showMuscleOverlay;
  final String? heroTag;
  final bool compact;
  final ValueChanged<bool>? onLoadingChanged;

  @override
  State<ExerciseMediaPlayer> createState() => _ExerciseMediaPlayerState();
}

class _ExerciseMediaPlayerState extends State<ExerciseMediaPlayer>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _videoController;
  AnimationController? _lottieController;
  bool _mediaFailed = false;
  bool _lottieLoading = true;
  bool _muted = true;

  @override
  void initState() {
    super.initState();
    widget.onLoadingChanged?.call(true);
    if (widget.detail.mediaType == ExerciseMediaType.video) {
      _initVideo();
    } else if (widget.detail.mediaType == ExerciseMediaType.lottie) {
      _lottieController = AnimationController(vsync: this);
    } else {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    if (_lottieLoading == value) return;
    _lottieLoading = value;
    widget.onLoadingChanged?.call(value);
  }

  Future<void> _initVideo() async {
    try {
      final controller = VideoPlayerController.asset(widget.detail.mediaPath);
      _videoController = controller;
      await controller.initialize();
      await controller.setLooping(true);
      await controller.setVolume(0);
      await controller.play();
      if (mounted) {
        _setLoading(false);
        setState(() {});
      }
    } catch (_) {
      if (mounted) {
        _setLoading(false);
        setState(() => _mediaFailed = true);
      }
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _lottieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final height = widget.compact
        ? 120.0
        : screenHeight * widget.heightFactor;

    Widget media = _buildMedia(colors);

    if (widget.heroTag != null) {
      media = Hero(tag: widget.heroTag!, child: media);
    }

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.background.withValues(alpha: 0.88),
              borderRadius: widget.compact
                  ? BorderRadius.circular(12)
                  : const BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: ClipRRect(
              borderRadius: widget.compact
                  ? BorderRadius.circular(12)
                  : const BorderRadius.vertical(bottom: Radius.circular(20)),
              child: media,
            ),
          ),
          if (widget.showMuscleOverlay && !widget.compact && !_mediaFailed)
            Positioned(
              right: 8,
              bottom: 8,
              child: SizedBox(
                width: 100,
                child: MuscleMap(
                  primaryMuscles: widget.detail.muscleGroups,
                  secondaryMuscles: widget.detail.secondaryMuscles,
                  compact: true,
                ),
              ),
            ),
          if (widget.detail.mediaType == ExerciseMediaType.video &&
              _videoController != null &&
              _videoController!.value.isInitialized &&
              !widget.compact)
            Positioned(
              left: 12,
              bottom: 12,
              child: _VideoControls(
                controller: _videoController!,
                muted: _muted,
                onTogglePlay: () {
                  final c = _videoController!;
                  c.value.isPlaying ? c.pause() : c.play();
                  setState(() {});
                },
                onToggleMute: () async {
                  _muted = !_muted;
                  await _videoController!.setVolume(_muted ? 0 : 1);
                  setState(() {});
                },
                onFullscreen: () => _openFullscreen(context),
              ),
            ),
        ],
      ),
    );
  }

  void _openFullscreen(BuildContext context) {
    final controller = _videoController;
    if (controller == null || !controller.value.isInitialized) return;

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => _FullscreenVideoPage(controller: controller),
      ),
    );
  }

  Widget _buildMedia(VireoColors colors) {
    if (_mediaFailed) {
      return ExerciseMediaPlaceholder(
        exerciseName: widget.detail.name,
        compact: widget.compact,
      );
    }

    switch (widget.detail.mediaType) {
      case ExerciseMediaType.lottie:
        final controller = _lottieController;
        if (controller == null) {
          return ExerciseMediaPlaceholder(
            exerciseName: widget.detail.name,
            compact: widget.compact,
          );
        }
        return Lottie.asset(
          widget.detail.mediaPath,
          controller: controller,
          fit: BoxFit.contain,
          onLoaded: (composition) {
            _setLoading(false);
            controller
              ..duration = Duration(
                microseconds:
                    (composition.duration.inMicroseconds / 1.5).round(),
              )
              ..repeat();
            if (mounted) setState(() {});
          },
          errorBuilder: (context, error, stackTrace) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _setLoading(false);
                setState(() => _mediaFailed = true);
              }
            });
            return ExerciseMediaPlaceholder(
              exerciseName: widget.detail.name,
              compact: widget.compact,
            );
          },
        );
      case ExerciseMediaType.video:
        final c = _videoController;
        if (c == null || !c.value.isInitialized) {
          return ExerciseMediaPlaceholder(
            exerciseName: widget.detail.name,
            compact: widget.compact,
          );
        }
        return FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: c.value.size.width,
            height: c.value.size.height,
            child: VideoPlayer(c),
          ),
        );
      case ExerciseMediaType.gif:
      case ExerciseMediaType.placeholder:
        return Image.asset(
          widget.detail.mediaPath,
          fit: BoxFit.contain,
          gaplessPlayback: true,
          errorBuilder: (context, error, stackTrace) {
            return ExerciseMediaPlaceholder(
              exerciseName: widget.detail.name,
              compact: widget.compact,
            );
          },
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (frame != null || wasSynchronouslyLoaded) {
              _setLoading(false);
            }
            return child;
          },
        );
    }
  }
}

class _VideoControls extends StatelessWidget {
  const _VideoControls({
    required this.controller,
    required this.muted,
    required this.onTogglePlay,
    required this.onToggleMute,
    required this.onFullscreen,
  });

  final VideoPlayerController controller;
  final bool muted;
  final VoidCallback onTogglePlay;
  final VoidCallback onToggleMute;
  final VoidCallback onFullscreen;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.filled(
          onPressed: onTogglePlay,
          icon: Icon(
            controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
        IconButton(
          onPressed: onToggleMute,
          icon: Icon(muted ? Icons.volume_off : Icons.volume_up),
        ),
        IconButton(
          onPressed: onFullscreen,
          icon: const Icon(Icons.fullscreen),
        ),
      ],
    );
  }
}

class _FullscreenVideoPage extends StatelessWidget {
  const _FullscreenVideoPage({required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
