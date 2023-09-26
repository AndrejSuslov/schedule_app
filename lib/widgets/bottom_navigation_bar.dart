import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_project/generated/l10n.dart';
import 'package:flutter_test_project/screens/schedule_screen.dart';

import '../blocs/settings_bloc/settings_bloc.dart';
import '../screens/settings_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final List<Widget> _screens = [];
  int _currentIndex = 0;

  @override
  void initState() {
    final bloc = context.read<SettingsBloc>();
    _screens.add(ScheduleScreen({'group': bloc.settings.group}));
    _screens.add(SettingsScreen(bloc));
    super.initState();
  }

  void _onDestinationSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
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
        onDestinationSelected: _onDestinationSelected,
        selectedIndex: _currentIndex,
      ),
    );
  }
}
