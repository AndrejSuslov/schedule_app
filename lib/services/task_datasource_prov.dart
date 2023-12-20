import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_service.dart';

final taskDatasourceProvider = Provider<TaskDatasource>((ref) {
  return TaskDatasource();
});
