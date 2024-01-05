// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_test_project/screens/canteen_screen.dart';
import 'package:flutter_test_project/screens/error_screen.dart';
import 'package:flutter_test_project/screens/settings_screen.dart';
import 'package:flutter_test_project/widgets/schedule_widget.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rive/rive.dart';
import '../blocs/schedule_bloc/schedule_bloc.dart';
import '../blocs/settings_bloc/settings_bloc.dart';
import '../generated/l10n.dart';
import '../services/homework_screen.dart';
import '../services/parse.dart';
import '../widgets/calendar_widget.dart';

class ScheduleScreen extends StatefulWidget {
  final Map<String, String> request;

  const ScheduleScreen(this.request, {Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  ScheduleEvent _formEvent(DateTime dateTime) {
    if (widget.request.keys.contains('group')) {
      return GetScheduleForGroup(
        group: widget.request['group']!,
        dateTime: dateTime,
      );
    } else if (widget.request.keys.contains('teacher')) {
      return GetScheduleForTeacher(
        teacher: widget.request['teacher']!,
        dateTime: dateTime,
      );
    } else if (widget.request.keys.contains('auditorium')) {
      return GetScheduleForAuditorium(
        auditorium: widget.request['auditorium']!,
        dateTime: dateTime,
      );
    } else {
      return ChangeDateOfClasses(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ScheduleBloc>(
      create: (context) {
        return ScheduleBloc()..add(_formEvent(DateTime.now()));
      },
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                InkWell(
                  child: const Padding(
                    padding: EdgeInsets.only(right: 20),
                  ),
                  onTap: () {
                    pushToCanteenScreenWithLoading(context);
                  },
                ),
              ],
              title:
                  Text(S.of(context).scheduleOf(widget.request.values.first)),
            ),
            drawer: _buildDrawer(context),
            body: SafeArea(
              child: Column(
                children: [
                  _buildCalendar(context),
                  _buildBlocListBuilder(context),
                ],
              ),
            ),
            floatingActionButton: _buildFloatingActionButton(context),
          );
        },
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
        width: double.infinity,
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 14),
                // const Text(
                //   '',
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 22,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                const SizedBox(height: 6),
                _buildImage(context),
                // const Text(
                //   '',
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 16,
                //   ),
                // ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.fastfood), // Icon for the first item
            title: const Text('Столовая'),
            onTap: () {
              pushToCanteenScreenWithLoading(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.task_alt), // Icon for the second item
            title: const Text('Домашние задания'),
            onTap: () {
              pushToNotificationScreen(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings), // Icon for the second item
            title: Text(S.of(context).settings),
            onTap: () {
              pushToSettingsScreen(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(BuildContext context) {
    return CalendarWidget(widget.request);
  }

  Widget _buildBlocListBuilder(BuildContext context) {
    int currentIndex = 0;
    late List<String> schedule;
    return Expanded(
      child: Dismissible(
        key: ValueKey(currentIndex),
        movementDuration: const Duration(milliseconds: 0),
        confirmDismiss: (dismiss) {
          final bloc = context.read<ScheduleBloc>();
          var duration = const Duration();
          if (dismiss == DismissDirection.endToStart) {
            duration = const Duration(days: 1);
          } else {
            duration = const Duration(days: -1);
          }
          if (bloc.state is ScheduleLoaded) {
            final _date = (bloc.state as ScheduleLoaded).date.add(duration);
            schedule = (bloc.state as ScheduleLoaded).classes;
            bloc.add(ChangeDateOfClasses(_date));
            bloc.add(const LoadSchedule());
          }
          return Future.value(false);
        },
        child: BlocBuilder<ScheduleBloc, ScheduleState>(
          builder: (context, state) {
            if (state is ScheduleLoaded) {
              return _buildAnimatedListView(context, state.classes);
            } else if (state is ScheduleError) {
              return _buildErrorWidget(context, state.message);
            } else if (state is ScheduleLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            // не забыть поменять!
            // return _buildAnimatedListView(context, []);
            return _buildAnimatedListView(context, []);
          },
        ),
      ),
    );
  }

  Widget _buildAnimatedListView(BuildContext context, List<String> schedule) {
    if (schedule.isNotEmpty) {
      int forNullCheking = 0;
      for (var element in schedule) {
        if (element == 'null') {
          forNullCheking++;
        }
      }
      if (forNullCheking >= 6) {
        return _buildEmptyListWidget(context);
      }
      return AnimationLimiter(
        child: ListView.builder(
          itemBuilder: (_, index) {
            return GroupScheduleWidget(
              index: index,
              schedule: schedule,
            );
          },
          itemCount: schedule.length,
          shrinkWrap: true,
        ),
      );
    }
    return _buildEmptyListWidget(context);
  }

  Widget _buildEmptyListWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width * 0.7,
          child: const RiveAnimation.asset(
            'assets/anims/sleep.riv',
          ),
        ),
        Text(
          S.of(context).emptyLessons,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Add logic to open the context menu here
        _showContextMenu(context);
      },
      child: const Icon(Icons.add, size: 36),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  void _showContextMenu(BuildContext context) {
    // Define variables to hold the selected group number and stream group count
    int selectedGroupNumber = 1;
    int selectedStreamGroupCount = 2; // Default value set to 2

    //FilePickerResult? excelFileResult;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final bloc = context.read<ScheduleBloc>();
        final settingsBloc = context.read<SettingsBloc>();
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text("Меню выбора"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildGroupListTile(),
                  _buildNumsOfGroupListTile(),
                  ElevatedButton(
                    onPressed: () async {
                      bloc.add(const PickFile());
                    },
                    child: const Text("Выбрать файл Excel"),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    bloc.add(SaveSchedule(
                        group: settingsBloc.settings.group,
                        numOfGroups: settingsBloc.settings.numOfGroups));
                    bloc.add(const LoadSchedule());
                    Navigator.pop(context);
                  },
                  child: const Text("Ок"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
              ],
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            );
          },
        );
      },
    );
  }

  Widget _buildGroupListTile() {
    final bloc = context.read<SettingsBloc>();
    List<int> groups = [1, 2, 3, 4, 5];
    return BlocBuilder<SettingsBloc, SettingsState>(
      bloc: bloc,
      builder: (context, state) {
        return ListTile(
          title: const Text('Группа'),
          trailing: DropdownButton<String>(
            value: bloc.settings.group,
            items: [
              DropdownMenuItem(
                value: groups.elementAt(0).toString(),
                child: const Text('1'),
              ),
              DropdownMenuItem(
                value: groups.elementAt(1).toString(),
                child: const Text('2'),
              ),
              DropdownMenuItem(
                value: groups.elementAt(2).toString(),
                child: const Text('3'),
              ),
              DropdownMenuItem(
                value: groups.elementAt(3).toString(),
                child: const Text('4'),
              ),
              DropdownMenuItem(
                value: groups.elementAt(4).toString(),
                child: const Text('5'),
              ),
            ],
            onChanged: (group) {
              if (group != null) {
                bloc.add(ChangeSettings(
                    bloc.settings.themeMode, group, bloc.settings.numOfGroups));
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildNumsOfGroupListTile() {
    final bloc = context.read<SettingsBloc>();
    List<int> groups = [2, 3, 4, 5];
    return BlocBuilder<SettingsBloc, SettingsState>(
      bloc: bloc,
      builder: (context, state) {
        return ListTile(
          title: const Text('Кол-во групп на потоке'),
          trailing: DropdownButton<String>(
            value: bloc.settings.numOfGroups,
            items: [
              DropdownMenuItem(
                value: groups.elementAt(0).toString(),
                child: const Text('2'),
              ),
              DropdownMenuItem(
                value: groups.elementAt(1).toString(),
                child: const Text('3'),
              ),
              DropdownMenuItem(
                value: groups.elementAt(2).toString(),
                child: const Text('4'),
              ),
              DropdownMenuItem(
                value: groups.elementAt(3).toString(),
                child: const Text('5'),
              ),
            ],
            onChanged: (numOfGroups) {
              if (numOfGroups != null) {
                bloc.add(ChangeSettings(
                    bloc.settings.themeMode, bloc.settings.group, numOfGroups));
              }
            },
          ),
        );
      },
    );
  }
}

void pushToNotificationScreen(BuildContext context) {
  Navigator.of(context).popUntil((route) => route.isFirst);
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => const HomeScreen(),
    ),
  );
}

void pushToErrorScreen(BuildContext context) {
  Navigator.of(context).popUntil((route) => route.isFirst);
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => const ErrorScreen(),
    ),
  );
}

void pushToSettingsScreen(BuildContext context) {
  final bloc = context.read<SettingsBloc>();
  Navigator.of(context).popUntil((route) => route.isFirst);
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => SettingsScreen(bloc),
    ),
  );
}

Future<void> pushToCanteenScreenWithLoading(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                size: 50,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            const Text("Finding cookies..."),
          ],
        ),
      );
    },
  );
  bool result = await InternetConnection().hasInternetAccess;
  if (result) {
    try {
      final canteen = await MenuLoader(
        "https://script.google.com/macros/s/AKfycbxU0kHQHz5ozY262ZR-1veg0ZQFn0Z7KdBVgqNgMZG4wnMy-OKK86srjOoawl9goZ5N3w/exec",
      ).loadMenu();

      Navigator.pop(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CanteenScreen(
            canteen: canteen,
            dateTime: DateTime.now(),
          ),
        ),
      );
    } catch (error) {
      Navigator.pop(context);

      // _buildErrorWidget(context, 'error');
      _buildErrorWidget(context, "error");
    }
  } else {
    pushToErrorScreen(context);
  }
}

Widget _buildErrorWidget(BuildContext context, String message) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width * 0.7,
        child: const RiveAnimation.asset(
          'assets/anims/error.riv',
        ),
      ),
      Text(
        message,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    ],
  );
}
