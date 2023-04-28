///Model for the physical alarm
class Alarm {
  Alarm(
      {required this.iD,
      required this.startTime,
      required this.endTime,
      required this.name});
  late String iD;
  late String startTime;
  late String endTime;
  late String name;

//Factory method for when you need to convert from json, into the alarm object
  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
        iD: json['alarmId'],
        startTime: json['startTime'],
        endTime: json['endTime'],
        name: json['name']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['alarmId'] = iD;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['name'] = name;
    return data;
  }
}
