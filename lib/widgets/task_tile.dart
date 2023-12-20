import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../models/homework.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    this.onCompleted,
  });

  final Homework task;

  final Function(bool?)? onCompleted;

  @override
  Widget build(BuildContext context) {
    final textDecoration =
        task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none;
    final fontWeight = task.isCompleted ? FontWeight.normal : FontWeight.bold;
    final double iconOpacity = task.isCompleted ? 0.3 : 0.5;
    final double backgroundOpacity = task.isCompleted ? 0.1 : 0.3;

    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10),
      child: Row(
        children: [
          const Gap(16),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
              ),
              Text(
                task.date,
              ),
            ],
          )),
          Checkbox(
            value: task.isCompleted,
            onChanged: onCompleted,
            // fillColor: MaterialStateProperty.resolveWith<Color>(
            //   (Set<MaterialState> states) {
            //     if (states.contains(MaterialState.disabled)) {
            //       return colors.primary;
            //     }
            //     return colors.primary;
            //   },
            // ),
          ),
        ],
      ),
    );
  }
}
