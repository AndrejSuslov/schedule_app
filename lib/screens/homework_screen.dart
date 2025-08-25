import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test_project/models/homework.dart';
import 'package:flutter_test_project/screens/create_screen_task.dart';
import 'package:flutter_test_project/widgets/typography.dart';
import 'package:intl/intl.dart';
import '../blocs/settings_bloc/settings_bloc.dart';
import '../generated/l10n.dart';
import '../hometaskproviders/hometask_provider.dart';
import 'schedule_screen.dart';
import '../widgets/disp_list_of_tasks.dart';
import '../services/date_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final date = ref.watch(dateProvider);
    final taskState = ref.watch(tasksProvider);
    final inCompletedTasks = _incompltedTask(taskState.tasks, ref);
    final completedTasks = _compltedTask(taskState.tasks, ref);

    return WillPopScope(
      onWillPop: () async {
        pushToMainScreen(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).hometasks,
            style: Style.h6,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              pushToMainScreen(context);
            },
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: S.of(context).toComplete),
              Tab(text: S.of(context).completed),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildToCompleteTab(inCompletedTasks, context),
            _buildCompletedTab(completedTasks, context),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateTaskScreen(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildToCompleteTab(List<Homework> tasks, BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            InkWell(
              child: Text(
                '${S.of(context).today} ${(DateFormat.yMMMd().format(DateTime.now()).toString())}',
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildTasksListWithDividers(tasks, false),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildCompletedTab(List<Homework> tasks, BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            InkWell(
              child: Text(
                '${S.of(context).today} ${(DateFormat.yMMMd().format(DateTime.now()).toString())}',
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildTasksListWithDividers(tasks, true),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildTasksListWithDividers(List<Homework> tasks, bool isCompleted) {
    if (tasks.isEmpty) {
      return Center(
        child: Text(
          isCompleted
              ? S.of(context).thereIsNotCompTask
              : S.of(context).thereIsNotTask,
          style: Style.bodyRegular.copyWith(color: Colors.grey),
        ),
      );
    }

    return Column(
      children: [
        for (int i = 0; i < tasks.length; i++) ...[
          DisplayListOfTasks(
            isCompletedTasks: isCompleted,
            tasks: [tasks[i]],
          ),
          if (i < tasks.length - 1)
            const Divider(
              height: 1,
              thickness: 0.5,
              color: Colors.white30,
              indent: 16,
              endIndent: 16,
            ),
        ],
      ],
    );
  }

  List<Homework> _incompltedTask(List<Homework> tasks, WidgetRef ref) {
    final date = ref.watch(dateProvider);
    List<Homework> filteredTask = [];

    List<Homework> sortedTasks = List.from(tasks);
    sortedTasks.sort((a, b) => a.date.compareTo(b.date));

    for (var task in sortedTasks) {
      if (!task.isCompleted) {
        filteredTask.add(task);
      }
    }
    return filteredTask;
  }

  List<Homework> _compltedTask(List<Homework> tasks, WidgetRef ref) {
    final date = ref.watch(dateProvider);
    List<Homework> filteredTask = [];

    List<Homework> sortedTasks = List.from(tasks);
    sortedTasks.sort((a, b) => a.date.compareTo(b.date));

    for (var task in sortedTasks) {
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
