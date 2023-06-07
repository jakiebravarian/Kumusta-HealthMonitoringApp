import 'dart:convert';

class Entry {
  String? id;
  int? date;
  bool? isApproved;
  bool? isEditApproved;
  bool? isDeleteApproved;
  bool? editRequest;
  bool? deleteRequest;
  List<dynamic>? symptoms;
  String? editReason;
  String? deleteReason;
  String? submittedBy;
  String? stdnum;

  String? userID;

  Entry({
    this.id,
    this.date,
    this.isApproved,
    this.symptoms,
    this.userID,
    this.isEditApproved,
    this.isDeleteApproved,
    this.editRequest,
    this.deleteRequest,
    this.editReason,
    this.deleteReason,
    this.submittedBy,
    this.stdnum,
  });

  // Factory constructor to instantiate object from json format
  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      id: json['id'],
      date: json['date'],
      isApproved: json['isApporved'],
      symptoms: json['symptoms'],
      userID: json['userID'],
      isEditApproved: json["isEditApproved"],
      isDeleteApproved: json["isDeleteApproved"],
      editRequest: json["editRequest"],
      deleteRequest: json["deleteRequest"],
      editReason: json["editReason"],
      deleteReason: json["deleteReason"],
      submittedBy: json["submittedBy"],
      stdnum: json["stdnum"],
    );
  }

  static List<Entry> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Entry>((dynamic d) => Entry.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Entry entry) {
    return {
      'id': entry.id,
      'date': entry.date,
      'isApproved': entry.isApproved,
      'symptoms': entry.symptoms,
      'userID': entry.userID,
      'isEditApproved': entry.isEditApproved,
      'isDeleteApproved': entry.isDeleteApproved,
      'editRequest': entry.editRequest,
      'deleteRequest': entry.deleteRequest,
      'editReason': entry.editReason,
      'deleteReason': entry.deleteReason,
      'submittedBy': entry.submittedBy,
      'stdnum': entry.stdnum,
    };
  }
}
