import 'dart:convert';
import 'dart:ui' as ui;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../integrations/telegram.dart';
import '../models/settings.dart';
import 'package:flutter_test_project/services/parser/parser.dart';

class Storage {
  static const String DATA_KEY = "DATA_CLASSES";
  static const String SETTINGS_KEY = 'settsNew68';
  static const String LANGUAGE_KEY = 'language';
  static const _supported = {'ru', 'be', 'en'};

  bool get _useTg => kIsWeb && TelegramWebApp.isAvailable;

  String get _deviceLang {
    final code =
        ui.PlatformDispatcher.instance.locale.languageCode.toLowerCase();
    return _supported.contains(code) ? code : 'en';
  }

  Future<void> saveSettings(Settings settings) async {
    final json = jsonEncode(settings.toMap());
    if (_useTg) {
      await TelegramWebApp.cloudSetItem(SETTINGS_KEY, json);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(SETTINGS_KEY, json);
    }
  }

  Future<Settings?> readSettings() async {
    if (_useTg) {
      final s = await TelegramWebApp.cloudGetItem(SETTINGS_KEY);
      if (s != null && s.isNotEmpty) return Settings.fromMap(jsonDecode(s));
      return null;
    } else {
      final prefs = await SharedPreferences.getInstance();
      final s = prefs.getString(SETTINGS_KEY);
      if (s != null && s.isNotEmpty) return Settings.fromMap(jsonDecode(s));
      return null;
    }
  }

  Future<void> saveSchedule(String date, String jsonFromBloc) async {
    if (_useTg) {
      final key = 'schedule:$date';
      await TelegramWebApp.deviceSetItem(key, jsonFromBloc);
      await TelegramWebApp.cloudSetItem('current_schedule_key', key);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(date, jsonFromBloc);
    }
  }

  Future<String> readSchedule(String date) async {
    if (_useTg) {
      final key = 'schedule:$date';
      final s = await TelegramWebApp.deviceGetItem(key);
      return s ?? '';
    } else {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(date) ?? '';
    }
  }

  Future<void> clearStorage() async {
    if (_useTg) {
      return;
    } else {
      final prefs = await SharedPreferences.getInstance();
      final settings = prefs.getString(SETTINGS_KEY);
      final language = prefs.getString(LANGUAGE_KEY);
      await prefs.clear();
      await prefs.setString(SETTINGS_KEY, settings ?? '');
      await prefs.setString(LANGUAGE_KEY, language ?? '');
    }
  }

  Future<void> clearFullStorage() async {
    if (_useTg) {
      return;
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    }
  }

  Future<void> saveTime(List<String> time) async {
    if (_useTg) {
      await TelegramWebApp.cloudSetItem('time4', jsonEncode(time));
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('time4', time);
    }
  }

  Future<List<String>> readTime() async {
    if (_useTg) {
      final s = await TelegramWebApp.cloudGetItem('time4');
      if (s == null || s.isEmpty) return [];
      final list = (jsonDecode(s) as List).map((e) => e.toString()).toList();
      return list;
    } else {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList('time4') ?? [];
    }
  }

  Future<void> saveClassesData(List<DataClasses> classes) async {
    final jsonList = classes.map((item) => item.toJson()).toList();
    final jsonStr = jsonEncode(jsonList);
    if (_useTg) {
      await TelegramWebApp.deviceSetItem(DATA_KEY, jsonStr);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(DATA_KEY, jsonStr);
    }
  }

  Future<List<DataClasses>> loadClassesData() async {
    final String? jsonString;
    if (_useTg) {
      jsonString = await TelegramWebApp.deviceGetItem(DATA_KEY);
    } else {
      final prefs = await SharedPreferences.getInstance();
      jsonString = prefs.getString(DATA_KEY);
    }
    if (jsonString == null || jsonString.isEmpty) return [];
    final decodedData = jsonDecode(jsonString) as List<dynamic>;
    return decodedData
        .map((item) => DataClasses(
              item['shortName'] as String,
              item['fullName'] as String,
              item['attestationForm'] as String,
              item['teachers'] as String,
            ))
        .toList();
  }

  Future<void> saveLanguage(String language) async {
    if (_useTg) {
      await TelegramWebApp.cloudSetItem(LANGUAGE_KEY, language);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(LANGUAGE_KEY, language);
    }
  }

  Future<String> loadLanguage() async {
    if (_useTg) {
      final v = await TelegramWebApp.cloudGetItem(LANGUAGE_KEY);
      return (v == null || v.isEmpty) ? _deviceLang : v;
    } else {
      final prefs = await SharedPreferences.getInstance();
      final v = prefs.getString(LANGUAGE_KEY);
      return (v == null || v.isEmpty) ? _deviceLang : v;
    }
  }
}
