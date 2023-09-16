import 'package:flutter/material.dart';
import 'package:flutter_test_project/themes/dark_theme/dark_theme.dart';
import 'package:flutter_test_project/themes/light_theme/light_theme.dart';
import 'package:flutter_test_project/widgets/calendar_widget.dart';
import 'generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const ScheduleApp());
}

class ScheduleApp extends StatelessWidget {
  const ScheduleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const HomeScreen(),
    );
  }
}

// Home Screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_work_outlined),
            label: S.of(context).home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person),
            label: S.of(context).teacher,
          ),
          NavigationDestination(
            icon: const Icon(Icons.meeting_room_rounded),
            label: S.of(context).auditories,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings),
            label: S.of(context).settings,
          )
        ],
      ),
      body: const CalendarWidget(),
    );
  }
}
