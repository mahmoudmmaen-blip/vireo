import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/progress/domain/progress_photo_service.dart';
import 'package:vireo/features/progress/providers/progress_extended_provider.dart';

class ProgressPhotosSection extends ConsumerStatefulWidget {
  const ProgressPhotosSection({super.key});

  @override
  ConsumerState<ProgressPhotosSection> createState() => _ProgressPhotosSectionState();
}

class _ProgressPhotosSectionState extends ConsumerState<ProgressPhotosSection> {
  final ImagePicker _picker = ImagePicker();
  PhotoPose _selectedPose = PhotoPose.front;

  Future<void> _pickAndAddPhoto() async {
    final l10n = AppLocalizations.of(context);
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: Text(l10n.photoSourceCamera),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.photoSourceGallery),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final picked = await _picker.pickImage(source: source, imageQuality: 85);
    if (picked == null || !mounted) return;

    await ProgressPhotoStorageService.savePhoto(
      sourceFile: File(picked.path),
      date: DateTime.now(),
      pose: _selectedPose,
    );

    ref.read(progressPhotosProvider.notifier).refresh();
  }

  void _openComparison(List<ProgressPhotoRecord> photos) {
    if (photos.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: Text(AppLocalizations.of(context).photosNeedTwoToCompare),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => PhotoComparisonScreen(photos: photos),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final photos = ref.watch(progressPhotosProvider);
    final filtered = photos.where((p) => p.pose == _selectedPose).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.progressPhotosTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Row(
                children: [
                  if (photos.length >= 2)
                    IconButton(
                      icon: const Icon(Icons.compare, size: 20),
                      tooltip: l10n.photosCompareSideBySide,
                      onPressed: () => _openComparison(photos),
                    ),
                  IconButton(
                    icon: const Icon(Icons.add_a_photo, size: 20),
                    onPressed: _pickAndAddPhoto,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          // ── Privacy Guard Notice ──
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colors.line.withValues(alpha: 0.6)),
            ),
            child: Row(
              children: [
                const Icon(Icons.lock_outline, size: 16, color: Color(0xFF22C55E)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.photosPrivacyNote,
                    style: TextStyle(
                      fontSize: 11,
                      color: colors.textMute,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Pose switcher
          Row(
            children: PhotoPose.values.map((pose) {
              final active = _selectedPose == pose;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(pose.label(locale)),
                  selected: active,
                  onSelected: (_) => setState(() => _selectedPose = pose),
                  selectedColor: colors.ember.withValues(alpha: 0.2),
                  labelStyle: TextStyle(
                    color: active ? colors.ember : colors.textMute,
                    fontWeight: active ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          if (filtered.isEmpty)
            Container(
              height: 110,
              alignment: Alignment.center,
              child: Text(
                'No ${_selectedPose.label(locale)} photos yet. Tap camera to add one.',
                style: TextStyle(color: colors.textMute, fontSize: 12),
              ),
            )
          else
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filtered.length,
                itemBuilder: (ctx, i) {
                  final item = filtered[i];
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 110,
                            height: 150,
                            color: colors.surface,
                            child: File(item.localPath).existsSync()
                                ? Image.file(File(item.localPath), fit: BoxFit.cover)
                                : const Center(child: Icon(Icons.broken_image, size: 30)),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(12),
                              ),
                            ),
                            child: Text(
                              DateFormat.MMMd().format(item.date),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () async {
                              await ref.read(progressPhotosProvider.notifier).delete(item.id);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, size: 14, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
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

  @override
  void initState() {
    super.initState();
    // Default: oldest is before, newest is after
    final sorted = [...widget.photos]..sort((a, b) => a.date.compareTo(b.date));
    _beforePhoto = sorted.first;
    _afterPhoto = sorted.last;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(l10n.photosCompareSideBySide),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.photoBeforeLabel, style: TextStyle(color: colors.textMute, fontSize: 12)),
                    Text(
                      DateFormat.yMMMd().format(_beforePhoto.date),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(l10n.photoAfterLabel, style: TextStyle(color: colors.textMute, fontSize: 12)),
                    Text(
                      DateFormat.yMMMd().format(_afterPhoto.date),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (ctx, constraints) {
                final width = constraints.maxWidth;
                final height = constraints.maxHeight;

                final beforeFile = File(_beforePhoto.localPath);
                final afterFile = File(_afterPhoto.localPath);

                return Stack(
                  children: [
                    // Base: After Photo (full width)
                    Positioned.fill(
                      child: afterFile.existsSync()
                          ? Image.file(afterFile, fit: BoxFit.cover)
                          : Center(child: Text(l10n.photoMissingFile)),
                    ),
                    // Clipped overlay: Before Photo
                    ClipRect(
                      clipper: _ComparisonClipper(splitX: width * _sliderPosition),
                      child: SizedBox(
                        width: width,
                        height: height,
                        child: beforeFile.existsSync()
                            ? Image.file(beforeFile, fit: BoxFit.cover)
                            : Center(child: Text(l10n.photoMissingFile)),
                      ),
                    ),
                    // Divider Line
                    Positioned(
                      left: width * _sliderPosition - 1.5,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 3,
                        color: Colors.white,
                      ),
                    ),
                    // Drag handle
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
                            boxShadow: const [
                              BoxShadow(color: Colors.black38, blurRadius: 4),
                            ],
                          ),
                          child: const Icon(Icons.drag_indicator, size: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Slider(
            value: _sliderPosition,
            activeColor: colors.ember,
            onChanged: (v) => setState(() => _sliderPosition = v),
          ),
          const SizedBox(height: 12),
        ],
      ),
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
