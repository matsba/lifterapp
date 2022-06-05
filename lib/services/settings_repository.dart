import 'package:lifterapp/services/database_client.dart';
import 'package:lifterapp/services/service_locator.dart';
import 'package:sqflite/sqflite.dart';

class SettingsRepository {
  Database db = getIt.get<Database>();

  Future<void> saveRestingTimeSwitchSetting(bool switchValue) async {
    await db.update(
      "settings",
      {"using_resting_time": switchValue ? 1 : 0},
    );
  }

  Future<bool> getRestingTimeSwitchSetting() async {
    var result =
        await db.query("settings", columns: ["using_resting_time"], limit: 1);
    return result.single["using_resting_time"] == 1 ? true : false;
  }

  Future<void> saveRestingTimeInSecondsSetting(int seconds) async {
    await db.update(
      "settings",
      {"resting_time_in_seconds": seconds},
    );
  }

  Future<int> getRestingTimeInSecondsSetting() async {
    var result = await db.query("settings",
        columns: ["resting_time_in_seconds"], limit: 1);
    return int.parse(result.single["resting_time_in_seconds"].toString());
  }
}
