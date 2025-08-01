part of 'parser.dart';

class Day {
  String _date;
  Map<int, List<String>> _classes;

  Day(this._date, this._classes);

  String get date => _date;

  Map<int, List<String>> get classes => _classes;

  set date(String date) => _date = date;

  set classes(Map<int, List<String>> classes) => _classes = classes;

}