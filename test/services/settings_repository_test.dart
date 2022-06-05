import 'package:flutter_test/flutter_test.dart';
import 'package:lifterapp/services/database_client.dart';
import 'package:lifterapp/services/service_locator.dart';
import 'package:lifterapp/services/settings_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Initialize sqflite for test.

Future main() async {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    print("Testing Settings Repository");
  });

  setUp(() async {
    Database db = await databaseFactory.openDatabase(inMemoryDatabasePath);
    //initate database for tests
    //since default values are loaded in migrations, then these can be used
    await DatabaseClient().migrationsV1(db);
    await DatabaseClient().migrationsV2(db);

    //Dependency injection for db
    getIt.registerSingleton(db, dispose: (Database db) => db.close());
  });

  test('getRestingTimeSwitchSetting()', () async {
    //ASSEMBLE
    var repo = SettingsRepository();

    //ARRANGE
    var result = await repo.getRestingTimeSwitchSetting();

    //ASSERT
    expect(result, true);
  });

  test("getRestingTimeInSecondsSetting()", () async {
    //ASSEMBLE
    var repo = SettingsRepository();

    //ARRANGE
    var result = await repo.getRestingTimeInSecondsSetting();

    //ASSERT
    expect(result, 90);
  });

  //Tear down after each test to avoid using same db
  tearDown(() async => await getIt.reset());
}
