import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  // final Map<String, String> request;

  const CalendarWidget({Key? key}) : super(key: key);
  // first version
  // const CalendarWidget(this.request, {Key? key}) : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  CalendarFormat _format = CalendarFormat.week;
  DateTime _selectedDate = DateTime.now();

  // ScheduleEvent _formEvent(DateTime dateTime) {
  //   final request = widget.request;
  //   if (request.keys.contains('group')) {
  //     return GetScheduleForGroup(
  //       group: request['group']!,
  //       dateTime: dateTime,
  //     );
  //   } else if (request.keys.contains('teacher')) {
  //     return GetScheduleForTeacher(
  //       teacher: request['teacher']!,
  //       dateTime: dateTime,
  //     );
  //   } else {
  //     return GetScheduleForAuditorium(
  //       auditorium: request['auditorium']!,
  //       dateTime: dateTime,
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // return BlocListener<ScheduleBloc, ScheduleState>(
    // listener: (context, state) {
    // if (state is ScheduleLoaded) {
    //   setState(() {
    //     _selectedDate = state.selectedDate;
    //   });
    // }
    // },
    return TableCalendar(
      locale: 'ru',
      calendarFormat: _format,
      focusedDay: _selectedDate,
      currentDay: _selectedDate,
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      weekendDays: const [DateTime.sunday],
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        defaultDecoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        todayDecoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          color: Theme.of(context).colorScheme.primary,
        ),
        weekendDecoration: const BoxDecoration(),
      ),
      availableCalendarFormats: const {
        CalendarFormat.twoWeeks: 'Две недели',
        CalendarFormat.month: 'Месяц',
        CalendarFormat.week: 'Неделя'
      },
      onFormatChanged: (format) {
        setState(() {
          _format = format;
        });
      },
      // onDaySelected: (prevDate, selDate) {
      //   setState(() {
      //     _selectedDate = selDate;
      //     final bloc = context.read<ScheduleBloc>();
      //     bloc.add(_formEvent(selDate));
      //   });
      // },
    );
    // );
  }
}
