import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class Settings {
  ThemeMode themeMode;
  String group;
  String numOfGroups;
  bool isFirstLaunch = true;
  String? file;
  // String course;

  static Settings defaultSettings = Settings(
    ThemeMode.system,
    '1',
    '2',
    true,
  );

  Settings(
    this.themeMode,
    this.group,
    this.numOfGroups,
    this.isFirstLaunch,
    // this.course,
  );

  Map<String, dynamic> toMap() {
    return {
      'themeMode': themeMode.index,
      'group': group,
      'numOfGroups': numOfGroups,
      'isFirstLaunch': isFirstLaunch,
      // 'course': course,
    };
  }

  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      ThemeMode.values[map['themeMode']],
      map['group'],
      map['numOfGroups'],
      map['isFirstLaunch'],
      // map['course'],
    );
  }
}
