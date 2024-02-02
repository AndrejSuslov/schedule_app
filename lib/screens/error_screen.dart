import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_project/generated/l10n.dart';
import 'package:flutter_test_project/screens/schedule_screen.dart';
import 'package:flutter_test_project/widgets/typography.dart';
import 'package:rive/rive.dart';

import '../blocs/settings_bloc/settings_bloc.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle the back button press here
        pushToMainScreen(context);
        return false; // Return false to disable the default back button behavior
      },
      child: Scaffold(
        appBar: AppBar(
          // title: Text(
          //     // style: Style.h6,
          //     ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              pushToMainScreen(context);
            },
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background
            Container(
              decoration: const BoxDecoration(),
            ),
            // Error Widget
            Center(
              child: _buildErrorWidget(
                context,
                S.of(context).checkConn,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width * 0.7,
          child: const RiveAnimation.asset(
            'assets/anims/error.riv',
          ),
        ),
        const SizedBox(height: 20),
        Text(
          message,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () {
            pushToCanteenScreenWithLoading(context);
          },
          child: Text(S.of(context).tryAgain),
        ),
      ],
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
