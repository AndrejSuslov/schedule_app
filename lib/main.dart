import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test_project/blocs/schedule_bloc/schedule_bloc.dart';
import 'package:flutter_test_project/screens/onboarding_screen.dart';
import 'package:flutter_test_project/screens/schedule_screen.dart';
import 'package:flutter_test_project/themes/dark_theme/dark_theme.dart';
import 'package:flutter_test_project/themes/light_theme/light_theme.dart';
import 'blocs/settings_bloc/settings_bloc.dart';
import 'generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  runApp(const ProviderScope(child: ScheduleApp()));

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarIconBrightness: Brightness.light, //n
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent, //
      systemNavigationBarContrastEnforced: false // navigation bar icons color
      ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top]);
}

class ScheduleApp extends StatelessWidget {
  const ScheduleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildApplication(context);
  }

  Widget _buildApplication(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsBloc>(
          create: (context) => SettingsBloc(),
        ),
        BlocProvider<ScheduleBloc>(
          create: (context) => ScheduleBloc(),
        )
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        buildWhen: (prevState, newState) {
          return newState is! SettingsError;
        },
        builder: (context, state) {
          final bloc = context.read<SettingsBloc>();
          if (state is SettingsLoading) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.amber,
            ));
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
                  if (state.settings.group.isNotEmpty &&
                      state.settings.isFirstLaunch == false) {
                    return ScheduleScreen({'group': bloc.settings.group});
                  }

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const OnBoardingPage(),
                      ),
                    );
                  });

                  return const SizedBox.shrink();
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
