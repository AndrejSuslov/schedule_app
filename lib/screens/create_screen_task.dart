import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../generated/l10n.dart';
import '../hometaskproviders/hometask_provider.dart';
import '../models/homework.dart';
import '../services/app_alerts.dart';
import '../services/date_provider.dart';
import '../services/helpers.dart';
import '../services/time_provider.dart';
import '../widgets/common_text_field.dart';
import '../widgets/select_date_time.dart';

class CreateTaskScreen extends ConsumerStatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateTaskScreenState();
}

class _CreateTaskScreenState extends ConsumerState<CreateTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).addNewTask,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CommonTextField(
                hintText: (S.of(context).taskTitle),
                title: S.of(context).taskTitle,
                controller: _titleController,
              ),
              const SizedBox(
                height: 20,
              ),
              CommonTextField(
                hintText: S.of(context).notes,
                title: S.of(context).notes,
                maxLines: 10,
                controller: _noteController,
              ),
              const SizedBox(
                height: 20,
              ),
              const SelectDateTime(),
              const SizedBox(
                height: 20,
              ),
              _buildConfirmButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: FilledButton(
        onPressed: () {
          _createTask();
        },
        child: Text(S.of(context).confirmButton),
      ),
    );
  }

  void _createTask() async {
    final title = _titleController.text.trim();
    final note = _noteController.text.trim();
    final time = ref.watch(timeProvider);
    final date = ref.watch(dateProvider);
    if (title.isNotEmpty) {
      final task = Homework(
        title: title,
        time: Helpers.timeToString(time),
        date: DateFormat.yMMMd().format(date),
        note: note,
        isCompleted: false,
      );

      await ref.read(tasksProvider.notifier).createTask(task).then((value) {
        AppAlerts.displaySnackbar(context, S.of(context).createdTask);
        _titleController.clear();
        _noteController.clear();
        Navigator.of(context).pop();
      });
    } else {
      AppAlerts.displaySnackbar(context, S.of(context).emptyTitle);
    }
  }
}
