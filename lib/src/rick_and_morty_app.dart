import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

class RickAndMortyApp extends StatelessWidget {
  const RickAndMortyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterGetIt(
      pages: const [],
      builder: (context, routes, flutterGetItNavObserver) {
        return AsyncStateBuilder(
          builder: (navigatorObserver) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Rick and Morty Client',
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
