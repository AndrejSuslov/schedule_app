import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildThemeListTile(),
                  // _buildGroupListTile(context),
                  _buildClearCacheListTile(context),
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
                bloc.add(ChangeSettings(themeMode, bloc.settings.group));
              }
            },
          ),
        );
      },
    );
  }
}
