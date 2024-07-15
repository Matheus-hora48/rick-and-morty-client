import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:rick_and_morty_client/src/pages/main/base_page.dart';

class MainRoute extends FlutterGetItPageRouter {
  const MainRoute({super.key});

  @override
  List<Bind<Object>> get bindings => [];

  @override
  String get routeName => '/';

  @override
  WidgetBuilder get view => (_) => const BasePage();
}
