import 'dart:convert';

class User {
  final String email;
  String? id;
  String name;
  String username;
  String course;
  String stdnum;
  List<String>? illnessList;
  bool? isQuarantined;
  bool? isAdmin;
  bool? isUnderMonitoring;

  User(
      {required this.email,
      this.id,
      required this.name,
      required this.username,
      required this.course,
      required this.stdnum,
      this.illnessList,
      this.isQuarantined,
      this.isAdmin,
      this.isUnderMonitoring});

  // Factory constructor to instantiate object from json format
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        email: json['email'],
        id: json['id'],
        name: json['name'],
        username: json['username'],
        course: json['course'],
        stdnum: json['studentNum'],
        isQuarantined: json['isQuarantined'],
        isAdmin: json['isAdmin'],
        isUnderMonitoring: json['isUnderMonitoring']);
  }

  static List<User> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<User>((dynamic d) => User.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(User user) {
    return {
      'email': user.email,
      'name': user.name,
      'username': user.username,
      'course': user.course,
      'studentNum': user.stdnum,
      'isQuarantined': user.isQuarantined,
      'isAdmin': user.isAdmin,
      'isUnderMonitoring': user.isUnderMonitoring
    };
  }
}
