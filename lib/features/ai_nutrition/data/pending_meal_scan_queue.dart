import 'dart:convert';
import 'dart:typed_data';

import 'package:vireo/core/services/hive_service.dart';

const _queueKey = 'pending_meal_scans_v1';
const _maxPending = 5;

/// Offline queue for compressed meal photos (P52).
abstract final class PendingMealScanQueue {
  static List<PendingMealScan> loadAll() {
    if (!HiveService.isInitialized) return const [];
    final raw = HiveService.cacheBox.get(_queueKey);
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => PendingMealScan.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  static Future<void> enqueue({
    required List<Uint8List> images,
    required String language,
    String? userHint,
  }) async {
    if (!HiveService.isInitialized || images.isEmpty) return;
    final item = PendingMealScan(
      id: 'pending_${DateTime.now().millisecondsSinceEpoch}',
      imagesB64: images.map(base64Encode).toList(),
      language: language,
      userHint: userHint,
      createdAt: DateTime.now(),
    );
    final next = [item, ...loadAll()].take(_maxPending).toList();
    await HiveService.cacheBox.put(
      _queueKey,
      next.map((e) => e.toJson()).toList(),
    );
  }

  static Future<void> remove(String id) async {
    if (!HiveService.isInitialized) return;
    final next = loadAll().where((e) => e.id != id).toList();
    await HiveService.cacheBox.put(
      _queueKey,
      next.map((e) => e.toJson()).toList(),
    );
  }
}

class PendingMealScan {
  const PendingMealScan({
    required this.id,
    required this.imagesB64,
    required this.language,
    required this.createdAt,
    this.userHint,
  });

  final String id;
  final List<String> imagesB64;
  final String language;
  final String? userHint;
  final DateTime createdAt;

  List<Uint8List> get images =>
      imagesB64.map((e) => base64Decode(e)).toList(growable: false);

  factory PendingMealScan.fromJson(Map<String, dynamic> json) {
    return PendingMealScan(
      id: json['id']?.toString() ?? '',
      imagesB64: (json['images'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      language: json['language']?.toString() ?? 'ar',
      userHint: json['user_hint']?.toString(),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'images': imagesB64,
        'language': language,
        if (userHint != null) 'user_hint': userHint,
        'created_at': createdAt.toIso8601String(),
      };
}
