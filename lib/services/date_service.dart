import 'dart:core';

class DateService {
  // static String? getWeekDayFromLang(String lang) {
  //   try {
  //     DateTime now = DateTime.now();

  //     switch (now.weekday) {
  //       case 1:
  //         return monday[lang];
  //       case 2:
  //         return tuesday[lang];
  //       case 3:
  //         return wednesday[lang];
  //       case 4:
  //         return thursday[lang];
  //       case 5:
  //         return friday[lang];
  //       case 6:
  //         return saturday[lang];
  //       case 7:
  //         return sunday[lang];
  //       default:
  //         return "Monday";
  //     }
  //   } catch (e) {
  //     return "Monday";
  //   }
  // }

  // static String? getWeekDayFromNum(int num, String lang) {
  //   if (num == DateTime.now().weekday) {
  //     return today[lang];
  //   }

  //   if (num == DateTime.now().weekday + 1) {
  //     return tomorrow[lang];
  //   }

  //   switch (num) {
  //     case 1:
  //       return monday[lang];
  //     case 2:
  //       return tuesday[lang];
  //     case 3:
  //       return wednesday[lang];
  //     case 4:
  //       return thursday[lang];
  //     case 5:
  //       return friday[lang];
  //     case 6:
  //       return saturday[lang];
  //     case 7:
  //       return sunday[lang];
  //     default:
  //       return "Monday";
  //   }
  // }

  // static String? getWeekDayName(int num, String lang) {
  //   switch (num) {
  //     case 1:
  //       return monday[lang];
  //     case 2:
  //       return tuesday[lang];
  //     case 3:
  //       return wednesday[lang];
  //     case 4:
  //       return thursday[lang];
  //     case 5:
  //       return friday[lang];
  //     case 6:
  //       return saturday[lang];
  //     case 7:
  //       return sunday[lang];
  //     default:
  //       return "Monday";
  //   }
  // }

  // static String? getMonthFromNum(int num, String lang) {
  //   switch (num) {
  //     case 1:
  //       return january[lang];
  //     case 2:
  //       return february[lang];
  //     case 3:
  //       return march[lang];
  //     case 4:
  //       return april[lang];
  //     case 5:
  //       return may[lang];
  //     case 6:
  //       return june[lang];
  //     case 7:
  //       return july[lang];
  //     case 8:
  //       return august[lang];
  //     case 9:
  //       return september[lang];
  //     case 10:
  //       return october[lang];
  //     case 11:
  //       return november[lang];
  //     case 12:
  //       return december[lang];
  //     default:
  //       return january[lang];
  //   }
  // }

  static bool equalDates(DateTime dt1, DateTime dt2) {
    if (dt1.month == dt2.month && dt1.weekday == dt2.weekday) return true;
    return false;
  }

  static String encodeDate(DateTime date) {
    return "${date.day}:${date.month}:${date.year}";
  }

  static DateTime decodeDate(String date) {
    List<String> split = date.split(":");
    return DateTime(int.parse(split[2].replaceAll(")", "")),
        int.parse(split[1]), int.parse(split[0]));
  }
}
