import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdfx/pdfx.dart';
import 'package:vireo/core/boot/boot_log.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/ai_nutrition/utils/image_compressor.dart';
import 'package:vireo/features/measurements/data/body_report_vision_service.dart';
import 'package:vireo/features/measurements/screens/inbody_review_screen.dart';

/// Camera / gallery / PDF → analyze-body-report → review.
class InBodyScanScreen extends ConsumerStatefulWidget {
  const InBodyScanScreen({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const InBodyScanScreen()),
    );
  }

  @override
  ConsumerState<InBodyScanScreen> createState() => _InBodyScanScreenState();
}

class _InBodyScanScreenState extends ConsumerState<InBodyScanScreen> {
  final _picker = ImagePicker();
  bool _loading = false;
  String? _error;

  Future<void> _analyze(Uint8List bytes) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final lang = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context);
    try {
      final compressed = await MealImageCompressor.compress(bytes);
      final report = await BodyReportVisionService.analyzeBytes(
        compressed,
        language: lang,
      );
      if (!mounted) return;
      final saved = await InBodyReviewScreen.open(context, report);
      if (mounted && saved == true) Navigator.of(context).pop();
    } on BodyReportVisionException catch (e) {
      BootLog.warn('inbody scan failed', e.code);
      if (!mounted) return;
      setState(() {
        _error = switch (e.code) {
          'UNREADABLE' => l10n.inbodyUnreadable,
          'DAILY_LIMIT' => l10n.aiDailyLimitReached,
          _ => l10n.inbodyScanFailed,
        };
      });
    } catch (e) {
      BootLog.warn('inbody scan unexpected', e);
      if (!mounted) return;
      setState(() => _error = l10n.inbodyScanFailed);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 90,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (picked == null) return;
    await _analyze(await picked.readAsBytes());
  }

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf'],
      withData: kIsWeb,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    try {
      PdfDocument doc;
      if (file.bytes != null) {
        doc = await PdfDocument.openData(file.bytes!);
      } else if (file.path != null) {
        doc = await PdfDocument.openFile(file.path!);
      } else {
        throw Exception('no pdf data');
      }
      final page = await doc.getPage(1);
      final rendered = await page.render(
        width: page.width * 2,
        height: page.height * 2,
        format: PdfPageImageFormat.jpeg,
      );
      await page.close();
      await doc.close();
      if (rendered?.bytes == null) throw Exception('render failed');
      await _analyze(Uint8List.fromList(rendered!.bytes));
    } catch (e) {
      BootLog.warn('inbody pdf failed', e);
      if (mounted) {
        setState(() => _error = AppLocalizations.of(context).inbodyUnreadable);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: Text(l10n.inbodyScanTitle)),
      body: _loading
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(l10n.inbodyAnalyzing),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(VSpace.lg),
              children: [
                AspectRatio(
                  aspectRatio: 0.72,
                  child: CustomPaint(
                    painter: _PaperFramePainter(colors.ember),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          l10n.inbodyFrameHint,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: colors.textMute),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: VSpace.md),
                Text(
                  l10n.inbodyMedicalNote,
                  style: TextStyle(color: colors.textMute, fontSize: 12),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: TextStyle(color: colors.danger)),
                ],
                const SizedBox(height: VSpace.lg),
                FilledButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: Text(l10n.aiScanCamera),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_outlined),
                  label: Text(l10n.aiScanGallery),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: _pickPdf,
                  icon: const Icon(Icons.picture_as_pdf_outlined),
                  label: Text(l10n.inbodyPickPdf),
                ),
              ],
            ),
    );
  }
}

class _PaperFramePainter extends CustomPainter {
  _PaperFramePainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    final inset = size.shortestSide * 0.06;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(inset, inset, size.width - inset * 2, size.height - inset * 2),
        const Radius.circular(8),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
