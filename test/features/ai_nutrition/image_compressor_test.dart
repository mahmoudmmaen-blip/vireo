import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:vireo/features/ai_nutrition/utils/image_compressor.dart';

void main() {
  test('compresses longest side to max 1024', () async {
    final big = img.Image(width: 2400, height: 1600);
    img.fill(big, color: img.ColorRgb8(200, 100, 50));
    final raw = Uint8List.fromList(img.encodeJpg(big, quality: 95));

    final out = await MealImageCompressor.compress(raw);
    final decoded = img.decodeImage(out);
    expect(decoded, isNotNull);
    final maxSide =
        decoded!.width >= decoded.height ? decoded.width : decoded.height;
    expect(maxSide, lessThanOrEqualTo(MealImageCompressor.maxDimension));
    expect(MealImageCompressor.maxDimension, 1024);
    expect(out.length, lessThan(raw.length));
  });
}
