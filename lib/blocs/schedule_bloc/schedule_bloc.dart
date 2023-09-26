import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_project/models/schedule.dart';
import 'package:intl/intl.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final DateFormat _dateFormat = DateFormat('dd.MM.yyyy');

  ScheduleBloc() : super(ScheduleInitial()) {
    on<ScheduleEvent>((event, emit) {});
  }

  // ТУТ ДОЛЖЕН БЫТЬ ПАРСИНГ РАСПИСАНИЯ ДЛЯ УЧИЛОК

  // ТУТ ДОЛЖЕН БЫТЬ ПАРСИНГ РАСПИСАНИЯ ДЛЯ ШКОЛОТРОНОВ

  // ТУТ ДОЛЖЕН БЫТЬ ПАРСИНГ РАСПИСАНИЯ ДЛЯ АУДИТОРИИ

  // ТУТ ДОЛЖЕН БЫТЬ ПАРСИНГ УЧИЛОК ДЛЯ ГРУППЫ

  // ТУТ ДОЛЖЕН БЫТЬ ПАРСИНГ УЧИЛОК С ОЧЕРЕДИ

  // ТУТ ДОЛЖЕН БЫТЬ ПАРСИНГ АУДИТОРИИ С ОЧЕРЕДИ
}
