import 'dart:convert';

import 'package:SimpleWindowCalculator/objects/OManager.dart';
import 'package:SimpleWindowCalculator/objects/Window.dart';
import 'package:path/path.dart' as paths;
import 'package:path_provider/path_provider.dart' as syspath;
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
    final directoryPath = await getDatabasesPath();
    String path = paths.join(directoryPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  _onCreate(Database db, int version) async {
    db.execute("CREATE TABLE $WINDOW_TABLE("
        "$WINDOW_NAME_ID TEXT PRIMARY KEY,"
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
  Future<List<Map>> queryWindow(String windowName) async {
    Database db = await database;

    List<Map> mapList = await db.query(
      WINDOW_TABLE,
      columns: [WINDOW_OBJECT],
      where: "$WINDOW_NAME_ID = ?",
      whereArgs: [windowName],
    );

    if (mapList.length > 0) {
      return mapList;
    } else
      return null;
  }

  Future<List<Window>> load(String subString) async {
    if (subString == null || subString.length <= 0) {
      return await loadAll();
    } else {
      Database db = await database;

      /// TODO: Will probably have to refine this, as its vulnerbal to sql injections
      List<Map> mapList = await db.rawQuery(
        "SELECT * FROM $WINDOW_TABLE WHERE $WINDOW_NAME_ID LIKE '%$subString%'",
      );

      if (mapList.length > 0) {
        List<Window> windowList = List();

        /// Get window from window json
        for (Map map in mapList) {
          windowList.add(Window.fromMap(jsonDecode(map[WINDOW_OBJECT])));
        }
        return windowList;
      } else {
        return List();
      }
    }
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

      print('PROCESS: Initialized database, basic list');

      for (Window window in OManager.presetWindows)
        batch.insert(WINDOW_TABLE, window.toMap());

      batch.commit();
      return OManager.presetWindows;
    }
  }
}
