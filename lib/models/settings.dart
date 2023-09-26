import 'package:flutter/material.dart';

class Settings {
  ThemeMode themeMode;
  String group;
  // String course;

  static Settings defaultSettings = Settings(ThemeMode.system, '' /*,''*/);

  Settings(
    this.themeMode,
    this.group,
    // this.course,
  );

  Map<String, dynamic> toMap() {
    return {
      'themeMode': themeMode.index,
      'group': group,
      // 'course': course,
    };
  }

  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      ThemeMode.values[map['themeMode']],
      map['group'],
      // map['course'],
    );
  }
}
