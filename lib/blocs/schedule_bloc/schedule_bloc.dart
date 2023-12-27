import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_project/blocs/settings_bloc/settings_bloc.dart';
import 'package:flutter_test_project/services/parser.dart';
import 'package:flutter_test_project/services/storage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  late DateTime currentDay = DateTime.now();
  late final PlatformFile globalFile;
  late final Map<DateTime, List<String>> loadedClassesFromCache;

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

  // FutureOr <void> _loadSchedule(LoadingSchedule event, Emitter<ScheduleState> emit) {

  // }

  FutureOr<void> _onChangeDate(
      ChangeDateOfClasses event, Emitter<ScheduleState> emit) {
    emit(ScheduleInitial());
    currentDay = event.selectedDay;
    //final readData = Storage().readSchedule() as Map<DateTime, List<String>>;
    //loadedClassesFromCache = readData;
    if (loadedClassesFromCache != null) {
      if (currentDay.weekday != DateTime.sunday) {
        emit(ScheduleLoaded(
            loadedClassesFromCache[currentDay]!.toList(), currentDay));
      } else {
        const ScheduleDayIsEmpty('There aren\'t classes. Chill out, bro');
      }
    } else {
      emit(const ScheduleError('Data is not downloaded'));
    }
  }

  FutureOr<void> _pickFile(PickFile event, Emitter<ScheduleState> emit) async {
    emit(const PickingFile());

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
    final loadedClassesForGroup =
        parsedExcel.getClassesForChoosedGroup(int.parse(event.group));
    await Storage().saveSchedule(loadedClassesForGroup);
    //final classes = Storage().readSchedule() as Map<DateTime, List<String>>;
    emit(SavedSchedule());
    // } else {
    //   emit(const ScheduleError(
    //       'Some troubles with parsing. Clear the cache and try again.'));
    // }
  }

  FutureOr<void> _loadSchedule(
      LoadSchedule event, Emitter<ScheduleState> emit) {
    emit(ScheduleLoading());
    loadedClassesFromCache =
        Storage().readSchedule() as Map<DateTime, List<String>>;
    emit(ScheduleLoaded(
        loadedClassesFromCache[currentDay] as List<String>, currentDay));
  }
}

// мне нужно разделить файл пикер на другой стейт и добавить ивент туда
// сделать сохранение данных в кэш тоже стейт и ивент
// попробовать вмонтировать все это в ту клавишу

