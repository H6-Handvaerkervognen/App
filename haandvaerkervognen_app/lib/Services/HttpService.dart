import 'dart:ffi';

import 'package:haandvaerkervognen_app/models/Alarm.dart';

class HttpService {
  Future<bool> login(String userName) async {
    /*  var headers = {
      'Content-Type': 'application/json',
    };
    var request =
        http.Request('POST', Uri.parse('${_baseUrl}api/login/usertoken'));
    request.headers.addAll(headers);
    request.body = json.encode({"username": userName});
    var response2 = await request.send();
    if (response2.statusCode == 200) {
      var result = await response2.stream.bytesToString();
      var token = result;
      currentUser.username = userName;
      currentUser.token = token;
      print(currentUser.token);
      return true;
    } else {
      print(response2.reasonPhrase);
      return false;
    } */
    return true;
  }

  Future<bool> savePairing(String appId, Alarm alarmInfo) async {
    return true;
  }
}
