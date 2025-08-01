import 'dart:async';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
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
    on<ScheduleEvent>(
      (event, emit) {},
    );
    on<PickFile>(_pickFile);
    on<ChangeDateOfClasses>(_onChangeDate);
    on<SaveSchedule>(_saveScheduleToCache);
    on<LoadSchedule>(_loadSchedule);
  }

  FutureOr<void> _onChangeDate(
      ChangeDateOfClasses event, Emitter<ScheduleState> emit) {
    emit(ScheduleReeloadDate());
    currentDay = event.selectedDay;
    if (currentDay.weekday != DateTime.sunday) {
      emit(ChangedDate());
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

    final parser = ExcelParsing(int.parse(event.numOfGroups));
    var days = await parser.parse(globalFile!) as List<Day>;

    for (Day day in days) {
      String jsonString = jsonEncode(day.classes[int.parse(event.group)]);
      Storage().saveSchedule(day.date, jsonString);
    }

    var time = parser.parseTimeOfClasses();
    Storage().saveTime(time);
    emit(SavedSchedule());
  }

  FutureOr<void> _loadSchedule(
      LoadSchedule event, Emitter<ScheduleState> emit) async {
    emit(ScheduleLoading());

    var futureString = Storage().readSchedule(_dateToString(event.date));
    late final List<String> loadedClassesFromCache;

    await futureString.then((string) {
      try {
        final decodedList = jsonDecode(string) as List<dynamic>;
        loadedClassesFromCache = decodedList.cast<String>().toList();
      } catch (e) {
        emit(const ScheduleError('Необходимо выбрать файл'));
        loadedClassesFromCache = [];
      }
    });
    late final List<String> lastTime;
    var time = Storage().readTime();
    await time.then((listWithTime) {
      try {
        lastTime = listWithTime;
      } catch (e) {
        emit(const ScheduleError('Необходимо выбрать файл'));
      }
    });
    if (loadedClassesFromCache.isEmpty) emit(const ScheduleDayIsEmpty(""));
    emit(ScheduleLoaded(loadedClassesFromCache, event.date, lastTime));
  }

  String _dateToString(DateTime date) {
    return date.toString().replaceRange(10, date.toString().length, '');
  }
}
