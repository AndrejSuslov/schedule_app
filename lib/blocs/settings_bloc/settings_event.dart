part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class ChangeLanguage extends SettingsEvent {
  final String language;

  const ChangeLanguage(this.language);
}

class ChangeSettings extends SettingsEvent {
  final ThemeMode themeMode;
  final String group;
  final String numOfGroups;
  final bool isFirstLaunch;
  final bool isScheduleLoaded;
  // final ScheduleBloc? bloc;

  const ChangeSettings(this.themeMode, this.group, this.numOfGroups,
      this.isFirstLaunch, this.isScheduleLoaded);
}

class ClearCache extends SettingsEvent {
  const ClearCache();
}

class FullClearCache extends SettingsEvent {
  const FullClearCache();
}
