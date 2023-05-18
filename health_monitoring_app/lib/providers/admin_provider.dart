import 'package:flutter/material.dart';
import '../api/firebase_admin_api.dart';
import '../models/admin_model.dart';

class AdminProvider with ChangeNotifier {
  late FirebaseAdminAPI firebaseService;
  // late Stream<QuerySnapshot> _todosStream;
  // Todo? _selectedTodo;

  AdminProvider() {
    firebaseService = FirebaseAdminAPI();
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

  void addAdmin(Admin admin) async {
    String message = await firebaseService.addAdmin(admin.toJson(admin));
    print(message);
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
