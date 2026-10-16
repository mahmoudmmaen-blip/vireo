import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/progress/domain/progress_photo_service.dart';
import 'package:vireo/features/progress/providers/progress_extended_provider.dart';

import 'package:vireo/features/progress/screens/photo_comparison_screen.dart';
import 'package:vireo/features/progress/screens/photo_ghost_camera_screen.dart';

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
              title: Text('${l10n.photoSourceCamera} (مع محاذاة الشبح 👻)'),
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

    if (source == null || !mounted) return;

    File? imageFile;
    if (source == ImageSource.camera) {
      // Find latest photo for ghost overlay
      final allPhotos = ref.read(progressPhotosProvider);
      final lastPhoto = allPhotos.where((p) => p.pose == _selectedPose).firstOrNull;
      imageFile = await Navigator.of(context).push<File>(
        MaterialPageRoute<File>(
          builder: (_) => PhotoGhostCameraScreen(
            pose: _selectedPose,
            ghostPhoto: lastPhoto,
          ),
        ),
      );
    } else {
      final picked = await _picker.pickImage(source: source, imageQuality: 85);
      if (picked != null) imageFile = File(picked.path);
    }

    if (imageFile == null || !mounted) return;

    await ProgressPhotoStorageService.savePhoto(
      sourceFile: imageFile,
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
                Icon(Icons.lock_outline, size: 16, color: colors.success),
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
