import 'dart:convert';

class Entry {
  String? id;
  String date;
  bool isApproved;
  bool isExposed;
  List<String> symptoms;
  String userID;

  Entry({
    this.id,
    required this.date,
    required this.isApproved,
    required this.isExposed,
    required this.symptoms,
    required this.userID,
  });

  // Factory constructor to instantiate object from json format
  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      id: json['id'],
      date: json['date'],
      isApproved: json['isApporved'],
      isExposed: json['isExposed'],
      symptoms: json['symptoms'],
      userID: json['userID'],
    );
  }

  static List<Entry> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Entry>((dynamic d) => Entry.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Entry entry) {
    return {
      'date': entry.date,
      'isApproved': entry.isApproved,
      'isExposed': entry.isExposed,
      'symptoms': entry.symptoms,
      'userID': entry.userID,
    };
  }
}
