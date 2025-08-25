import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings.dart';
import 'package:flutter_test_project/services/parser/parser.dart';

class Storage {
  static const String DATA_KEY = "DATA_CLASSES";
  Future<void> saveSettings(Settings settings) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('settsNew68', jsonEncode(settings.toMap()));
  }

  Future<Settings?> readSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final settings = prefs.getString('settsNew68');
    if (settings != null && settings.isNotEmpty) {
      return Settings.fromMap(jsonDecode(settings));
    }
    return null;
  }

  Future<void> saveSchedule(String date, String jsonFromBloc) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(date, jsonFromBloc);
  }

  Future<String> readSchedule(String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final schedule = prefs.getString(date).toString();
    return schedule;
  }

  Future<void> clearStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final settings = prefs.getString('settsNew68');
    final language = prefs.getString('language');
    prefs.clear();
    prefs.setString('settsNew68', settings ?? '');
    prefs.setString('language', language ?? '');
  }

  Future<void> clearFullStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<void> saveTime(List<String> time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('time4', time);
  }

  Future<List<String>> readTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final time = prefs.getStringList('time4') ?? [];
    return time;
  }

  Future<void> saveClassesData(List<DataClasses> classes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = classes.map((item) => item.toJson()).toList();
      await prefs.setString(DATA_KEY, jsonEncode(jsonList));
    } catch (e) {
      throw Exception('Не удалось сохранить данные в кэш');
    }
  }

  Future<List<DataClasses>> loadClassesData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(DATA_KEY);

      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final decodedData = jsonDecode(jsonString) as List<dynamic>;
      return decodedData.map((item) {
        return DataClasses(
          item['shortName'] as String,
          item['fullName'] as String,
          item['attestationForm'] as String,
          item['teachers'] as String,
        );
      }).toList();
    } catch (e) {
      throw Exception('Не удалось загрузить данные из кэша');
    }
  }

  Future<void> saveLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('language', language);
  }

  Future<String> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('language') ?? '';
  }
}
