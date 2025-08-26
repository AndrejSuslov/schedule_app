import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

Future<Uint8List> readPlatformFileBytes(PlatformFile f) async {
  if (f.bytes == null) {
    throw UnsupportedError('On Web call FilePicker with withData: true');
  }
  return f.bytes!;
}