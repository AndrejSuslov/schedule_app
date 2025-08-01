part of 'schedule_bloc.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object> get props => [];
}

class ChangeDateOfClasses extends ScheduleEvent {
  final DateTime selectedDay;

  const ChangeDateOfClasses(this.selectedDay);
}

class PickFile extends ScheduleEvent {
  const PickFile();
}

class LoadSchedule extends ScheduleEvent {
  final DateTime date;

  const LoadSchedule(this.date);
}

class GetSchedule extends ScheduleEvent {}

class SaveSchedule extends ScheduleEvent {
  final String group;
  final String numOfGroups;

  const SaveSchedule({
    required this.group,
    required this.numOfGroups,
  });
}
////////////////////////////////////////////////////////////////////////////////

class GetScheduleForGroup extends ScheduleEvent {
  final String group;
  final DateTime dateTime;

  const GetScheduleForGroup({
    required this.group,
    required this.dateTime,
  });
}

class GetScheduleForTeacher extends ScheduleEvent {
  final String teacher;
  final DateTime dateTime;

  const GetScheduleForTeacher({
    required this.teacher,
    required this.dateTime,
  });
}

class GetScheduleForAuditorium extends ScheduleEvent {
  final String auditorium;
  final DateTime dateTime;

  const GetScheduleForAuditorium({
    required this.auditorium,
    required this.dateTime,
  });
}

class GetTeachersForGroup extends ScheduleEvent {
  final String group;

  const GetTeachersForGroup(this.group);
}

class GetTeachersFromQuery extends ScheduleEvent {
  final String query;

  const GetTeachersFromQuery(this.query);
}

class GetAuditoriumFromQuery extends ScheduleEvent {
  final String query;

  const GetAuditoriumFromQuery(this.query);
}
