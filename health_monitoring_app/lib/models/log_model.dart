import 'dart:convert';

class Log {
  String? date;
  String? uid;
  String? name;
  String? stdnum;

  Log({this.date, this.uid, this.name, this.stdnum});

  // Factory constructor to instantiate object from json format
  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      date: json['date'],
      uid: json['uid'],
      name: json['name'],
      stdnum: json['stdnum'],
    );
  }

  static List<Log> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Log>((dynamic d) => Log.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Log log) {
    return {
      'date': log.date,
      'uid': log.uid,
      'name': log.name,
      'stdnum': log.stdnum
    };
  }
}
