import 'dart:convert';

import '../objects/Window.dart';
import 'package:path/path.dart' as paths;
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

  delete(Window window) async {
    Database db = await database;
    String name = window.getName();

    int id = await db.delete(
      WINDOW_TABLE,
      where: "$WINDOW_NAME_ID = ?",
      whereArgs: [name.toLowerCase()],
    );

    return id;
  }

  Future<int> replace(Window oldWindow, Window newWindow) async {
    String name = oldWindow.getName();
    Database db = await database;

    int val = await db.update(
      WINDOW_TABLE,
      newWindow.toMap(),
      where: "$WINDOW_NAME_ID = ?",
      whereArgs: [name.toLowerCase()],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return val;
  }

  /// Load a single Window
  Future<Window> queryWindow(String windowName) async {
    Database db = await database;

    List<Map> mapList = await db.query(
      WINDOW_TABLE,
      columns: [WINDOW_OBJECT],
      where: "$WINDOW_NAME_ID = ?",
      whereArgs: [windowName.toLowerCase()],
    );

    if (mapList.length > 0) {
      return Window.fromMap(jsonDecode(mapList.single[WINDOW_OBJECT]));
    } else
      return null;
  }

  Future<bool> contains(String windowName) async {
    Database db = await database;

    List<Map> mapList = await db.query(
      WINDOW_TABLE,
      columns: [WINDOW_OBJECT],
      where: "$WINDOW_NAME_ID = ?",
      whereArgs: [windowName.toLowerCase()],
    );

    if (mapList.length > 0) {
      return true;
    } else
      return false;
  }

  Future<List<Window>> querySearch(String subString) async {
    if (subString == null || subString.length <= 0) {
      return await loadAll();
    } else {
      Database db = await database;

      List<Map> mapList = await db.rawQuery(
        "SELECT * FROM $WINDOW_TABLE WHERE $WINDOW_NAME_ID LIKE '%$subString%'",
      );

      if (mapList.length > 0) {
        List<Window> windowList = List.empty(growable:true);

        /// Get window from window json
        for (Map map in mapList) {
          windowList.add(Window.fromMap(jsonDecode(map[WINDOW_OBJECT])));
        }
        return windowList;
      } else {
        return List.empty(growable: true);
      }
    }
  }

  /// Load all Windows
  Future<List<Window>> loadAll() async {
    Database db = await database;

    List<Map> mapList = await db.rawQuery("SELECT * FROM $WINDOW_TABLE");

    if (mapList.length >= 1) {
      List<Window> windowList = List.empty(growable: true);

      /// Get window from window json
      for (Map map in mapList) {
        windowList.add(Window.fromMap(jsonDecode(map[WINDOW_OBJECT])));
      }
      return windowList;
    }
    // No objects to load, so return empty list.
    return List<Window>.empty(growable: true);
  }

  Future<int> entryLength() async {
    Database db = await database;

    var result = await db.rawQuery("SELECT COUNT(*) FROM $WINDOW_TABLE");

    int count = Sqflite.firstIntValue(result);
    return count;
  }

  // No data has been saved yet, (INSERT PRESET DATA)
  // Return preset windows
  // else {
  //   Batch batch = db.batch();

  //   print('PROCESS: Initialized database, basic list');

  //   for (Window window in OManager.presetWindows)
  //     batch.insert(WINDOW_TABLE, window.toMap());

  //   batch.commit();
  //   return OManager.presetWindows;
  Future<bool> isInitialized() async {
    final directoryPath = await getDatabasesPath();
    String path = paths.join(directoryPath, _databaseName);

    bool exists = await databaseExists(path);

    return exists;
  }

  fillDatabase(List<Window> list) async {
    Database db = await database;

    Batch batch = db.batch();

    for (Window window in list) batch.insert(WINDOW_TABLE, window.toMap());

    batch.commit();
    print('DB-PROCESS: Database initialized default values');
    return;
  }
}
