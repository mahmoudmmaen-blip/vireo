import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/progress/domain/progress_photo_service.dart';

class PhotoGhostCameraScreen extends StatefulWidget {
  const PhotoGhostCameraScreen({
    super.key,
    required this.pose,
    this.ghostPhoto,
  });

  final PhotoPose pose;
  final ProgressPhotoRecord? ghostPhoto;

  @override
  State<PhotoGhostCameraScreen> createState() => _PhotoGhostCameraScreenState();
}

class _PhotoGhostCameraScreenState extends State<PhotoGhostCameraScreen> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isInitialized = false;
  bool _isTakingPhoto = false;
  double _ghostOpacity = 0.45;
  int _selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      // Select back camera by default
      _selectedCameraIndex = _cameras.indexWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
      );
      if (_selectedCameraIndex == -1) _selectedCameraIndex = 0;

      await _startCamera(_cameras[_selectedCameraIndex]);
    } catch (_) {}
  }

  Future<void> _startCamera(CameraDescription camera) async {
    await _cameraController?.dispose();
    final controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await controller.initialize();
      if (!mounted) return;
      setState(() {
        _cameraController = controller;
        _isInitialized = true;
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized || _isTakingPhoto) return;
    setState(() => _isTakingPhoto = true);
    HapticFeedback.mediumImpact();

    try {
      final xFile = await _cameraController!.takePicture();
      if (!mounted) return;
      Navigator.of(context).pop(File(xFile.path));
    } catch (_) {
      if (mounted) setState(() => _isTakingPhoto = false);
    }
  }

  void _switchCamera() {
    if (_cameras.length < 2) return;
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    _startCamera(_cameras[_selectedCameraIndex]);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final isAr = Localizations.localeOf(context).languageCode.startsWith('ar');

    if (!_isInitialized || _cameraController == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    final ghostFile = widget.ghostPhoto != null ? File(widget.ghostPhoto!.localPath) : null;
    final hasGhost = ghostFile != null && ghostFile.existsSync();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Live Camera Preview
          Center(
            child: CameraPreview(_cameraController!),
          ),

          // Ghost Overlay (previous photo with alignment guide)
          if (hasGhost)
            Opacity(
              opacity: _ghostOpacity,
              child: Image.file(
                ghostFile,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),

          // Body Alignment Silhouette Lines
          CustomPaint(
            painter: _BodyGuidePainter(color: Colors.white.withValues(alpha: 0.35)),
          ),

          // Top Bar with Pose & Ghost Slider
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.pose.label(isAr ? 'ar' : 'en'),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    if (hasGhost) ...[
                      const SizedBox(width: 14),
                      const Icon(Icons.layers_outlined, color: Colors.white70, size: 18),
                      SizedBox(
                        width: 100,
                        child: Slider(
                          value: _ghostOpacity,
                          min: 0.1,
                          max: 0.8,
                          activeColor: colors.ember,
                          onChanged: (val) => setState(() => _ghostOpacity = val),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // Bottom Shutter Controls
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Flip camera
                    IconButton(
                      icon: const Icon(Icons.flip_camera_ios, color: Colors.white, size: 28),
                      onPressed: _switchCamera,
                    ),

                    // Shutter Button
                    GestureDetector(
                      onTap: _takePhoto,
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          decoration: BoxDecoration(
                            color: colors.ember,
                            shape: BoxShape.circle,
                          ),
                          child: _isTakingPhoto
                              ? const Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),

                    // Guide hint icon
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Colors.black45,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          hasGhost ? '👻' : '📏',
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BodyGuidePainter extends CustomPainter {
  const _BodyGuidePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final centerX = size.width / 2;

    // Head circle guideline
    canvas.drawCircle(Offset(centerX, size.height * 0.22), size.width * 0.12, paint);

    // Shoulder line
    canvas.drawLine(
      Offset(centerX - size.width * 0.32, size.height * 0.36),
      Offset(centerX + size.width * 0.32, size.height * 0.36),
      paint,
    );

    // Center vertical alignment axis
    canvas.drawLine(
      Offset(centerX, size.height * 0.10),
      Offset(centerX, size.height * 0.90),
      paint..color = color.withValues(alpha: 0.2),
    );
  }

  @override
  bool shouldRepaint(covariant _BodyGuidePainter oldDelegate) => false;
}
