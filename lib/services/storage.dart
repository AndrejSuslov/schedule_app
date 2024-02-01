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
    if (settings != null) {
      return Settings.fromMap(jsonDecode(settings));
    }
    return null;
  }

  Future<void> saveSchedule(String jsonFromBloc) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('schedule25', jsonFromBloc);
  }

  Future<String> readSchedule() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final schedule = prefs.getString('schedule25').toString();
    return schedule;
  }

  Future<void> clearStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('time4');
    prefs.remove('schedule25');
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
