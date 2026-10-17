import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vireo/core/boot/boot_log.dart';
import 'package:vireo/core/permissions/sensitive_permission_gate.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/ai_nutrition/data/barcode_lookup_service.dart';
import 'package:vireo/features/ai_nutrition/data/gemini_food_service_core.dart';
import 'package:vireo/features/ai_nutrition/screens/meal_review_screen.dart';

class MealBarcodeScreen extends ConsumerStatefulWidget {
  const MealBarcodeScreen({super.key});

  @override
  ConsumerState<MealBarcodeScreen> createState() => _MealBarcodeScreenState();
}

class _MealBarcodeScreenState extends ConsumerState<MealBarcodeScreen> {
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  bool _isProcessing = false;
  bool _isTorchOn = false;
  String? _notFoundBarcode;
  String? _errorMessage;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _toggleTorch() async {
    try {
      await _scannerController.toggleTorch();
      setState(() => _isTorchOn = !_isTorchOn);
    } catch (_) {}
  }

  Future<void> _onBarcodeDetected(String code) async {
    if (_isProcessing) return;
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
      _notFoundBarcode = null;
    });

    // Haptic feedback when a code is scanned
    HapticFeedback.mediumImpact();

    try {
      final result = await BarcodeLookupService.lookup(code);
      if (result != null) {
        if (!mounted) return;
        HapticFeedback.lightImpact();
        await MealReviewScreen.open(
          context,
          MealScanDraft(
            lines: [result.line],
            imageBytes: Uint8List(0),
          ),
        );
        if (mounted) Navigator.of(context).maybePop();
        return;
      }

      // If not found in Cache, DB, or Open Food Facts
      if (mounted) {
        HapticFeedback.vibrate();
        setState(() {
          _isProcessing = false;
          _notFoundBarcode = code;
        });
      }
    } catch (e) {
      BootLog.warn('Barcode scan error', e);
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _errorMessage = 'حدث خطأ أثناء البحث عن الباركود، يرجى المحاولة مرة أخرى.';
        });
      }
    }
  }

  Future<void> _captureNutritionLabel() async {
    if (_notFoundBarcode == null) return;
    final camOk = await SensitivePermissionGate.ensureCamera(context);
    if (!camOk) return;
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera, imageQuality: 85);
    if (picked == null || !mounted) return;

    setState(() => _isProcessing = true);
    final bytes = await picked.readAsBytes();

    if (!mounted) return;
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');
    try {
      final result = await BarcodeLookupService.analyzeNutritionLabel(
        labelImageBytes: bytes,
        barcode: _notFoundBarcode!,
        language: isArabic ? 'ar' : 'en',
      );

      if (!mounted) return;
      await MealReviewScreen.open(
        context,
        MealScanDraft(
          lines: [result.line],
          imageBytes: bytes,
        ),
      );
      if (mounted) Navigator.of(context).maybePop();
    } catch (e) {
      BootLog.warn('Label scan error', e);
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _errorMessage = 'لم نتمكن من قراءة الملصق الغذائي، يمكنك إدخال الوجبة يدوياً.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final isAr = Localizations.localeOf(context).languageCode.startsWith('ar');

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(isAr ? 'ماسح الباركود' : 'Barcode Scanner'),
        backgroundColor: Colors.black.withValues(alpha: 0.7),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isTorchOn ? Icons.flash_on : Icons.flash_off),
            tooltip: isAr ? 'الكشاف' : 'Torch',
            onPressed: _toggleTorch,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Full-screen camera view
          MobileScanner(
            controller: _scannerController,
            onDetect: (capture) {
              final barcode = capture.barcodes.firstOrNull?.rawValue;
              if (barcode != null && barcode.isNotEmpty) {
                _onBarcodeDetected(barcode);
              }
            },
          ),

          // Viewfinder reticle overlay
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(color: colors.ember, width: 2.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 8,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isAr ? 'وجّه الكاميرا نحو الباركود' : 'Align barcode within frame',
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Processing spinner
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: Colors.white),
                    const SizedBox(height: 16),
                    Text(
                      isAr ? 'جاري البحث عن بيانات المنتج...' : 'Looking up product details...',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

          // Fallback UI when barcode is not found in database or Open Food Facts
          if (_notFoundBarcode != null && !_isProcessing)
            Positioned(
              left: 16,
              right: 16,
              bottom: 30,
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: colors.ember.withValues(alpha: 0.5)),
                  boxShadow: const [
                    BoxShadow(color: Colors.black45, blurRadius: 12, offset: Offset(0, 4)),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: colors.ember),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            isAr ? 'المنتج غير مسجل في قاعدة البيانات' : 'Product not found in database',
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isAr
                          ? 'رمز الباركود: $_notFoundBarcode\nصوّر الملصق الغذائي وسيقوم الذكاء الاصطناعي بقراءة السعرات والماكروز وحفظه لك.'
                          : 'Barcode: $_notFoundBarcode\nTake a photo of the nutrition label and AI will read the macros and save it.',
                      style: TextStyle(color: colors.textMute, fontSize: 12),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: colors.ember,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            icon: const Icon(Icons.camera_alt),
                            label: Text(isAr ? 'صوّر الملصق الغذائي' : 'Scan Nutrition Label'),
                            onPressed: _captureNutritionLabel,
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _notFoundBarcode = null;
                            });
                          },
                          child: Text(isAr ? 'إلغاء' : 'Cancel'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          // Error banner
          if (_errorMessage != null && !_isProcessing && _notFoundBarcode == null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 30,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colors.danger),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: colors.danger),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: colors.danger, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: () => setState(() => _errorMessage = null),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
