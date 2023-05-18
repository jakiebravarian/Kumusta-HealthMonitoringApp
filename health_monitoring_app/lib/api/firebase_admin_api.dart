import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAdminAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addAdmin(Map<String, dynamic> admin) async {
    try {
      final docRef = await db.collection("admin").add(admin);
      await db.collection("admin").doc(docRef.id).update({'id': docRef.id});

      return "New user was added!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}
