import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_project/screens/schedule_screen.dart';
import 'package:flutter_test_project/widgets/typography.dart';
import '../blocs/settings_bloc/settings_bloc.dart';
import '../generated/l10n.dart';
import '../services/app_alerts.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsBloc bloc;

  const SettingsScreen(this.bloc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        pushToMainScreen(context);
        return false;
      },
      child: BlocProvider<SettingsBloc>(
        create: (_) => SettingsBloc(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              S.of(context).settings,
              style: Style.h6,
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                pushToMainScreen(context);
              },
            ),
          ),
          body: MultiBlocListener(
            listeners: [
              BlocListener<SettingsBloc, SettingsState>(
                listener: (context, state) {
                  if (state is CachedDataDeleted) {
                    AppAlerts.displaySnackbar(context, state.message);
                  }
                },
              ),
            ],
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildThemeListTile(),
                        // _buildGroupListTile(),
                        // _buildNumsOfGroupListTile(),
                        _buildClearCacheListTile(context),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        children: [
                          TextSpan(
                              text: "UIR-2022",
                              style: Style.bodyRegular.copyWith(fontSize: 14)),
                          // TextSpan(
                          //   text: "UIR-2022",
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Style.captionL,
        ),
      ),
    );
  }

  Widget _buildClearCacheListTile(BuildContext context) {
    return ListTile(
      title: Text(S.of(context).clearCache,
          style: Style.bodyL.copyWith(fontSize: 16)),
      onTap: () {
        bloc.add(const FullClearCache());
        _showSnackBar(context, S.of(context).cacheDeleted);
      },
    );
  }

  void pushToMainScreen(BuildContext context) {
    final bloc = context.read<SettingsBloc>();
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ScheduleScreen({S.of(context).group: bloc.settings.group}),
      ),
    );
  }

  Widget _buildThemeListTile() {
    return BlocBuilder<SettingsBloc, SettingsState>(
      bloc: bloc,
      builder: (context, state) {
        return ListTile(
          title: Text(
            S.of(context).theme,
            style: Style.bodyL.copyWith(fontSize: 16),
          ),
          trailing: DropdownButton<ThemeMode>(
            value: bloc.settings.themeMode,
            items: [
              DropdownMenuItem(
                value: ThemeMode.system,
                child: Text(S.of(context).system,
                    style: Style.bodyL.copyWith(fontSize: 16)),
              ),
              DropdownMenuItem(
                value: ThemeMode.light,
                child: Text(S.of(context).light,
                    style: Style.bodyL.copyWith(fontSize: 16)),
              ),
              DropdownMenuItem(
                value: ThemeMode.dark,
                child: Text(S.of(context).dark,
                    style: Style.bodyL.copyWith(fontSize: 16)),
              ),
            ],
            onChanged: (themeMode) {
              if (themeMode != null) {
                bloc.add(ChangeSettings(themeMode, bloc.settings.group,
                    bloc.settings.numOfGroups, bloc.settings.isFirstLaunch));
              }
            },
          ),
        );
      },
    );
  }

  // Widget _buildGroupListTile() {
  //   List<int> groups = [1, 2, 3, 4, 5];
  //   return BlocBuilder<SettingsBloc, SettingsState>(
  //     bloc: bloc,
  //     builder: (context, state) {
  //       return ListTile(
  //         title: const Text('Группа'),
  //         trailing: DropdownButton<String>(
  //           value: bloc.settings.group,
  //           items: [
  //             DropdownMenuItem(
  //               value: groups.elementAt(0).toString(),
  //               child: const Text('1'),
  //             ),
  //             DropdownMenuItem(
  //               value: groups.elementAt(1).toString(),
  //               child: const Text('2'),
  //             ),
  //             DropdownMenuItem(
  //               value: groups.elementAt(2).toString(),
  //               child: const Text('3'),
  //             ),
  //             DropdownMenuItem(
  //               value: groups.elementAt(3).toString(),
  //               child: const Text('4'),
  //             ),
  //             DropdownMenuItem(
  //               value: groups.elementAt(4).toString(),
  //               child: const Text('5'),
  //             ),
  //           ],
  //           onChanged: (group) {
  //             if (group != null) {
  //               bloc.add(ChangeSettings(bloc.settings.themeMode, group,
  //                   bloc.settings.numOfGroups, bloc.settings.isFirstLaunch));
  //             }
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget _buildNumsOfGroupListTile() {
  //   List<int> groups = [2, 3, 4, 5];
  //   return BlocBuilder<SettingsBloc, SettingsState>(
  //     bloc: bloc,
  //     builder: (context, state) {
  //       return ListTile(
  //         title: const Text('Кол-во групп на потоке'),
  //         trailing: DropdownButton<String>(
  //           value: bloc.settings.numOfGroups,
  //           items: [
  //             DropdownMenuItem(
  //               value: groups.elementAt(0).toString(),
  //               child: const Text('2'),
  //             ),
  //             DropdownMenuItem(
  //               value: groups.elementAt(1).toString(),
  //               child: const Text('3'),
  //             ),
  //             DropdownMenuItem(
  //               value: groups.elementAt(2).toString(),
  //               child: const Text('4'),
  //             ),
  //             DropdownMenuItem(
  //               value: groups.elementAt(3).toString(),
  //               child: const Text('5'),
  //             ),
  //           ],
  //           onChanged: (numOfGroups) {
  //             if (numOfGroups != null) {
  //               bloc.add(ChangeSettings(
  //                   bloc.settings.themeMode,
  //                   bloc.settings.group,
  //                   numOfGroups,
  //                   bloc.settings.isFirstLaunch));
  //             }
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }
}
