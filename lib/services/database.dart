// import 'dart:async';
// import 'package:sqflite/sqflite.dart';

// import '../models/homework.dart';

// class DatabaseHelper0 {
//   static Database? _database;
//   final _textType = 'TEXT NOT NULL';
//   final _integerType = 'INTEGER NOT NULL';

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDB("HOMETASK.db");
//     return _database!;
//   }

//   Future<Database> _initDB(String filePath) async {
//     final dbPath = '${await getDatabasesPath()}/$filePath';
//     return await openDatabase(
//       dbPath,
//       version: 1,
//       onCreate: _createDB,
//     );
//   }

//   FutureOr<void> _createDB(Database db, int version) async {
//     await db.execute("""
//     CREATE TABLE hometask(
//     'id' INTEGER PRIMARY KEY AUTOINCREMENT,
//     'group' $_textType,
//     'lesson' $_textType,
//     'title' $_textType,
//     'description' $_textType,
//     'confirm_by' $_integerType,
//     'created_at' $_integerType,
//     'is_completed' $_integerType);
//     """);
//   }

//   Future<List<Homework>> getRecords(
//     String lesson,
//     String group,
//     DateTime dateTime,
//   ) async {
//     final db = await database;
//     final response = await db.query(
//       'hometask',
//       where: "lesson = ? and `group` = ? and confirm_by > ? and created_at < ?",
//       whereArgs: [
//         lesson,
//         group,
//         dateTime.millisecondsSinceEpoch,
//         dateTime.millisecondsSinceEpoch
//       ],
//     );
//     return response.map((e) => Homework.fromMap(e)).toList();
//   }

//   Future<List<Homework>> getDataList() async {
//     await _database;
//     final List<Map<String, Object?>> queryResult =
//         await _database!.rawQuery('SELECT * FROM HOMETASK');
//     return queryResult.map((e) => Homework.fromMap(e)).toList();
//   }

//   Future<bool> deleteRecord(int id) async {
//     final db = await database;
//     final response = await db.delete(
//       'hometask',
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     return response > 0;
//   }

//   Future<Homework?> updateRecord(Homework homework) async {
//     final db = await database;
//     final response = await db.update('hometask', homework.toMap());
//     return response > 0 ? homework : null;
//   }

//   Future<Homework?> insertRecord(Homework homework) async {
//     final db = await database;
//     final id = await db.insert('hometask', homework.toMap());
//     return homework.copyWith(id: id);
//   }
// }
