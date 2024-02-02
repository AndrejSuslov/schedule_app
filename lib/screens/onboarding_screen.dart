import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_project/blocs/settings_bloc/settings_bloc.dart';
import 'package:flutter_test_project/screens/schedule_screen.dart';
import 'package:flutter_test_project/widgets/indicator.dart';
import 'package:flutter_test_project/widgets/next_button.dart';
import 'package:flutter_test_project/widgets/typography.dart';
import 'package:provider/provider.dart';
import '../generated/l10n.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final int _numPages = 4;

  static const List<Image> containersImages = [
    Image(
      image: AssetImage('assets/images/max.png'),
      height: 375.0,
      width: 375.0,
    ),
    Image(
      image: AssetImage('assets/images/schedule.png'),
      height: 324.0,
      width: 328.0,
    ),
    Image(
      image: AssetImage('assets/images/computer-engineer.png'),
      height: 315.0,
      width: 315.0,
    ),
    Image(
      image: AssetImage('assets/images/geography.png'),
      height: 315.0,
      width: 315.0,
    ),
  ];

  static const List titlesTexts = [
    'Добро пожаловать!',
    'Смотри расписание!',
    'Будь в курсе в любой момент!',
    'Узнай как пользоваться!',
  ];

  static const List contentTexts = [
    'Это приложение было создано студентами для студентов',
    'В столовой ты или на парах - оказывается, расписание можно смотреть и без всяких файлов',
    'Иногда так лень открывать файл в Excel и искать нужную тебе информацию, мы это исправили',
    'Скачай готовый файл с расписанием у нас в телеграм-канале. Далее нажми на главном экране на плюс в правом нижнем углу, выставь свою группу и количество групп на потоке. Довольствуйся расписанием!'
  ];

  double getImageTopPadding(int page) {
    switch (page) {
      case 0:
        return 18.0;
      case 1:
        return 70.0;
      case 2:
        return 73.0;
      case 3:
        return 30.0;
      case 4:
        return 91.0;
      default:
        return 0.0;
    }
  }

  final PageController _pageController = PageController(initialPage: 0);

  int _currentPage = 0;

  List<Widget> _buildPageView() {
    return List.generate(_numPages, (index) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Stack(
          alignment: AlignmentDirectional.center,
          textDirection: TextDirection.ltr,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Padding(
                    padding: EdgeInsets.only(top: getImageTopPadding(index)),
                    child: containersImages[index]),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: MediaQuery.of(context).size.height * 0.48,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    titlesTexts[index],
                    style: Style.h4,
                  ),
                  const SizedBox(height: 8.0),
                  Text(contentTexts[index], style: Style.bodyL),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<_PageIndicatorsState> pageStateKey = GlobalKey();

    final Widget pageIndicator = PageIndicators(
      key: pageStateKey,
      onClick: () {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      },
      dotsNum: _numPages,
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: PageView(
                allowImplicitScrolling: true,
                physics: const ClampingScrollPhysics(),
                controller: _pageController,
                onPageChanged: (int page) {
                  _currentPage = page;
                  pageStateKey.currentState!.updateWith(_currentPage);
                },
                children: _buildPageView(),
              ),
            ),
            pageIndicator,
          ],
        ),
      ),
    );
  }
}

class PageIndicators extends StatefulWidget {
  const PageIndicators({
    Key? key,
    required this.onClick,
    required this.dotsNum,
  }) : super(key: key);

  final VoidCallback onClick;
  final int dotsNum;

  @override
  State<PageIndicators> createState() => _PageIndicatorsState();
}

class _PageIndicatorsState extends State<PageIndicators> {
  List<Widget> _buildPageIndicators(int currentPage) {
    List<Widget> list = [];
    for (int i = 0; i < widget.dotsNum; i++) {
      list.add(i == currentPage
          ? const IndicatorPageView(isActive: true)
          : const IndicatorPageView(isActive: false));
    }
    return list;
  }

  int _currentPage = 0;

  void updateWith(int value) {
    setState(() {
      _currentPage = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SettingsBloc>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0, left: 20.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.dotsNum - 1 == _currentPage
              ? Container()
              : TextButton(
                  onPressed: () {
                    bloc.add(ChangeSettings(bloc.settings.themeMode,
                        bloc.settings.group, bloc.settings.numOfGroups, false));
                    pushToMainScreen(context);
                  },
                  child: Text(
                    "Пропустить",
                    style: Style.buttonS.copyWith(),
                  ),
                ),
          Row(
            children: _buildPageIndicators(_currentPage),
          ),
          NextPageViewButton(
            isLastPage: widget.dotsNum - 1 == _currentPage,
            onClick: widget.onClick,
          ),
        ],
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
