import 'dart:async';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_project/services/parser.dart';
import 'package:flutter_test_project/services/storage.dart';
// import 'package:intl/intl.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final String date = DateTime.now().toString().replaceRange(10, 26, '');
  late DateTime currentDay = DateTime.parse(date);
  late final PlatformFile globalFile;
  Map<DateTime, List<String>> loadedClassesFromCache = {};

  ScheduleBloc() : super(ScheduleInitial()) {
    on<ScheduleEvent>(
      (event, emit) {},
    );
    on<PickFile>(_pickFile);
    //on<ScheduleLoading>(_loadSchedule);
    on<ChangeDateOfClasses>(_onChangeDate);
    on<SaveSchedule>(_saveScheduleToCache);
    on<LoadSchedule>(_loadSchedule);
  }

  FutureOr<void> _onChangeDate(
      ChangeDateOfClasses event, Emitter<ScheduleState> emit) {
    emit(SchedulereeloadDate());
    currentDay = event.selectedDay;
    if (currentDay.weekday != DateTime.sunday) {
      emit(
          ScheduleLoaded(loadedClassesFromCache[currentDay] ?? [], currentDay));
    } else {
      const ScheduleDayIsEmpty('There aren\'t classes. Chill out, bro');
    }
  }

  FutureOr<void> _pickFile(PickFile event, Emitter<ScheduleState> emit) async {
    emit(ScheduleInitial());

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );
    if (result != null) {
      PlatformFile file = result.files.single;
      globalFile = file;
      emit(PickedFile(file));
    } else {
      emit(const ScheduleError('Something went wrong'));
    }
  }

  FutureOr<void> _saveScheduleToCache(
      SaveSchedule event, Emitter<ScheduleState> emit) async {
    emit(SavingSchedule());
    final parsedExcel = ExcelParsing(int.parse(event.numOfGroups));
    await parsedExcel.parseForAllGroups(globalFile);
    // loadedClassesFromCache =
    //     parsedExcel.getClassesForChoosedGroup(int.parse(event.group));

    Map<String, List<String>> stringMap = parsedExcel
        .getClassesForChoosedGroup(int.parse(event.group))
        .map((key, value) => MapEntry(key.toString(), value));
    String jsonString = jsonEncode(stringMap);
    Storage().saveSchedule(jsonString);
    emit(SavedSchedule());
  }

  FutureOr<void> _loadSchedule(
      LoadSchedule event, Emitter<ScheduleState> emit) async {
    emit(ScheduleLoading());
    var futureString = Storage().readSchedule();
    late final Map<DateTime, List<String>> loadedClassesFromCache1;
    await futureString.then((string) {
      try {
        Map<String, List<dynamic>> decodedStringMap =
            Map<String, List<dynamic>>.from(jsonDecode(string));
        loadedClassesFromCache1 = decodedStringMap.map((key, value) =>
            MapEntry(DateTime.parse(key), value.cast<String>().toList()));
      } catch (e) {
        debugPrint('Ошибка при разборе JSON: $e');
      }
    });
    loadedClassesFromCache = loadedClassesFromCache1;
    // Map<String, List<String>> decodedStringMap = Map<String, List<String>>.from(
    //     jsonDecode(Storage().readSchedule().toString()));
    // loadedClassesFromCache = decodedStringMap.map((key, value) =>
    //     MapEntry(DateTime.parse(key), value)); //  DateTime.parse(key)
    emit(ScheduleLoaded(
        loadedClassesFromCache[currentDay]!.toList(), currentDay));
  }
}


// map((key, value) =>
//             MapEntry(DateTime.parse(key), value.cast<String>()));