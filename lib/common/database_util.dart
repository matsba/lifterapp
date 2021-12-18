import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async' show Future;

class DatabaseUtil {
  late Database _db;

  Future<Database> get db async {
    await initDb();
    return _db;
  }

  Future<void> initDb() async {
    String path = await getDatabasesPath();
    Future<Database> connection = openDatabase(
      join(path, 'lifterapp.db'),
      onCreate: (database, version) async {
        await database.execute("""CREATE TABLE workouts(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            name TEXT, 
            reps INTEGER, 
            weigth REAL, 
            body_weigth INTEGER,
            timestamp TEXT, 
            year INTEGER, 
            month INTEGER, 
            day INTEGER)""");
      },
      version: 1,
    );
    _db = await connection;
  }
}
