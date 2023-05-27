import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../api/firebase_user_api.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  late FirebaseUserAPI firebaseService;
  late Stream<QuerySnapshot> _userStream;

  UserModel? user = UserModel();

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
  }
  Map<String, bool> get preExistingIllness => _preExistingIllness;
  Map<String, bool> get allergies => _allergies;
  Stream<QuerySnapshot> get userStream => _userStream;

  UserModel? get getUser => user;

  void setUserInfo1(name, username) {
    user?.name = name;
    user?.username = username;
  }

  void setUserInfo11(college, course, stdnum) {
    user?.college = college;
    user?.course = course;
    user?.stdnum = stdnum;
  }

  void setUserInfo2(illnesses, allergies) {
    user?.illnessList = illnesses;
    user?.allergiesList = allergies;
  }

  void setUserInfo3(email) {
    user?.email = email;
  }

  void fetchUser(userID) {
    _userStream = firebaseService.getUser(userID);
    notifyListeners();
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
    notifyListeners();
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
