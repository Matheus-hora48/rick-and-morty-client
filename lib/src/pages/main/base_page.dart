import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:rick_and_morty_client/src/pages/character/character_page.dart';
import 'package:rick_and_morty_client/src/pages/episodes/episodes_page.dart';
import 'package:rick_and_morty_client/src/pages/home/home_page.dart';
import 'package:rick_and_morty_client/src/pages/main/base_controller.dart';
import 'package:rick_and_morty_client/src/pages/navigation_history/navigation_history_page.dart';
import 'nav/nav_bar.dart';
import 'nav/nav_model.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  final homeNavKey = GlobalKey<NavigatorState>();
  final episodesNavKey = GlobalKey<NavigatorState>();
  final charactersNavKey = GlobalKey<NavigatorState>();
  final historyNavKey = GlobalKey<NavigatorState>();
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
  final controller = Injector.get<BaseController>();
  int selectedTab = 0;
  List<NavModel> items = [];
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    items = [
      NavModel(
        page: const HomePage(),
        navKey: homeNavKey,
      ),
      NavModel(
        page: const EpisodesPage(),
        navKey: episodesNavKey,
      ),
      NavModel(
        page: const CharacterPage(),
        navKey: charactersNavKey,
      ),
      NavModel(
        page: NavigationHistoryPage(
          navigateToTab: navigateToTab,
          navigateToTabWithDetail: navigateToTabWithDetail,
          controller: controller,
        ),
        navKey: historyNavKey,
      ),
    ];
  }

  void navigateToTab(int index) {
    setState(() {
      selectedTab = index;
    });
    _pageController.jumpToPage(index);
    items[index].navKey.currentState?.popUntil((route) => route.isFirst);
  }

  void navigateToTabWithDetail(
    int index,
    Widget detailPage,
    dynamic arguments,
  ) {
    setState(() {
      selectedTab = index;
    });
    _pageController.jumpToPage(index);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => detailPage,
        settings: RouteSettings(arguments: arguments),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (items[selectedTab].navKey.currentState?.canPop() ?? false) {
          items[selectedTab].navKey.currentState?.pop();
        } else {
          didPop;
        }
      },
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: items
              .map((page) => Navigator(
                    key: page.navKey,
                    onGenerateInitialRoutes: (navigator, initialRoute) {
                      return [
                        MaterialPageRoute(builder: (context) => page.page)
                      ];
                    },
                  ))
              .toList(),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          child: NavBar(
            pageIndex: selectedTab,
            onTap: (index) {
              if (index == selectedTab) {
                items[index]
                    .navKey
                    .currentState
                    ?.popUntil((route) => route.isFirst);
              } else {
                navigateToTab(index);
              }

              if (index == 3) {
                controller.loadHistory();
              }
            },
          ),
        ),
      ),
    );
  }
}
