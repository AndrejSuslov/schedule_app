import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_test_project/blocs/schedule_bloc/schedule_bloc.dart';
import 'package:flutter_test_project/services/homework_screen.dart';
import 'package:intl/intl.dart';

class GroupScheduleWidget extends StatelessWidget {
  final int index;
  final List<String> schedule;
  final List<String> time;

  const GroupScheduleWidget(
      {Key? key,
      required this.index,
      required this.schedule,
      required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (schedule[index] == 'null' || schedule[index].isEmpty) {
      return Container();
    } else {
      return AnimationConfiguration.staggeredList(
        position: index,
        duration: const Duration(milliseconds: 375),
        child: SlideAnimation(
          verticalOffset: 50.0,
          child: Card(
            child: ListTile(
              onTap: () {
                _showScheduleFullDialog(context);
              },
              title: (schedule[index].contains('(лк.)') ||
                      schedule[index].contains('КЧ') ||
                      schedule[index].contains('Зачет'))
                  ? Text(schedule[index])
                  : Text('${schedule[index]} (пз.)'),
              subtitle: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Text(''),
                  // Text('Преподаватель: -'),
                ],
              ),
              trailing: Flex(
                crossAxisAlignment: CrossAxisAlignment.end,
                direction: Axis.vertical,
                children: _buildTrailingListWidget(),
              ),
            ),
          ),
        ),
      );
    }
  }

  List<Widget> _buildTrailingListWidget() {
    List<Widget> widgets = [];
    widgets.add(Text(
      time[index].replaceAll(RegExp(r' - '), '\n'),
      style: const TextStyle(fontSize: 14),
    ));
    widgets.addAll([
      const SizedBox(height: 5),
    ]);
    return widgets;
  }

  void _showScheduleFullDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.only(
          top: 20,
          left: 10,
          right: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDescriptionSection(context),
            _buildHomeworkSection(context),
          ],
        ),
      ),
    );
  }

  Column _buildHomeworkSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Домашнее задание',
              style: Theme.of(context).textTheme.headline6,
            ),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomeScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Добавить'),
            ),
          ],
        ),
        const SizedBox(height: 15),
        _buildHomeworkListView(context),
      ],
    );
  }

  Widget _buildHomeworkListView(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: ListView.builder(
        itemCount: 2, // Placeholder count
        itemBuilder: (context, index) {
          // return ListTile(
          //   onTap: () {},
          //   // title: const Text(''),
          //   // subtitle: const Text(
          //   //   '-',
          //   //   overflow: TextOverflow.ellipsis,
          //   //   maxLines: 2,
          //   // ),
          //   // trailing: Text(
          //   //   DateFormat.yMMMd('ru').format(DateTime.now()),
          //   // ),
          // );
        },
      ),
    );
  }

  Widget _buildEmptyListWidget(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 0.7,
        child: const Icon(Icons.warning),
      ),
    );
  }

  Column _buildDescriptionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '-',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          'Преподаватель: -',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          'Тип: -',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          'Время: -',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
