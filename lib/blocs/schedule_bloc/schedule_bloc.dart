import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_project/models/schedule.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

// ТУТ ДОЛЖЕН БЫТЬ ПАРСИНГ РАСПИСАНИЯ ДЛЯ ШКОЛОТРОНОВ

// class DictionaryDataBaseHelper {
//   Database _db;

//   Future<void> init() async {
//     io.Directory applicationDirectory =
//         await getApplicationDocumentsDirectory();

//     String dbPathEnglish =
//         path.join(applicationDirectory.path, "englishDictionary.db");

//     bool dbExistsEnglish = await io.File(dbPathEnglish).exists();

//     if (!dbExistsEnglish) {
//       // Copy from asset
//       ByteData data =
//           await rootBundle.load(path.join("assets", "eng_dictionary.db"));
//       List<int> bytes =
//           data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

//       // Write and flush the bytes written
//       await io.File(dbPathEnglish).writeAsBytes(bytes, flush: true);
//     }

//     this._db = await openDatabase(dbPathEnglish);
//   }

//   /// get all the words from english dictionary
//   Future<List<EnglishWord>> getAllTheWordsEnglish() async {
//     if (_db == null) {
//       throw "bd is not initiated, initiate using [init(db)] function";
//     }
//     List<Map> words;

//     await _db.transaction((txn) async {
//       words = await txn.query(
//         "words",
//         columns: [
//           "en_word",
//           "en_definition",
//         ],
//       );
//     });

//     return words.map((e) => EnglishWord.fromJson(e)).toList();
//   }
// }

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final DateFormat _dateFormat = DateFormat('yyyy-dd-MM');
  final List<String> _Trying = [];

  ScheduleBloc() : super(ScheduleInitial()) {
    on<ScheduleEvent>((event, emit) {});
  }
}
