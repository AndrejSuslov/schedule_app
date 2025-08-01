import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings.dart';
// import '../models/schedule.dart';

class Storage {
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
    prefs.clear();
    prefs.setString('settsNew68', settings ?? '');
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
}
