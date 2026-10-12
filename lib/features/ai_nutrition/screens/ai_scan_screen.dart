import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/locale_provider.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/ai_nutrition/application/ai_scan_state.dart';
import 'package:vireo/features/ai_nutrition/providers/ai_scan_provider.dart';
import 'package:vireo/features/ai_nutrition/screens/meal_log_text_screen.dart';
import 'package:vireo/features/ai_nutrition/screens/meal_review_screen.dart';
import 'package:vireo/features/ai_nutrition/utils/image_compressor.dart';
import 'package:vireo/features/ai_nutrition/widgets/meal_scan_loading_overlay.dart';
import 'package:vireo/features/subscription/screens/paywall_screen.dart';
import 'package:vireo/features/ai_nutrition/application/meal_scan_native_file.dart'
    if (dart.library.html) 'package:vireo/features/ai_nutrition/application/meal_scan_native_file_web.dart';

import 'package:vireo/features/ai_nutrition/widgets/meal_scan_source_sheet.dart';

class AiScanScreen extends ConsumerStatefulWidget {
  const AiScanScreen({super.key, this.initialSource});

  final ImageSource? initialSource;

  static Future<void> open(
    BuildContext context,
    WidgetRef ref, {
    bool? fromCamera,
  }) {
    if (fromCamera == null) {
      return showMealScanSourceSheet(context, ref);
    }
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AiScanScreen(
          initialSource: fromCamera ? ImageSource.camera : ImageSource.gallery,
        ),
      ),
    );
  }

  @override
  ConsumerState<AiScanScreen> createState() => _AiScanScreenState();
}

class _AiScanScreenState extends ConsumerState<AiScanScreen> {
  final _picker = ImagePicker();
  final _hintCtrl = TextEditingController();
  Uint8List? _previewBytes;
  bool _launchedInitialPick = false;
  bool _flashOn = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialSource != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _pick(widget.initialSource!));
    }
  }

  Future<void> _pick(ImageSource source) async {
    ref.read(aiScanProvider.notifier).reset();
    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (picked == null) {
      if (mounted && widget.initialSource != null && !_launchedInitialPick) {
        Navigator.of(context).maybePop();
      }
      return;
    }
    _launchedInitialPick = true;

    final bytes = await picked.readAsBytes();
    final compressed = await MealImageCompressor.compress(bytes);
    if (!mounted) return;
    setState(() => _previewBytes = compressed);

    final loc = ref.read(localeProvider);
    final lang = loc.countryCode != null
        ? '${loc.languageCode}_${loc.countryCode}'
        : loc.languageCode;
    final scanInput = mealScanInputFromPicker(picked, compressed);
    await ref.read(aiScanProvider.notifier).scanMeal(
          scanInput,
          language: lang,
          userHint: _hintCtrl.text.trim().isEmpty ? null : _hintCtrl.text.trim(),
        );
    if (!mounted) return;

    final scan = ref.read(aiScanPhaseProvider);
    if (scan.isSuccess && scan.draftOrNull != null) {
      final draft = scan.draftOrNull!;
      final nav = Navigator.of(context);
      final saved = await MealReviewScreen.open(context, draft);
      if (mounted && saved == true) nav.pop();
    }
  }

  void _openTextLog() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const MealLogTextScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final scan = ref.watch(aiScanPhaseProvider);

    ref.listen(aiScanPhaseProvider, (prev, next) {
      if (next.isError && next.errorKindOrNull != null) {
        final kind = next.errorKindOrNull!;
        final message = switch (kind) {
          AiScanErrorKind.offline => l10n.aiScanOffline,
          AiScanErrorKind.parse => l10n.aiScanParseError,
          AiScanErrorKind.config => l10n.aiScanConfigError,
          AiScanErrorKind.dailyLimit => l10n.aiDailyLimitReached,
          AiScanErrorKind.api => l10n.aiScanFailed,
        };

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(duration: const Duration(seconds: 3), persist: false, 
            content: Text(message),
            action: SnackBarAction(
              label: kind == AiScanErrorKind.dailyLimit
                  ? l10n.aiUpgradeCta
                  : l10n.mealReviewLogByText,
              onPressed: () {
                if (kind == AiScanErrorKind.dailyLimit) {
                  openPaywall(context);
                } else {
                  _openTextLog();
                }
              },
            ),
          ),
        );
      }
    });

    final scanning = scan.isScanning;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(l10n.aiScanTitle),
        actions: [
          IconButton(
            tooltip: l10n.mealReviewLogByText,
            icon: const Icon(Icons.keyboard_alt_outlined),
            onPressed: _openTextLog,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: scanning || _previewBytes != null
                ? MealScanLoadingOverlay(imageBytes: _previewBytes)
                : _CameraPrompt(
                    flashOn: _flashOn,
                    onToggleFlash: () => setState(() => _flashOn = !_flashOn),
                    onCamera: () => _pick(ImageSource.camera),
                    onGallery: () => _pick(ImageSource.gallery),
                  ),
          ),
          if (!scanning && _previewBytes == null)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: TextField(
                controller: _hintCtrl,
                decoration: InputDecoration(
                  labelText: l10n.mealScanHintLabel,
                  hintText: l10n.mealScanHintPlaceholder,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
          if (scanning)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(l10n.aiScanAnalyzing, textAlign: TextAlign.center),
            )
          else if (_previewBytes == null)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _pick(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt),
                      label: Text(l10n.aiScanCamera),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pick(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library_outlined),
                      label: Text(l10n.aiScanGallery),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _hintCtrl.dispose();
    super.dispose();
  }
}

class _CameraPrompt extends StatelessWidget {
  const _CameraPrompt({
    required this.flashOn,
    required this.onToggleFlash,
    required this.onCamera,
    required this.onGallery,
  });

  final bool flashOn;
  final VoidCallback onToggleFlash;
  final VoidCallback onCamera;
  final VoidCallback onGallery;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    return ListView(
      padding: const EdgeInsets.all(VSpace.lg),
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: CustomPaint(
            painter: _PlateFramePainter(colors.ember),
            child: Center(
              child: Icon(Icons.restaurant, size: 48, color: colors.textMute),
            ),
          ),
        ),
        const SizedBox(height: VSpace.md),
        Text(l10n.aiScanPrompt, textAlign: TextAlign.center),
        const SizedBox(height: VSpace.sm),
        _Tip(Icons.vertical_align_top, l10n.mealScanTipAbove),
        _Tip(Icons.fullscreen, l10n.mealScanTipWholePlate),
        _Tip(Icons.wb_sunny_outlined, l10n.mealScanTipLight),
        const SizedBox(height: VSpace.sm),
        TextButton.icon(
          onPressed: onToggleFlash,
          icon: Icon(flashOn ? Icons.flash_on : Icons.flash_off),
          label: Text(flashOn ? l10n.mealScanFlashOn : l10n.mealScanFlashOff),
        ),
      ],
    );
  }
}

class _Tip extends StatelessWidget {
  const _Tip(this.icon, this.text);
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: context.vireoColors.textMute),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _PlateFramePainter extends CustomPainter {
  _PlateFramePainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final inset = size.shortestSide * 0.08;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(inset, inset, size.width - inset * 2, size.height - inset * 2),
        const Radius.circular(24),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
