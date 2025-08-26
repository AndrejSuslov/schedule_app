import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

Future<Uint8List> readPlatformFileBytes(PlatformFile f) async {
  if (f.bytes != null) return f.bytes!;
  final path = f.path;
  if (path == null) {
    throw ArgumentError('Файл пустой!');
  }
  return await File(path).readAsBytes();
}