import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controller/alarm_controller.dart';
import '../../../model/alarm_model.dart';
import '../../../services/notification_services.dart';
import '../../../utils/constants.dart';

class AlarmDialogWidget extends StatefulWidget {
  final AlarmInfoModel? alarmInfo;
  AlarmDialogWidget({
    super.key,
    this.alarmInfo,
  });

  @override
  State<AlarmDialogWidget> createState() => _AlarmDialogWidgetState();
}

class _AlarmDialogWidgetState extends State<AlarmDialogWidget> {
  TextEditingController textController = TextEditingController();
  final AlarmController alarmController = Get.put(AlarmController());
  String alarmTimeString = DateFormat('hh:mm aa').format(DateTime.now());

  DateTime selectedDateTime = DateTime.now();

  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    if (widget.alarmInfo != null) {
      textController.text = widget.alarmInfo!.title!;
      selectedDateTime = widget.alarmInfo!.alarmDateTime!;
      alarmTimeString =
          DateFormat('hh:mm aa').format(widget.alarmInfo!.alarmDateTime!);
      alarmController.isRepeat.value = widget.alarmInfo!.isRepeating!;
    }
    return StatefulBuilder(builder: (context, setModalState) {
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
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          primaryColor: CustomColors
                              .primaryColor, // Set your desired primary color
                          colorScheme: ColorScheme.light(
                              primary: CustomColors
                                  .primaryColor), // Adjust your color scheme
                          buttonTheme: const ButtonThemeData(
                            textTheme: ButtonTextTheme.primary,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  log(selectedTime.toString());
                  if (selectedTime != null) {
                    final now = DateTime.now();
                    selectedDateTime = DateTime(now.year, now.month, now.day,
                        selectedTime!.hour, selectedTime!.minute);
                    //_alarmTime = selectedDateTime;
                    setModalState(() {
                      alarmTimeString =
                          DateFormat('hh:mm aa').format(selectedDateTime);
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
                    color: CustomColors.secondaryTextColor),
              ),
              trailing: Switch(
                activeColor: CustomColors.primaryColor,
                onChanged: (value) {
                  setModalState(() {
                    alarmController.isRepeat.value = value;
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
                      borderSide:
                          BorderSide(color: CustomColors.primaryColor))),
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
                        MaterialStatePropertyAll(CustomColors.primaryColor)),
                onPressed: () {
                  if (textController.text.isEmpty) {
                    Get.snackbar('Alarm Label is required', '');
                  } else if (selectedTime == null) {
                    Get.snackbar('Choose a time foe alarm', '');
                  } else {
                    onSaveAlarm(context);
                    Navigator.pop(context);
                    textController.clear();
                    alarmController.isRepeat.value = false;
                  }
                },
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.secondaryTextColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void onSaveAlarm(BuildContext context) async {
    DateTime? scheduleAlarmDateTime;
    if (selectedDateTime.isAfter(DateTime.now())) {
      scheduleAlarmDateTime = selectedDateTime;
    } else {
      scheduleAlarmDateTime = selectedDateTime.add(const Duration(days: 1));
    }

    if (widget.alarmInfo != null) {
      var alarmInfo = AlarmInfoModel(
        id: widget.alarmInfo!.id,
        alarmDateTime: scheduleAlarmDateTime,
        isActive: true,
        isRepeating: alarmController.isRepeat.value,
        title: textController.text,
      );
      await alarmController.updateAlarm(alarmInfo);
      LocalNotifications.showScheduleNotification(
        scheduleAlarmDateTime,
        alarmInfo.title!,
        alarmInfo,
        id: widget.alarmInfo!.id!,
        isRepeating: alarmController.isRepeat.value,
      );
    } else {
      var alarmInfo = AlarmInfoModel(
        alarmDateTime: scheduleAlarmDateTime,
        isActive: true,
        isRepeating: alarmController.isRepeat.value,
        title: textController.text,
      );
      var id = await alarmController.addNewAlarm(alarmInfo);
      LocalNotifications.showScheduleNotification(
        scheduleAlarmDateTime,
        alarmInfo.title!,
        alarmInfo,
        id: id,
        isRepeating: alarmController.isRepeat.value,
      );
    }
  }
}
