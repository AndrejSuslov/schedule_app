import 'homework.dart';

class Schedule {
  String course;
  String group;
  String day;
  String time;
  String lesson;
  String teacher;
  String auditorium;
  String type;
  bool evenWeek;
  List<Homework> homework;

  Schedule({
    required this.course,
    required this.group,
    required this.day,
    required this.time,
    required this.lesson,
    required this.teacher,
    required this.auditorium,
    required this.type,
    required this.evenWeek,
    this.homework = const [],
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Schedule &&
          runtimeType == other.runtimeType &&
          group == other.group &&
          day == other.day &&
          time == other.time &&
          lesson == other.lesson &&
          teacher == other.teacher &&
          auditorium == other.auditorium &&
          type == other.type &&
          evenWeek == other.evenWeek);

  @override
  int get hashCode =>
      group.hashCode ^
      day.hashCode ^
      time.hashCode ^
      lesson.hashCode ^
      teacher.hashCode ^
      auditorium.hashCode ^
      type.hashCode ^
      evenWeek.hashCode;

  @override
  String toString() {
    return 'Schedule{ course: $course, group: $group, day: $day, time: $time, lesson: $lesson, teacher: $teacher, auditorium: $auditorium, type: $type, evenWeek: $evenWeek,}';
  }

  Schedule copyWith({
    String? course,
    String? group,
    String? day,
    String? time,
    String? lesson,
    String? teacher,
    String? auditorium,
    String? type,
    bool? evenWeek,
  }) {
    return Schedule(
      course: course ?? this.course,
      group: group ?? this.group,
      day: day ?? this.day,
      time: time ?? this.time,
      lesson: lesson ?? this.lesson,
      teacher: teacher ?? this.teacher,
      auditorium: auditorium ?? this.auditorium,
      type: type ?? this.type,
      evenWeek: evenWeek ?? this.evenWeek,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'course': course,
      'group': group,
      'day': day,
      'time': time,
      'lesson': lesson,
      'teacher': teacher,
      'auditorium': auditorium,
      'type': type,
      'evenWeek': evenWeek,
    };
  }

  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      course: map['course'] as String,
      group: map['group'] as String,
      day: map['day'] as String,
      time: map['time'] as String,
      lesson: map['lesson'] as String,
      teacher: map['teacher'] as String,
      auditorium: map['auditorium'] as String,
      type: map['type'] as String,
      evenWeek: map['even_week'] == 1,
    );
  }
}
