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
    _loadSettings();
  }

  FutureOr<void> _onChangeSettings(
    ChangeSettings event,
    Emitter<SettingsState> emit,
  ) {
    try {
      //ЗАМЕНИТЬ НА ISNOTEMPTY КОГДА ДОБАВИМ ГРУППЫ!!!!!!!!!!!!!!1
      if (event.group.trim().isEmpty) {
        emit(SettingsInitial());
        settings.group = event.group;
        settings.themeMode = event.themeMode;
        emit(SettingsLoaded(settings));
        Storage().saveSettings(settings);
      } else {
        emit(const SettingsError('Заполните поля'));
      }
    } catch (_) {
      emit(const SettingsError('Произошла ошибка'));
    }
  }

  FutureOr<void> _onClearCache(
    ClearCache event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsInitial());
    //RE - DO!!!! SHITTY CODE;
    // ignore: await_only_futures
    await ();
    emit(const CachedDataDeleted('Кэшированые данные были удалены'));
    emit(SettingsLoaded(settings));
  }
}
