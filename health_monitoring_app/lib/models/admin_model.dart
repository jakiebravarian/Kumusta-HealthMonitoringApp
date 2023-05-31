import 'dart:convert';

class Admin {
  final String email;
  String? id;
  String name;
  int empNo;
  String position;
  String homeUnit;
  String? uid;

  Admin({
    required this.email,
    this.id,
    required this.name,
    required this.empNo,
    required this.position,
    required this.homeUnit,
    this.uid,
  });

  // Factory constructor to instantiate object from json format
  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
        email: json['email'],
        id: json['id'],
        name: json['name'],
        empNo: json['empNo'],
        position: json['position'],
        homeUnit: json['homeUnit'],
        uid: json["uid"]);
  }

  static List<Admin> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Admin>((dynamic d) => Admin.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Admin admin) {
    return {
      'email': admin.email,
      'name': admin.name,
      'empNo': admin.empNo,
      'position': admin.position,
      'homeUnit': admin.homeUnit,
      'uid': admin.uid
    };
  }
}
