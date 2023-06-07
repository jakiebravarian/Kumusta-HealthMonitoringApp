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

  late Stream<QuerySnapshot> _allEntriesStream;
  Stream<QuerySnapshot> get allEntriesStream => _allEntriesStream;

  late Stream<QuerySnapshot> _streamOfEntriesRequestingForEdit;
  Stream<QuerySnapshot> get streamOfEntriesRequestingForEdit =>
      _streamOfEntriesRequestingForEdit;

  late Stream<QuerySnapshot> _streamOfEntriesRequestingForDelete;
  Stream<QuerySnapshot> get streamOfEntriesRequestingForDelete =>
      _streamOfEntriesRequestingForDelete;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  // late Stream<QuerySnapshot> _specificEntryStream;
  // Stream<QuerySnapshot> get specificEntryStream => _specificEntryStream;

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
    fetchEntriesRequestingForDelete();
    fetchEntriesRequestingForEdit();
  }

  void changeValueInSymptoms(key) {
    symptomsMap[key] = !symptomsMap[key]!;
    print(symptomsMap);
    notifyListeners();
  }

  void setIndex(index) {
    _currentIndex = index;
    notifyListeners();
  }

  void setEntry(entry) {
    _entry = entry;
    // notifyListeners();
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
    _entriesStream = firebaseService.getEntries(userID);
    _uid = userID;
    // notifyListeners();
  }

  fetchAllData() {
    _allEntriesStream = firebaseService.getAllEntries();
    // notifyListeners();
  }

  fetchEntriesRequestingForEdit() {
    _streamOfEntriesRequestingForEdit =
        firebaseService.getEntriesRequestingForEdit();
    // notifyListeners();
  }

  fetchEntriesRequestingForDelete() {
    _streamOfEntriesRequestingForDelete =
        firebaseService.getEntriesRequestingForDelete();
    // notifyListeners();
  }

  void addEntry(Entry entry) async {
    String message = await firebaseService.addEntry(entry.toJson(entry));
    print(message);
    // notifyListeners();
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

  void toggleIsEditApproved(id, status) async {
    String message = await firebaseService.toggleIsEditApproved(id, status);
    print(message);
    notifyListeners();
  }

  void toggleIsDeleteApproved(id, status) async {
    String message = await firebaseService.toggleIsDeleteApproved(id, status);
    print(message);
    // notifyListeners();
  }

  void toggleforEditApproval(id, status) async {
    String message = await firebaseService.toggleforEditApproval(id, status);
    print(message);
    // notifyListeners();
  }

  void toggleforDeleteApproval(id, status) async {
    String message = await firebaseService.toggleforDeleteApproval(id, status);
    print(message);
    // notifyListeners();
  }

  void editApprovalReason(id, reason) async {
    String message = await firebaseService.editApprovalReason(id, reason);
    print(message);
    // notifyListeners();
  }

  void deleteApprovalReason(id, reason) async {
    String message = await firebaseService.deleteApprovalReason(id, reason);
    print(message);
    // notifyListeners();
  }

  // void isEditApprovedListenable(id) {
  //   _specificEntryStream = firebaseService.getOneEntry(id);
  //   notifyListeners();
  // }

  // void toggleStatus(int index, bool status) {
  //   // _todoList[index].completed = status;
  //   print("Toggle Status");
  //   notifyListeners();
  // }
}
