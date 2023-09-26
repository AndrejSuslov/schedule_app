part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class ChangeSettings extends SettingsEvent {
  final ThemeMode themeMode;
  final String group;
  // final ScheduleBloc? bloc;

  const ChangeSettings(this.themeMode, this.group);
}

class ClearCache extends SettingsEvent {
  const ClearCache();
}
