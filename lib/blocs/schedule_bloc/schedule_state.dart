part of 'schedule_bloc.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object> get props => [];
}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final List<Schedule> schedule;
  final DateTime selectedDate;

  const ScheduleLoaded({
    required this.schedule,
    required this.selectedDate,
  });
}

class ScheduleError extends ScheduleState {
  final String message;

  const ScheduleError({
    required this.message,
  });
}

class ScheduleTeacherLoaded extends ScheduleState {
  final List<String> teachers;

  const ScheduleTeacherLoaded({
    required this.teachers,
  });
}

class ScheduleAuditoriumLoaded extends ScheduleState {
  final List<String> auditorium;

  const ScheduleAuditoriumLoaded({
    required this.auditorium,
  });
}
