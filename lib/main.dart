// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifterapp/app.dart';
import 'package:lifterapp/routing/navigation_service.dart';
import 'package:lifterapp/services/database_provider.dart';
import 'package:lifterapp/services/database_service.dart';
import 'package:lifterapp/services/notification_provider.dart';
import 'package:lifterapp/services/notification_service.dart';
import 'package:riverpod_navigator_core/riverpod_navigator_core.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final databaseService = DatabaseService();
  await databaseService.initDb();
  var database = await databaseService.db;

  final notificationService = NotificationService();
  notificationService.initialize();

  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();

  try {
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  } on tz.LocationNotFoundException catch (_) {
    tz.setLocalLocation(tz.getLocation("Etc/GMT"));
  }

  runApp(ProviderScope(
    overrides: [
      databaseProvider.overrideWithValue(database),
      databaseServiceProvider.overrideWithValue(databaseService),
      notificationProvider.overrideWithValue(notificationService)
    ],
    child: App(),
  ));
  //runApp(ReduxApp(store: store));
}
