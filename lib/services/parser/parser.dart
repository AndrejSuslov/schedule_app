import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';

part 'day.dart';
part 'classes_data.dart';

class ExcelParsing {
  static const int QUANTITY_OF_CLASSES = 6;
  static const int DAYS_IN_WEEK = 6;
  static const int WEEKS_IN_ROW = 9;

  static const int FIRST_START_CLASSES_CELL_COLUMN = 3;
  static const int FIRST_START_CLASSES_CELL_ROW = 14;

  static const int SECOND_START_CLASSES_CELL_COLUMN = 3;
  static const int SECOND_START_CLASSES_CELL_ROW = 54;

  static const int CLASSES_DATA_START_CELL_COLUMN = 1;
  static const int CLASSES_DATA_START_CELL_ROW = 94;

  static const int START_TYPE_OF_CLASSES_COLUMN = 11;
  static const int START_TYPE_OF_CLASSES_ROW = 3;

  static const int CABINETS_START_COLUMN = 14;
  static const int CABINETS_START_ROW = 5;

  late Excel excel;
  final int quantityOfGroups;

  ExcelParsing(
    this.quantityOfGroups,
  );

  Future<List<Day>?> parse(PlatformFile file) async {
    final bytes = await File(file.path ?? '').readAsBytes();
    excel = Excel.decodeBytes(bytes);
    var sheet = excel[excel.getDefaultSheet() as String];
    var firstClasses = _parseClasses(
        sheet, FIRST_START_CLASSES_CELL_COLUMN, FIRST_START_CLASSES_CELL_ROW);
    var secondClasses = _parseClasses(
        sheet, SECOND_START_CLASSES_CELL_COLUMN, SECOND_START_CLASSES_CELL_ROW);
    firstClasses.addAll(secondClasses);
    return firstClasses;
  }

///////////////////////////////////////////////////////////////////////////////////////////////////

  List<String> parseTimeOfClasses() {
    var sheet = excel[excel.getDefaultSheet() as String];
    List<String> time = [];

    for (int i = 0; i < QUANTITY_OF_CLASSES; i++) {
      time.add(_getValue(sheet, 1, FIRST_START_CLASSES_CELL_ROW + i));
    }
    return time;
  }

///////////////////////////////////////////////////////////////////////////////////////////////////

  List<DataClasses> parseDataClasses() {
    var sheet = excel[excel.getDefaultSheet() as String];
    List<DataClasses> result = [];
    int i = 0;
    do {
      result.add(DataClasses(
          _getValue(sheet, CLASSES_DATA_START_CELL_COLUMN,
              CLASSES_DATA_START_CELL_ROW + i),
          _getValue(sheet, CLASSES_DATA_START_CELL_COLUMN + 1,
              CLASSES_DATA_START_CELL_ROW + i),
          _getValue(sheet, CLASSES_DATA_START_CELL_COLUMN + 2,
              CLASSES_DATA_START_CELL_ROW + i),
          _getValue(sheet, CLASSES_DATA_START_CELL_COLUMN + 3,
              CLASSES_DATA_START_CELL_ROW + i)));
    } while (_isValidRussianClass(_getValue(sheet,
        CLASSES_DATA_START_CELL_COLUMN, CLASSES_DATA_START_CELL_ROW + ++i)));
    return result;
  }

///////////////////////////////////////////////////////////////////////////////////////////////////

  List<Day> _parseClasses(
      Sheet sheet, int startIndexColumn, int startIndexRow) {
    sheet = excel[excel.getDefaultSheet() as String];
    List<Day> result = [];
    for (int week = 0; week < WEEKS_IN_ROW; week++) {
      for (int day = 0; day < DAYS_IN_WEEK; day++) {
        Map<int, List<String>> groupClasses = {};
        var cell = _getData(
            sheet,
            startIndexColumn + week * (quantityOfGroups + 1) - 1,
            startIndexRow + day * QUANTITY_OF_CLASSES);
        late String date;
        if (cell.value != null) {
          if (_isCellFormula(cell)) {
            date = _dateToString(
                _resolveDateFormula(cell, sheet) ?? DateTime.now());
          } else {
            date = _dateToString(DateTime.parse(cell.value.toString()));
          }

          for (int group = 0; group < quantityOfGroups; group++) {
            List<String> classes = [];

            for (int clazz = 0; clazz < QUANTITY_OF_CLASSES; clazz++) {
              classes.add(_getValue(
                  sheet,
                  startIndexColumn + startIndexColumn * week + group,
                  startIndexRow + day * QUANTITY_OF_CLASSES + clazz));
            }
            groupClasses[group + 1] = classes;
          }
          result.add(Day(date, groupClasses));
        }
      }
    }
    return result;
  }

///////////////////////////////////////////////////////////////////////////////////////////////////

  String _getValue(Sheet sheet, int columnIndex, int rowIndex) {
    return sheet
            .cell(CellIndex.indexByColumnRow(
                columnIndex: columnIndex, rowIndex: rowIndex))
            .value
            ?.toString() ??
        'null';
  }

  Data _getData(Sheet sheet, int columnIndex, int rowIndex) {
    return sheet.cell(CellIndex.indexByColumnRow(
        columnIndex: columnIndex, rowIndex: rowIndex));
  }

///////////////////////////////////////////////////////////////////////////////////////////////////

  bool _isValidRussianClass(String text) {
    return RegExp(r'^[А-ЯЁ][а-яёА-ЯЁ\-()\s]*$').hasMatch(text);
  }

///////////////////////////////////////////////////////////////////////////////////////////////////

  bool _isCellFormula(Data cell) {
    return cell.value is FormulaCellValue && cell.value != null;
  }

///////////////////////////////////////////////////////////////////////////////////////////////////

  DateTime? _resolveDateFormula(Data cell, Sheet sheet) {
    if (cell.value is DateCellValue) {
      return (cell.value as DateCellValue).asDateTimeLocal();
    }

    if (_isCellFormula(cell)) {
      final formula = (cell.value as FormulaCellValue).formula;
      final pattern = RegExp(r'^([A-Z]+\d+)\s*\+\s*7$');
      final match = pattern.firstMatch(formula);

      if (match != null) {
        final refCell = sheet.cell(CellIndex.indexByColumnRow(
            columnIndex: cell.columnIndex - quantityOfGroups - 1,
            rowIndex: cell.rowIndex));
        final baseDate = _resolveDateFormula(refCell, sheet);
        return baseDate != null ? _addWeekToExcelDate(baseDate) : null;
      }
    }

    return null;
  }

///////////////////////////////////////////////////////////////////////////////////////////////////

  DateTime _addWeekToExcelDate(DateTime excelDate) {
    const daysToAdd = 7;
    return excelDate.add(const Duration(days: daysToAdd));
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////

  String _dateToString(DateTime date) {
    return date.toString().replaceRange(10, date.toString().length, '');
  }
}
