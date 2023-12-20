// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_test_project/screens/canteen_screen.dart';
import 'package:flutter_test_project/screens/error_screen.dart';
import 'package:flutter_test_project/screens/settings_screen.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rive/rive.dart';
import '../blocs/schedule_bloc/schedule_bloc.dart';
import '../blocs/settings_bloc/settings_bloc.dart';
import '../generated/l10n.dart';
import '../models/schedule.dart';
import '../services/homework_screen.dart';
import '../services/parse.dart';
import '../widgets/calendar_widget.dart';
// import 'notification_screen.dart';

class ScheduleScreen extends StatelessWidget {
  final Map<String, String> request;

  const ScheduleScreen(this.request, {Key? key}) : super(key: key);

  // ЗДЕСЬ НУЖНО НАПИСАТЬ РЕКВЕСТЫ К ГРУППЕ, КУРСУ, АУДИТОРИИ, УЧИЛКЕ (ПОКА ХЗ КАК)
  ScheduleEvent _formEvent(DateTime dateTime) {
    if (request.keys.contains('group')) {
      return GetScheduleForGroup(
        group: request['group']!,
        dateTime: dateTime,
      );
    } else if (request.keys.contains('teacher')) {
      return GetScheduleForTeacher(
        teacher: request['teacher']!,
        dateTime: dateTime,
      );
    } else {
      return GetScheduleForAuditorium(
        auditorium: request['auditorium']!,
        dateTime: dateTime,
      );
    }
  }
// PEREDELAT!!!!!!!!!!!!!!1
//////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeworkBloc>(
      create: (context) {
        return HomeworkBloc()..add(_formEvent(DateTime.now()));
      },
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                InkWell(
                  child: const Padding(
                    padding: EdgeInsets.only(right: 20),
                    // child: Icon(
                    //   Icons.notifications,
                    //   size: 27,
                    // ),
                  ),
                  onTap: () {
                    pushToCanteenScreenWithLoading(context);
                  },
                ),
              ],
              title: Text(S.of(context).scheduleOf(request.values.first)),
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
          );
        },
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
              color: Theme.of(context)
                  .primaryColor, // Use your app's primary color
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // You can add your app's logo or any other header content here
                Text(
                  'Расписание АУППРБ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Андронио Суслини',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
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
    return CalendarWidget(request);
  }

  Widget _buildBlocListBuilder(BuildContext context) {
    int currentIndex = 0;
    return Expanded(
      child: Dismissible(
        key: ValueKey(currentIndex),
        movementDuration: const Duration(milliseconds: 0),
        confirmDismiss: (dismiss) {
          final bloc = context.read<HomeworkBloc>();
          var duration = const Duration();
          if (dismiss == DismissDirection.endToStart) {
            duration = const Duration(days: 1);
          } else {
            duration = const Duration(days: -1);
          }
          if (bloc.state is ScheduleLoaded) {
            final date =
                (bloc.state as ScheduleLoaded).selectedDate.add(duration);
            bloc.add(_formEvent(date));
          }
          return Future.value(false);
        },
        child: BlocBuilder<HomeworkBloc, ScheduleState>(
          builder: (context, state) {
            if (state is ScheduleLoaded) {
              return _buildAnimatedListView(context, state.schedule);
            } else if (state is ScheduleError) {
              return _buildErrorWidget(context, state.message);
            } else if (state is ScheduleLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            // не забыть поменять!
            // return _buildAnimatedListView(context, []);
            return _buildEmptyListWidget(context);
          },
        ),
      ),
    );
  }
  // ШЛЯПУ НИЖЕ НЕ ТРОГАТЬ ПОКА ЧТО!
  //  Widget _buildWidgetDependOnRequest(Schedule schedule, int index) {
  //   if (request.keys.contains('group')) {
  //     return GroupScheduleWidget(schedule: schedule, index: index);
  //   } else if (request.keys.contains('teacher')) {
  //     return TeacherScheduleWidget(schedule: schedule, index: index);
  //   } else {
  //     return AuditoriumScheduleWidget(schedule: schedule, index: index);
  //   }
  // }

  Widget _buildAnimatedListView(BuildContext context, List<Schedule> schedule) {
    // change to ISNOTEMPTY
    if (schedule.isEmpty) {
      return AnimationLimiter(
        child: ListView.builder(
          itemBuilder: (_, index) {
            // return _buildWidgetDependOnRequest(schedule[index], index);
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

// Future<void> pushToCanteenScreen(BuildContext context) async {
//   Canteen? canteen = await MenuLoader(
//           "https://script.google.com/macros/s/AKfycbxU0kHQHz5ozY262ZR-1veg0ZQFn0Z7KdBVgqNgMZG4wnMy-OKK86srjOoawl9goZ5N3w/exec")
//       .loadMenu();
//   SchedulerBinding.instance.addPostFrameCallback((_) {
//     Navigator.of(context).popUntil((route) => route.isFirst);
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (_) => CanteenScreen(
//           canteen: canteen!,
//           dateTime: DateTime.now(),
//         ),
//       ),
//     );
//   });
// }

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
