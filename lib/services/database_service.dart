import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async' show Future;
import 'package:flutter/foundation.dart';

class DatabaseService {
  late Database _db;

  static const List<String> _databaseTableNames = [
    "android_metadata",
    "exercise",
    "session",
    "sets",
    "settings",
    "training",
    "workouts",
    "workout"
  ];

  Future<Database> get db async {
    await initDb();
    return _db;
  }

  Future<DatabaseService> createFromFile(Uint8List database) async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'lifterapp.db');
    await _overwriteDatabaseInPath(database, path);
    var service = DatabaseService();
    service._db = await openDatabase(path);
    return service;
  }

  Future<void> _overwriteDatabaseInPath(Uint8List database, String path) async {
    debugPrint("Overwriting database in $path");

    final isValidDatabase = await _isValidDatabase(database);
    if (!isValidDatabase) {
      debugPrint("Error in overwriting database: Not a valid database!");
      throw Exception("Not a valid database!");
    }

    debugPrint("Overwriting database: Deleting current database");
    await deleteDatabase(path);

    List<int> bytes = database.buffer
        .asUint8List(database.offsetInBytes, database.lengthInBytes);

    debugPrint("Overwriting database: Loading database...");
    await File(path).writeAsBytes(bytes, flush: true);
  }

  Future<bool> _isValidDatabase(Uint8List database) async {
    debugPrint("Validating database...");
    late Database databaseToValidate;
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'validate_database.db');

    debugPrint("Validate database: loading file");
    final List<int> bytes = database.buffer
        .asUint8List(database.offsetInBytes, database.lengthInBytes);
    await File(path).writeAsBytes(bytes, flush: true);

    try {
      debugPrint("Validate database: opening database for validation");
      databaseToValidate = await openReadOnlyDatabase(path);
    } catch (e) {
      debugPrint("Validate database: Failed to open the database");
      debugPrint(e.toString());
      return false;
    }

    debugPrint("Validate database: getting table names for validation");
    final tables = await _describeDatabase(databaseToValidate);
    final tableNamesToCheck = [..._databaseTableNames, "sqlite_sequence"];
    final tableNamesInDatabase = tables
        .where((element) => element["type"] == "table")
        .map((e) => e["tbl_name"])
        .toList();

    debugPrint("Validate database: Tables in database $tableNamesInDatabase");

    try {
      debugPrint("Validate database: closing validation database in $path");
      await databaseToValidate.close();
      debugPrint("Validate database: deleting database in $path");
      await deleteDatabase(path);
    } catch (e) {
      debugPrint("Validate database: Failed to close database");
      debugPrint(e.toString());
    }

    debugPrint("Validate database: validating names");
    final isValid =
        tableNamesToCheck.every((e) => tableNamesInDatabase.contains(e));

    debugPrint("Validate database: result is $isValid");
    return isValid;
  }

/*   Future<void> migrationsV1(database) async {
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

  Future<void> migrationsV2(database) async {
    await database.execute("""            
            CREATE TABLE settings(
              using_resting_time INTEGER,
              resting_time_in_seconds INTEGER
            );
            """);
    await database.insert(
        "settings", {"using_resting_time": 1, "resting_time_in_seconds": 90});
  } */

  Future<void> createNewDatabase(database) async {
    await database.execute("""
          CREATE TABLE training (
                id INTEGER PRIMARY KEY AUTOINCREMENT
            );


            CREATE TABLE session (
                id             INTEGER PRIMARY KEY AUTOINCREMENT,
                timestamp      TEXT    NOT NULL,
                fk_training_id INTEGER REFERENCES training (id) 
            );

            CREATE TABLE exercise (
                id                     INTEGER PRIMARY KEY AUTOINCREMENT,
                name                   TEXT,
                restingTimeBetweenSets INTEGER
            );


            CREATE TABLE workout (
                id             INTEGER PRIMARY KEY AUTOINCREMENT,
                fk_exercise_id INTEGER REFERENCES exercise (id),
                fk_session_id  INTEGER REFERENCES session (id) 
            );

            CREATE TABLE sets (
                id            INTEGER     PRIMARY KEY AUTOINCREMENT,
                reps          INTEGER,
                weigth        REAL,
                timestamp     TEXT,
                body_weigth   INTEGER (1) DEFAULT (0),
                fk_workout_id INTEGER     REFERENCES workout (id) 
            );

            """);
  }

  Future<List<Map<String, Object?>>> _describeDatabase(
      Database database) async {
    return await database.query("sqlite_master");
  }

  Future<void> initDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'lifterapp.db');

    if (kDebugMode) {
      debugPrint("In debug mode...");

      if (!await databaseExists(path)) {
        debugPrint("Overwriting existing database...");
        try {
          await Directory(dirname(path)).create(recursive: true);
        } catch (e) {
          debugPrint("Parent dir doesn't existis! Error: $e");
        }

        ByteData data =
            await rootBundle.load(join("assets", "debug", "lifterapp.db"));
        Uint8List bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

        try {
          await _overwriteDatabaseInPath(bytes, path);
        } catch (e) {
          debugPrint("Could not overwrite the database! Error: $e");
        }
      }

      debugPrint("Opening database...");
      _db = await openDatabase(path);
      debugPrint("Opened database!");
    } else {
      Future<Database> connection = openDatabase(
        path,
        onCreate: (database, version) async {
          print("Running $version version of database");
          await createNewDatabase(database);
        },
        onUpgrade: (database, version, newVersion) async {
          if (newVersion == 3) {
            await createNewDatabase(database);
          }
        },
        version: 3,
      );

      _db = await connection;
    }
  }
}
