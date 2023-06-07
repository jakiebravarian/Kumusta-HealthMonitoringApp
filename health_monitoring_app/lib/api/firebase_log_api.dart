import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseLogAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  // Future<String> addUser(Map<String, dynamic> user) async {
  //   try {
  //     final docRef = await db.collection("logs").add(user);
  //     await db.collection("logs").doc(docRef.id).update({'id': docRef.id});

  //     return "New user was added!";
  //   } on FirebaseException catch (e) {
  //     return "Failed with error '${e.code}: ${e.message}";
  //   }
  // }

  Stream<QuerySnapshot> getUser(userID) {
    return db.collection("logs").where("uid", isEqualTo: userID).snapshots();
  }

//collects all logs
  Stream<QuerySnapshot> getAlllogs() {
    return db.collection("logs").snapshots();
  }

  Stream<QuerySnapshot> updateLog(userID) {
    return db.collection("logs").where("uid", isEqualTo: userID).snapshots();
  }

  Future<String> deleteLog(String? id) async {
    try {
      await db.collection("logs").doc(id).delete();

      return "Successfully deleted todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}
