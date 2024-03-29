import 'dart:developer';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_test_project/screens/app_info_screen.dart';
import 'package:flutter_test_project/screens/canteen_screen.dart';
import 'package:flutter_test_project/screens/error_screen.dart';
import 'package:flutter_test_project/screens/onboarding_screen.dart';
import 'package:flutter_test_project/screens/services_screen.dart';
import 'package:flutter_test_project/screens/settings_screen.dart';
import 'package:flutter_test_project/widgets/guider.dart';
import 'package:flutter_test_project/widgets/schedule_widget.dart';
import 'package:flutter_test_project/widgets/typography.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rive/rive.dart';
import 'package:unicons/unicons.dart';
import '../blocs/schedule_bloc/schedule_bloc.dart';
import '../blocs/settings_bloc/settings_bloc.dart';
import '../generated/l10n.dart';
import 'homework_screen.dart';
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

  // @override
  // void initState() {
  //   super.initState();
  //   final bloc = context.read<ScheduleBloc>();
  //   var temp = DateTime.now().toString().replaceRange(10, 26, '');
  //   bloc.add(ChangeDateOfClasses(DateTime.parse(temp)));
  //   bloc.add(const LoadSchedule());
  // }

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
              title: Text(
                S.of(context).scheduleOf(widget.request.values.first),
                style: Style.h6,
              ),
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
                const SizedBox(height: 6),
                _buildImage(context),
              ],
            ),
          ),
          ListTile(
            leading:
                const Icon(Icons.fastfood_outlined), // Icon for the first item
            title: Text(
              S.of(context).canteen,
              style: Style.bodyRegular.copyWith(fontSize: 16),
            ),
            onTap: () {
              pushToCanteenScreenWithLoading(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.task_alt), // Icon for the second item
            title: Text(
              S.of(context).hometasks,
              style: Style.bodyRegular.copyWith(fontSize: 16),
            ),
            onTap: () {
              pushToNotificationScreen(context);
            },
          ),
          ListTile(
            leading: const Icon(
                Icons.supervised_user_circle_sharp), // Icon for the second item
            title: Text(
              S.of(context).services,
              style: Style.bodyRegular.copyWith(fontSize: 16),
            ),
            onTap: () {
              pushToServicesScreen(context);
            },
          ),
          ListTile(
            leading:
                const Icon(UniconsLine.info_circle), // Icon for the second item
            title: Text(
              S.of(context).aboutApp,
              style: Style.bodyRegular.copyWith(fontSize: 16),
            ),
            onTap: () {
              pushToAppInfoScreen(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings), // Icon for the second item
            title: Text(
              S.of(context).settings,
              style: Style.bodyRegular.copyWith(fontSize: 16),
            ),
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
    List<String> schedule;
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
              return _buildAnimatedListView(context, state.classes, state.time);
            } else if (state is ScheduleError) {
              return _buildErrorWidget(context, state.message);
            } else if (state is ScheduleLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ScheduleDayIsEmpty) {
              return _buildEmptyListWidget(context);
            }
            return _buildAnimatedListView(context, [], []);
          },
        ),
      ),
    );
  }

  Widget _buildAnimatedListView(
      BuildContext context, List<String> schedule, List<String> time) {
    if (schedule.isNotEmpty) {
      int forNullCheking = 0;
      for (var element in schedule) {
        if (element == 'null') {
          forNullCheking++;
        }
      }
      if (forNullCheking >= 6 || DateTime.sunday == DateTime.now().weekday) {
        return _buildEmptyListWidget(context);
      }
      return AnimationLimiter(
        child: ListView.builder(
          itemBuilder: (_, index) {
            return GroupScheduleWidget(
              index: index,
              schedule: schedule,
              time: time,
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
          style: Style.bodyBold.copyWith(fontSize: 16),
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
      backgroundColor: Theme.of(context).primaryColor,
      child: const Icon(Icons.add, size: 36),
    );
  }

  void _showContextMenu(BuildContext context) {
    int selectedGroupNumber = 1;
    int selectedStreamGroupCount = 2;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final bloc = context.read<ScheduleBloc>();
        final settingsBloc = context.read<SettingsBloc>();
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.of(context).menu,
                      style: Style.bodyL.copyWith(fontSize: 22)),
                  IconButton(
                    icon: const Icon(Icons.help),
                    onPressed: () {
                      showUsageGuideBottomSheet(context);
                    },
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildGroupListTile(),
                  _buildNumsOfGroupListTile(),
                  ElevatedButton(
                    onPressed: () async {
                      settingsBloc.add(const ClearCache());
                      bloc.add(const PickFile());
                    },
                    child: Text(
                      S.of(context).chooseExcel,
                      style: Style.captionL.copyWith(fontSize: 14),
                    ),
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
                  child: Text(S.of(context).ok, style: Style.buttonS),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(S.of(context).cancel, style: Style.buttonS),
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
          title: Text(S.of(context).numOfGroup,
              style: Style.captionL.copyWith(fontSize: 16)),
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
                bloc.add(ChangeSettings(bloc.settings.themeMode, group,
                    bloc.settings.numOfGroups, bloc.settings.isFirstLaunch));
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
          title: Text(S.of(context).totalGroups,
              style: Style.captionL.copyWith(fontSize: 16)),
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
                    bloc.settings.themeMode,
                    bloc.settings.group,
                    numOfGroups,
                    bloc.settings.isFirstLaunch));
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

void pushToAppInfoScreen(BuildContext context) {
  Navigator.of(context).popUntil((route) => route.isFirst);
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => const AboutAppPage(),
    ),
  );
}

void showUsageGuideBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return const UsageGuideBottomSheet();
    },
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

void pushToServicesScreen(BuildContext context) {
  Navigator.of(context).popUntil((route) => route.isFirst);
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => const ServicesScreen(),
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
  List<String> canteenLoadingPhrases = [
    "Ищем печеньки...",
    "Тетя Зина накрывает на стол...",
    "Греем сосиски в тесте...",
    "Нарезаем салаты...",
    "Разгоняем заочников...",
    "Занимаем очередь..."
  ];

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
            Text(canteenLoadingPhrases[
                Random().nextInt(canteenLoadingPhrases.length)]),
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

      if (context.mounted) Navigator.pop(context);

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => CanteenScreen(
              canteen: canteen,
              dateTime: DateTime.now(),
            ),
          ),
        );
      }
    } catch (error) {
      if (context.mounted) Navigator.pop(context);

      // _buildErrorWidget(context, 'error');
      if (context.mounted) _buildErrorWidget(context, "error");
    }
  } else {
    if (context.mounted) pushToErrorScreen(context);
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
        style: Style.bodyBold.copyWith(fontSize: 16),
      ),
    ],
  );
}
