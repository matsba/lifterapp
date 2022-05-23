import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lifterapp/services/service_locator.dart';
import 'package:lifterapp/services/workout_repository.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future main() async {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    print("Testing Workout Repository");
  });

  setUp(() async {
    //Use sql file to initate database for tests
    var pathToFile = "test/assets/lifterapp_test.sql";
    var sqlQuery =
        await File(join(dirname(Platform.script.toFilePath()), pathToFile))
            .readAsString();
    Database db = await databaseFactory.openDatabase(inMemoryDatabasePath);
    await db.execute(sqlQuery);

    //Dependency injection for db
    getIt.registerSingleton(db, dispose: (Database db) => db.close());
  });

  test('getAll()', () async {
    //ASSEMBLE
    var repo = WorkoutRepository();

    //ARRANGE
    var result = await repo.getAll();

    //ASSERT
    expect(result.length, 26);
  });

  test("deleteWorkout()", () async {
    //ASSEMBLE
    Database db = getIt.get<Database>();
    var repo = WorkoutRepository();

    //ARRANGE
    await repo.deleteWorkout(817);
    var foundDeletedWorkout = await db.query("workouts", where: "id = 817");

    //ASSERT
    expect(foundDeletedWorkout, []);
  });

  //Tear down after each test to avoid using same db
  tearDown(() async => await getIt.reset());
}
