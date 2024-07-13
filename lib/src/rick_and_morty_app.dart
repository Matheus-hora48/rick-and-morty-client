import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:rick_and_morty_client/src/binding/rick_and_morty_binding.dart';
import 'package:rick_and_morty_client/src/core/ui/theme/rick_and_morty_theme.dart';
import 'package:rick_and_morty_client/src/pages/main/main_page.dart';
import 'package:rick_and_morty_client/src/pages/splash_page/splash_page.dart';

class RickAndMortyApp extends StatelessWidget {
  const RickAndMortyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterGetIt(
      bindings: RickAndMortyBinding(),
      pages: [
        FlutterGetItPageBuilder(
          page: (_) => const SplashPage(),
          path: '/',
        ),
        FlutterGetItPageBuilder(
          page: (_) => const MainScreen(),
          path: '/home',
        ),
      ],
      builder: (context, routes, flutterGetItNavObserver) {
        return AsyncStateBuilder(
          builder: (navigatorObserver) {
            return MaterialApp(
              theme: RickAndMortyTheme.lightTheme,
              debugShowCheckedModeBanner: false,
              title: 'Rick and Morty Client',
              initialRoute: '/',
              routes: routes,
              navigatorObservers: [
                flutterGetItNavObserver,
                navigatorObserver,
              ],
            );
          },
        );
      },
    );
  }
}
