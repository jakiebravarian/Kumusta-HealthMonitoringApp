import 'dart:convert';

class User {
  String? email;
  String? id;
  String? name;
  String? username;
  String? college;
  String? course;
  String? stdnum;
  List<String>? illnessList;
  bool? isQuarantined;
  bool? isAdmin;
  bool? isUnderMonitoring;
  String? userID;

  User(
      {this.email,
      this.id,
      this.name,
      this.username,
      this.college,
      this.course,
      this.stdnum,
      this.illnessList,
      this.isQuarantined,
      this.isAdmin,
      this.isUnderMonitoring,
      this.userID});

  // Factory constructor to instantiate object from json format
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        email: json['email'],
        id: json['id'],
        name: json['name'],
        username: json['username'],
        college: json['college'],
        course: json['course'],
        stdnum: json['studentNum'],
        illnessList: json["illnesses"],
        isQuarantined: json['isQuarantined'],
        isAdmin: json['isAdmin'],
        isUnderMonitoring: json['isUnderMonitoring'],
        userID: json["uid"]);
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
      'college': user.college,
      'course': user.course,
      'studentNum': user.stdnum,
      'illnesses': user.illnessList,
      'isQuarantined': user.isQuarantined,
      'isAdmin': user.isAdmin,
      'isUnderMonitoring': user.isUnderMonitoring,
      'uid': user.userID
    };
  }
}
