import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:rive/rive.dart';

import '../blocs/schedule_bloc/schedule_bloc.dart';
import '../generated/l10n.dart';
import '../models/schedule.dart';
import '../widgets/calendar_widget.dart';

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
    return BlocProvider<ScheduleBloc>(
      create: (context) {
        return ScheduleBloc()..add(_formEvent(DateTime.now()));
      },
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).scheduleOf(request.values.first)),
            ),
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
          final bloc = context.read<ScheduleBloc>();
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
        child: BlocBuilder<ScheduleBloc, ScheduleState>(
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
