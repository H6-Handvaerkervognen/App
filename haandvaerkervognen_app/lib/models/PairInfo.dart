import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:haandvaerkervognen_app/models/Alarm.dart';

class PairInfo {
  PairInfo({required this.username, required this.AlarmInfo});

  late String username;
  late Alarm AlarmInfo;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['alarmInfo'] = AlarmInfo.toJson();

    return data;
  }
}
