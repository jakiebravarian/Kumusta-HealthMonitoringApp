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

  Stream<QuerySnapshot> getUser(userID) {
    return db.collection("users").where("uid", isEqualTo: userID).snapshots();
  }

  Stream<QuerySnapshot> getUserLog(userID) {
    return db.collection("users").where("id", isEqualTo: userID).snapshots();
  }

  Stream<QuerySnapshot> getQuarantinedUsers() {
    return db
        .collection("users")
        .where("isQuarantined", isEqualTo: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getUnderMonitoringUsers() {
    return db
        .collection("users")
        .where("isUnderMonitoring", isEqualTo: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getAllUsers() {
    return db.collection("users").snapshots();
  }

  Future<String> editUnderMonitoringStatus(id, bool status) async {
    print(id);
    try {
      await db
          .collection("users")
          .doc(id)
          .update({"isUnderMonitoring": status});
      return "Successfully edited monitoring status!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> editQuarantineStatus(id, bool status) async {
    print(id);
    try {
      await db.collection("users").doc(id).update({"isQuarantined": status});
      return "Successfully edited quarantine status!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> editUserType(id, String type) async {
    print(id);
    try {
      await db.collection("users").doc(id).update({"usertype": type});
      return "Successfully elevated user to admin!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}
