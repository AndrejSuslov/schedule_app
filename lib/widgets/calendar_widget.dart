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
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    final bloc = context.read<ScheduleBloc>();
    var temp = DateTime.now().toString().replaceRange(10, 26, '');
    _selectedDate = DateTime.parse(temp);
    bloc.add(ChangeDateOfClasses(_selectedDate));
    bloc.add(LoadSchedule(_selectedDate));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        firstDay: DateTime.utc(2020, 08, 09),
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
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            shape: BoxShape.rectangle,
          ),
          todayDecoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            color: Theme.of(context).colorScheme.primary,
          ),
          weekendDecoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        availableCalendarFormats: {
          CalendarFormat.twoWeeks: S.of(context).twoWeeks,
          CalendarFormat.week: S.of(context).week,
        },
        onFormatChanged: (format) {
          setState(() {
            _format = format;
          });
        },
        onDaySelected: (prevDate, selDate) {
          setState(() {
            final bloc = context.read<ScheduleBloc>();
            var temp = selDate
                .toString()
                .replaceRange(10, selDate.toString().length, '');
            _selectedDate = DateTime.parse(temp);
            bloc.add(ChangeDateOfClasses(_selectedDate));
            bloc.add(LoadSchedule(_selectedDate));
            if (bloc.state is ScheduleError) {
              bloc.emit(const ScheduleDayIsEmpty("messsage"));
            }
          });
        },
      ),
    );
  }
}
