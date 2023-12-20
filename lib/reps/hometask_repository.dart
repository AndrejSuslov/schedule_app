import 'package:flutter_test_project/models/homework.dart';

abstract class TaskRepository {
  Future<void> addTask(Homework task);
  Future<void> updateTask(Homework task);
  Future<void> deleteTask(Homework task);
  Future<List<Homework>> getAllTasks();
}
