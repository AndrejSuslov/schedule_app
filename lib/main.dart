import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_project/themes/dark_theme/dark_theme.dart';
import 'package:flutter_test_project/themes/light_theme/light_theme.dart';
import 'package:flutter_test_project/widgets/bottom_navigation_bar.dart';
import 'blocs/settings_bloc/settings_bloc.dart';
import 'generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const ScheduleApp());
}

class ScheduleApp extends StatelessWidget {
  const ScheduleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildApplication(context);
  }

  Widget _buildApplication(BuildContext context) {
    return BlocProvider<SettingsBloc>(
      create: (context) => SettingsBloc(),
      child: BlocBuilder<SettingsBloc, SettingsState>(
        buildWhen: (prevState, newState) {
          return newState is! SettingsError;
        },
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SettingsLoaded) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              onGenerateTitle: (context) => S.of(context).schedule,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: state.settings.themeMode,
              supportedLocales: S.delegate.supportedLocales,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              home: Builder(
                builder: (context) {
                  //ИЗМЕНИТЬ НА ISNOTEMPTY КОГДА ДОБАВИМ ГРУППЫ!!!!!
                  if (state.settings.group.isEmpty) {
                    return const BottomNavBar();
                  }
                  return Text("error");
                },
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
