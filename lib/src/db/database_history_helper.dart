import 'dart:convert';

import 'package:rick_and_morty_client/src/model/navigation_history.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHistoryHelper {
  static final DatabaseHistoryHelper _instance =
      DatabaseHistoryHelper._internal();
  static Database? _database;
  static const int _version = 1;
  static const String _tableName = 'navigationHistory';

  factory DatabaseHistoryHelper() {
    return _instance;
  }

  DatabaseHistoryHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = '${await getDatabasesPath()}$_tableName.db';

    return await openDatabase(
      path,
      version: _version,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            screenName TEXT,
            route TEXT,
            arguments TEXT,
            title TEXT,
            dateTime TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertHistory(NavigationHistoryItem history) async {
    final db = await database;
    await db.insert(_tableName, {
      'screenName': history.screenName,
      'route': history.route,
      'arguments': jsonEncode(history.arguments),
      'title': history.title,
      'dateTime': history.dateTime,
    });
  }

  Future<List<NavigationHistoryItem>> getHistory() async {
    final db = await database;
    final result = await db.query(_tableName, orderBy: 'id DESC');

    return result.map((map) {
      return NavigationHistoryItem(
        screenName: map['screenName'] as String,
        route: map['route'] as String,
        arguments: map['arguments'],
        title: map['title'] as String,
        dateTime: map['dateTime'] as String,
      );
    }).toList();
  }

  Future<void> clearHistory() async {
    final db = await database;
    await db.delete(_tableName);
  }
}
