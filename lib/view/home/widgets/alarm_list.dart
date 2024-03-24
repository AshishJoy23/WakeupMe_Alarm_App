import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controller/alarm_controller.dart';
import '../../../model/alarm_model.dart';
import '../../../services/notification_services.dart';
import '../../../utils/constants.dart';

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
              fontSize: 26,
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
              return Card(
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
                        value: alarm.isActive!,
                        onChanged: (value) {},
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
                            onTap: () async{
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
              );
            },
          ),
        ),
      ],
    );
  }
}
