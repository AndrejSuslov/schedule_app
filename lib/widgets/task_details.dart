import 'package:flutter/material.dart';
import 'package:flutter_test_project/models/homework.dart';
import 'package:gap/gap.dart';

import '../generated/l10n.dart';

class TaskDetails extends StatelessWidget {
  const TaskDetails({super.key, required this.task});

  final Homework task;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Gap(16),
          Text(
            task.title,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const Gap(16),
          Visibility(
            visible: !task.isCompleted,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(S.of(context).taskToBeCompletedOn),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(task.date),
                    Text(' '),
                    Text(task.time),
                    const Icon(
                      Icons.check_box,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(16),
          const Divider(
            thickness: 1.5,
          ),
          const Gap(16),
          Text(
            task.note.isEmpty ? S.of(context).noAdditionalNote : task.note,
            textAlign: TextAlign.center,
          ),
          const Gap(16),
          Visibility(
            visible: task.isCompleted,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(S.of(context).taskCompleted),
                const Icon(
                  Icons.check_box,
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
