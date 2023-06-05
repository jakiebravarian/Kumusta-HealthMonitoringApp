import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../api/firebase_user_api.dart';
import '../models/user_model.dart';
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

}
