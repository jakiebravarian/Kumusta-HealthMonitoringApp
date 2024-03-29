import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/log_model.dart';
import '../api/firebase_log_api.dart';

class LogsProvider with ChangeNotifier {
  late FirebaseLogAPI firebaseService;

  late Stream<QuerySnapshot> _allUserStream;

  LogsProvider() {
    firebaseService = FirebaseLogAPI();

    fetchAllUsers();
  }

  Stream<QuerySnapshot> get allUserStream => _allUserStream;

  void fetchAllUsers() {
    _allUserStream = firebaseService.getAlllogs();
    notifyListeners();
  }

  void deleteEntry(String id) async {
    String message = await firebaseService.deleteLog(id);
    print(message);
    notifyListeners();
  }

  void addLog(Log log) async {
    String message = await firebaseService.addLog(log.toJson(log));
    print(message);
    notifyListeners();
  }
}
