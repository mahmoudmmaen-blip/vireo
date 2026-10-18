import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/permissions/sensitive_permission_gate.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/ai_nutrition/application/ai_scan_state.dart';
import 'package:vireo/features/ai_nutrition/providers/ai_scan_provider.dart';
import 'package:vireo/features/ai_nutrition/screens/meal_review_screen.dart';
import 'package:vireo/features/ai_nutrition/widgets/meal_scan_loading_overlay.dart';

class CalAiCameraScreen extends ConsumerStatefulWidget {
  const CalAiCameraScreen({super.key, this.initialPhotos = const []});

  final List<Uint8List> initialPhotos;

  @override
  ConsumerState<CalAiCameraScreen> createState() => _CalAiCameraScreenState();
}

class _CalAiCameraScreenState extends ConsumerState<CalAiCameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  final List<Uint8List> _photos = [];
  bool _isInitializing = true;
  bool _isTakingPhoto = false;
  FlashMode _flashMode = FlashMode.off;

  @override
  void initState() {
    super.initState();
    _photos.addAll(widget.initialPhotos);
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final granted = await SensitivePermissionGate.ensureCamera(context);
      if (!granted) {
        if (mounted) {
          setState(() => _isInitializing = false);
          _showPermissionDeniedDialog();
        }
        return;
      }

      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        final backCamera = _cameras!.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.back,
          orElse: () => _cameras!.first,
        );
        final ctrl = CameraController(
          backCamera,
          ResolutionPreset.high,
          enableAudio: false,
        );
        await ctrl.initialize();
        if (mounted) {
          setState(() {
            _controller = ctrl;
            _isInitializing = false;
          });
        }
      } else {
        if (mounted) setState(() => _isInitializing = false);
      }
    } catch (_) {
      if (mounted) setState(() => _isInitializing = false);
    }
  }

  void _showPermissionDeniedDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.cameraPermissionRationaleTitle),
        content: Text(l10n.cameraPermissionRationaleBody),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _pickFromGallery();
            },
            child: Text(l10n.photoSourceGallery),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await openAppSettings();
            },
            child: Text(l10n.continueButton),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    if (_controller == null || !_controller!.value.isInitialized || _isTakingPhoto) return;
    if (_photos.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الحد الأقصى 5 صور لكل وجبة')),
      );
      return;
    }

    setState(() => _isTakingPhoto = true);
    HapticFeedback.mediumImpact();

    try {
      final file = await _controller!.takePicture();
      final bytes = await file.readAsBytes();
      if (mounted) {
        setState(() {
          _photos.add(bytes);
          _isTakingPhoto = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isTakingPhoto = false);
    }
  }

  Future<void> _pickFromGallery() async {
    final remaining = 5 - _photos.length;
    if (remaining <= 0) return;

    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(limit: remaining);
    if (pickedFiles.isNotEmpty) {
      for (final pf in pickedFiles.take(remaining)) {
        final b = await pf.readAsBytes();
        _photos.add(b);
      }
      if (mounted) setState(() {});
    }
  }

  Future<void> _toggleFlash() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    final next = _flashMode == FlashMode.off ? FlashMode.torch : FlashMode.off;
    try {
      await _controller!.setFlashMode(next);
      setState(() => _flashMode = next);
    } catch (_) {}
  }

  Future<void> _analyze() async {
    if (_photos.isEmpty) return;
    HapticFeedback.mediumImpact();

    final loc = Localizations.localeOf(context).languageCode;
    await ref.read(aiScanProvider.notifier).scanMealMulti(_photos, language: loc);

    if (!mounted) return;
    final scan = ref.read(aiScanPhaseProvider);
    if (scan.isSuccess && scan.draftOrNull != null) {
      final draft = scan.draftOrNull!;
      final nav = Navigator.of(context);
      final saved = await MealReviewScreen.open(context, draft);
      if (mounted && saved == true) nav.pop();
    }
  }

  String _errorMessage(BuildContext context, AiScanErrorKind kind) {
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');
    if (isArabic) {
      return switch (kind) {
        AiScanErrorKind.offline => 'مفيش اتصال بالنت.. اتأكد من شبكة الإنترنت وحاول تاني',
        AiScanErrorKind.timeout => 'التحليل أخد وقت أطول من المتوقع.. حاول تاني',
        AiScanErrorKind.noFood || AiScanErrorKind.parse =>
          'مش قادرين نتعرف على الأكل في الصورة.. حاول تصوّر الوجبة بوضوح أكتر',
        AiScanErrorKind.dailyLimit =>
          'وصلت للحد الأقصى للتحليل بالذكاء الاصطناعي اليوم.. جرب بكرة أو اشترك في Pro',
        AiScanErrorKind.config || AiScanErrorKind.api =>
          'حصلت مشكلة في السيرفر.. حاول مرة تانية كمان شوية',
      };
    }
    return switch (kind) {
      AiScanErrorKind.offline => 'No internet connection. Please check your network and try again.',
      AiScanErrorKind.timeout => 'Analysis timed out. Please try again.',
      AiScanErrorKind.noFood || AiScanErrorKind.parse =>
        'Couldn\'t recognize food in the photo. Please take a clearer photo.',
      AiScanErrorKind.dailyLimit => 'Daily AI meal scan limit reached. Try tomorrow or upgrade to Pro.',
      AiScanErrorKind.config || AiScanErrorKind.api => 'Server error occurred. Please try again later.',
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final scanState = ref.watch(aiScanPhaseProvider);

    if (scanState.isScanning || scanState.isError) {
      final errorKind = scanState.errorKindOrNull;
      final errorMsg = errorKind != null ? _errorMessage(context, errorKind) : null;
      return Scaffold(
        backgroundColor: Colors.black,
        body: MealScanLoadingOverlay(
          imageBytes: _photos.isNotEmpty ? _photos.first : null,
          isError: scanState.isError,
          errorMessage: errorMsg,
          onRetry: _analyze,
          onCancel: () => ref.read(aiScanProvider.notifier).reset(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Fullscreen camera preview or placeholder
            if (_controller != null && _controller!.value.isInitialized)
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller!.value.previewSize?.height ?? 1,
                    height: _controller!.value.previewSize?.width ?? 1,
                    child: CameraPreview(_controller!),
                  ),
                ),
              )
            else
              Center(
                child: _isInitializing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.camera_alt_outlined, size: 64, color: Colors.white54),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: _pickFromGallery,
                            icon: const Icon(Icons.photo_library),
                            label: const Text('اختيار من المعرض'),
                          ),
                        ],
                      ),
              ),

            // Top controls (Close & Flash)
            Positioned(
              top: MediaQuery.paddingOf(context).top + 12,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black45,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ),
                  if (_controller != null && _controller!.value.isInitialized)
                    CircleAvatar(
                      backgroundColor: Colors.black45,
                      child: IconButton(
                        icon: Icon(
                          _flashMode == FlashMode.torch
                              ? Icons.flash_on_rounded
                              : Icons.flash_off_rounded,
                          color: _flashMode == FlashMode.torch ? Colors.amber : Colors.white,
                        ),
                        onPressed: _toggleFlash,
                      ),
                    ),
                ],
              ),
            ),

            // Bottom control bar (Strip, Shutter, Actions)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Multi-photo thumbnail strip
                    if (_photos.isNotEmpty) ...[
                      SizedBox(
                        height: 64,
                        child: Row(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: _photos.length,
                                separatorBuilder: (_, _) => const SizedBox(width: 8),
                                itemBuilder: (ctx, i) {
                                  return Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.memory(
                                          _photos[i],
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 2,
                                        right: 2,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() => _photos.removeAt(i));
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: const BoxDecoration(
                                              color: Colors.black54,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(Icons.close, size: 14, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            if (_photos.length < 5) ...[
                              const SizedBox(width: 8),
                              ActionChip(
                                backgroundColor: Colors.white24,
                                label: const Text('صورة كمان +', style: TextStyle(color: Colors.white, fontSize: 12)),
                                onPressed: _takePhoto,
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Shutter row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Gallery button
                        IconButton(
                          iconSize: 32,
                          icon: const Icon(Icons.photo_library_outlined, color: Colors.white),
                          onPressed: _photos.length < 5 ? _pickFromGallery : null,
                        ),

                        // Shutter button
                        GestureDetector(
                          onTap: _photos.length < 5 ? _takePhoto : null,
                          child: Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              color: _isTakingPhoto ? Colors.white30 : Colors.white12,
                            ),
                            child: Center(
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Analyze button
                        _photos.isNotEmpty
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colors.ember,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                ),
                                onPressed: _analyze,
                                child: Text(
                                  'تحليل (${_photos.length})',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )
                            : const SizedBox(width: 48),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (_isTakingPhoto)
              const ColoredBox(
                color: Color(0x88000000),
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFFFF6B35)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
