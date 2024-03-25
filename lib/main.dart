import 'dart:developer';
import 'package:alarm_app_test/controller/controllers.dart';
import 'package:alarm_app_test/services/services.dart';
import 'package:alarm_app_test/view/screens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final WeatherController weatherController = Get.put(WeatherController());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  log('main call');
  await LocalNotifications.requestNotificationPermission();
  await weatherController.getPermission();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Offline Alarm App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
    );
  }
}


