part of 'settings_bloc.dart';

// RE-DO
abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final Settings settings;

  const SettingsLoaded(this.settings);
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);
}

class CachedDataDeleted extends SettingsState {
  final String message;

  const CachedDataDeleted(this.message);
}
