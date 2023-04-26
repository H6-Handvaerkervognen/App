import 'dart:async';
import 'dart:convert';
import 'package:haandvaerkervognen_app/models/Alarm.dart';
import 'package:haandvaerkervognen_app/models/LoginCredentials.dart';
import 'package:haandvaerkervognen_app/models/PairInfo.dart';
import 'package:haandvaerkervognen_app/services/TokenService.dart';
import 'package:http/http.dart' as http;

class HttpService {
  //Api base url
  final String baseUrl = 'https://URL_HERE/api';
  late http.Response response;
  final TokenService _tokenService = TokenService();

  //There is a limitation on the http library used, so we need to add the timeout method to each of the methods below.
  int timeoutSecondsDuration = 2;

  ///Posts to the api your login attempt and returns if it was successful or not
  Future<bool> login(String username, String password) async {
    try {
      LoginCredentials credentials =
          LoginCredentials(username: username, password: password);

      response = await http
          .post(Uri.parse('$baseUrl/Login/Login'),
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
    } catch (e) {
      print(e);
      return false;
    }
  }

  ///Used for saving a phone and alarm pairing after using bluetooth
  Future<bool> pairAlarm(String username, Alarm alarmInfo) async {
    String? token = await _tokenService.getToken();
    try {
      PairInfo info = PairInfo(username: username, AlarmInfo: alarmInfo);
      if (token != null) {
        response = await http
            .post(Uri.parse('$baseUrl/App/PairAlarm'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Token': token,
                },
                body: jsonEncode(<String, dynamic>{
                  'PairInfo': info,
                }))
            .timeout(Duration(seconds: timeoutSecondsDuration));
        if (response.statusCode == 201) {
          return true;
        }
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  ///Fetches all alarms that the user has access to
  Future<List<Alarm>> getAlarms(String username) async {
    String? token = await _tokenService.getToken();
    if (token != null) {
      try {
        response = await http
            .get(Uri.parse('$baseUrl/App/GetAlarms'), headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Token': token,
        }).timeout(
          Duration(seconds: timeoutSecondsDuration),
        );

        if (response.statusCode == 200) {
          Iterable alarms = jsonDecode(response.body);

          return List<Alarm>.from(alarms.map((alarm) => Alarm.fromJson(alarm)));
        } else {
          return List.empty();
        }
      } on TimeoutException catch (e) {
        print(e);
        return List.empty();
      }
    }
    return List.empty();
  }

  ///Sends a request to stop an alarm.
  ///The api then checks if the alarm is actually going
  stopAlarm(String alarmId) async {
    String? token = await _tokenService.getToken();
    if (token != null) {
      response = await http
          .post(Uri.parse('$baseUrl/App/StopAlarm'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Token': token,
              },
              body: jsonEncode(<String, dynamic>{
                'alarmId': alarmId,
              }))
          .timeout(Duration(seconds: timeoutSecondsDuration));

      //Consider having a response for this one
      //if (response.statusCode == 200) {}
    }
  }

  ///Save an alarm after some of it's values have been altered
  Future<bool> updateAlarmInfo(Alarm alarm) async {
    String? token = await _tokenService.getToken();
    try {
      if (token != null) {
        response = await http
            .patch(Uri.parse('$baseUrl/App/UpdateAlarmInfo'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Token': token,
                },
                body: jsonEncode(<String, dynamic>{
                  'alarmInfo': alarm,
                }))
            .timeout(Duration(seconds: timeoutSecondsDuration));

        if (response.statusCode == 200) {
          return true;
        }
      }
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }

  ///Used for registering a new user
  Future<bool> registerUser(String username, String password) async {
    try {
      LoginCredentials credentials =
          LoginCredentials(username: username, password: password);

      response = await http
          .post(Uri.parse('$baseUrl/Login/CreateNewUser'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, dynamic>{
                'loginCredentials': credentials,
              }))
          .timeout(Duration(seconds: timeoutSecondsDuration));

      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }
}
