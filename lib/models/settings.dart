import 'dart:ffi';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class Settings {
  ThemeMode themeMode;
  String group;
  String numOfGroups;
  PlatformFile? file;
  // String course;

  static Settings defaultSettings = Settings(
    ThemeMode.system,
    '1',
    '2',
    null,
  );

  Settings(
    this.themeMode,
    this.group,
    this.numOfGroups,
    this.file,
    // this.course,
  );

  Map<String, dynamic> toMap() {
    return {
      'themeMode': themeMode.index,
      'group': group,
      'numOfGroups': numOfGroups,
      'file': file,
      // 'course': course,
    };
  }

  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      ThemeMode.values[map['themeMode']],
      map['group'],
      map['numOfGroups'],
      map['file'],
      // map['course'],
    );
  }
}
