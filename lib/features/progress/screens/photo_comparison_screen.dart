import 'dart:io';
import 'dart:ui' as ui show ImageByteFormat, ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/progress/domain/progress_photo_service.dart';

enum ComparisonDisplayMode {
  slider,
  sideBySide,
}

class PhotoComparisonScreen extends StatefulWidget {
  const PhotoComparisonScreen({super.key, required this.photos});

  final List<ProgressPhotoRecord> photos;

  @override
  State<PhotoComparisonScreen> createState() => _PhotoComparisonScreenState();
}

class _PhotoComparisonScreenState extends State<PhotoComparisonScreen> {
  late ProgressPhotoRecord _beforePhoto;
  late ProgressPhotoRecord _afterPhoto;
  double _sliderPosition = 0.5;
  ComparisonDisplayMode _mode = ComparisonDisplayMode.slider;
  bool _blurFace = false;
  bool _isExporting = false;
  final GlobalKey _exportBoundaryKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Default: oldest is before, newest is after
    final sorted = [...widget.photos]..sort((a, b) => a.date.compareTo(b.date));
    _beforePhoto = sorted.first;
    _afterPhoto = sorted.last;
  }

  Future<void> _exportAndShare() async {
    if (_isExporting) return;
    setState(() => _isExporting = true);
    HapticFeedback.mediumImpact();

    try {
      final boundary = _exportBoundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      final Uint8List pngBytes = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/vireo_progress_compare_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(pngBytes);

      if (!mounted) return;
      final isAr = Localizations.localeOf(context).languageCode.startsWith('ar');
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'image/png')],
        text: isAr ? 'مقارنة التقدم البدني مع Vireo 💪' : 'My physique progress comparison with Vireo 💪',
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل تصدير صورة المقارنة')),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  void _pickBeforePhoto() {
    _showPhotoPicker(
      title: 'اختر صورة البداية (قبل)',
      selected: _beforePhoto,
      onSelected: (p) => setState(() => _beforePhoto = p),
    );
  }

  void _pickAfterPhoto() {
    _showPhotoPicker(
      title: 'اختر صورة النهاية (بعد)',
      selected: _afterPhoto,
      onSelected: (p) => setState(() => _afterPhoto = p),
    );
  }

  void _showPhotoPicker({
    required String title,
    required ProgressPhotoRecord selected,
    required ValueChanged<ProgressPhotoRecord> onSelected,
  }) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.photos.length,
                  itemBuilder: (context, i) {
                    final item = widget.photos[i];
                    final isSel = item.id == selected.id;
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(item.localPath),
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(DateFormat.yMMMd().format(item.date)),
                      subtitle: Text(item.pose.name.toUpperCase()),
                      trailing: isSel ? const Icon(Icons.check, color: Colors.green) : null,
                      onTap: () {
                        onSelected(item);
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final l10n = AppLocalizations.of(context);
    final isAr = Localizations.localeOf(context).languageCode.startsWith('ar');

    final beforeFile = File(_beforePhoto.localPath);
    final afterFile = File(_afterPhoto.localPath);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(isAr ? 'مقارنة التقدم البدني' : 'Progress Comparison'),
        actions: [
          // Toggle Slider vs Side-by-Side
          IconButton(
            icon: Icon(_mode == ComparisonDisplayMode.slider ? Icons.view_column_rounded : Icons.compare_arrows_rounded),
            tooltip: _mode == ComparisonDisplayMode.slider
                ? (isAr ? 'عرض جنباً إلى جنب' : 'Side by Side')
                : (isAr ? 'عرض بالمزلاق' : 'Slider Mode'),
            onPressed: () {
              setState(() {
                _mode = _mode == ComparisonDisplayMode.slider
                    ? ComparisonDisplayMode.sideBySide
                    : ComparisonDisplayMode.slider;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: isAr ? 'مشاركة المقارنة' : 'Share',
            onPressed: _exportAndShare,
          ),
        ],
      ),
      body: Column(
        children: [
          // Date selection pills
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.calendar_today, size: 14),
                  label: Text('${isAr ? 'قبل:' : 'Before:'} ${DateFormat.MMMd().format(_beforePhoto.date)}'),
                  onPressed: _pickBeforePhoto,
                ),
                ActionChip(
                  avatar: const Icon(Icons.calendar_today, size: 14),
                  label: Text('${isAr ? 'بعد:' : 'After:'} ${DateFormat.MMMd().format(_afterPhoto.date)}'),
                  onPressed: _pickAfterPhoto,
                ),
              ],
            ),
          ),

          // Privacy face-blur toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.face_retouching_natural_outlined, size: 18, color: colors.textMute),
                const SizedBox(width: 8),
                Text(
                  isAr ? 'تمويه الوجه لحماية الخصوصية' : 'Blur face for privacy',
                  style: TextStyle(fontSize: 12, color: colors.textMute, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Switch(
                  value: _blurFace,
                  activeTrackColor: colors.ember,
                  onChanged: (val) => setState(() => _blurFace = val),
                ),
              ],
            ),
          ),

          // Comparison Area (Inside RepaintBoundary for high-res export)
          Expanded(
            child: RepaintBoundary(
              key: _exportBoundaryKey,
              child: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.black,
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: _mode == ComparisonDisplayMode.slider
                    ? _buildSliderView(beforeFile, afterFile, colors, l10n, isAr)
                    : _buildSideBySideView(beforeFile, afterFile, colors, l10n, isAr),
              ),
            ),
          ),

          // Slider control when in slider mode
          if (_mode == ComparisonDisplayMode.slider) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Slider(
                value: _sliderPosition,
                activeColor: colors.ember,
                onChanged: (v) => setState(() => _sliderPosition = v),
              ),
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSliderView(
    File beforeFile,
    File afterFile,
    VireoColors colors,
    AppLocalizations l10n,
    bool isAr,
  ) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return Stack(
          children: [
            // Base: After Photo
            Positioned.fill(
              child: _buildPhotoWithOptionalBlur(afterFile, l10n),
            ),
            // Clipped: Before Photo
            ClipRect(
              clipper: _ComparisonClipper(splitX: width * _sliderPosition),
              child: SizedBox(
                width: width,
                height: height,
                child: _buildPhotoWithOptionalBlur(beforeFile, l10n),
              ),
            ),
            // Divider Line
            Positioned(
              left: width * _sliderPosition - 1.5,
              top: 0,
              bottom: 0,
              child: Container(width: 3, color: Colors.white),
            ),
            // Drag Handle
            Positioned(
              left: width * _sliderPosition - 16,
              top: height / 2 - 16,
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    _sliderPosition =
                        (_sliderPosition + details.primaryDelta! / width).clamp(0.0, 1.0);
                  });
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: colors.ember,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 4)],
                  ),
                  child: const Icon(Icons.drag_indicator, size: 16, color: Colors.white),
                ),
              ),
            ),
            // Watermark logo
            Positioned(
              bottom: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('VIREO', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSideBySideView(
    File beforeFile,
    File afterFile,
    VireoColors colors,
    AppLocalizations l10n,
    bool isAr,
  ) {
    return Row(
      children: [
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildPhotoWithOptionalBlur(beforeFile, l10n),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(6)),
                  child: Text(isAr ? 'قبل' : 'Before', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
        Container(width: 2, color: Colors.white24),
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildPhotoWithOptionalBlur(afterFile, l10n),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(6)),
                  child: Text(isAr ? 'بعد' : 'After', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoWithOptionalBlur(File file, AppLocalizations l10n) {
    if (!file.existsSync()) {
      return Center(child: Text(l10n.photoMissingFile, style: const TextStyle(color: Colors.white70)));
    }

    Widget img = Image.file(file, fit: BoxFit.cover);

    if (!_blurFace) return img;

    // Apply privacy blur filter on the top 28% of the image (face region)
    return Stack(
      fit: StackFit.expand,
      children: [
        img,
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 120,
          child: ClipRect(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(color: Colors.black.withValues(alpha: 0.15)),
            ),
          ),
        ),
      ],
    );
  }
}

class _ComparisonClipper extends CustomClipper<Rect> {
  _ComparisonClipper({required this.splitX});
  final double splitX;

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, splitX, size.height);
  }

  @override
  bool shouldReclip(covariant _ComparisonClipper oldClipper) => oldClipper.splitX != splitX;
}
