import 'package:flutter/material.dart';
import 'package:rick_and_morty_client/src/pages/character/character_page.dart';
import 'package:rick_and_morty_client/src/pages/episodes/episodes_page.dart';
import 'package:rick_and_morty_client/src/pages/home/home_page.dart';
import 'package:rick_and_morty_client/src/pages/navigation_history/navigation_history_page.dart';
import 'nav_bar.dart';
import 'nav_model.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final homeNavKey = GlobalKey<NavigatorState>();
  final episodesNavKey = GlobalKey<NavigatorState>();
  final charactersNavKey = GlobalKey<NavigatorState>();
  final historyNavKey = GlobalKey<NavigatorState>();
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
  int selectedTab = 0;
  List<NavModel> items = [];

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
        ),
        navKey: historyNavKey,
      ),
    ];
  }

  void navigateToTab(int index) {
    setState(() {
      selectedTab = index;
    });
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
    items[index].navKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => detailPage,
            settings: RouteSettings(arguments: arguments),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (items[selectedTab].navKey.currentState?.canPop() ?? false) {
          items[selectedTab].navKey.currentState?.pop();
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: selectedTab,
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
                setState(() {
                  selectedTab = index;
                });
              }
            },
          ),
        ),
      ),
    );
  }
}
