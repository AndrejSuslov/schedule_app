part of 'schedule_bloc.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object> get props => [];
}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final List<String> classes;
  final DateTime date;

  const ScheduleLoaded(this.classes, this.date);
}

class ScheduleError extends ScheduleState {
  final String message;

  const ScheduleError(this.message);
}

class PickingFile extends ScheduleState {
  const PickingFile();
}

class PickedFile extends ScheduleState {
  final PlatformFile file;

  const PickedFile(this.file);
}

class ScheduleDayIsEmpty extends ScheduleState {
  final String messsage;

  const ScheduleDayIsEmpty(this.messsage);
}

class SavingSchedule extends ScheduleState {}

class SavedSchedule extends ScheduleState {}

////////////////////////////////////////////////////////////////////////////////

class ScheduleTeacherLoaded extends ScheduleState {
  // if we wanna add this, we need remove requierd
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
