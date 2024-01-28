import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_project/blocs/settings_bloc/settings_bloc.dart';
import 'package:flutter_test_project/screens/schedule_screen.dart';
import 'package:flutter_test_project/widgets/card.dart';
import 'package:flutter_test_project/widgets/comm_card.dart';
import 'package:flutter_test_project/widgets/icons.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: const Text(
          "Сервисы",
        ),
      ),
      body: const SafeArea(
        child: ServicesView(),
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Основные",
              style: TextStyle(
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
              children: const [
                ServiceCard(
                  serviceTitle: 'Сайт АУпПРБ',
                  serviceUrl: 'https://www.pac.by/',
                  serviceIcon: ServiceIcon(
                    color: Color.fromARGB(255, 71, 132, 253),
                    iconColor: Color(0xFFFFFFFF),
                    icon: Icons.school,
                  ),
                  launchMode: LaunchMode.inAppBrowserView,
                  serviceDescription: 'Найди нужную информацию',
                ),
                ServiceCard(
                  serviceTitle: 'Moodle',
                  serviceUrl: 'https://moodle.pac.by/moodle/',
                  serviceIcon: ServiceIcon(
                    color: Color.fromARGB(255, 248, 156, 76),
                    iconColor: Color(0xFF181A20),
                    icon: UniconsLine.cloud_bookmark,
                  ),
                  launchMode: LaunchMode.externalApplication,
                  serviceDescription: 'Узнай свои задания',
                ),
                ServiceCard(
                  serviceTitle: 'ilex',
                  serviceUrl: 'https://ilex.by/',
                  serviceIcon: ServiceIcon(
                    color: Color.fromARGB(255, 79, 211, 103),
                    iconColor: Color(0xFF181A20),
                    icon: Icons.menu_book,
                  ),
                  launchMode: LaunchMode.externalApplication,
                  serviceDescription: 'Будь в курсе новых законов',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Сообщества",
              style: TextStyle(
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
                  title: 'Расписание АУпПРБ',
                  url: 'https://t.me/schedulepacby',
                  logo: CircleAvatar(
                    // backgroundColor: AppTheme.colors.colorful01,
                    foregroundImage: Image.network(
                      'https://www.pac.by/upload/iblock/d35/_-_.png',
                    ).image,
                  ),
                  launchMode: LaunchMode.externalApplication,
                  description:
                      'Телеграм канал с публикациями готовых файлов Excel для отображения в приложении',
                ),
                CommunityCard(
                  title: 'Студенческий совет АУпПРБ',
                  url: 'https://vk.com/st_au',
                  logo: CircleAvatar(
                    // backgroundColor: AppTheme.colors.colorful01,
                    foregroundImage: Image.network(
                      'https://sun9-49.userapi.com/impg/-W_reccl0idEA4wReDYLhhCbUY5Tby_JpoiKqA/3cZXJ8xDd5g.jpg?size=2048x2048&quality=96&sign=7ee1928a16f85dec22816aea158a67b9&type=album',
                    ).image,
                  ),
                  launchMode: LaunchMode.externalApplication,
                  description: 'Официальная группа Студенческого совета АУпПРБ',
                ),
                CommunityCard(
                  title: 'Профсоюз студентов АУпПРБ',
                  url: 'https://vk.com/profsouz_au',
                  logo: CircleAvatar(
                    // backgroundColor: AppTheme.colors.colorful01,
                    foregroundImage: Image.network(
                      'https://sun9-72.userapi.com/impg/_iih_g7Sma7VvAklxm_8kP3ssniIhW-cBSJ85Q/O-sV8MAJVv8.jpg?size=1080x1080&quality=95&sign=e62a240d0744647729d5d73e01ed8156&type=album',
                    ).image,
                  ),
                  launchMode: LaunchMode.externalApplication,
                  description:
                      'Первичная профсоюзная организация студентов Академии управления',
                ),
                CommunityCard(
                  title: 'БРСМ Академии управления',
                  url: 'https://vk.com/brsmaupprb',
                  logo: CircleAvatar(
                    // backgroundColor: AppTheme.colors.colorful01,
                    foregroundImage: Image.network(
                      'https://sun9-80.userapi.com/impg/eFwYCzRIzRUEw8alD5FF6TK9HPb3WO6AQYS26w/IPoKJJY237E.jpg?size=640x640&quality=95&sign=5d0e491f2fc847147e20ff1e9daf45e0&type=album',
                    ).image,
                  ),
                  launchMode: LaunchMode.externalApplication,
                  description:
                      'Первичная организация Общественного объединения "Белорусский республиканский союз молодёжи"',
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
