import 'dart:async';
import 'dart:convert';
import 'package:haandvaerkervognen_app/models/Alarm.dart';
import 'package:haandvaerkervognen_app/models/LoginCredentials.dart';
import 'package:haandvaerkervognen_app/models/PairInfo.dart';
import 'package:haandvaerkervognen_app/services/TokenService.dart';
import 'package:http/http.dart' as http;

class HttpService {
  //Api base url
  final String baseUrl = 'https://google.com/api';
  late http.Response response;
  final TokenService _tokenService = TokenService();

  //There is a limitation on the http library used, so we need to add the timeout method to each of the methods below.
  int timeoutSecondsDuration = 2;

  ///Posts to the api your login attempt and returns if it was successful or not
  Future<bool> login(String username, String password) async {
    LoginCredentials credentials =
        LoginCredentials(username: username, password: password);

    response = await http
        .post(Uri.parse('$baseUrl/login'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'loginCredentials': credentials,
            }))
        .timeout(Duration(seconds: timeoutSecondsDuration));

    if (response.statusCode == 200) {
      _tokenService.saveToken(response.body);
      return true;
    }
    return false;
  }

  ///Used for saving a phone and alarm pairing after using bluetooth
  Future<bool> pairAlarm(String username, Alarm alarmInfo) async {
    PairInfo info = PairInfo(username: username, AlarmInfo: alarmInfo);

    response = await http
        .post(Uri.parse('$baseUrl/savePairing'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'PairInfo': info,
            }))
        .timeout(Duration(seconds: timeoutSecondsDuration));

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  ///Fetches all alarms that the user has access to
  Future<List<Alarm>> getAlarms(String username) async {
    try {
      response = await http.get(Uri.parse('$baseUrl/alarms')).timeout(
            Duration(seconds: timeoutSecondsDuration),
          );

      if (response.statusCode == 200) {
        Iterable alarms = jsonDecode(response.body);

        return List<Alarm>.from(alarms.map((alarm) => Alarm.fromJson(alarm)));
      } else {
        return List.empty();
      }
    } on TimeoutException catch (e) {
      return List.empty();
    }
  }

  ///Sends a request to stop an alarm. T
  ///The api then checks if the alarm is actually going
  stopAlarm(String alarmId) async {
    response = await http
        .post(Uri.parse('$baseUrl/stop'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'alarmId': alarmId,
            }))
        .timeout(Duration(seconds: timeoutSecondsDuration));

    if (response.statusCode == 200) {
      Iterable alarms = jsonDecode(response.body);

      return List<Alarm>.from(alarms.map((alarm) => Alarm.fromJson(alarm)));
    } else {
      return List.empty();
    }
  }

  ///Save an alarm after some of it's values have been altered
  Future<bool> updateAlarmInfo(Alarm alarm) async {
    response = await http
        .patch(Uri.parse('$baseUrl/saveTimes'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'alarmInfo': alarm,
            }))
        .timeout(Duration(seconds: timeoutSecondsDuration));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  ///Used for registering a new user
  Future<bool> registerUser(String username, String password) async {
    LoginCredentials credentials =
        LoginCredentials(username: username, password: password);

    response = await http
        .post(Uri.parse('$baseUrl/register'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'loginCredentials': credentials,
            }))
        .timeout(Duration(seconds: timeoutSecondsDuration));

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
