import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test_project/models/homework.dart';
import 'package:flutter_test_project/screens/create_screen_task.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../blocs/settings_bloc/settings_bloc.dart';
import '../generated/l10n.dart';
import '../hometaskproviders/hometask_provider.dart';
import '../screens/schedule_screen.dart';
import '../widgets/app_back.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/disp_list_of_tasks.dart';
import 'date_provider.dart';
import 'helpers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(dateProvider);
    final taskState = ref.watch(tasksProvider);
    final inCompletedTasks = _incompltedTask(taskState.tasks, ref);
    final completedTasks = _compltedTask(taskState.tasks, ref);

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).hometasks),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              pushToMainScreen(context);
            },
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Gap(10),
                InkWell(
                  child: Text(
                    'Today is ${(DateFormat.yMMMd().format(DateTime.now()).toString())}',
                  ),
                ),
              ],
            ),
            const Gap(20),
            DisplayListOfTasks(
              tasks: inCompletedTasks,
            ),
            const Gap(20),
            Text(
              S.of(context).completed,
            ),
            const Gap(20),
            DisplayListOfTasks(
              isCompletedTasks: true,
              tasks: completedTasks,
            ),
            ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  S.of(context).addNewTask,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateTaskScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      onWillPop: () async => false,
    );
  }

  List<Homework> _incompltedTask(List<Homework> tasks, WidgetRef ref) {
    final date = ref.watch(dateProvider);
    final List<Homework> filteredTask = [];

    for (var task in tasks) {
      if (!task.isCompleted) {
        filteredTask.add(task);
      }
    }
    return filteredTask;
  }

  List<Homework> _compltedTask(List<Homework> tasks, WidgetRef ref) {
    final date = ref.watch(dateProvider);
    final List<Homework> filteredTask = [];

    for (var task in tasks) {
      if (task.isCompleted) {
        filteredTask.add(task);
      }
    }
    return filteredTask;
  }

  void pushToMainScreen(BuildContext context) {
    final bloc = context.read<SettingsBloc>();
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ScheduleScreen({'group': bloc.settings.group}),
      ),
    );
  }
}
