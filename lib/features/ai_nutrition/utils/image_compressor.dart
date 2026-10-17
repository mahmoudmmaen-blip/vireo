import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// Compresses meal photos to max [maxDimension] (720 px on long side)
/// as WebP for lower upload cost (P40 API cost guard).
abstract final class MealImageCompressor {
  static const int maxDimension = 720;

  static Future<Uint8List> compress(
    Uint8List input, {
    int maxSide = maxDimension,
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

    final encoded = img.encodeWebP(working);
    return Uint8List.fromList(encoded);
  }
}
