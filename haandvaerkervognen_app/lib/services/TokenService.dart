import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  void saveToken(String body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', body);
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
