import 'dart:io';

import 'package:image_picker/image_picker.dart';

Object mealScanInputFromPicker(XFile picked, List<int> compressedBytes) {
  return File(picked.path);
}
