import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:excel/excel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_project/models/schedule.dart';
import 'package:flutter_test_project/services/events.dart';
import 'package:flutter_test_project/services/parser.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:table_calendar/table_calendar.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  late DateTime currentDay = DateTime.now();
  late final Map<DateTime, List<String>> loadedClassesForFirstGroup;

  ScheduleBloc() : super(ScheduleInitial()) {
    on<ScheduleEvent>(
      (event, emit) {},
    );
    on<ChangeDateOfClasses>(_onChangeDate);
    //on<LoadScheduleFromFile>(_loadScheduleFromFile); // Добавим новое событие
    _loadSchedule();
  }

  void _loadSchedule() async {
    emit(ScheduleLoading());
    final parsedExcel = ExcelParsing(6, 2);
    await parsedExcel.parseForAllGroups();
    {
      loadedClassesForFirstGroup = parsedExcel.getClassesForChoosedGroup(1);
      if (currentDay.weekday == 7) {
        emit(
            /* here will be emit to the state void day with animation */ somevoiddaystate);
      }
      emit(ScheduleLoaded(
          loadedClassesForFirstGroup[currentDay]!.toList(), currentDay));
    }
    emit(const ScheduleError('Some troubles with file extension'));
  }

  FutureOr<void> _onChangeDate(
      ChangeDateOfClasses event, Emitter<ScheduleState> emit) {
    emit(ScheduleInitial());
    currentDay = event.selectedDay;

    if (loadedClassesForFirstGroup[currentDay] != null) {
      emit(ScheduleLoaded(
          loadedClassesForFirstGroup[currentDay]!.toList(), currentDay));
    } else {
      emit(const ScheduleError('Classes for the selected day are null'));
    }
  }

  FutureOr<void> _loadScheduleFromFile(
      LoadScheduleFromFile event, Emitter<ScheduleState> emit) async {
    final parsedExcel = ExcelParsing(6, 2);
    await parsedExcel.parseForAllGroups();
    loadedClassesForFirstGroup = parsedExcel.getClassesForChoosedGroup(1);
    emit(ScheduleLoaded(
        loadedClassesForFirstGroup[currentDay]!.toList(), currentDay));
    emit(const ScheduleError('Some troubles with file extension'));
  }
}
