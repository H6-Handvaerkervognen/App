import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:haandvaerkervognen_app/models/Alarm.dart';

class PairInfo {
  late String username;
  late Alarm AlarmInfo;

  PairInfo({required this.username, required this.AlarmInfo});
}
