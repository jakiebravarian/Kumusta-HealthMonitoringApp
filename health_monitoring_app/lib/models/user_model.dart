import 'dart:convert';

class UserModel {
  String? email;
  String? id;
  String? name;
  String? username;
  String? college;
  String? course;
  String? stdnum;
  String? usertype;
  List<dynamic>? illnessList;
  List<dynamic>? allergiesList;
  bool? isQuarantined;
  bool? isAdmin;
  bool? isUnderMonitoring;
  String? uid;
  String? empno;
  String? position;
  String? homeUnit;

  UserModel({
    this.email,
    this.id,
    this.name,
    this.username,
    this.college,
    this.course,
    this.stdnum,
    this.usertype,
    this.illnessList,
    this.allergiesList,
    this.isQuarantined,
    this.isAdmin,
    this.isUnderMonitoring,
    this.uid,
    this.empno,
    this.position,
    this.homeUnit,
  });

  // Factory constructor to instantiate object from json format
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      id: json['id'],
      name: json['name'],
      username: json['username'],
      college: json['college'],
      course: json['course'],
      stdnum: json['studentNum'],
      usertype: json["usertype"],
      illnessList: json["illnesses"],
      allergiesList: json["allergiesList"],
      isQuarantined: json['isQuarantined'],
      isAdmin: json['isAdmin'],
      isUnderMonitoring: json['isUnderMonitoring'],
      uid: json["uid"],
      empno: json["empno"],
      position: json["position"],
      homeUnit: json["homeUnit"],
    );
  }

  static List<UserModel> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<UserModel>((dynamic d) => UserModel.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(UserModel user) {
    return {
      'id': user.id,
      'email': user.email,
      'name': user.name,
      'username': user.username,
      'college': user.college,
      'course': user.course,
      'studentNum': user.stdnum,
      'usertype': user.usertype,
      'illnesses': user.illnessList,
      'allergiesList': user.allergiesList,
      'isQuarantined': user.isQuarantined,
      'isAdmin': user.isAdmin,
      'isUnderMonitoring': user.isUnderMonitoring,
      'uid': user.uid,
      'empno': user.empno,
      'position': user.position,
      'homeUnit': user.homeUnit,
    };
  }
}
