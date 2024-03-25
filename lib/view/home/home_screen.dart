import 'package:alarm_app_test/controller/alarm_controller.dart';
import 'package:alarm_app_test/utils/constants.dart';
import 'package:alarm_app_test/view/home/widgets/alarm_dialog.dart';
import 'package:alarm_app_test/view/home/widgets/alarm_list.dart';
import 'package:alarm_app_test/view/home/widgets/weather_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../controller/weather_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final WeatherController weatherController = Get.put(WeatherController());
  final AlarmController alarmController = Get.put(AlarmController());
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Obx(
      () => weatherController.checkLoading().value
          ? const Scaffold(
              body: Center(
                child: SpinKitChasingDots(
                  color: Color(0xFFFFA738),
                ),
              ),
            )
          : weatherController.isError.value
              ? Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error,
                          size: 50,
                          color: Colors.red,
                        ),
                        Text(
                          'Something went wrong!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: CustomColors.secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Scaffold(
                  extendBodyBehindAppBar: false,
                  backgroundColor: CustomColors.pageBackgroundColor,
                  appBar: AppBar(
                    centerTitle: true,
                    title: Text(
                      'WakeMe!Up',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.secondaryTextColor,
                      ),
                    ),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: CustomColors.mango,
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: const WeatherDataWidget(),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Obx(() => alarmController.alarmList.isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Image.asset(
                                        'assets/icons/empty_icon.png',
                                        width: size.width * 0.7,
                                        height: size.height * 0.3,
                                      ),
                                    ),
                                    Text(
                                      'No Alarms Found!',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: CustomColors.secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                )
                              : AlarmListWidget(
                                  alarmInfoList: alarmController.alarmList,
                                  alarmController: alarmController,
                                ))
                        ],
                      ),
                    ),
                  ),
                  floatingActionButton: FloatingActionButton.extended(
                      backgroundColor: CustomColors.primaryColor,
                      onPressed: () {
                        alarmController.isRepeat.value = false;

                        showModalBottomSheet(
                          useRootNavigator: true,
                          context: context,
                          clipBehavior: Clip.antiAlias,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                          ),
                          builder: (context) {
                            return AlarmDialogWidget();
                          },
                        );
                      },
                      icon: Icon(
                        Icons.alarm_add,
                        size: 30,
                        color: CustomColors.secondaryTextColor,
                      ),
                      label: Text(
                        'Set Alarms',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.secondaryTextColor,
                        ),
                      )),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerFloat,
                ),
    );
  }
}
