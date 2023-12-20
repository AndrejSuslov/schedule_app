import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/task_datasource_prov.dart';
import 'hometask_rep_impl.dart';
import 'hometask_repository.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final datasource = ref.read(taskDatasourceProvider);
  return TaskRepositoryImpl(datasource);
});
