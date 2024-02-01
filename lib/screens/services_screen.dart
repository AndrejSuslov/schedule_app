import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_project/blocs/settings_bloc/settings_bloc.dart';
import 'package:flutter_test_project/generated/l10n.dart';
import 'package:flutter_test_project/screens/schedule_screen.dart';
import 'package:flutter_test_project/widgets/card.dart';
import 'package:flutter_test_project/widgets/comm_card.dart';
import 'package:flutter_test_project/widgets/icons.dart';
import 'package:flutter_test_project/widgets/typography.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        pushToMainScreen(context);
        return false;
      },
      child: Scaffold(
        // backgroundColor: AppTheme.colors.background01,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              pushToMainScreen(context);
            },
          ),
          // backgroundColor: AppTheme.colors.background01,
          elevation: 0,
          title: Text(
            S.of(context).services,
            style: Style.h6,
          ),
        ),
        body: const SafeArea(
          child: ServicesView(),
        ),
      ),
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
}

class ServicesView extends StatefulWidget {
  const ServicesView({super.key});

  @override
  State<ServicesView> createState() => _ServicesViewState();
}

class _ServicesViewState extends State<ServicesView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              S.of(context).main,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 152,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                ServiceCard(
                  serviceTitle: S.current.website,
                  serviceUrl: 'https://www.pac.by/',
                  serviceIcon: const ServiceIcon(
                    color: Color.fromARGB(255, 71, 132, 253),
                    iconColor: Color(0xFFFFFFFF),
                    icon: Icons.school,
                  ),
                  launchMode: LaunchMode.inAppBrowserView,
                  serviceDescription: S.current.websiteDesc,
                ),
                ServiceCard(
                  serviceTitle: 'Moodle',
                  serviceUrl: 'https://moodle.pac.by/moodle/',
                  serviceIcon: const ServiceIcon(
                    color: Color.fromARGB(255, 248, 156, 76),
                    iconColor: Color(0xFF181A20),
                    icon: UniconsLine.cloud_bookmark,
                  ),
                  launchMode: LaunchMode.externalApplication,
                  serviceDescription: S.current.moodleDesc,
                ),
                ServiceCard(
                  serviceTitle: 'ilex',
                  serviceUrl: 'https://ilex.by/',
                  serviceIcon: const ServiceIcon(
                    color: Color.fromARGB(255, 79, 211, 103),
                    iconColor: Color(0xFF181A20),
                    icon: Icons.menu_book,
                  ),
                  launchMode: LaunchMode.externalApplication,
                  serviceDescription: S.current.ilexDesc,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              S.of(context).communities,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: [
                CommunityCard(
                  title: S.current.aupprbChannel,
                  url: 'https://t.me/schedulepacby',
                  logo: CircleAvatar(
                    // backgroundColor: AppTheme.colors.colorful01,
                    foregroundImage: Image.network(
                      'https://www.pac.by/upload/iblock/d35/_-_.png',
                    ).image,
                  ),
                  launchMode: LaunchMode.externalApplication,
                  description: S.current.aupprbChannelDes,
                ),
                CommunityCard(
                  title: S.current.studSovet,
                  url: 'https://vk.com/st_au',
                  logo: CircleAvatar(
                    // backgroundColor: AppTheme.colors.colorful01,
                    foregroundImage: Image.network(
                      'https://sun9-49.userapi.com/impg/-W_reccl0idEA4wReDYLhhCbUY5Tby_JpoiKqA/3cZXJ8xDd5g.jpg?size=2048x2048&quality=96&sign=7ee1928a16f85dec22816aea158a67b9&type=album',
                    ).image,
                  ),
                  launchMode: LaunchMode.externalApplication,
                  description: S.current.studSovetDesc,
                ),
                CommunityCard(
                  title: S.current.profsouz,
                  url: 'https://vk.com/profsouz_au',
                  logo: CircleAvatar(
                    // backgroundColor: AppTheme.colors.colorful01,
                    foregroundImage: Image.network(
                      'https://sun9-72.userapi.com/impg/_iih_g7Sma7VvAklxm_8kP3ssniIhW-cBSJ85Q/O-sV8MAJVv8.jpg?size=1080x1080&quality=95&sign=e62a240d0744647729d5d73e01ed8156&type=album',
                    ).image,
                  ),
                  launchMode: LaunchMode.externalApplication,
                  description: S.current.profsouzDesc,
                ),
                CommunityCard(
                  title: S.current.brsm,
                  url: 'https://vk.com/brsmaupprb',
                  logo: CircleAvatar(
                    // backgroundColor: AppTheme.colors.colorful01,
                    foregroundImage: Image.network(
                      'https://sun9-80.userapi.com/impg/eFwYCzRIzRUEw8alD5FF6TK9HPb3WO6AQYS26w/IPoKJJY237E.jpg?size=640x640&quality=95&sign=5d0e491f2fc847147e20ff1e9daf45e0&type=album',
                    ).image,
                  ),
                  launchMode: LaunchMode.externalApplication,
                  description: S.current.brsmDesc,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
