import 'dart:io';
import 'dart:typed_data';

Future<Uint8List> mealImageToBytesImpl(Object imageFile) async {
  if (imageFile is File) {
    return imageFile.readAsBytes();
  }
  if (imageFile is Uint8List) {
    return imageFile;
  }
  throw ArgumentError('Expected File or Uint8List, got ${imageFile.runtimeType}');
}
