import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rick_and_morty_client/src/rick_and_morty_app.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(const RickAndMortyApp());
  }, (error, stack) {
    log('Erro não tratado', error: error, stackTrace: stack);
    throw error;
  });
}
