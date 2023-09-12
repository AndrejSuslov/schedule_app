// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(of) => "Schedule of ${of}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "auditories": MessageLookupByLibrary.simpleMessage("Audiences"),
        "changeGroup": MessageLookupByLibrary.simpleMessage("Change Group"),
        "clearCache": MessageLookupByLibrary.simpleMessage("Clear Cache"),
        "confirmButton": MessageLookupByLibrary.simpleMessage("Confirm"),
        "dark": MessageLookupByLibrary.simpleMessage("Dark"),
        "empty": MessageLookupByLibrary.simpleMessage("Nothing found"),
        "emptyLessons": MessageLookupByLibrary.simpleMessage(
            "There are no classes today, you can relax"),
        "home": MessageLookupByLibrary.simpleMessage("Home"),
        "inviteScreenTitle":
            MessageLookupByLibrary.simpleMessage("The schedule of "),
        "light": MessageLookupByLibrary.simpleMessage("Light"),
        "noTeachers": MessageLookupByLibrary.simpleMessage(
            "There is no list of teachers"),
        "schedule": MessageLookupByLibrary.simpleMessage("Schedule"),
        "scheduleOf": m0,
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "system": MessageLookupByLibrary.simpleMessage("System"),
        "teacher": MessageLookupByLibrary.simpleMessage("Teacher"),
        "teachers": MessageLookupByLibrary.simpleMessage("Teachers"),
        "theme": MessageLookupByLibrary.simpleMessage("Theme"),
        "welcomeText": MessageLookupByLibrary.simpleMessage(
            "Welcome\nEnter your group number")
      };
}
