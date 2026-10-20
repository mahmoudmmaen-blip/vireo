import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:flutter/services.dart';

/// Load a gzipped JSON asset (`*.json.gz`) into a Dart object (P55 size cut).
Future<Object?> loadGzippedJsonAsset(String assetPath) async {
  final data = await rootBundle.load(assetPath);
  final bytes = data.buffer.asUint8List();
  final decoded = const GZipDecoder().decodeBytes(bytes);
  return jsonDecode(utf8.decode(decoded));
}

Future<Map<String, dynamic>> loadGzippedJsonMap(String assetPath) async {
  final decoded = await loadGzippedJsonAsset(assetPath);
  return Map<String, dynamic>.from(decoded as Map);
}
