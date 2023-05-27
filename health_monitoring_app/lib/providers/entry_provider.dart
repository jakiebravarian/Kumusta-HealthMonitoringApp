import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_app/api/firebase_auth_api.dart';
import 'package:project_app/models/entry_model.dart';
import 'package:project_app/providers/user_provider.dart';

import '../api/firebase_entry_api.dart';

class EntryProvider with ChangeNotifier {
  late FirebaseEntryAPI firebaseService;
  late FirebaseAuthAPI firebaseAuth;

  late Stream<QuerySnapshot> _entriesStream;
  Stream<QuerySnapshot> get entriesData => _entriesStream;

  Map<String, bool> symptomsMap = {
    "Fever (37.8 C and above)": false,
    "Feeling feverish": false,
    "Muscle or joint pains": false,
    "Cough": false,
    "Colds": false,
    "Sore throat": false,
    "Difficulty of breathing": false,
    "Diarrhea": false,
    "Loss of taste": false,
    "Loss of smell": false
  };
  Map<String, bool> get symptoms => symptomsMap;

  UserProvider userProvider = UserProvider();

  String _uid = "";
  String get uid => _uid;

  Entry? _entry = Entry();
  Entry? get getEntry => _entry;

  bool _isExposed = false;
  bool _isUnderMonitoring = false;
  bool get isExposed => _isExposed;
  bool get isUnderMonitoring => _isUnderMonitoring;

  EntryProvider() {
    firebaseService = FirebaseEntryAPI();
    firebaseAuth = FirebaseAuthAPI();
    fetchData(uid);
  }

  void changeValueInSymptoms(key) {
    symptomsMap[key] = !symptomsMap[key]!;
    print(symptomsMap);
    notifyListeners();
  }

  void setEntry(entry) {
    _entry = entry;
    notifyListeners();
  }

  void resetSymptomsMap() {
    symptomsMap.forEach((key, value) {
      symptomsMap[key] = false;
    });
    _isExposed = false;
    _isUnderMonitoring = false;
    notifyListeners();
  }

  void toggleIsExposed() {
    _isExposed = !_isExposed;
    notifyListeners();
  }

  void toggleIsUnderMonitoring() {
    _isUnderMonitoring = !_isUnderMonitoring;
    notifyListeners();
  }

  fetchData(userID) {
    _entriesStream = firebaseService.getAllEntries(userID);
    _uid = userID;
    notifyListeners();
  }

  void addEntry(Entry entry) async {
    String message = await firebaseService.addEntry(entry.toJson(entry));
    print(message);
    notifyListeners();
  }

  void editEntry(Entry entry) async {
    String message = await firebaseService.editEntry(entry.toJson(entry));
    print("Entry in provider stage: ${entry.toJson(entry)}");
    print(message);
    notifyListeners();
  }

  void deleteEntry() async {
    String message = await firebaseService.deleteEntry(_entry!.id);
    print(message);
    notifyListeners();
  }

  // void toggleStatus(int index, bool status) {
  //   // _todoList[index].completed = status;
  //   print("Toggle Status");
  //   notifyListeners();
  // }
}
