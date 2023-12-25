class Schedule {
  final Map<DateTime, List<String>> scheduleForGroup;

  Schedule(this.scheduleForGroup);

  List<String>? getScheduleByDay(DateTime date) {
    return scheduleForGroup[date];
  }

  Map<DateTime, List<String>> toMap() {
    return scheduleForGroup;
  }
}
