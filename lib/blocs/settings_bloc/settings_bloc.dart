import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';

import '../../models/settings.dart';
import '../../services/storage.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  late final Settings settings;

  void _loadSettings() async {
    emit(SettingsLoading());
    final loadedInfo = await Storage().readSettings();
    if (loadedInfo != null) {
      settings = loadedInfo;
    } else {
      settings = Settings.defaultSettings;
    }
    emit(SettingsLoaded(settings));
  }

  SettingsBloc() : super(SettingsInitial()) {
    on<ChangeSettings>(_onChangeSettings);
    on<ClearCache>(_onClearCache);
    on<FullClearCache>(_onFullClearCache);
    _loadSettings();
  }

  FutureOr<void> _onChangeSettings(
    ChangeSettings event,
    Emitter<SettingsState> emit,
  ) {
    try {
      emit(SettingsInitial());
      settings.group = event.group;
      settings.themeMode = event.themeMode;
      settings.numOfGroups = event.numOfGroups;
      settings.isFirstLaunch = event.isFirstLaunch;
      Storage().saveSettings(settings);
      emit(SettingsLoaded(settings));
    } catch (_) {
      emit(const SettingsError('Произошла ошибка'));
    }
  }

  FutureOr<void> _onClearCache(
    ClearCache event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsInitial());
    await Storage().clearStorage();
    emit(const CachedDataDeleted('Кэшированые данные были удалены'));
    emit(SettingsLoaded(settings));
  }

  FutureOr<void> _onFullClearCache(
    FullClearCache event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsInitial());
    await Storage().clearFullStorage();
    emit(const FullCachedDataDeleted('Кэшированые данные были удалены'));
    emit(SettingsLoaded(settings));
  }
}
