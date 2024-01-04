import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';

class ExcelParsing {
  Map<String, List<List<String>>> finalData = {};
  Map<DateTime, List<String>> classesForOneGroup = {};
  late final List<List<String>> _tempData =
      []; // временно для двумерного списка
  static const int _quentityOfClasses = 6;
  final int _quentityOfGroups;
  //final int _quentityOfWeeks;

  ExcelParsing(
    this._quentityOfGroups,
    /*this._quentityOfWeeks*/
  ); // enter the quentity of classes and quentity of groups

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
        i <
            (/*_quentityOfWeeks// but is always the quentity equal 18, doesn't it?*/ 18 *
                    (_quentityOfGroups + 1)) +
                2;
        i += _quentityOfGroups + 1) {
      String tempDateOfClasses = '';

      for (int j = 0; j < _quentityOfClasses * 6; j += _quentityOfClasses) {
        List<List<String>> tempClasses = [[], [], [], [], []];
        tempDateOfClasses = _tempData[j][i];
        // .replaceRange(10, this._tempData[j][i].length, '');

        for (int q = 0; q < _quentityOfGroups; q++) {
          List<String> temp = [];
          for (int w = 0; w < _quentityOfClasses; w++) {
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
    for (int i = 0; i < _quentityOfClasses; i++) {
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
