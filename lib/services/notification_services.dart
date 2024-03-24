import 'package:alarm_app_test/model/alarm_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../controller/alarm_controller.dart';

class LocalNotifications {
  final AlarmController alarmController = Get.put(AlarmController());
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

// initialize the local notifications
  static Future init() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('alarm_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
    });
  }

  // to show periodic notification at regular interval
  static Future showPeriodicNotifications({
    required int id,
    required String title,
  }) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channel 1',
      'wakeupme channel',
      channelDescription: 'Channel for Alarm Notification',
      icon: 'alarm_icon',
      sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('alarm_icon'),
    );

    var iOSPlatformChannelSpecifics = const IOSNotificationDetails(
      sound: 'a_long_cold_sting.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.periodicallyShow(
      id,
      title,
      'You have a new alarm notification',
      RepeatInterval.everyMinute,
      platformChannelSpecifics,
    );
  }

  // to schedule a local notification
   Future showScheduleNotification(
      DateTime scheduledNotificationDateTime, String title,
      {required int id,required bool isRepeating}) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channel 2',
      'wakeupme channel',
      channelDescription: 'Channel for Alarm Notification',
      icon: 'alarm_icon',
      sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('alarm_icon'),
    );

    var iOSPlatformChannelSpecifics = const IOSNotificationDetails(
      sound: 'a_long_cold_sting.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    tz.initializeTimeZones();
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      'You have a new alarm notification',
      tz.TZDateTime.now(tz.local)
          .add(scheduledNotificationDateTime.difference(DateTime.now())),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    if (isRepeating) {
      showPeriodicNotifications(id: id,title: title);
    }else{
      var alarm = alarmController.alarmList.firstWhere((element) => element.id == id);
      alarm.isActive = false;
      alarmController.updateAlarm(alarm);
    }
  }

  // close a specific channel notification
  static Future cancel(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  // close all the notifications available
  static Future cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
