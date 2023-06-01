import 'dart:convert';

class Log {
  String? date;
  String? uid;

  Log({this.date, this.uid});

  // Factory constructor to instantiate object from json format
  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(date: json['date'], uid: json['uid']);
  }

  static List<Log> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Log>((dynamic d) => UserModel.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Log user) {
    return {
      '': user.id,
  
      'uid': user.uid,

  }
}
