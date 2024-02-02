import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test_project/widgets/typography.dart';

import '../generated/l10n.dart';
import '../hometaskproviders/hometask_provider.dart';
import '../models/homework.dart';

@immutable
class AppAlerts {
  const AppAlerts._();

  static displaySnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          // style: context.textTheme.bodyMedium,
        ),
        // backgroundColor: context.colorScheme.onSecondary,
      ),
    );
  }

  static Future<void> showAlertDeleteDialog({
    required BuildContext context,
    required WidgetRef ref,
    required Homework task,
  }) async {
    Widget cancelButton = TextButton(
      child: Text(S.of(context).no, style: Style.buttonS),
      onPressed: () => Navigator.pop(context),
    );
    Widget deleteButton = TextButton(
      onPressed: () async {
        await ref.read(tasksProvider.notifier).deleteTask(task).then(
          (value) {
            displaySnackbar(
              context,
              S.of(context).taskDeleted,
            );
            Navigator.pop(context);
          },
        );
      },
      child: Text(S.of(context).yes, style: Style.buttonS),
    );

    AlertDialog alert = AlertDialog(
      title: Text(S.of(context).taskDeleteAlert),
      actions: [
        deleteButton,
        cancelButton,
      ],
    );

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
