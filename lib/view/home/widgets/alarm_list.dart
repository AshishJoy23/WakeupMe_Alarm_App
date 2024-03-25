import 'package:alarm_app_test/view/home/widgets/alarm_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:alarm_app_test/controller/controllers.dart';
import 'package:alarm_app_test/services/services.dart';
import 'package:alarm_app_test/view/screens.dart';
import 'package:alarm_app_test/model/models.dart';
import 'package:alarm_app_test/utils/utils.dart';

class AlarmListWidget extends StatelessWidget {
  final AlarmController alarmController;
  final List<AlarmInfoModel> alarmInfoList;
  const AlarmListWidget({
    super.key,
    required this.alarmInfoList,
    required this.alarmController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alarms',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: CustomColors.secondaryTextColor),
        ),
        const Divider(
          color: Colors.black38,
          height: 1,
        ),
        Obx(
          () => ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: alarmInfoList.length,
            padding: const EdgeInsets.all(4),
            itemBuilder: (context, index) {
              var alarm = alarmInfoList[index];
              var alarmTime =
                  DateFormat('hh:mm aa').format(alarm.alarmDateTime!);
              return InkWell(
                onTap: () {
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
                      return AlarmDialogWidget(
                        alarmInfo: alarm,
                      );
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: alarm.isActive!
                          ? CustomColors.mango
                          : CustomColors.mangoDim,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.all(6),
                        title: Text(
                          alarmTime,
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.secondaryTextColor),
                        ),
                        subtitle: Text(
                          alarm.title!,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: CustomColors.secondaryTextColor),
                        ),
                        trailing: Switch(
                          activeColor: Colors.blue,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey,
                          value: alarm.isActive!,
                          onChanged: (value) async {
                            DateTime? scheduleAlarmDateTime;
                            if (value) {
                              if (alarm.alarmDateTime!
                                  .isBefore(DateTime.now())) {
                                scheduleAlarmDateTime = alarm.alarmDateTime!
                                    .add(const Duration(days: 1));
                              } else {
                                scheduleAlarmDateTime = alarm.alarmDateTime;
                              }
                              alarm.isActive = value;
                              await LocalNotifications.showScheduleNotification(
                                scheduleAlarmDateTime!,
                                alarm.title!,
                                alarm,
                                id: alarm.id!,
                                isRepeating: alarm.isRepeating!,
                              );
                            } else {
                              alarm.isActive = value;
                              await LocalNotifications.cancel(alarm.id!);
                            }
                            await alarmController.updateAlarm(alarm);
                          },
                        ),
                      ),
                      const Divider(
                        color: Colors.black38,
                        height: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              alarm.isRepeating! ? 'Daily' : 'Ring Once',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54),
                            ),
                            InkWell(
                              onTap: () async {
                                await LocalNotifications.cancel(alarm.id!);
                                await alarmController.deleteAlarm(alarm.id!);
                              },
                              child: const Icon(
                                CupertinoIcons.delete,
                                color: Colors.red,
                                size: 28,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
