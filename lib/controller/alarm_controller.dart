import 'package:get/get.dart';
import 'package:alarm_app_test/services/services.dart';
import 'package:alarm_app_test/model/models.dart';

class AlarmController extends GetxController {
  var isRepeat = false.obs;
  var alarmList = <AlarmInfoModel>[].obs;
  
    @override
  void onInit() {
    super.onInit();
    getDbInitialized();
    fetchAllAlarms();
  }

  Future<void> getDbInitialized() async {
    await SqfliteServices().database;
  }

  Future<void> fetchAllAlarms() async {
    alarmList.clear();
    final response = await SqfliteServices().getAlarms();
    alarmList.value = response;
  }

  Future<int> addNewAlarm(AlarmInfoModel alarmInfo) async {
    final response = await SqfliteServices().insertAlarm(alarmInfo);
    fetchAllAlarms();
    return response;
  }

  Future<void> deleteAlarm(int id) async {
    await SqfliteServices().delete(id);
    fetchAllAlarms();
  }

  Future<int> updateAlarm(AlarmInfoModel alarmInfo) async {
    final response = await SqfliteServices().update(alarmInfo);
    fetchAllAlarms();
    return response;
  }
}