import 'package:get_it/get_it.dart';
import 'package:lifterapp/services/database_client.dart';
import 'package:sqflite/sqflite.dart';

final getIt = GetIt.instance;

///This function setups GetIt to be able to use as dependency injector
Future<void> setupLocator() async {
  getIt.registerSingletonAsync<Database>(() async {
    final client = DatabaseClient();
    await client.initDb();
    return client.db;
  });

  await getIt
      .allReady(); //this can also be loading indicator with FutureBuilder
}
