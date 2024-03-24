import 'dart:developer';

import 'package:alarm_app_test/controller/alarm_controller.dart';
import 'package:alarm_app_test/model/alarm_model.dart';
import 'package:alarm_app_test/services/notification_services.dart';
import 'package:alarm_app_test/utils/constants.dart';
import 'package:alarm_app_test/view/home/widgets/alarm_list.dart';
import 'package:alarm_app_test/view/home/widgets/weather_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/weather_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  TextEditingController textController = TextEditingController();
  DateTime selectedDateTime = DateTime.now();
  TimeOfDay? selectedTime;
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
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text('No Alarms'),
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
                    textController.clear();
                    alarmController.isRepeat.value = false;
                    var alarmTimeString =
                        DateFormat('hh:mm aa').format(DateTime.now());
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
                        return StatefulBuilder(
                          builder: (context, setModalState) {
                            return Container(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: TextButton(
                                      onPressed: () async {
                                        selectedTime = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );
                                        log(selectedTime.toString());
                                        if (selectedTime != null) {
                                          final now = DateTime.now();
                                          selectedDateTime = DateTime(
                                              now.year,
                                              now.month,
                                              now.day,
                                              selectedTime!.hour,
                                              selectedTime!.minute);
                                          //_alarmTime = selectedDateTime;
                                          setModalState(() {
                                            alarmTimeString =
                                                DateFormat('hh:mm aa')
                                                    .format(selectedDateTime);
                                          });
                                        }
                                      },
                                      child: Text(
                                        alarmTimeString,
                                        style: TextStyle(
                                          fontSize: 32,
                                          color: CustomColors.primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ListTile(
                                    title: Text(
                                      'Repeat Daily',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              CustomColors.secondaryTextColor),
                                    ),
                                    trailing: Switch(
                                      activeColor: CustomColors.primaryColor,
                                      onChanged: (value) {
                                        setModalState(() {
                                          alarmController.isRepeat.value =
                                              value;
                                        });
                                      },
                                      value: alarmController.isRepeat.value,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    controller: textController,
                                    cursorColor: CustomColors.primaryColor,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: CustomColors.secondaryTextColor),
                                    decoration: InputDecoration(
                                        hintText: 'Alarm Label',
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: CustomColors
                                                    .primaryColor))),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  SizedBox(
                                    height: 50,
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  CustomColors.primaryColor)),
                                      onPressed: () {
                                        textController.text.isEmpty
                                            ? Get.snackbar(
                                                'Alarm Label is required', '')
                                            : selectedTime == null
                                                ? Get.snackbar(
                                                    'Choose a time foe alarm',
                                                    '')
                                                : onSaveAlarm(context);
                                      },
                                      child: Text(
                                        'Save',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              CustomColors.secondaryTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
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

  void onSaveAlarm(BuildContext context) async {
    DateTime? scheduleAlarmDateTime;
    if (selectedDateTime.isAfter(DateTime.now())) {
      scheduleAlarmDateTime = selectedDateTime;
    } else {
      scheduleAlarmDateTime = selectedDateTime.add(const Duration(days: 1));
    }

    var alarmInfo = AlarmInfoModel(
      alarmDateTime: scheduleAlarmDateTime,
      isActive: true,
      isRepeating: alarmController.isRepeat.value,
      title: textController.text,
    );
    var id = await alarmController.addNewAlarm(alarmInfo);
    LocalNotifications().showScheduleNotification(
      scheduleAlarmDateTime,
      alarmInfo.title!,
      id: id,
      isRepeating: alarmController.isRepeat.value,
    );
    Navigator.pop(context);
  }
}
