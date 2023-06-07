import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../api/firebase_user_api.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  late FirebaseUserAPI firebaseService;
  late Stream<QuerySnapshot> _userStream;
  late Stream<QuerySnapshot> _allUserStream;
  late Stream<QuerySnapshot> _allUserLogStream;
  UserModel? _user = UserModel();
  UserModel? admin = UserModel();
  UserModel? _userLog = UserModel();

  static final Map<String, bool> _preExistingIllness = {
    "Hypertension": false,
    "Diabetes": false,
    "Tuberculosis": false,
    "Cancer": false,
    "Kidney Disease": false,
    "Cardiac Disease": false,
    "Autoimmune Disease": false,
    "Asthma": false,
  };

  static final Map<String, bool> _allergies = {
    "Allergic Rhinitis": false,
    "Allergic Conjunctivitis": false,
    "Food": false,
    "Skin": false,
    "Others": false
  };

  UserProvider() {
    firebaseService = FirebaseUserAPI();
    fetchUser("");
    fetchAllUsers();
    fetchQuarantinedUsers();
    fetchUnderMonitoringUsers();
  }

  Map<String, bool> get preExistingIllness => _preExistingIllness;
  Map<String, bool> get allergies => _allergies;
  Stream<QuerySnapshot> get userStream => _userStream;
  Stream<QuerySnapshot> get allUserStream => _allUserStream;
  Stream<QuerySnapshot> get allUserLogStream => _allUserLogStream;
  UserModel? get getUser => _user;
  UserModel? get getAdminUser => admin;
  bool _hasScanned = false;
  bool get hasScanned => _hasScanned;

  UserModel? get userLog => _userLog;

  void setUserInfo1(name, username) {
    _user?.name = name;
    _user?.username = username;
  }

  setHasScanned(flag) {
    _hasScanned = flag;
  }

  void setUserInfo11(college, course, stdnum) {
    _user?.college = college;
    _user?.course = course;
    _user?.stdnum = stdnum;
  }

  void setUserInfo2(illnesses, allergies) {
    _user?.illnessList = illnesses;
    _user?.allergiesList = allergies;
  }

  void setUserInfo3(email) {
    _user?.email = email;
  }

  void setUser(UserModel user) {
    _user = user;
  }

  void setUserLog(UserModel user) {
    _userLog = user;
    notifyListeners();
  }

  void fetchUser(userID) {
    _userStream = firebaseService.getUser(userID);
    // notifyListeners();
  }

  void fetchAllUsers() {
    _allUserLogStream = firebaseService.getAllUsers();
    // notifyListeners();
  }

  void fetchQuarantinedUsers() {
    _allUserStream = firebaseService.getQuarantinedUsers();
    // notifyListeners();
  }

  void fetchUnderMonitoringUsers() {
    _allUserStream = firebaseService.getUnderMonitoringUsers();
    // notifyListeners();
  }

  void changeValueInPreexistingIllness(key) {
    _preExistingIllness[key] = !_preExistingIllness[key]!;
    print(_preExistingIllness);
    notifyListeners();
  }

  void changeValueInAllergies(key) {
    _allergies[key] = !_allergies[key]!;
    print(_allergies);
    notifyListeners();
  }

  void addUser(UserModel user) async {
    String returnValue = await firebaseService.addUser(user.toJson(user));
    print(returnValue);
    // notifyListeners();
  }

  void reset() {
    _preExistingIllness.forEach((key, value) {
      _preExistingIllness[key] = false;
    });
    _allergies.forEach((key, value) {
      _allergies[key] = false;
    });

    notifyListeners();
  }

  void editUnderMonitoringStatus(id, status) async {
    String message =
        await firebaseService.editUnderMonitoringStatus(id, status);
    print(message);
    // notifyListeners();
  }

  void editQuarantineStatus(id, status) async {
    String message = await firebaseService.editQuarantineStatus(id, status);
    print(message);
    // notifyListeners();
  }

  void editUserType(id, type) async {
    String message = await firebaseService.editUserType(id, type);
    print(message);
    // notifyListeners();
  }

  // void editTodo(int index, String newTitle) {
  //   // _todoList[index].title = newTitle;
  //   print("Edit");
  //   notifyListeners();
  // }

  // void deleteTodo() async {
  //   String message = await firebaseService.deleteTodo(_selectedTodo!.id);
  //   print(message);
  //   notifyListeners();
  // }

  // void toggleStatus(int index, bool status) {
  //   // _todoList[index].completed = status;
  //   print("Toggle Status");
  //   notifyListeners();
  // }
}
