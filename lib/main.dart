import 'package:flutter/material.dart';
import 'package:flutter_test_project/services/parser.dart';
import 'dart:ffi';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_project/themes/dark_theme/dark_theme.dart';
import 'package:flutter_test_project/themes/light_theme/light_theme.dart';
import 'package:flutter_test_project/widgets/bottom_navigation_bar.dart';
import 'blocs/settings_bloc/settings_bloc.dart';
import 'generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

// void main() {
//   runApp(const ScheduleApp());
// }

// class ScheduleApp extends StatelessWidget {
//   const ScheduleApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return _buildApplication(context);
//   }

//   Widget _buildApplication(BuildContext context) {
//     return BlocProvider<SettingsBloc>(
//       create: (context) => SettingsBloc(),
//       child: BlocBuilder<SettingsBloc, SettingsState>(
//         buildWhen: (prevState, newState) {
//           return newState is! SettingsError;
//         },
//         builder: (context, state) {
//           if (state is SettingsLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is SettingsLoaded) {
//             return MaterialApp(
//               debugShowCheckedModeBanner: false,
//               onGenerateTitle: (context) => S.of(context).schedule,
//               theme: lightTheme,
//               darkTheme: darkTheme,
//               themeMode: state.settings.themeMode,
//               supportedLocales: S.delegate.supportedLocales,
//               localizationsDelegates: const [
//                 S.delegate,
//                 GlobalMaterialLocalizations.delegate,
//                 GlobalWidgetsLocalizations.delegate,
//                 GlobalCupertinoLocalizations.delegate,
//               ],
//               home: Builder(
//                 builder: (context) {
//                   //ИЗМЕНИТЬ НА ISNOTEMPTY КОГДА ДОБАВИМ ГРУППЫ!!!!!
//                   if (state.settings.group.isEmpty) {
//                     return const BottomNavBar();
//                   }
//                   return Text("error");
//                 },
//               ),
//             );
//           }
//           return const Center(child: CircularProgressIndicator());
//         },
//       ),
//     );
//   }
// }

void main() {
  var some = ExcelParsing(6, 2);
}

// class ExcelParsing extends StatelessWidget {
//   List<Map<String, List<List<String>>>> _finalData = [];
// // список групп со списками словарей, где ключ - дата и значение спиок пар
//   List<List<String>> _tempData = []; // временно для двумерного списка
//   List<String> _timeOfClasses = [];
//   var _decodedExcel;
//   int _quentityOfClasses;
//   int _quentityOfGroups;

//   ExcelParsing(this._quentityOfClasses,
//       this._quentityOfGroups); // enter the quentity of classes and quentity of groups

//   Future<Excel> pickAndDecodeExcel() async {
//     //this method picks some file and deccodes it
//     // ByteData data = await rootBundle.load('UIR2.xlsx');
//     // var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//     // return _decodedExcel = Excel.decodeBytes(bytes);

//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['xlsx'],
//     );
//     if (result != null) {
//       PlatformFile file = result.files.first;
//       final bytes = await File(file.path!).readAsBytes();
//       _decodedExcel = Excel.decodeBytes(bytes);
//       return _decodedExcel;
//     } else {
//       return 0 as Excel;
//     }
//   }

//   List<List<String>> saveDataToTemp() {
//     // here all data is assembled to twodimensional array
//     Excel excel = pickAndDecodeExcel() as Excel;
//     for (var row in excel.tables[excel.getDefaultSheet()]!.rows) {
//       List<String> rowData = [];
//       for (var cell in row) {
//         cell == null ? rowData.add('') : rowData.add(cell.value.toString());
//       }
//       this._tempData.add(rowData);
//     }
//     return this._tempData;
//   }

//   List<String> get timeOfClasses {
//     // returns the list of time of beggining of classes
//     for (int i = 0; i < _quentityOfClasses; i++) {
//       this._timeOfClasses!.add(this._tempData[i][1]);
//     }
//     return this._timeOfClasses;
//   }

//   List<Map<String, List<List<String>>>> getFinalData() {

//     // the main method returns our completed list woth classes
// //
//     Map<String, List<List<String>>> tempFinalDataForOneGroup =
//         {}; // tmp list of map of classes
//     List<List<String>> tempClasses =
//         []; // list with first index - number of group and second is a class
// //
//     for (var t = 0; t < _quentityOfGroups; t++) {
//       tempClasses.add([]);
//     } // filling a tempData with zero-contain Lists
// //
//     // var decodedExcel = _decodedExcel as Excel;
//     // var some = decodedExcel.tables.keys;
//     //var maxRows = decodedExcel.tables[some]!.maxRows;
//     //var maxColumns = decodedExcel.tables[some]!.maxColumns;
// // looking for max columns and rows
//     String tempDateOfClasses; // temp date - for Ex. 12.12.2023
//     Map<String, List<List<String>>> tempMapForAdding = {}; // temp map
// //
//     for (int i = 2; i < 62; i += _quentityOfGroups + 1) {
//       for (int j = 0; j < 36; j += _quentityOfClasses) {
//         tempDateOfClasses = _tempData[j][i];
//         for (int q = 0; q < _quentityOfGroups; q++) {
//           for (int w = 0; w < _quentityOfClasses; w++) {
//             tempClasses[q][w] = _tempData[w + j][i + q + 1];
//           }
//         }
//         tempMapForAdding[tempDateOfClasses] = tempClasses;
//         _finalData.add(tempMapForAdding);
//       }
//     }
// //
//     return _finalData;
//   }

//   void saveToDataBase() {
//     // this method is gonna save all to database,  that's why we can use it always
//   }

//   void mainMethod() {}

//   @override
//   Widget build(BuildContext context) {
//     getFinalData();
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Пустой экран'),
//         ),
//         body: Center(
//           child: Text('Это пустой экран!'),
//         ),
//       ),
//     );
//   }
// }

