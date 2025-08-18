import 'package:flutter/material.dart';

class Settings {
  ThemeMode themeMode;
  String group;
  String numOfGroups;
  bool isFirstLaunch = true;
  bool isScheduleLoaded = false;
  String? file;

  static Settings defaultSettings =
      Settings(ThemeMode.system, '1', '2', true, false);

  Settings(this.themeMode, this.group, this.numOfGroups, this.isFirstLaunch,
      this.isScheduleLoaded);

  Map<String, dynamic> toMap() {
    return {
      'themeMode': themeMode.index,
      'group': group,
      'numOfGroups': numOfGroups,
      'isFirstLaunch': isFirstLaunch,
      'isScheduleLoaded': isScheduleLoaded
    };
  }

  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
        ThemeMode.values[map['themeMode']],
        map['group'],
        map['numOfGroups'],
        map['isFirstLaunch'],
        map['isScheduleLoaded'] != Null ? map['isScheduleLoaded'] : false);
  }
}
