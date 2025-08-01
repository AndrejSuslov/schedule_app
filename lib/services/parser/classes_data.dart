part of "parser.dart";

class DataClasses {
  String _shortName;
  String _fullName;
  String _attestationForm;
  String _teachers;

  DataClasses(this._shortName, this._fullName, this._attestationForm, this._teachers);

  String get shortName => _shortName;
  String get fullName => _fullName;
  String get attestationForm => _attestationForm;
  String get teachers => _teachers;
  
}