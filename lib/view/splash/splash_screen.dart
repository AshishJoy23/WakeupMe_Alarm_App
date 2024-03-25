import 'package:alarm_app_test/controller/controllers.dart';
import 'package:alarm_app_test/view/screens.dart';
import 'package:alarm_app_test/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    gotoMain();
    super.initState();
  }

  final AlarmController alarmController = Get.put(AlarmController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: CustomColors.mango,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/splash_icon.png',
            width: size.width * 0.4,
            height: size.width * 0.4,
            fit: BoxFit.fill,
          ),
          Text(
            'WakeMe!Up',
            style: TextStyle(
              letterSpacing: 1.5,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: CustomColors.secondaryTextColor,
            ),
          ),
        ],
      ),
    ));
  }

  Future<void> gotoMain() async {
    await Future.delayed(
      const Duration(seconds: 3),
    );
    alarmController.getDbInitialized();
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ));
  }
}
