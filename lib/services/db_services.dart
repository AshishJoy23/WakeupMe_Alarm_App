import 'package:alarm_app_test/model/alarm_model.dart';
import 'package:sqflite/sqflite.dart';

const String tableAlarm = 'alarm';
const String columnId = 'id';
const String columnTitle = 'title';
const String columnDateTime = 'alarmDateTime';
const String columnRepeating = 'isRepeating';
const String columnActive = 'isActive';

class SqfliteServices {
  static Database? _database;
  static SqfliteServices? _alarmServices;

  SqfliteServices._createInstance();
  factory SqfliteServices() {
    if (_alarmServices == null) {
      _alarmServices = SqfliteServices._createInstance();
    }
    return _alarmServices!;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = "${dir}alarm.db";

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          create table $tableAlarm ( 
          $columnId integer primary key autoincrement, 
          $columnTitle text not null,
          $columnDateTime text not null,
          $columnRepeating integer,
          $columnActive integer)
        ''');
      },
    );
    return database;
  }

  Future<int> insertAlarm(AlarmInfoModel alarmInfo) async {
    var db = await this.database;
    var result = await db.insert(tableAlarm, alarmInfo.toMap());
    print('result : $result');
    return result;
  }

  Future<List<AlarmInfoModel>> getAlarms() async {
    List<AlarmInfoModel> _alarms = [];

    var db = await this.database;
    var result = await db.query(tableAlarm);
    result.forEach((element) {
      var alarmInfo = AlarmInfoModel.fromMap(element);
      _alarms.add(alarmInfo);
    });

    return _alarms;
  }

  Future<int> delete(int? id) async {
    var db = await this.database;
    return await db.delete(tableAlarm, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(AlarmInfoModel alarmInfo) async {
    var db = await this.database;
    return await db.update(tableAlarm, alarmInfo.toMap(),
        where: '$columnId = ?', whereArgs: [alarmInfo.id]);
  }
}
