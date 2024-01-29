import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test_project/widgets/task_details.dart';
import 'package:flutter_test_project/widgets/task_tile.dart';
import 'package:flutter_test_project/widgets/typography.dart';

import '../hometaskproviders/hometask_provider.dart';
import '../models/homework.dart';
import '../services/app_alerts.dart';
import 'common_container.dart';

class DisplayListOfTasks extends ConsumerWidget {
  const DisplayListOfTasks({
    super.key,
    this.isCompletedTasks = false,
    required this.tasks,
  });
  final bool isCompletedTasks;
  final List<Homework> tasks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emptyTasksAlert = isCompletedTasks
        ? 'There is no completed task yet'
        : 'There is no task to todo!';

    return CommonContainer(
      child: tasks.isEmpty
          ? Center(
              child: Text(emptyTasksAlert, style: Style.bodyRegular),
            )
          : ListView.separated(
              shrinkWrap: true,
              itemCount: tasks.length,
              padding: EdgeInsets.zero,
              itemBuilder: (ctx, index) {
                final task = tasks[index];

                return InkWell(
                  onLongPress: () async {
                    await AppAlerts.showAlertDeleteDialog(
                      context: context,
                      ref: ref,
                      task: task,
                    );
                  },
                  onTap: () async {
                    await showModalBottomSheet(
                      context: context,
                      builder: (ctx) {
                        return TaskDetails(task: task);
                      },
                    );
                  },
                  child: TaskTile(
                    task: task,
                    onCompleted: (value) async {
                      await ref
                          .read(tasksProvider.notifier)
                          .updateTask(task)
                          .then((value) {
                        AppAlerts.displaySnackbar(
                          context,
                          (task.isCompleted
                              ? 'Task incompleted'
                              : 'Task completed'),
                        );
                      });
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(
                thickness: 1.5,
              ),
            ),
    );
  }
}
