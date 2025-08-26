import 'dart:async';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_project/services/parser/parser.dart';
import 'package:flutter_test_project/services/storage.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final String date = DateTime.now().toString().replaceRange(10, 26, '');
  late DateTime currentDay = DateTime.parse(date);
  PlatformFile? globalFile;

  ScheduleBloc() : super(ScheduleInitial()) {
    on<ScheduleEvent>((event, emit) {});
    on<PickFile>(_pickFile);
    on<ChangeDateOfClasses>(_onChangeDate);
    on<SaveSchedule>(_saveScheduleToCache);
    on<LoadSchedule>(_loadSchedule);
  }

  FutureOr<void> _onChangeDate(ChangeDateOfClasses event, Emitter<ScheduleState> emit) {
    emit(ScheduleReeloadDate());
    currentDay = event.selectedDay;
    if (currentDay.weekday != DateTime.sunday) {
      emit(ChangedDate());
    } else {
      emit(const ScheduleDayIsEmpty('There aren\'t classes. Chill out, bro'));
    }
  }

  FutureOr<void> _pickFile(PickFile event, Emitter<ScheduleState> emit) async {
    emit(ScheduleInitial());

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['xlsx'],
      withData: true,
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty) {
      emit(const ScheduleError('Something went wrong'));
      return;
    }

    final file = result.files.single;
    if (kIsWeb && file.bytes == null) {
      emit(const ScheduleError('File read error'));
      return;
    }

    globalFile = file;
    emit(PickedFile(file));
  }

  FutureOr<void> _saveScheduleToCache(SaveSchedule event, Emitter<ScheduleState> emit) async {
    emit(SavingSchedule());

    try {
      if (globalFile == null) {
        emit(const ScheduleError('Select a file first'));
        return;
      }

      final parser = ExcelParsing(int.parse(event.numOfGroups));
      final days = await parser.parse(globalFile!) as List<Day>;

      for (final day in days) {
        final classesForGroup = day.classes[int.parse(event.group)] ?? <String>[];
        final jsonString = jsonEncode(classesForGroup);
        await Storage().saveSchedule(day.date, jsonString);
      }

      final time = parser.parseTimeOfClasses();
      await Storage().saveTime(time);

      final classesData = parser.parseDataClasses();
      await Storage().saveClassesData(classesData);

      emit(SavedSchedule());
    } catch (e) {
      emit(ScheduleError('Import error: $e'));
    }
  }

  FutureOr<void> _loadSchedule(LoadSchedule event, Emitter<ScheduleState> emit) async {
    emit(ScheduleLoading());

    try {
      final scheduleJson = await Storage().readSchedule(_dateToString(event.date));
      List<String> classes = [];
      if (scheduleJson.isNotEmpty) {
        try {
          final decoded = jsonDecode(scheduleJson) as List<dynamic>;
          classes = decoded.cast<String>().toList();
        } catch (_) {}
      }

      final time = await Storage().readTime();

      if (classes.isEmpty) {
        emit(const ScheduleDayIsEmpty(''));
        return;
      }

      emit(ScheduleLoaded(classes, event.date, time));
    } catch (e) {
      emit(ScheduleError('Load error: $e'));
    }
  }

  String _dateToString(DateTime date) {
    return date.toString().replaceRange(10, date.toString().length, '');
  }
}
