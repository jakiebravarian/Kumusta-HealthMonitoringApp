import 'package:flutter/material.dart';
import 'package:project_app/models/entry_model.dart';
import '../api/firebase_admin_api.dart';
import '../api/firebase_entry_api.dart';
import '../api/firebase_user_api.dart';
import '../models/user_model.dart';

class EntryProvider with ChangeNotifier {
  late FirebaseEntryAPI firebaseService;
  // late Stream<QuerySnapshot> _todosStream;
  // Todo? _selectedTodo;

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

  Map<String, bool> isExposed = {"Yes": false, "No": false};
  Map<String, bool> isUnderMonitoring = {"Yes": false, "No": false};

  Entry? entry = Entry();

  EntryProvider() {
    firebaseService = FirebaseEntryAPI();
  }

  Entry? get getEntry => entry;
  Map<String, bool> get symptoms => symptomsMap;
  Map<String, bool> get exp => isExposed;
  Map<String, bool> get monitoring => isUnderMonitoring;

  void changeValueInSymptoms(key, value) {
    symptomsMap[key] = value;
    notifyListeners();
  }

  void toggleIsExposed(value) {
    if (value == "Yes") {
      isExposed[value] = true;
      isExposed["No"] = false;
    } else {
      isExposed[value] = true;
      isExposed["Yes"] = false;
    }

    notifyListeners();
  }

  void toggleIsUnderMonitoring(value) {
    if (value == "Yes") {
      isUnderMonitoring[value] = true;
      isUnderMonitoring["No"] = false;
    } else {
      isUnderMonitoring[value] = true;
      isUnderMonitoring["Yes"] = false;
    }
    notifyListeners();
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

  void addEntry(Entry entry) async {
    String message = await firebaseService.addEntry(entry.toJson(entry));
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
