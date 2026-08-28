import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// Compresses meal photos to at most [maxBytes] (default 1 MB).
abstract final class MealImageCompressor {
  static const maxBytes = 1024 * 1024;

  static Future<Uint8List> compress(Uint8List input, {int maxSize = maxBytes}) async {
    if (input.length <= maxSize) return input;

    final decoded = img.decodeImage(input);
    if (decoded == null) return input;

    var quality = 85;
    var width = decoded.width;

    while (true) {
      final working = width < decoded.width
          ? img.copyResize(decoded, width: width)
          : decoded;
      final encoded = Uint8List.fromList(img.encodeJpg(working, quality: quality));
      if (encoded.length <= maxSize) return encoded;
      if (quality > 45) {
        quality -= 10;
        continue;
      }
      if (width > 480) {
        width = (width * 0.85).round();
        quality = 75;
        continue;
      }
      return encoded;
    }
  }
}
