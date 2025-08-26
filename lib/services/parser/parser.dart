import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'platform_file_bytes_io.dart' if (dart.library.html) 'platform_file_bytes_web.dart';

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

  ExcelParsing(this.quantityOfGroups);

  Future<List<Day>?> parse(PlatformFile file) async {
    final bytes = await readPlatformFileBytes(file);
    return parseBytes(bytes);
  }

///////////////////////////////////////////////////////////////////////////////////////////////////

  Future<List<Day>?> parseBytes(Uint8List bytes) async {
    excel = Excel.decodeBytes(bytes);
    if (!_isThereSeparationByStreams(excel)) {
      final defaultSheet = excel.getDefaultSheet() ?? excel.sheets.keys.first;
      var sheet = excel[defaultSheet];
      var firstClasses = _parseClasses(sheet, FIRST_START_CLASSES_CELL_COLUMN, FIRST_START_CLASSES_CELL_ROW, quantityOfGroups);
      var secondClasses = _parseClasses(sheet, SECOND_START_CLASSES_CELL_COLUMN, SECOND_START_CLASSES_CELL_ROW, quantityOfGroups);
      firstClasses.addAll(secondClasses);
      return firstClasses;
    } else {
      List<Day> resultFirst = [];
      List<Day> resultSecond = [];
      for (var sheet in excel.sheets.values) {
        if (sheet.sheetName == excel.getDefaultSheet()) {
          var firstClasses = _parseClasses(sheet, FIRST_START_CLASSES_CELL_COLUMN, FIRST_START_CLASSES_CELL_ROW + 1, 3);
          var secondClasses = _parseClasses(sheet, SECOND_START_CLASSES_CELL_COLUMN, SECOND_START_CLASSES_CELL_ROW + 2, 3);
          resultFirst.addAll(firstClasses);
          resultFirst.addAll(secondClasses);
        } else {
          var firstClasses = _parseClasses(sheet, FIRST_START_CLASSES_CELL_COLUMN, FIRST_START_CLASSES_CELL_ROW, 2);
          var secondClasses = _parseClasses(sheet, SECOND_START_CLASSES_CELL_COLUMN, SECOND_START_CLASSES_CELL_ROW + 1, 2);
          resultSecond.addAll(firstClasses);
          resultSecond.addAll(secondClasses);
        }
      }
      for (var day1 in resultFirst) {
        for (var day2 in resultSecond) {
          if (day1._date == day2._date) {
            day1._classes[4] = day2._classes[1] ?? List.empty();
            day1._classes[5] = day2._classes[2] ?? List.empty();
          }
        }
      }
      return resultFirst;
    }
  }

///////////////////////////////////////////////////////////////////////////////////////////////////

  List<String> parseTimeOfClasses() {
    final defaultSheet = excel.getDefaultSheet() ?? excel.sheets.keys.first;
    var sheet = excel[defaultSheet];
    List<String> time = [];
    for (int i = 0; i < QUANTITY_OF_CLASSES; i++) {
      time.add(_getValue(sheet, 1, FIRST_START_CLASSES_CELL_ROW + i));
    }
    if (_isThereSeparationByStreams(excel)) {
      time = [];
      for (int i = 0; i < QUANTITY_OF_CLASSES; i++) {
        time.add(_getValue(sheet, 1, FIRST_START_CLASSES_CELL_ROW + 1 + i));
      }
    }
    return time;
  }

///////////////////////////////////////////////////////////////////////////////////////////////////

  List<DataClasses> parseDataClasses() {
    final defaultSheet = excel.getDefaultSheet() ?? excel.sheets.keys.first;
    var sheet = excel[defaultSheet];
    List<DataClasses> result = [];
    int i = 0;
    while (_isValidRussianClass(_getValue(sheet, CLASSES_DATA_START_CELL_COLUMN, CLASSES_DATA_START_CELL_ROW + i))) {
      var (shortName, firstCol) = _getNextValueWhileNotNull(sheet, CLASSES_DATA_START_CELL_COLUMN, CLASSES_DATA_START_CELL_ROW + i);
      var (fullName, secondCol) = _getNextValueWhileNotNull(sheet, firstCol, CLASSES_DATA_START_CELL_ROW + i);
      var (attestationForm, thirdCol) = _getNextValueWhileNotNull(sheet, secondCol, CLASSES_DATA_START_CELL_ROW + i);
      var (teachers, fourth) = _getNextValueWhileNotNull(sheet, thirdCol, CLASSES_DATA_START_CELL_ROW + i);
      i++;
      result.add(DataClasses(shortName, fullName, attestationForm, teachers));
    }
    if (_isThereSeparationByStreams(excel)) {
      result = [];
      i = 0;
      while (_isValidRussianClass(_getValue(sheet, CLASSES_DATA_START_CELL_COLUMN, CLASSES_DATA_START_CELL_ROW + 1 + i))) {
        var (shortName, firstCol) = _getNextValueWhileNotNull(sheet, CLASSES_DATA_START_CELL_COLUMN, CLASSES_DATA_START_CELL_ROW + 1 + i);
        var (fullName, secondCol) = _getNextValueWhileNotNull(sheet, firstCol, CLASSES_DATA_START_CELL_ROW + 1 + i);
        var (attestationForm, thirdCol) = _getNextValueWhileNotNull(sheet, secondCol, CLASSES_DATA_START_CELL_ROW + 1 + i);
        var (teachers, fourth) = _getNextValueWhileNotNull(sheet, thirdCol, CLASSES_DATA_START_CELL_ROW + 1 + i);
        i++;
        result.add(DataClasses(shortName, fullName, attestationForm, teachers));
      }
    }
    return result;
  }

  List<Day> _parseClasses(Sheet sheet, int startIndexColumn, int startIndexRow, int quantityOfGroups) {
    List<Day> result = [];
    final horizontalMerges = _getHorizontalMerges(sheet);
    for (int week = 0; week < WEEKS_IN_ROW; week++) {
      for (int day = 0; day < DAYS_IN_WEEK; day++) {
        Map<int, List<String>> groupClasses = {};
        var cell = _getData(sheet, startIndexColumn + week * (quantityOfGroups + 1) - 1, startIndexRow + day * QUANTITY_OF_CLASSES);
        late String date;
        if (cell.value != null) {
          if (_isCellFormula(cell)) {
            date = _dateToString(_resolveDateFormula(cell, sheet, quantityOfGroups) ?? DateTime.now());
          } else {
            date = _dateToString(DateTime.parse(cell.value.toString()));
          }
          for (int group = 0; group < quantityOfGroups; group++) {
            List<String> classes = [];
            for (int clazz = 0; clazz < QUANTITY_OF_CLASSES; clazz++) {
              int col = startIndexColumn + week * (quantityOfGroups + 1) + group;
              int row = startIndexRow + day * QUANTITY_OF_CLASSES + clazz;
              final cellRef = _getCellReference(col, row);
              final mergedValue = _getHorizontalMergeValue(sheet, horizontalMerges, cellRef);
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

  String _getValue(Sheet sheet, int columnIndex, int rowIndex) {
    return sheet.cell(CellIndex.indexByColumnRow(columnIndex: columnIndex, rowIndex: rowIndex)).value?.toString() ?? 'null';
  }

  Data _getData(Sheet sheet, int columnIndex, int rowIndex) {
    return sheet.cell(CellIndex.indexByColumnRow(columnIndex: columnIndex, rowIndex: rowIndex));
  }

  bool _isValidRussianClass(String text) {
    return RegExp(r'^[А-ЯЁA-Z][а-яёa-zА-ЯЁA-Z\-()\s.,]*$').hasMatch(text);
  }

  bool _isCellFormula(Data cell) {
    return cell.value is FormulaCellValue && cell.value != null;
  }

  DateTime? _resolveDateFormula(Data cell, Sheet sheet, int quantityOfGroups) {
    if (cell.value is DateCellValue) {
      return (cell.value as DateCellValue).asDateTimeLocal();
    }
    if (_isCellFormula(cell)) {
      final formula = (cell.value as FormulaCellValue).formula;
      final pattern = RegExp(r'^([A-Z]+)(\d+)\s*\+\s*(\d+)$');
      final match = pattern.firstMatch(formula);
      if (match != null) {
        final columnLetter = match.group(1)!;
        final rowNumber = int.parse(match.group(2)!);
        final daysToAdd = int.parse(match.group(3)!);
        final columnIndex = _columnLetterToIndex(columnLetter);
        final refCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: columnIndex, rowIndex: rowNumber - 1));
        final baseDate = _resolveDateFormula(refCell, sheet, quantityOfGroups);
        return baseDate != null ? _addDaysToExcelDate(baseDate, daysToAdd) : null;
      }
    }
    return null;
  }

///////////////////////////////////////////////////////////////////////////////////////////////////

  int _columnLetterToIndex(String columnLetter) {
    int index = 0;
    for (int i = 0; i < columnLetter.length; i++) {
      index = index * 26 + (columnLetter.codeUnitAt(i) - 'A'.codeUnitAt(0) + 1);
    }
    return index - 1;
  }

///////////////////////////////////////////////////////////////////////////////////////////////////

  DateTime _addDaysToExcelDate(DateTime excelDate, int daysToAdd) {
    return excelDate.add(Duration(days: daysToAdd));
  }

///////////////////////////////////////////////////////////////////////////////////////////////////

  String _dateToString(DateTime date) {
    return date.toString().replaceRange(10, date.toString().length, '');
  }

///////////////////////////////////////////////////////////////////////////////////////////////////

  Map<String, String> _getHorizontalMerges(Sheet sheet) {
    final merges = <String, String>{};
    for (final mergeRange in sheet.spannedItems) {
      final parts = mergeRange.split(':');
      if (parts.length != 2) continue;
      final startCell = parts[0];
      final endCell = parts[1];
      final (_, sRow) = _parseCellRef(startCell);
      final (_, eRow) = _parseCellRef(endCell);
      if (sRow == eRow) {
        merges[mergeRange] = startCell;
      }
    }
    return merges;
  }

///////////////////////////////////////////////////////////////////////////////////////////////////

  String? _getHorizontalMergeValue(Sheet sheet, Map<String, String> merges, String cellRef) {
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

///////////////////////////////////////////////////////////////////////////////////////////////////

  String _getCellReference(int col, int row) {
    final colLetters = _indexToColumnLetters(col);
    return '$colLetters${row + 1}';
  }

///////////////////////////////////////////////////////////////////////////////////////////////////

  bool _isCellInMerge(String cellRef, String mergeRange) {
    final parts = mergeRange.split(':');
    if (parts.length != 2) return false;
    final (cCol, cRow) = _parseCellRef(cellRef);
    final (sCol, sRow) = _parseCellRef(parts[0]);
    final (eCol, eRow) = _parseCellRef(parts[1]);
    return cRow >= sRow && cRow <= eRow && cCol >= sCol && cCol <= eCol;
  }

///////////////////////////////////////////////////////////////////////////////////////////////////

  int _compareCellRefs(String a, String b) {
    final (aCol, aRow) = _parseCellRef(a);
    final (bCol, bRow) = _parseCellRef(b);
    if (aRow != bRow) return aRow.compareTo(bRow);
    return aCol.compareTo(bCol);
  }

///////////////////////////////////////////////////////////////////////////////////////////////////

  (String, int) _getNextValueWhileNotNull(Sheet sheet, int indexColumn, int indexRow) {
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

///////////////////////////////////////////////////////////////////////////////////////////////////

  (int, int) _parseCellRef(String ref) {
    final re = RegExp(r'^([A-Z]+)(\d+)$');
    final m = re.firstMatch(ref);
    if (m == null) return (0, 0);
    final colLetters = m.group(1)!;
    final row = int.parse(m.group(2)!);
    return (_columnLetterToIndex(colLetters), row);
  }

///////////////////////////////////////////////////////////////////////////////////////////////////

  String _indexToColumnLetters(int index) {
    var n = index + 1;
    final buf = StringBuffer();
    while (n > 0) {
      final rem = (n - 1) % 26;
      buf.writeCharCode(65 + rem);
      n = (n - 1) ~/ 26;
    }
    return buf.toString().split('').reversed.join();
  }

  bool _isThereSeparationByStreams(Excel excel) {
    var defaultSheetName = excel.getDefaultSheet() ?? "";
    for (var sheetEntry in excel.sheets.entries) {
      if (sheetEntry.key != defaultSheetName) {
        if (sheetEntry.value.spannedItems.isNotEmpty) {
          return true;
        }
      }
    }
    return false;
  }
}
