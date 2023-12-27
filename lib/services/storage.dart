import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings.dart';
// import '../models/schedule.dart';

class Storage {
  Future<void> saveSettings(Settings settings) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('settsNew55', jsonEncode(settings.toMap()));
  }

  Future<Settings?> readSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final settings = prefs.getString('settsNew55');
    if (settings != null) {
      return Settings.fromMap(jsonDecode(settings));
    }
    return null;
  }

  Future<void> saveSchedule(Map<DateTime, List<String>> schedule) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('schedule1', jsonEncode(schedule));
  }

  Future<Map<DateTime, List<String>>?> readSchedule() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final schedule = prefs.getString('schedule1');
    if (schedule != null) return jsonDecode(schedule);
    return null;
  }
}
