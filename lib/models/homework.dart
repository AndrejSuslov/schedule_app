// class Homework {
//   int id;
//   String lesson;
//   // String course;
//   String group;
//   String title;
//   String description;
//   DateTime dateTime;
//   DateTime creationDate;
//   bool isCompleted;

//   Homework({
//     required this.id,
//     required this.lesson,
//     // required this.course,
//     required this.title,
//     required this.description,
//     required this.group,
//     required this.dateTime,
//     required this.creationDate,
//     this.isCompleted = false,
//   });

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       (other is Homework &&
//           runtimeType == other.runtimeType &&
//           lesson == other.lesson &&
//           description == other.description &&
//           dateTime == other.dateTime &&
//           creationDate == other.creationDate);

//   @override
//   int get hashCode =>
//       lesson.hashCode ^
//       description.hashCode ^
//       dateTime.hashCode ^
//       creationDate.hashCode;

//   @override
//   String toString() {
//     return 'Homework{ lesson: $lesson, description: $description, dateTime: $dateTime, creationDate: $creationDate,}';
//   }

//   Homework copyWith({
//     int? id,
//     String? lesson,
//     // String? course,
//     String? description,
//     String? group,
//     String? title,
//     DateTime? dateTime,
//     DateTime? creationDate,
//     bool? isCompleted,
//   }) {
//     return Homework(
//       id: id ?? this.id,
//       lesson: lesson ?? this.lesson,
//       title: title ?? this.title,
//       description: description ?? this.description,
//       group: group ?? this.group,
//       // course: course ?? this.course,
//       dateTime: dateTime ?? this.dateTime,
//       creationDate: creationDate ?? this.creationDate,
//       isCompleted: isCompleted ?? this.isCompleted,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'lesson': lesson,
//       'title': title,
//       'description': description,
//       // 'course': course,
//       'group': group,
//       'confirm_by': dateTime.millisecondsSinceEpoch,
//       'created_at': creationDate.millisecondsSinceEpoch,
//       'is_completed': isCompleted ? 1 : 0,
//     };
//   }

//   factory Homework.fromMap(Map<String, dynamic> map) {
//     // print(DateTime.now().millisecondsSinceEpoch);
//     return Homework(
//         id: map['id'] as int,
//         lesson: map['lesson'] as String,
//         // course: map['course'] as String,
//         group: map['group'] as String,
//         title: map['title'] as String,
//         description: map['description'] as String,
//         dateTime: DateTime.fromMillisecondsSinceEpoch(map['confirm_by']),
//         creationDate: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
//         isCompleted: map['is_completed'] == 1);
//   }
// }

// class Homework {
//   String? uniqueID;
//   String id;
//   String name;
//   String description;
//   DateTime dueDate;
//   bool completed;

//   Homework({
//     required this.uniqueID,
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.dueDate,
//     required this.completed,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'description': description,
//       'dueDate': dueDate.toIso8601String(),
//       'completed': completed ? 1 : 0,
//     };
//   }

//   factory Homework.fromMap(Map<String, dynamic> map) {
//     return Homework(
//       uniqueID: map['id'],
//       id: map['id'],
//       name: map['name'],
//       description: map['description'],
//       dueDate: DateTime.parse(map['dueDate']),
//       completed: map['completed'] == 1,
//     );
//   }
// }

import 'package:equatable/equatable.dart';

import '../services/task_keys.dart';

class Homework extends Equatable {
  final int? id;
  final String title;
  final String note;
  final String time;
  final String date;
  final bool isCompleted;
  const Homework({
    this.id,
    required this.title,
    required this.time,
    required this.date,
    required this.note,
    required this.isCompleted,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      TaskKeys.id: id,
      TaskKeys.title: title,
      TaskKeys.note: note,
      TaskKeys.time: time,
      TaskKeys.date: date,
      TaskKeys.isCompleted: isCompleted ? 1 : 0,
    };
  }

  factory Homework.fromJson(Map<String, dynamic> map) {
    return Homework(
      id: map[TaskKeys.id],
      title: map[TaskKeys.title],
      note: map[TaskKeys.note],
      time: map[TaskKeys.time],
      date: map[TaskKeys.date],
      isCompleted: map[TaskKeys.isCompleted] == 1 ? true : false,
    );
  }

  @override
  List<Object> get props {
    return [
      title,
      note,
      time,
      date,
      isCompleted,
    ];
  }

  Homework copyWith({
    int? id,
    String? title,
    String? note,
    String? time,
    String? date,
    bool? isCompleted,
  }) {
    return Homework(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      time: time ?? this.time,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
