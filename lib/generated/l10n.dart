// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'messages/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Schedule`
  String get schedule {
    return Intl.message(
      'Schedule',
      name: 'schedule',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Teacher`
  String get teacher {
    return Intl.message(
      'Teacher',
      name: 'teacher',
      desc: '',
      args: [],
    );
  }

  /// `Audiences`
  String get auditories {
    return Intl.message(
      'Audiences',
      name: 'auditories',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Nothing found`
  String get empty {
    return Intl.message(
      'Nothing found',
      name: 'empty',
      desc: '',
      args: [],
    );
  }

  /// `The schedule of the AUPPRB`
  String get inviteScreenTitle {
    return Intl.message(
      'The schedule of the AUPPRB',
      name: 'inviteScreenTitle',
      desc: '',
      args: [],
    );
  }

  /// `Welcome\nEnter your group number`
  String get welcomeText {
    return Intl.message(
      'Welcome\nEnter your group number',
      name: 'welcomeText',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirmButton {
    return Intl.message(
      'Confirm',
      name: 'confirmButton',
      desc: '',
      args: [],
    );
  }

  /// `Schedule of {of}`
  String scheduleOf(Object of) {
    return Intl.message(
      'Schedule of $of',
      name: 'scheduleOf',
      desc: '',
      args: [of],
    );
  }

  /// `There are no classes today, you can relax`
  String get emptyLessons {
    return Intl.message(
      'There are no classes today, you can relax',
      name: 'emptyLessons',
      desc: '',
      args: [],
    );
  }

  /// `Clear Cache`
  String get clearCache {
    return Intl.message(
      'Clear Cache',
      name: 'clearCache',
      desc: '',
      args: [],
    );
  }

  /// `Change Group`
  String get changeGroup {
    return Intl.message(
      'Change Group',
      name: 'changeGroup',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message(
      'Theme',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `System`
  String get system {
    return Intl.message(
      'System',
      name: 'system',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get light {
    return Intl.message(
      'Light',
      name: 'light',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get dark {
    return Intl.message(
      'Dark',
      name: 'dark',
      desc: '',
      args: [],
    );
  }

  /// `Teachers`
  String get teachers {
    return Intl.message(
      'Teachers',
      name: 'teachers',
      desc: '',
      args: [],
    );
  }

  /// `There is no list of teachers`
  String get noTeachers {
    return Intl.message(
      'There is no list of teachers',
      name: 'noTeachers',
      desc: '',
      args: [],
    );
  }

  String get hometasks {
    return Intl.message(
      'Hometasks',
      name: 'hometasks',
      desc: '',
      args: [],
    );
  }

  String get completed {
    return Intl.message(
      'Completed',
      name: 'completed',
      desc: '',
      args: [],
    );
  }

  String get taskTitle {
    return Intl.message(
      'Task Title',
      name: 'taskTitle',
      desc: '',
      args: [],
    );
  }

  String get notes {
    return Intl.message(
      'Notes',
      name: 'notes',
      desc: '',
      args: [],
    );
  }

  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  String get time {
    return Intl.message(
      'Time',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  String get addNewTask {
    return Intl.message(
      'Add new task',
      name: 'addNewTask',
      desc: '',
      args: [],
    );
  }

  String get createdTask {
    return Intl.message(
      'Task has been created successfully',
      name: 'createdTask',
      desc: '',
      args: [],
    );
  }

  String get emptyTitle {
    return Intl.message(
      'Title cannot be empty',
      name: 'emptyTitle',
      desc: '',
      args: [],
    );
  }

  String get taskToBeCompletedOn {
    return Intl.message(
      'Task to be completed on ',
      name: 'taskToBeCompletedOn',
      desc: '',
      args: [],
    );
  }

  String get taskCompleted {
    return Intl.message(
      'Task completed',
      name: 'taskCompleted',
      desc: '',
      args: [],
    );
  }

  String get noAdditionalNote {
    return Intl.message(
      'There is no additional note for this task',
      name: 'noAdditionalNote',
      desc: '',
      args: [],
    );
  }

  String get taskDeleted {
    return Intl.message(
      'Task has been deleted successfully',
      name: 'taskDeleted',
      desc: '',
      args: [],
    );
  }

  String get taskDeleteAlert {
    return Intl.message(
      'Are you sure you want to delete this task?',
      name: 'taskDeleteAlert',
      desc: '',
      args: [],
    );
  }

  String get yes {
    return Intl.message(
      'YES',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  String get no {
    return Intl.message(
      'NO',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  String get emptyCanteen {
    return Intl.message(
      'Canteen is closed today',
      name: 'emptyCanteen',
      desc: '',
      args: [],
    );
  }

  String get canteen {
    return Intl.message(
      'Canteen',
      name: 'canteen',
      desc: '',
      args: [],
    );
  }

  String get services {
    return Intl.message(
      'Services',
      name: 'services',
      desc: '',
      args: [],
    );
  }

  String get aboutApp {
    return Intl.message(
      'About app',
      name: 'aboutApp',
      desc: '',
      args: [],
    );
  }

  String get tryAgain {
    return Intl.message(
      'Try again',
      name: 'tryAgain',
      desc: '',
      args: [],
    );
  }

  String get checkConn {
    return Intl.message(
      'There is no internet connection. Please, check your connection and try again',
      name: 'checkConn',
      desc: '',
      args: [],
    );
  }

  String get communities {
    return Intl.message(
      'Communities',
      name: 'communities',
      desc: '',
      args: [],
    );
  }

  String get main {
    return Intl.message(
      'Important',
      name: 'main',
      desc: '',
      args: [],
    );
  }

  String get developers {
    return Intl.message(
      'Developers',
      name: 'developers',
      desc: '',
      args: [],
    );
  }

  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  String get price {
    return Intl.message(
      'Price',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  String get cart {
    return Intl.message(
      'Cart',
      name: 'cart',
      desc: '',
      args: [],
    );
  }

  String get quantity {
    return Intl.message(
      'Quantity',
      name: 'quantity',
      desc: '',
      args: [],
    );
  }

  String get total {
    return Intl.message(
      'Totoal',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  String get studentDisc {
    return Intl.message(
      'Student discount',
      name: 'studDiscount',
      desc: '',
      args: [],
    );
  }

  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  String get clear {
    return Intl.message(
      'Clear',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  String get portion {
    return Intl.message(
      'Portion',
      name: 'portion',
      desc: '',
      args: [],
    );
  }

  String get appVersion {
    return Intl.message(
      'App version',
      name: 'appVersion',
      desc: '',
      args: [],
    );
  }

  String get buildNum {
    return Intl.message(
      'Build number ',
      name: 'buildNum',
      desc: '',
      args: [],
    );
  }

  String get messageAboutApp {
    return Intl.message(
      'This application and all related services are completely free and Open Source products. We will be glad to hear your ideas and feedback, and we also welcome any of your participation in the project!',
      name: 'messageAboutApp',
      desc: '',
      args: [],
    );
  }

  String get developedBy {
    return Intl.message(
      'This app was developed by',
      name: 'developedBy',
      desc: '',
      args: [],
    );
  }

  String get vlad {
    return Intl.message(
      'Vladislav Ponomarenko',
      name: 'vlad',
      desc: '',
      args: [],
    );
  }

  String get and {
    return Intl.message(
      ' and ',
      name: 'and',
      desc: '',
      args: [],
    );
  }

  String get andron {
    return Intl.message(
      'Andrey Suslov',
      name: 'andron',
      desc: '',
      args: [],
    );
  }

  String get group {
    return Intl.message(
      'Group',
      name: 'group',
      desc: '',
      args: [],
    );
  }

  String get today {
    return Intl.message(
      'Today is',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  String get cacheDeleted {
    return Intl.message(
      'Cache has been deleted',
      name: 'cacheDeleted',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'be'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
