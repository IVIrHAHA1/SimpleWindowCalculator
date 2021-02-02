import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

/// Keys to be used with SQL database
String WINDOW_TABLE = "WindowTable";
String WINDOW_NAME = "WindowName";
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

  _onCreate(Database db, int version) async{
    db.execute("CREATE TABLE $WINDOW_TABLE("
    "$WINDOW_NAME TEXT PRIMARY KEY,"
    "$WINDOW_OBJECT TEXT"
    ")");
  }
}
