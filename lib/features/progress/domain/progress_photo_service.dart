import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vireo/core/services/hive_service.dart';

enum PhotoPose {
  front('front', 'Front', 'أمام'),
  side('side', 'Side', 'جانب'),
  back('back', 'Back', 'خلف');

  const PhotoPose(this.id, this.labelEn, this.labelAr);
  final String id;
  final String labelEn;
  final String labelAr;

  String label(String lang) => lang.startsWith('ar') ? labelAr : labelEn;

  static PhotoPose fromId(String id) {
    for (final pose in PhotoPose.values) {
      if (pose.id == id) return pose;
    }
    return PhotoPose.front;
  }
}

@immutable
class ProgressPhotoRecord {
  const ProgressPhotoRecord({
    required this.id,
    required this.date,
    required this.pose,
    required this.localPath,
    this.weightKg,
    this.notes,
  });

  final String id;
  final DateTime date;
  final PhotoPose pose;
  final String localPath;
  final double? weightKg;
  final String? notes;

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'pose': pose.id,
        'local_path': localPath,
        'weight_kg': weightKg,
        'notes': notes,
      };

  factory ProgressPhotoRecord.fromJson(Map<String, dynamic> json) {
    return ProgressPhotoRecord(
      id: json['id'] as String? ?? '',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      pose: PhotoPose.fromId(json['pose'] as String? ?? 'front'),
      localPath: json['local_path'] as String? ?? '',
      weightKg: (json['weight_kg'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
    );
  }
}

class ProgressPhotoStorageService {
  static const _boxKey = 'local_progress_photos';
  static const _backupSettingKey = 'progress_photos_cloud_backup_enabled';

  static bool isCloudBackupEnabled() {
    if (!HiveService.isInitialized) return false;
    return HiveService.settingsBox.get(_backupSettingKey, defaultValue: false) == true;
  }

  static Future<void> setCloudBackupEnabled(bool enabled) async {
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.put(_backupSettingKey, enabled);
  }

  static List<ProgressPhotoRecord> getAllPhotos() {
    if (!HiveService.isInitialized) return [];
    final raw = HiveService.cacheBox.get(_boxKey);
    if (raw is! List) return [];
    final list = <ProgressPhotoRecord>[];
    for (final item in raw) {
      if (item is Map) {
        list.add(ProgressPhotoRecord.fromJson(Map<String, dynamic>.from(item)));
      }
    }
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  /// Saves an image file locally in the app's documents directory.
  static Future<ProgressPhotoRecord> savePhoto({
    required File sourceFile,
    required DateTime date,
    required PhotoPose pose,
    double? weightKg,
    String? notes,
  }) async {
    final appDir = await getApplicationDocumentsDirectory();
    final photosDir = Directory('${appDir.path}/vireo_progress_photos');
    if (!await photosDir.exists()) {
      await photosDir.create(recursive: true);
    }

    final id = 'photo_${DateTime.now().millisecondsSinceEpoch}_${pose.id}';
    final dotIdx = sourceFile.path.lastIndexOf('.');
    final ext = dotIdx != -1 ? sourceFile.path.substring(dotIdx) : '.jpg';
    final targetPath = '${photosDir.path}/$id$ext';

    // Copy to persistent local directory
    final savedFile = await sourceFile.copy(targetPath);

    final record = ProgressPhotoRecord(
      id: id,
      date: date,
      pose: pose,
      localPath: savedFile.path,
      weightKg: weightKg,
      notes: notes,
    );

    final existing = getAllPhotos();
    final updated = [...existing, record];
    await HiveService.cacheBox.put(
      _boxKey,
      updated.map((e) => e.toJson()).toList(),
    );

    return record;
  }

  static Future<void> deletePhoto(String id) async {
    final existing = getAllPhotos();
    final toRemove = existing.where((e) => e.id == id).toList();
    for (final r in toRemove) {
      try {
        final f = File(r.localPath);
        if (await f.exists()) {
          await f.delete();
        }
      } catch (_) {}
    }

    final updated = existing.where((e) => e.id != id).toList();
    await HiveService.cacheBox.put(
      _boxKey,
      updated.map((e) => e.toJson()).toList(),
    );
  }
}
