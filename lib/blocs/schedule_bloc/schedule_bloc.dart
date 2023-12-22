import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:excel/excel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_project/models/schedule.dart';
import 'package:flutter_test_project/services/events.dart';
import 'package:flutter_test_project/services/parser.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class SheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  late final DateTime currentDay;
  late final Map<DateTime, List<String>> loadedClassesForFirstGroup;

  SheduleBloc() : super(ScheduleInitial()) {
    on<ScheduleEvent>(
        (event, emit) {}); // I dunno bro what is it and what it does
    on<ChangeDateOfClasses>(
        _onChangeDate); // if u chanfed the date, go to the this method
  }

  void _loadSchedule() async {
    emit(ScheduleLoading());
    final parsedExcel = ExcelParsing(6, 2);
    if (await parsedExcel.parseForAllGroups() != null) {
      loadedClassesForFirstGroup = parsedExcel.getClassesForChoosedGroup(1);
      emit(ScheduleLoaded(
          loadedClassesForFirstGroup[currentDay]!.toList(), currentDay));
    }
    emit(const ScheduleError('Some troubles with file extension'));
  }

  FutureOr<void> _onChangeDate(
      ChangeDateOfClasses event, Emitter<ScheduleState> emit) {
    // change date and return the classes for group,
    //but we need to add into settings a choosing of group and quantity of group
    emit(ScheduleInitial());
    currentDay = event.selectedDay;
    emit(ScheduleLoaded(
        loadedClassesForFirstGroup[currentDay]!.toList(), currentDay));
  }
}
