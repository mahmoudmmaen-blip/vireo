import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// Compresses meal photos to max [maxDimension] (768 px on long side)
/// at JPEG quality [quality] (~80–150 KB) for high-speed analysis.
abstract final class MealImageCompressor {
  static const int maxDimension = 768;
  static const int defaultQuality = 70;

  static Future<Uint8List> compress(
    Uint8List input, {
    int maxSide = maxDimension,
    int quality = defaultQuality,
  }) async {
    final decoded = img.decodeImage(input);
    if (decoded == null) return input;

    img.Image working = decoded;
    final int origWidth = decoded.width;
    final int origHeight = decoded.height;
    final int maxDim = origWidth >= origHeight ? origWidth : origHeight;

    if (maxDim > maxSide) {
      if (origWidth >= origHeight) {
        working = img.copyResize(decoded, width: maxSide);
      } else {
        working = img.copyResize(decoded, height: maxSide);
      }
    }

    final encoded = img.encodeJpg(working, quality: quality);
    return Uint8List.fromList(encoded);
  }
}
