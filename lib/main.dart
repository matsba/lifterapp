import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:lifterapp/redux_app.dart';
import 'package:lifterapp/services/notification_service.dart';
import 'package:lifterapp/store/store.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  final store = createStore();
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initialize();

  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();

  try {
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
  } on tz.LocationNotFoundException catch (_) {
    tz.setLocalLocation(tz.getLocation("Etc/GMT"));
  }

  runApp(ReduxApp(store: store));
}
