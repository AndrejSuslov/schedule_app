import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test_project/services/parser.dart';

import '../../models/settings.dart';
import '../../services/storage.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  late final Settings settings;

  void _loadSettings() async {
    // ignore: invalid_use_of_visible_for_testing_member
    emit(SettingsLoading());
    final loadedInfo = await Storage().readSettings();
    if (loadedInfo != null) {
      settings = loadedInfo;
    } else {
      settings = Settings.defaultSettings;
    }
    // ignore: invalid_use_of_visible_for_testing_member
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
      //ЗАМЕНИТЬ НА ISNOTEMPTY КОГДА ДОБАВИМ ГРУППЫ!!!!!!!!!!!!!!1
      emit(SettingsInitial());
      settings.group = event.group;
      settings.themeMode = event.themeMode;
      settings.numOfGroups = event.numOfGroups;
      settings.isFirstLaunch = event.isFirstLaunch;

      // settings.numOfGroups = event.numOfGroups;
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
