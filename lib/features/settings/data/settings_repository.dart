import 'dart:io';

import 'package:flutter/services.dart';
import 'package:lifterapp/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

class SettingsRepository {
  final Database db;
  final DatabaseService databaseService;

  SettingsRepository({required this.db, required this.databaseService});

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

  Future<Uint8List> getDatabaseFileToExport() async {
    return File(db.path).readAsBytes();
  }

  Future<Database> importDatabaseFile(Uint8List databaseFile) async {
    var service = await DatabaseService().createFromFile(databaseFile);
    return service.db;
  }
}
