import 'package:shared_preferences/shared_preferences.dart';

//Class that handles saving and fetching of the token
class TokenService {
  late SharedPreferences prefs;

  ///Save a token into sharedpreferences
  void saveToken(String body) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('token', body);
  }

  ///Get a token from shared preferences
  Future<String?> getToken() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
