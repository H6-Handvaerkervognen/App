import 'package:haandvaerkervognen_app/models/Alarm.dart';

class PairInfo {
  PairInfo({required this.username, required this.alarmInfo});

  late String username;
  late Alarm alarmInfo;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['alarmInfo'] = alarmInfo.toJson();

    return data;
  }
}
