import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseEntryAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addEntry(Map<String, dynamic> entry) async {
    try {
      final docRef = await db.collection("entries").add(entry);
      await db.collection("entries").doc(docRef.id).update({'id': docRef.id});

      return "Successfully added an entry!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllEntries(userID) {
    return db
        .collection("entries")
        .where("userID", isEqualTo: userID)
        .snapshots();
  }

  // Stream<QuerySnapshot> getAllEntries(String id) {
  //   return db.collection("entries").snapshots().where(() => false);
  // }

  // Future<String> deleteTodo(String? id) async {
  //   try {
  //     await db.collection("friends").doc(id).delete();

  //     return "Successfully removed friend!";
  //   } on FirebaseException catch (e) {
  //     return "Failed with error '${e.code}: ${e.message}";
  //   }
  // }

  // Future<String> editDetails(
  //     String? id,
  //     String nickname,
  //     int age,
  //     bool relStatus,
  //     double happinessLevel,
  //     String superpower,
  //     String motto) async {
  //   try {
  //     await db.collection("friends").doc(id).update({
  //       "nickname": nickname,
  //       "age": age,
  //       "relstatus": relStatus,
  //       "happinessLevel": happinessLevel,
  //       "superpower": superpower,
  //       "motto": motto
  //     });
  //     return "Successfully edited details!";
  //   } on FirebaseException catch (e) {
  //     return "Failed with error '${e.code}: ${e.message}";
  //   }
  // }
}
