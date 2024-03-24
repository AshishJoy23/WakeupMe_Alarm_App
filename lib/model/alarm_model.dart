class AlarmInfoModel {
  int? id;
  String? title;
  DateTime? alarmDateTime;
  bool? isRepeating;
  bool? isActive;

  AlarmInfoModel(
      {this.id,
      this.title,
      this.alarmDateTime,
      this.isRepeating,
      this.isActive});

  factory AlarmInfoModel.fromMap(Map<String, dynamic> json) => AlarmInfoModel(
        id: json["id"],
        title: json["title"],
        alarmDateTime: DateTime.parse(json["alarmDateTime"]),
        isRepeating: json["isRepeating"]==1?true:false,
        isActive: json["isActive"]==1?true:false,
      );
  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "alarmDateTime": alarmDateTime!.toIso8601String(),
        "isRepeating": isRepeating==true?1:0,
        "isActive": isActive==true?1:0,
      };
}