class Pair {
  Pair(
      {required this.alarmId,
      required this.username,
  });
  late String alarmId;
  late String username;
 

//Factory method for when you need to convert from json, into the alarm object
  factory Pair.fromJson(Map<String, dynamic> json) {
    return Pair(
        alarmId: json['alarmId'],
        username: json['username']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['alarmId'] = alarmId;
    data['username'] = username;
    return data;
  }
}
