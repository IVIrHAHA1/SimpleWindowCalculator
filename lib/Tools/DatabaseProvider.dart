import 'dart:convert';

import 'package:SimpleWindowCalculator/objects/OManager.dart';
import 'package:SimpleWindowCalculator/objects/Window.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

/// Keys to be used with SQL database
// ignore: non_constant_identifier_names
String WINDOW_TABLE = "WindowTable";
// ignore: non_constant_identifier_names
String WINDOW_NAME_ID = "WindowName";
// ignore: non_constant_identifier_names
String WINDOW_OBJECT = "WindowObject";

class DatabaseProvider {
  static final _databaseName = "WindowCounterDB";
  static final _databaseVersion = 1;

  // Create a singleton of DatabaseProvider
  DatabaseProvider._();
  static final DatabaseProvider instance = DatabaseProvider._();

  // Create a single instance of database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String directoryPath = await getDatabasesPath();
    String path = join(directoryPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  _onCreate(Database db, int version) async {
    db.execute("CREATE TABLE $WINDOW_TABLE("
        "$WINDOW_NAME_ID INTEGER PRIMARY KEY,"
        "$WINDOW_OBJECT TEXT"
        ")");
  }

  Future<int> insert(Window window) async {
    Database db = await database;

    return await db.insert(
      WINDOW_TABLE,
      window.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Load a single Window
  Future<List<Map>> queryWindow(int windowHashCodeID) async {
    Database db = await database;

    List<Map> mapList = await db.query(
      WINDOW_TABLE,
      columns: [WINDOW_OBJECT],
      where: "$WINDOW_NAME_ID = ?",
      whereArgs: [windowHashCodeID],
    );

    if (mapList.length > 0) {
      return mapList;
    } else
      return null;
  }

  /// Load all Windows
  Future<List<Window>> loadAll() async {
    Database db = await database;

    List<Map> mapList = await db.rawQuery("SELECT * FROM $WINDOW_TABLE");

    if (mapList.length >= OManager.presetWindows.length) {
      List<Window> windowList = List();

      /// Get window from window json
      for (Map map in mapList) {
        windowList.add(Window.fromMap(jsonDecode(map[WINDOW_OBJECT])));
      }
      return windowList;
    }

    /// TODO: Look into saving this data upon start up
    // No data has been saved yet, (INSERT PRESET DATA)
    // Return preset windows
    else {
      Batch batch = db.batch();

      for (Window window in OManager.presetWindows)
        batch.insert(WINDOW_TABLE, window.toMap());

      batch.commit();
      return OManager.presetWindows;
    }
  }
}
