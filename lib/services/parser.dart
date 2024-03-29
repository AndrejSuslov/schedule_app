import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';

class ExcelParsing {
  Map<String, List<List<String>>> finalData = {};
  Map<DateTime, List<String>> classesForOneGroup = {};
  late final List<List<String>> _tempData =
      []; // временно для двумерного списка
  static const int _quantityOfClasses = 7;
  final int _quantityOfGroups;
  //final int _quentityOfWeeks;

  ExcelParsing(
    this._quantityOfGroups,
  );

  Future<Map<String, List<List<String>>>?> parseForAllGroups(
      PlatformFile file) async {
    final bytes = await File(file.path ?? '').readAsBytes();
    var decodedExcel = Excel.decodeBytes(bytes);

    for (var row in decodedExcel.tables[decodedExcel.getDefaultSheet()]!.rows) {
      List<String> rowData = [];
      for (var cell in row) {
        cell == null ? rowData.add("") : rowData.add(cell.value.toString());
      }
      _tempData.add(rowData);
    }

    for (int i = 2;
        i < (18 * (_quantityOfGroups + 1)) + 2;
        i += _quantityOfGroups + 1) {
      String tempDateOfClasses = '';
      for (int j = 0; j < _quantityOfClasses * 6; j += _quantityOfClasses) {
        List<List<String>> tempClasses = [[], [], [], [], []];
        tempDateOfClasses = _tempData[j][i];
        for (int q = 0; q < _quantityOfGroups; q++) {
          List<String> temp = [];
          for (int w = 0; w < _quantityOfClasses; w++) {
            temp.add(_tempData[w + j][i + q + 1]);
          }
          tempClasses[q] = temp;
        }
        finalData[tempDateOfClasses] = tempClasses;
      }
    }
    return finalData;
  }

  List<String> getTimeOfClasses() {
    List<String> timeOfClasses = [];
    for (int i = 0; i < _quantityOfClasses; i++) {
      timeOfClasses.add(_tempData[i][1]);
    }
    return timeOfClasses;
  }

  Map<DateTime, List<String>> getClassesForChoosedGroup(int numberOfGroup) {
    for (var key in finalData.keys) {
      var newKey =
          DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.parse(key)));
      classesForOneGroup[newKey] = finalData[key]![numberOfGroup - 1];
    }
    return classesForOneGroup;
  }
}
