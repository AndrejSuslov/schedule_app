import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_project/screens/schedule_screen.dart';
import '../blocs/settings_bloc/settings_bloc.dart';
import '../generated/l10n.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsBloc bloc;

  const SettingsScreen(this.bloc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsBloc>(
      create: (_) => SettingsBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).settings),
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
                  _showSnackBar(context, state.message);
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
                      _buildGroupListTile(),
                      _buildNumsOfGroupListTile(),
                      _buildExcelPickerListTile(context),
                      _buildClearCacheListTile(context),
                    ],
                  ),
                ),
                const Spacer(), // Добавлен Spacer для создания пространства
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                      children: [
                        TextSpan(
                          text: "App was created by\n",
                        ),
                        TextSpan(
                          text: "Vladislav Ponomarenko & Andrey Suslov",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Widget _buildClearCacheListTile(BuildContext context) {
    return ListTile(
      title: Text(S.of(context).clearCache),
      onTap: () {
        bloc.add(const ClearCache());
      },
    );
  }

  Widget _buildExcelPickerListTile(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      bloc: bloc,
      builder: (context, state) {
        return ListTile(
          title: Text(
              'Выбрать файл (${bloc.settings.file})'), // тут надо чето придумать
          onTap: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['xlsx'],
            );
            PlatformFile file = result!.files.single;
            bloc.add(ChangeSettings(bloc.settings.themeMode,
                bloc.settings.group, bloc.settings.numOfGroups, file));
          },
        );
      },
    );
  }

  void pushToMainScreen(BuildContext context) {
    final bloc = context.read<SettingsBloc>();
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ScheduleScreen({'group': bloc.settings.group}),
      ),
    );
  }

  // Widget _buildGroupListTile(BuildContext context) {
  //   return ListTile(
  //     title: Text(S.of(context).changeGroup),
  //     onTap: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (_) => InviteScreen(bloc),
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildThemeListTile() {
    return BlocBuilder<SettingsBloc, SettingsState>(
      bloc: bloc,
      builder: (context, state) {
        return ListTile(
          title: Text(S.of(context).theme),
          trailing: DropdownButton<ThemeMode>(
            value: bloc.settings.themeMode,
            items: [
              DropdownMenuItem(
                value: ThemeMode.system,
                child: Text(S.of(context).system),
              ),
              DropdownMenuItem(
                value: ThemeMode.light,
                child: Text(S.of(context).light),
              ),
              DropdownMenuItem(
                value: ThemeMode.dark,
                child: Text(S.of(context).dark),
              ),
            ],
            onChanged: (themeMode) {
              if (themeMode != null) {
                bloc.add(ChangeSettings(themeMode, bloc.settings.group,
                    bloc.settings.numOfGroups, bloc.settings.file));
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildGroupListTile() {
    List<int> groups = [1, 2, 3, 4, 5];
    return BlocBuilder<SettingsBloc, SettingsState>(
      bloc: bloc,
      builder: (context, state) {
        return ListTile(
          title: const Text('Группа'),
          trailing: DropdownButton<String>(
            value: bloc.settings.group,
            items: [
              DropdownMenuItem(
                value: groups.elementAt(0).toString(),
                child: const Text('1'),
              ),
              DropdownMenuItem(
                value: groups.elementAt(1).toString(),
                child: const Text('2'),
              ),
              DropdownMenuItem(
                value: groups.elementAt(2).toString(),
                child: const Text('3'),
              ),
              DropdownMenuItem(
                value: groups.elementAt(3).toString(),
                child: const Text('4'),
              ),
              DropdownMenuItem(
                value: groups.elementAt(4).toString(),
                child: const Text('5'),
              ),
            ],
            onChanged: (group) {
              if (group != null) {
                bloc.add(ChangeSettings(bloc.settings.themeMode, group,
                    bloc.settings.numOfGroups, bloc.settings.file));
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildNumsOfGroupListTile() {
    List<int> groups = [2, 3, 4, 5];
    return BlocBuilder<SettingsBloc, SettingsState>(
      bloc: bloc,
      builder: (context, state) {
        return ListTile(
          title: const Text('Кол-во групп на потоке'),
          trailing: DropdownButton<String>(
            value: bloc.settings.numOfGroups,
            items: [
              DropdownMenuItem(
                value: groups.elementAt(0).toString(),
                child: const Text('2'),
              ),
              DropdownMenuItem(
                value: groups.elementAt(1).toString(),
                child: const Text('3'),
              ),
              DropdownMenuItem(
                value: groups.elementAt(2).toString(),
                child: const Text('4'),
              ),
              DropdownMenuItem(
                value: groups.elementAt(3).toString(),
                child: const Text('5'),
              ),
            ],
            onChanged: (numOfGroups) {
              if (numOfGroups != null) {
                bloc.add(ChangeSettings(bloc.settings.themeMode,
                    bloc.settings.group, numOfGroups, bloc.settings.file));
              }
            },
          ),
        );
      },
    );
  }
}
