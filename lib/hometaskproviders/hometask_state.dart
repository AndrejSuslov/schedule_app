import 'package:equatable/equatable.dart';
import '../models/homework.dart';

class TaskState extends Equatable {
  final List<Homework> tasks;

  const TaskState({
    required this.tasks,
  });
  const TaskState.initial({
    this.tasks = const [],
  });

  TaskState copyWith({
    List<Homework>? tasks,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
    );
  }

  @override
  List<Object> get props => [tasks];
}
