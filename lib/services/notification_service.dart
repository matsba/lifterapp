// ignore_for_file: depend_on_referenced_packages, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  final AndroidInitializationSettings _initializationSettingsAndroid =
      const AndroidInitializationSettings('app_icon');

  final AndroidNotificationDetails _androidNotificationDetails =
      const AndroidNotificationDetails(
    'lifterapp',
    'lifterapp',
    channelDescription: 'lifterapp notifications',
    icon: 'app_icon',
    color: Color.fromRGBO(4, 41, 58, 1),
  );

  Future<void> selectNotification(String payload) async {
    //TODO: where to go when opening push notification
    debugPrint('notification payload: $payload');
  }

  Future<void> initialize() async {
    await _flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(android: _initializationSettingsAndroid),
        onSelectNotification: (value) =>
            value != null ? selectNotification(value) : null);
  }

  String _formatDurationToMinutes(Duration d) => d.toString().substring(3, 7);

  Future<void> scheduleNotification({required int seconds}) async {
    if (seconds > 600) {
      throw "Only under 10min notifications allowed";
    }

    var duration = Duration(seconds: seconds);
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Tauko loppui!',
        "Lepäsit ${_formatDurationToMinutes(duration)} minuuttia",
        tz.TZDateTime.now(tz.local).add(duration),
        NotificationDetails(android: _androidNotificationDetails),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> cancelScheduledNotification() async {
    await _flutterLocalNotificationsPlugin.cancel(0);
  }
}
