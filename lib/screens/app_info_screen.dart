import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_project/blocs/settings_bloc/settings_bloc.dart';
import 'package:flutter_test_project/generated/l10n.dart';
import 'package:flutter_test_project/screens/contributor/contributors_view.dart';
import 'package:flutter_test_project/screens/schedule_screen.dart';
import 'package:flutter_test_project/widgets/icon_button.dart';
import 'package:flutter_test_project/widgets/typography.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle the back button press here
        pushToMainScreen(context);
        return false; // Return false to disable the default back button behavior
      },
      child: FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final versionName = snapshot.data?.version;
              final versionCode = snapshot.data?.buildNumber;
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    S.of(context).aboutApp,
                    style: Style.h6,
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      pushToMainScreen(context);
                    },
                  ),
                  // backgroundColor: AppTheme.colors.background01,
                ),
                // backgroundColor: AppTheme.colors.background01,
                body: SafeArea(
                  bottom: false,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Open Source', style: Style.h4),
                                  PopupMenuButton<String>(
                                    // color: AppTheme.colors.background03,
                                    onSelected: (value) {},
                                    itemBuilder: (BuildContext context) {
                                      return [
                                        PopupMenuItem(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${S.of(context).appVersion}:',
                                                style: Style.body,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "Beta",
                                                style: Style.bodyRegular,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuDivider(),
                                        PopupMenuItem(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${S.of(context).buildNum}:',
                                                style: Style.body,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                versionCode!,
                                                style: Style.bodyRegular,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ];
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8, top: 4, bottom: 4),
                                      decoration: const BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        // color: AppTheme.colors.primary,
                                      ),
                                      child: Text(
                                        "Beta",
                                        style: Style.buttonS,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                S.of(context).messageAboutApp,
                                style: Style.bodyRegular,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                S.of(context).developedBy,
                                style: Style.bodyRegular,
                              ),
                              Row(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: S.of(context).vlad,
                                      style: Style.bodyRegular
                                          .copyWith(color: Colors.blue),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          launchUrlString(
                                              "https://t.me/sheluvssic");
                                        },
                                    ),
                                  ),
                                  Text(S.of(context).and,
                                      style: Style.bodyRegular),
                                  RichText(
                                      text: TextSpan(
                                    text: S.of(context).andron,
                                    style: Style.bodyRegular
                                        .copyWith(color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        launchUrlString(
                                            "https://t.me/juuustyyy");
                                      },
                                  )),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                S.current.appIcon,
                                style: Style.bodyRegular,
                              ),
                              Row(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: S.of(context).tanya,
                                      style: Style.bodyRegular
                                          .copyWith(color: Colors.blue),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          launchUrlString(
                                              "https://www.instagram.com/tannussha_/");
                                        },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 40,
                                    width: 90,
                                    child: SocialIconButton(
                                      icon: Icon(
                                        UniconsLine.github,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                      onClick: () {
                                        launchUrlString(
                                          'https://github.com/AndrejSuslov/our_app_flutter',
                                          mode: LaunchMode.externalApplication,
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  SizedBox(
                                    height: 40,
                                    width: 90,
                                    child: SocialIconButton(
                                        icon: Icon(UniconsLine.telegram,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground),
                                        onClick: () {
                                          launchUrlString(
                                            'https://t.me/schedulepacby',
                                            mode:
                                                LaunchMode.externalApplication,
                                          );
                                        }),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child:
                              Text(S.of(context).developers, style: Style.h6),
                        ),
                        const SizedBox(height: 16),
                        ContributorsView(),
                        const SizedBox(height: 24),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
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
