import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:haandvaerkervognen_app/models/Alarm.dart';
import 'package:haandvaerkervognen_app/models/LoginCredentials.dart';
import 'package:haandvaerkervognen_app/models/PairInfo.dart';
import 'package:haandvaerkervognen_app/services/TokenService.dart';
import 'package:haandvaerkervognen_app/models/Pair.dart';

class HttpService {
  //Api base url
  final String baseUrl = 'https://192.168.1.11';
  late HttpClient client;
  late HttpClientRequest request;
  late HttpClientResponse response;
  final TokenService _tokenService = TokenService();

  ///Method needed to be ran before any calls can be made using the httpclient
  ///We renew the instance because there's a chance a long lived client can cause issues
  setupClient() {
    client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 2);
    //Make our self signed certificate trusted when it comes from the specific IP
    //So we can use https!
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      // Return true if trusted, false otherwise
      return host == '192.168.1.11';
    };
  }

  ///Posts to the api your login attempt and returns if it was successful or not
  Future<bool> login(String username, String password) async {
    try {
      LoginCredentials credentials =
          LoginCredentials(username: username, password: password);

      setupClient();

      request = await client.postUrl(Uri.parse('$baseUrl/Login/Login'));
      request.headers.set('Content-Type', 'application/json; charset=UTF-8');
      request.add(utf8.encode(jsonEncode(credentials.toJson())));

      response = await request.close();

      if (response.statusCode == 200) {
        _tokenService.saveToken(await response.transform(utf8.decoder).join());
        return true;
      }
    } on TimeoutException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    } finally {
      client.close();
    }

    return false;
  }

  ///Used for saving a phone and alarm pairing after using bluetooth
  Future<bool> pairAlarm(String username, Alarm alarmInfo) async {
    String? token = await _tokenService.getToken();
    if (token != null) {
      try {
        PairInfo info = PairInfo(username: username, alarmInfo: alarmInfo);

        setupClient();

        request = await client.postUrl(Uri.parse('$baseUrl/App/PairAlarm'));
        request.headers.set('Content-Type', 'application/json; charset=UTF-8');
        request.headers.set('token', token);
        request.add(utf8.encode(jsonEncode(info.toJson())));
        if (kDebugMode) {
          print(jsonEncode(info.toJson()));
        }
        response = await request.close();
        if (response.statusCode == 201) {
          return true;
        }
      } on TimeoutException catch (e) {
        if (kDebugMode) {
          print(e);
        }
        return false;
      } on Exception catch (e) {
        if (kDebugMode) {
          print(e);
        }
        return false;
      } finally {
        client.close();
      }
    }
    return false;
  }

  ///Fetches all alarms that the user has access to
  Future<List<Alarm>> getAlarms(String username,) async {
    String? token = await _tokenService.getToken();
    print("tokeeeeeeeeen$token");
    if (token != null) {
      try {
        setupClient();

        request = await client.getUrl(Uri.parse('$baseUrl/App/GetAlarms?username=$username'));
        request.headers.set('Content-Type', 'application/json; charset=UTF-8');
        request.headers.set('Token', token);
        // request.add(utf8.encode(jsonEncode(username)));

        HttpClientResponse response = await request.close();

        if (response.statusCode == 200) {
          Iterable alarms =
              jsonDecode(await response.transform(utf8.decoder).join());

          return List<Alarm>.from(alarms.map((alarm) => Alarm.fromJson(alarm)));
        } else {
          return List.empty();
        }
      } on TimeoutException catch (e) {
        if (kDebugMode) {
          print(e);
        }
        return List.empty();
      } on Exception catch (e) {
        if (kDebugMode) {
          print(e);
        }
        return List.empty();
      } finally {
        client.close();
      }
    }
    return List.empty();
  }

  ///Sends a request to stop an alarm.
  ///The api then checks if the alarm is actually going
  Future<void> stopAlarm(String alarmId, String username) async {
    String? token = await _tokenService.getToken();
    print(token);
    if (token != null) {
      try {
        Pair pair = Pair(alarmId: alarmId, username: username);
        setupClient();

        request = await client.postUrl(Uri.parse('$baseUrl/App/StopAlarm'));
        request.headers.set('Content-Type', 'application/json; charset=UTF-8');
        request.headers.set('Token', token);
        request.add(utf8.encode(jsonEncode(pair.toJson())));
        await request.close();
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      } finally {
        client.close();
      }
    }
  }

  ///Save an alarm after some of it's values have been altered
  Future<bool> updateAlarmInfo(Alarm alarm) async {
    String? token = await _tokenService.getToken();
    if (token != null) {
      try {
        setupClient();

        request =
            await client.patchUrl(Uri.parse('$baseUrl/App/UpdateAlarmInfo'));
        request.headers.set('Content-Type', 'application/json; charset=UTF-8');
        request.headers.set('Token', token);
        request.add(utf8.encode(jsonEncode(alarm.toJson())));

        response = await request.close();

        return response.statusCode == 200;
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        return false;
      } finally {
        client.close();
      }
    }
    return false;
  }

  ///Used for registering a new user
  Future<bool> registerUser(String username, String password) async {
    try {
      LoginCredentials credentials =
          LoginCredentials(username: username, password: password);

      setupClient();

      request = await client.postUrl(Uri.parse('$baseUrl/Login/CreateNewUser'));
      request.headers.set('Content-Type', 'application/json; charset=UTF-8');
      request.add(utf8.encode(jsonEncode(credentials.toJson())));

      response = await request.close();
      return response.statusCode == 201;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    } finally {
      client.close();
    }
  }
}
