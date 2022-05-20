import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async' show Future;

class DatabaseClient {
  late Database _db;

  Future<Database> get db async {
    await initDb();
    return _db;
  }

  Future<void> _migrationsV1(database) async {
    await database.execute("""CREATE TABLE workouts(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            name TEXT, 
            reps INTEGER, 
            weigth REAL, 
            body_weigth INTEGER,
            timestamp TEXT, 
            year INTEGER, 
            month INTEGER, 
            day INTEGER);
            """);
  }

  Future<void> _migrationsV2(database) async {
    await database.execute("""            
            CREATE TABLE settings(
              using_resting_time INTEGER,
              resting_time_in_seconds INTEGER
            );
            """);
    await database.insert(
        "settings", {"using_resting_time": 1, "resting_time_in_seconds": 90});
  }

  Future<void> initDb() async {
    String path = await getDatabasesPath();
    Future<Database> connection = openDatabase(
      join(path, 'lifterapp.db'),
      onCreate: (database, version) async {
        print("Running $version version of database");
        await _migrationsV1(database);
        await _migrationsV2(database);
      },
      onUpgrade: (database, version, newVersion) async {
        print("Running $version version of database");
        print("Available upgrade to $newVersion version");
        if (version < newVersion && newVersion == 2) {
          await _migrationsV2(database);
          print("Upgraded to $newVersion version!");
        }
      },
      version: 2,
    );
    _db = await connection;
  }
}
