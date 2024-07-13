import 'package:flutter_getit/flutter_getit.dart';
import 'package:flutter/material.dart';
import 'package:rick_and_morty_client/src/pages/splash_page/splash_page.dart';

class SplashRoute extends FlutterGetItPageRouter {
  const SplashRoute({super.key});

  @override
  List<Bind<Object>> get bindings => [];

  @override
  String get routeName => '/';

  @override
  WidgetBuilder get view => (_) => const SplashPage();
}
