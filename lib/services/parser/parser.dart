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
    while (_isValidRussianClass(_getValue(sheet, CLASSES_DATA_START_CELL_COLUMN,
        CLASSES_DATA_START_CELL_ROW + i))) {
      var (shortName, firstCol) = _getNextValueWhileNotNull(sheet,
          CLASSES_DATA_START_CELL_COLUMN, CLASSES_DATA_START_CELL_ROW + i);
      var (fullName, secondCol) = _getNextValueWhileNotNull(
          sheet, firstCol, CLASSES_DATA_START_CELL_ROW + i);
      var (attestationForm, thirdCol) = _getNextValueWhileNotNull(
          sheet, secondCol, CLASSES_DATA_START_CELL_ROW + i);
      var (teachers, fourth) = _getNextValueWhileNotNull(
          sheet, thirdCol, CLASSES_DATA_START_CELL_ROW + i);
      i++;
      result.add(DataClasses(shortName, fullName, attestationForm, teachers));
    }
    return result;
  }

///////////////////////////////////////////////////////////////////////////////////////////////////

  List<Day> _parseClasses(
      Sheet sheet, int startIndexColumn, int startIndexRow) {
    sheet = excel[excel.getDefaultSheet() as String];
    List<Day> result = [];
    final horizontalMerges = _getHorizontalMerges(sheet);
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
              int col =
                  startIndexColumn + week * (quantityOfGroups + 1) + group;
              int row = startIndexRow + day * QUANTITY_OF_CLASSES + clazz;

              final cellRef = _getCellReference(col, row);
              final mergedValue =
                  _getHorizontalMergeValue(sheet, horizontalMerges, cellRef);
              classes.add(mergedValue ?? _getValue(sheet, col, row));
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

  //////////////////////////////////////////////////////////////////////////////////////////////////////

  Map<String, String> _getHorizontalMerges(Sheet sheet) {
    final merges = <String, String>{};

    for (final mergeRange in sheet.spannedItems) {
      final parts = mergeRange.split(':');
      if (parts.length != 2) continue;

      final startCell = parts[0];
      final endCell = parts[1];

      // Check if it's horizontal merge (same row)
      if (startCell.substring(1) == endCell.substring(1)) {
        merges[mergeRange] = startCell;
      }
    }

    return merges;
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////

  String? _getHorizontalMergeValue(
      Sheet sheet, Map<String, String> merges, String cellRef) {
    for (final mergeRange in merges.keys) {
      if (_isCellInMerge(cellRef, mergeRange)) {
        final originCellRef = merges[mergeRange]!;
        final originCell = sheet.cell(CellIndex.indexByString(originCellRef));

        if (originCell.value?.toString().isNotEmpty == true) {
          return "${originCell.value} (лк.)";
        }
        break;
      }
    }
    return null;
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////

  String _getCellReference(int col, int row) {
    final colLetter = String.fromCharCode(65 + col);
    return '$colLetter${row + 1}';
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////

  bool _isCellInMerge(String cellRef, String mergeRange) {
    final [start, end] = mergeRange.split(':');
    return _compareCellRefs(cellRef, start) >= 0 &&
        _compareCellRefs(cellRef, end) <= 0;
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////

  int _compareCellRefs(String a, String b) {
    final aCol = a.codeUnitAt(0);
    final aRow = int.parse(a.substring(1));
    final bCol = b.codeUnitAt(0);
    final bRow = int.parse(b.substring(1));

    if (aRow != bRow) return aRow.compareTo(bRow);
    return aCol.compareTo(bCol);
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //TODO refactor this piece of shit, but it works, rewrite the logic later
  (String, int) _getNextValueWhileNotNull(
      Sheet sheet, int indexColumn, int indexRow) {
    for (int i = 0; true; i++) {
      String value = _getValue(sheet, indexColumn + i, indexRow);
      if (value != 'null') {
        return (value, indexColumn + i + 1);
      }
      if (indexColumn + i + 1 > 30) {
        return ('', 0);
      }
    }
  }
}
