import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseForTests {
  Future<Database> setup() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    var databasesPath = await getDatabasesPath();
    var pathToFile = "test/assets/lifterapp_test.db";

    var path = join(dirname(Platform.script.toFilePath()), pathToFile);

    return await databaseFactoryFfi.openDatabase(path);
  }

  Future<Database> setupEmptyMock() async {
    sqfliteFfiInit();
    return await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
  }

  DatabaseForTests();
}
