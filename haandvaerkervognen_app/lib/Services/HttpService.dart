import 'dart:convert';
import 'dart:ffi';

import 'package:haandvaerkervognen_app/models/Alarm.dart';
import 'package:http/http.dart' as http;

class HttpService {
  final String baseUrl = 'BaseUrl';
  late http.Response response;

  Future<bool> login(String userName, String password) async {
    response = await http.post(Uri.parse('$baseUrl/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': userName,
          'password': password,
        }));

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> savePairing(String appId, Alarm alarmInfo) async {
    response = await http.post(Uri.parse('$baseUrl/savePairing'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'appId': appId,
          'alarmInfo': alarmInfo,
        }));

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Alarm>> getAlarms() async {
    response = await http.get(Uri.parse('$baseUrl/alarms'));

    if (response.statusCode == 200) {
      Iterable alarms = jsonDecode(response.body);

      return List<Alarm>.from(alarms.map((alarm) => Alarm.fromJson(alarm)));
    } else {
      return List.empty();
    }
  }

  stopAlarm(String alarmId) async {
    response = await http.get(Uri.parse('$baseUrl/stop'));

    if (response.statusCode == 200) {
      Iterable alarms = jsonDecode(response.body);

      return List<Alarm>.from(alarms.map((alarm) => Alarm.fromJson(alarm)));
    } else {
      return List.empty();
    }
  }

  Future<bool> saveAlarmTimes(Alarm alarm) async {
    response = await http.patch(Uri.parse('$baseUrl/saveTimes'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'alarmInfo': alarm,
        }));

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
