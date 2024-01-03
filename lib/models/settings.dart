import 'dart:ffi';

import 'package:flutter/material.dart';

class Settings {
  ThemeMode themeMode;
  String group;
  String numOfGroups;
  // String course;

  static Settings defaultSettings = Settings(
    ThemeMode.system,
    '1',
    '2',
  );

  Settings(
    this.themeMode,
    this.group,
    this.numOfGroups,
    // this.course,
  );

  Map<String, dynamic> toMap() {
    return {
      'themeMode': themeMode.index,
      'group': group,
      'numOfGroups': numOfGroups,
      // 'course': course,
    };
  }

  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      ThemeMode.values[map['themeMode']],
      map['group'],
      map['numOfGroups'],
      // map['course'],
    );
  }
}
