import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:haandvaerkervognen_app/models/Alarm.dart';
import 'package:http/http.dart' as http;

class HttpService {
  final String baseUrl = 'https://192.168.1.1/api';
  late http.Response request;

  Future<bool> login(String userName, String password) async {
    request = await http.post(Uri.parse('$baseUrl/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': userName,
          'password': password,
        }));

    if (request.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> savePairing(String appId, Alarm alarmInfo) async {
    request = await http.post(Uri.parse('$baseUrl/savePairing'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'appId': appId,
          'alarmInfo': alarmInfo,
        }));

    if (request.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Alarm>> getAlarms() async {
    try {
      request = await http.get(Uri.parse('$baseUrl/alarms')).timeout(
            const Duration(seconds: 2),
          );

      if (request.statusCode == 200) {
        Iterable alarms = jsonDecode(request.body);

        return List<Alarm>.from(alarms.map((alarm) => Alarm.fromJson(alarm)));
      } else {
        return List.empty();
      }
    } on TimeoutException catch (e) {
      return List.empty();
    }
  }

  stopAlarm(String alarmId) async {
    request = await http.get(Uri.parse('$baseUrl/stop'));

    if (request.statusCode == 200) {
      Iterable alarms = jsonDecode(request.body);

      return List<Alarm>.from(alarms.map((alarm) => Alarm.fromJson(alarm)));
    } else {
      return List.empty();
    }
  }

  Future<bool> saveAlarmTimes(Alarm alarm) async {
    request = await http.patch(Uri.parse('$baseUrl/saveTimes'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'alarmInfo': alarm,
        }));

    if (request.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
