import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/ai_nutrition/application/ai_scan_state.dart';
import 'package:vireo/features/ai_nutrition/providers/ai_scan_provider.dart';
import 'package:vireo/features/ai_nutrition/utils/image_compressor.dart';
import 'package:vireo/features/ai_nutrition/widgets/ai_analysis_bottom_sheet.dart';
import 'package:vireo/features/ai_nutrition/widgets/meal_scan_loading_overlay.dart';
import 'package:vireo/features/nutrition/screens/manual_food_entry_screen.dart';
import 'package:vireo/features/ai_nutrition/application/meal_scan_native_file.dart'
    if (dart.library.html) 'package:vireo/features/ai_nutrition/application/meal_scan_native_file_web.dart';

class AiScanScreen extends ConsumerStatefulWidget {
  const AiScanScreen({super.key, this.initialSource});

  final ImageSource? initialSource;

  static Future<void> open(
    BuildContext context, {
    required bool fromCamera,
  }) {
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
  Uint8List? _previewBytes;
  bool _launchedInitialPick = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialSource != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _pick(widget.initialSource!));
    }
  }

  Future<void> _pick(ImageSource source) async {
    ref.read(aiScanProvider.notifier).reset();
    final picked = await _picker.pickImage(source: source, imageQuality: 85);
    if (picked == null) {
      if (mounted && widget.initialSource != null && !_launchedInitialPick) {
        Navigator.of(context).maybePop();
      }
      return;
    }
    _launchedInitialPick = true;

    final bytes = await picked.readAsBytes();
    final compressed = await MealImageCompressor.compress(bytes);
    setState(() => _previewBytes = compressed);

    final scanInput = mealScanInputFromPicker(picked, compressed);
    await ref.read(aiScanProvider.notifier).scanMeal(scanInput);
    if (!mounted) return;

    final scan = ref.read(aiScanPhaseProvider);
    if (scan.isSuccess && scan.resultOrNull != null) {
      await showAiAnalysisBottomSheet(context, scan.resultOrNull!);
      if (mounted) Navigator.of(context).pop();
    }
  }

  void _openManualEntry() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const ManualFoodEntryScreen()),
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
          AiScanErrorKind.api => l10n.aiScanFailed,
        };

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            action: SnackBarAction(
              label: kind == AiScanErrorKind.parse
                  ? l10n.aiScanManualEntry
                  : l10n.aiScanTryAgain,
              onPressed: () {
                if (kind == AiScanErrorKind.parse) {
                  _openManualEntry();
                } else if (_previewBytes != null) {
                  ref.read(aiScanProvider.notifier).scanMeal(_previewBytes!);
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
      appBar: AppBar(title: Text(l10n.aiScanTitle)),
      body: Column(
        children: [
          Expanded(
            child: scanning || _previewBytes != null
                ? MealScanLoadingOverlay(imageBytes: _previewBytes)
                : ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      Text(
                        l10n.aiScanPrompt,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colors.textMute),
                      ),
                    ],
                  ),
          ),
          if (scanning)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                l10n.aiScanAnalyzing,
                style: TextStyle(color: colors.ember),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pick(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: Text(l10n.aiScanCamera),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => _pick(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: Text(l10n.aiScanGallery),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
