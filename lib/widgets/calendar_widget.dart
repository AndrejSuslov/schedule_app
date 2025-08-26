import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_project/widgets/typography.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_test_project/generated/l10n.dart';

import '../blocs/schedule_bloc/schedule_bloc.dart';

class CalendarWidget extends StatefulWidget {
  final Map<String, String> request;

  const CalendarWidget(this.request, {Key? key}) : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  CalendarFormat _format = CalendarFormat.week;
  late DateTime _selectedDate;

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  void initState() {
    super.initState();
    final bloc = context.read<ScheduleBloc>();
    _selectedDate = _dateOnly(DateTime.now());
    bloc.add(ChangeDateOfClasses(_selectedDate));
    bloc.add(LoadSchedule(_selectedDate));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScheduleBloc, ScheduleState>(
      listener: (context, state) {
        if (state is ScheduleLoaded) {
          setState(() => _selectedDate = _dateOnly(state.date));
        }
      },
      child: TableCalendar(
        locale: Localizations.localeOf(context).languageCode,
        calendarFormat: _format,
        focusedDay: _selectedDate,
        selectedDayPredicate: (d) => isSameDay(d, _selectedDate),
        currentDay: _selectedDate,
        firstDay: DateTime.utc(2020, 8, 9),
        lastDay: DateTime.utc(2035, 1, 1),
        weekendDays: const [DateTime.sunday],
        startingDayOfWeek: StartingDayOfWeek.monday,
        headerStyle: HeaderStyle(
          titleTextStyle: Style.bodyL.copyWith(fontSize: 16),
          formatButtonTextStyle: Style.bodyRegular,
        ),
        calendarStyle: CalendarStyle(
          defaultTextStyle: Style.bodyRegular,
          defaultDecoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            shape: BoxShape.rectangle,
          ),
          todayDecoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: Theme.of(context).colorScheme.primary,
          ),
          weekendDecoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        availableCalendarFormats: {
          CalendarFormat.twoWeeks: S.of(context).twoWeeks,
          CalendarFormat.week: S.of(context).week,
        },
        onFormatChanged: (format) => setState(() => _format = format),
        onDaySelected: (selectedDay, focusedDay) {
          final d = _dateOnly(selectedDay);
          setState(() => _selectedDate = d);
          final bloc = context.read<ScheduleBloc>();
          bloc.add(ChangeDateOfClasses(d));
          bloc.add(LoadSchedule(d));
        },
      ),
    );
  }
}
