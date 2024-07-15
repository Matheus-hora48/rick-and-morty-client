import 'package:sqflite/sqflite.dart';

class DatabaseCacheHelper {
  static final DatabaseCacheHelper _instance = DatabaseCacheHelper._internal();
  static Database? _database;
  static const int _version = 1;
  static const String _tableName = 'cache';

  factory DatabaseCacheHelper() {
    return _instance;
  }

  DatabaseCacheHelper._internal();

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
        return db.execute(
          'CREATE TABLE $_tableName (url TEXT PRIMARY KEY, response TEXT, timestamp INTEGER)',
        );
      },
    );
  }

  Future<void> insertCache(String url, dynamic response) async {
    final db = await database;
    await db.insert(
      _tableName,
      {
        'url': url,
        'response': response.toString(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getCache(String url) async {
    final db = await database;
    final result = await db.query(
      _tableName,
      where: 'url = ?',
      whereArgs: [url],
    );
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  Future<void> clearOldCache(int cacheDuration) async {
    final db = await database;
    final expiryTime = DateTime.now().millisecondsSinceEpoch - cacheDuration;
    await db.delete(
      _tableName,
      where: 'timestamp < ?',
      whereArgs: [expiryTime],
    );
  }
}
