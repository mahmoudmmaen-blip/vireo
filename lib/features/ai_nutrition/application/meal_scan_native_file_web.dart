import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

Object mealScanInputFromPicker(XFile picked, List<int> compressedBytes) {
  return Uint8List.fromList(compressedBytes);
}
