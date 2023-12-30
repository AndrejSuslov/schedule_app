import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../blocs/schedule_bloc/schedule_bloc.dart';

// final Map<DateTime, List> _holidays = {
//   DateTime(2024, 1, 1): ['New Year\'s Day'],
//   DateTime(2024, 1, 6): ['Epiphany'],
//   DateTime(2024, 2, 14): ['Valentine\'s Day'],
//   DateTime(2024, 4, 21): ['Easter Sunday'],
//   DateTime(2024, 4, 22): ['Easter Monday'],
// };

class CalendarWidget extends StatefulWidget {
  final Map<String, String> request;

  // const CalendarWidget({Key? key}) : super(key: key);
  // first version
  const CalendarWidget(this.request, {Key? key}) : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  CalendarFormat _format = CalendarFormat.week;
  DateTime _selectedDate = DateTime.now();

// сейчас мы ссылаемся к этому говну. нужно к другому
  ScheduleEvent _formEvent(DateTime dateTime) {
    final request = widget.request;
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

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context).languageCode;

    String calendarFormatsWeek;
    String calendarFormatsTwoWeeks;

    if (currentLocale == 'ru') {
      calendarFormatsTwoWeeks = 'Две недели';
      calendarFormatsWeek = 'Неделя';
    } else if (currentLocale == 'be') {
      calendarFormatsTwoWeeks = 'Два тыдні';
      calendarFormatsWeek = 'Тыдзень';
    } else {
      calendarFormatsTwoWeeks = 'Two weeks';
      calendarFormatsWeek = 'Week';
    }

    return BlocListener<ScheduleBloc, ScheduleState>(
      listener: (context, state) {
        if (state is ScheduleLoaded) {
          setState(() {
            _selectedDate = state.date;
          });
        }
      },
      child: TableCalendar(
        locale: Localizations.localeOf(context).languageCode,
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
        availableCalendarFormats: {
          CalendarFormat.twoWeeks: calendarFormatsTwoWeeks,
          CalendarFormat.week: calendarFormatsWeek,
        },
        onFormatChanged: (format) {
          setState(() {
            _format = format;
          });
        },
        onDaySelected: (prevDate, selDate) {
          setState(() {
            final bloc = context.read<ScheduleBloc>();
            var temp = selDate.toString().replaceRange(10, 24, '');
            _selectedDate = DateTime.parse(temp);
            bloc.add(ChangeDateOfClasses(_selectedDate));
            bloc.add(const LoadSchedule()); // mb this will work
          });
        },
      ),
    );
  }
}
