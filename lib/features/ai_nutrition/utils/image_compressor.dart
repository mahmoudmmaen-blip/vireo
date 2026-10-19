import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// Compresses meal photos to max [maxDimension] on the long side
/// as JPEG quality 75 before upload.
/// The `image` package's WebP encoder has no quality argument.
abstract final class MealImageCompressor {
  /// Longest side before upload (P52). Larger than P42's 800 for clarity;
  /// still much smaller than camera originals.
  static const int maxDimension = 1024;
  static const int quality = 75;
  static const String mimeType = 'image/jpeg';

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

    final encoded = img.encodeJpg(working, quality: quality);
    return Uint8List.fromList(encoded);
  }
}
