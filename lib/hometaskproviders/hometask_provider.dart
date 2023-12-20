import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../reps/hometask_rep_provider.dart';
import 'hometask_notifier.dart';
import 'hometask_state.dart';

final tasksProvider = StateNotifierProvider<TaskNotifier, TaskState>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return TaskNotifier(repository);
});
