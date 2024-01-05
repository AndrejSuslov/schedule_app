import 'package:flutter/material.dart';
import 'package:flutter_test_project/blocs/settings_bloc/settings_bloc.dart';
import 'package:flutter_test_project/screens/schedule_screen.dart';
import 'package:flutter_test_project/widgets/typography.dart';
import 'package:provider/src/provider.dart';

/// Get next button to open next page
/// or to close onboarding and start main app
class NextPageViewButton extends StatelessWidget {
  const NextPageViewButton(
      {Key? key, required this.isLastPage, required this.onClick})
      : super(key: key);

  final bool isLastPage;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SettingsBloc>();
    return ElevatedButton(
      onPressed: () {
        if (isLastPage) {
          pushToMainScreen(context);
          bloc.add(ChangeSettings(bloc.settings.themeMode, bloc.settings.group,
              bloc.settings.numOfGroups, false));
        } else {
          onClick();
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        // backgroundColor: AppTheme.colors.primary,
        shadowColor: const Color(0x7f000000),
        elevation: 8.0,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: isLastPage
            ? const EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0)
            : const EdgeInsets.symmetric(vertical: 12.0, horizontal: 5),
        child: isLastPage
            ? Text(
                "Начать!",
                style: AppTextStyle.buttonS.copyWith(
                    // color: AppTheme.colors.white,
                    ),
              )
            : const Icon(Icons.arrow_forward_ios),
      ),
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
}
