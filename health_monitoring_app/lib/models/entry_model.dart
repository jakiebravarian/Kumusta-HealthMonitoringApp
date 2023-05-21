import 'dart:convert';

class Entry {
  String? id;
  DateTime? date;
  bool? isApproved;
  bool? isExposed;
  bool? isUnderMonitoring;
  List<String>? symptoms;
  String? userID;

  Entry({
    this.id,
    this.date,
    this.isApproved,
    this.isExposed,
    this.isUnderMonitoring,
    this.symptoms,
    this.userID,
  });

  // Factory constructor to instantiate object from json format
  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      id: json['id'],
      date: json['date'],
      isApproved: json['isApporved'],
      isExposed: json['isExposed'],
      isUnderMonitoring: json['isUnderMonitoring'],
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
      'isUnderMonitoring': entry.isUnderMonitoring,
      'symptoms': entry.symptoms,
      'userID': entry.userID,
    };
  }
}
