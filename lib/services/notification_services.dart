import 'dart:developer';
import 'package:alarm_app_test/model/alarm_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:alarm_app_test/controller/controllers.dart';
import 'package:alarm_app_test/model/models.dart';

class LocalNotifications {
  static final AlarmController alarmController = Get.put(AlarmController());
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

//request notification permission for Android 13 or greater
  static Future requestNotificationPermission() async {
    var isGranted = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    if (isGranted!) {
      await initializeNotification();
    }
  }

// initialize the local notifications
  static Future initializeNotification() async {
    log('called');
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('alarm_icon');
    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    var initilized = await flutterLocalNotificationsPlugin
        .initialize(initializationSettings, onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      debugPrint('notification notificationResponse: $notificationResponse');
      log('<<<<<<<<<<<<<<<message>>>>>>>>>>>>>>>');
    });
    log('intaialzed $initilized');
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
      sound: RawResourceAndroidNotificationSound('alarm_tone'),
      largeIcon: DrawableResourceAndroidBitmap('alarm_icon'),
    );

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails(
      sound: 'alarm_tone.wav',
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
      RepeatInterval.daily,
      platformChannelSpecifics,
    );
  }

  // to schedule a local notification
  static Future showScheduleNotification(DateTime scheduledNotificationDateTime,
      String title, AlarmInfoModel alarm,
      {required int id, required bool isRepeating}) async {
    log('noti triger');
    log('$isRepeating');
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channel 2',
      'wakeupme channel',
      channelDescription: 'Channel for Alarm Notification',
      icon: 'alarm_icon',
      sound: RawResourceAndroidNotificationSound('alarm_tone'),
      largeIcon: DrawableResourceAndroidBitmap('alarm_icon'),
      priority: Priority.max,
      importance: Importance.max,
    );

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails(
      sound: 'alarm_tone.wav',
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
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    if (isRepeating) {
      log('if triger');
      showPeriodicNotifications(id: id, title: title);
    } else {
      log('elseeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
      Future.delayed(scheduledNotificationDateTime.difference(DateTime.now()),
          () {
        // After waiting for the specified duration, call the function
        alarm.id = id;
        alarm.isActive = false;
        alarmController.updateAlarm(alarm);
        log('waited some minutes');
      });
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
