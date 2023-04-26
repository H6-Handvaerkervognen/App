///Object for sending login and register information
class LoginCredentials {
  LoginCredentials({required this.username, required this.password});

  late String username;
  late String password;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    return data;
  }
}
