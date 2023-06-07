import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../api/firebase_user_api.dart';
import '../models/log_model.dart';
import '../models/user_model.dart';
import '../api/firebase_log_api.dart';

class LogsProvider with ChangeNotifier {
  late FirebaseLogAPI firebaseService;

  // late Stream<QuerySnapshot> _allUserStream;

  late Stream<QuerySnapshot> _logStream;
  Stream<QuerySnapshot> get logStream => _logStream;

  LogsProvider() {
    firebaseService = FirebaseLogAPI();
    fetchLogs();
  }

  // Stream<QuerySnapshot> get allUserStream => _allUserStream;

  // void fetchAllUsers() {
  //   _allUserStream = firebaseService.getAlllogs();
  //   notifyListeners();
  // }

  fetchLogs() {
    _logStream = firebaseService.getAlllogs();
    notifyListeners();
  }

  void deleteEntry(String id) async {
    String message = await firebaseService.deleteLog(id);
    print(message);
    notifyListeners();
  }

  Future<Stream<QuerySnapshot<Object?>>> getUserLog(uid) async {
    return firebaseService.getLogUser(uid);
  }

  void addLog(Log log) async {
    String message = await firebaseService.addLog(log.toJson(log));
    print(message);
    notifyListeners();
  }
}
