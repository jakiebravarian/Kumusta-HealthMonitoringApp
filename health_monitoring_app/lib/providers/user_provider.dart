import 'package:flutter/material.dart';
import '../api/firebase_admin_api.dart';
import '../api/firebase_user_api.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  late FirebaseUserAPI firebaseService;
  // late Stream<QuerySnapshot> _todosStream;
  // Todo? _selectedTodo;
  User? user = User();

  UserProvider() {
    firebaseService = FirebaseUserAPI();
  }

  User? get getUser => user;

  void setUserInfo1(name, username) {
    user?.name = name;
    user?.username = username;
  }

  void setUserInfo11(college, course, stdnum) {
    user?.college = college;
    user?.course = course;
    user?.stdnum = stdnum;
  }

  void setUserInfo2(illnesses) {
    user?.illnessList = illnesses;
  }

  void setUserInfo3(email) {
    user?.email = email;
  }

  // getter
  // Stream<QuerySnapshot> get todos => _todosStream;
  // Todo get selected => _selectedTodo!;

  // changeSelectedTodo(Todo item) {
  //   _selectedTodo = item;
  // }

  // void fetchTodos() {
  //   _todosStream = firebaseService.getAllTodos();
  //   notifyListeners();
  // }

  void addUser(User user) async {
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
