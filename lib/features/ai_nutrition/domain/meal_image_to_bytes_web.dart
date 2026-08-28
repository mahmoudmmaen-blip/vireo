import 'dart:typed_data';

Future<Uint8List> mealImageToBytesImpl(Object imageFile) async {
  if (imageFile is Uint8List) {
    return imageFile;
  }
  throw ArgumentError('On web, pass Uint8List from image picker.');
}
