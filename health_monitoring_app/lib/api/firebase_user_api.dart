import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUserAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addUser(Map<String, dynamic> user) async {
    try {
      final docRef = await db.collection("users").add(user);
      await db.collection("users").doc(docRef.id).update({'id': docRef.id});

      return "New user was added!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}
