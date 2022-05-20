import 'package:lifterapp/services/database_client.dart';
import 'package:sqflite/sqflite.dart';

class SettingsReposity {
  final Future<Database> _db = DatabaseClient().db;

  Future<void> saveRestingTimeSwitchSetting(bool switchValue) async {
    final Database dbContact = await _db;
    await dbContact.update(
      "settings",
      {"using_resting_time": switchValue ? 1 : 0},
    );
  }

  Future<bool> getRestingTimeSwitchSetting() async {
    final Database dbContact = await _db;
    var result = await dbContact.query("settings",
        columns: ["using_resting_time"], limit: 1);
    return result.single["using_resting_time"] == 1 ? true : false;
  }

  Future<void> saveRestingTimeInSecondsSetting(int seconds) async {
    final Database dbContact = await _db;
    await dbContact.update(
      "settings",
      {"resting_time_in_seconds": seconds},
    );
  }

  Future<int> getRestingTimeInSecondsSetting() async {
    final Database dbContact = await _db;
    var result = await dbContact.query("settings",
        columns: ["resting_time_in_seconds"], limit: 1);
    return int.parse(result.single["resting_time_in_seconds"].toString());
  }
}
