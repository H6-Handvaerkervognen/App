import 'package:flutter/material.dart';

///Model for the physical alarm
class Alarm {
  Alarm(
      {required this.iD,
      required this.startTime,
      required this.endTime,
      required this.name});
  late String iD;
  late TimeOfDay startTime;
  late TimeOfDay endTime;
  late String name;

//Factory method for when you need to convert from json, into the alarm object
  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
        iD: json['alarmId'],
        startTime: json['startTime'],
        endTime: json['endTime'],
        name: json['name']);
  }
}
