import 'package:flutter/material.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_test_project/generated/l10n.dart';

import 'package:flutter_test_project/screens/homework_screen.dart';

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
              S.of(context).hometasks,
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
              label: Text(S.of(context).add),
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
          schedule[index],
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          schedule[index].contains('(лк.)')
              ? "Тип: лекция"
              : schedule[index].contains('Зачет')
                  ? "Тип: зачет"
                  : schedule[index].contains('КЧ')
                      ? "Тип: кураторский час"
                      : "Тип: практическое занятие",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          '${S.of(context).time}: ${time[index]}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
