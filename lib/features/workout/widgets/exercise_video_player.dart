import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';

class ExerciseVideoPlayer extends StatefulWidget {
  const ExerciseVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.aspectRatio,
  });

  final String videoUrl;
  final double aspectRatio;

  @override
  State<ExerciseVideoPlayer> createState() => _ExerciseVideoPlayerState();
}

class _ExerciseVideoPlayerState extends State<ExerciseVideoPlayer> {
  VideoPlayerController? _controller;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void didUpdateWidget(covariant ExerciseVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _disposeController();
      _initController();
    }
  }

  Future<void> _initController() async {
    if (widget.videoUrl.isEmpty) {
      setState(() => _failed = true);
      return;
    }

    setState(() => _failed = false);
    final controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _controller = controller;

    try {
      await controller.initialize();
      await controller.setLooping(true);
      await controller.setVolume(0);
      await controller.play();
      if (mounted) setState(() {});
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  void _disposeController() {
    _controller?.dispose();
    _controller = null;
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final controller = _controller;

    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surfaceRaised,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _failed
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.videocam_off_outlined, color: colors.textMute),
                      const SizedBox(height: 8),
                      Text(l10n.workoutVideoUnavailable, style: TextStyle(color: colors.textMute)),
                    ],
                  ),
                )
              : controller == null || !controller.value.isInitialized
                  ? Center(child: CircularProgressIndicator(color: colors.ember))
                  : VideoPlayer(controller),
        ),
      ),
    );
  }
}
