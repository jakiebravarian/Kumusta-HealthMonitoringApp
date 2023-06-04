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

  Stream<QuerySnapshot> getEntries(userID) {
    return db
        .collection("entries")
        .where("userID", isEqualTo: userID)
        .snapshots();
  }

  Stream<QuerySnapshot> getEntriesRequestingForEdit() {
    return db
        .collection("entries")
        .where("editRequest", isEqualTo: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getEntriesRequestingForDelete() {
    return db
        .collection("entries")
        .where("deleteRequest", isEqualTo: true)
        .snapshots();
  }

  // Stream<QuerySnapshot> getOneEntry(entryID) {
  //   return db.collection("entries").where("id", isEqualTo: entryID).snapshots();
  // }

  Stream<QuerySnapshot> getAllEntries() {
    return db.collection("entries").snapshots();
  }
  // Stream<QuerySnapshot> getAllEntries(String id) {
  //   return db.collection("entries").snapshots().where(() => false);
  // }

  Future<String> deleteEntry(String? id) async {
    try {
      await db.collection("entries").doc(id).delete();

      return "Successfully removed friend!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> editEntry(Map<String, dynamic> entry) async {
    print(entry["id"]);
    try {
      await db.collection("entries").doc(entry["id"]).update(entry);
      return "Successfully edited details!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> toggleIsEditApproved(entryID, bool status) async {
    print(entryID);
    try {
      await db
          .collection("entries")
          .doc(entryID)
          .update({"isEditApproved": status});
      return "Successfully toggled edit request status!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> toggleIsDeleteApproved(entryID, bool status) async {
    print(entryID);
    try {
      await db
          .collection("entries")
          .doc(entryID)
          .update({"isDeleteApproved": status});
      return "Successfully toggled delete request status!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> toggleforEditApproval(entryID, bool status) async {
    print(entryID);
    try {
      await db
          .collection("entries")
          .doc(entryID)
          .update({"editRequest": status});
      return "Successfully toggled edit approval flag!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> toggleforDeleteApproval(entryID, bool status) async {
    print(entryID);
    try {
      await db
          .collection("entries")
          .doc(entryID)
          .update({"deleteRequest": status});
      return "Successfully toggled delete approval flag!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> editApprovalReason(entryID, String reason) async {
    print(entryID);
    try {
      await db
          .collection("entries")
          .doc(entryID)
          .update({"editReason": reason});
      return "Successfully sent reason for edit";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> deleteApprovalReason(entryID, String reason) async {
    print(entryID);
    try {
      await db
          .collection("entries")
          .doc(entryID)
          .update({"deleteReason": reason});
      return "Successfully sent reason for delete";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  // Future<String> isEditApprovedListenable(id) async {
  //   print(id);
  //   try {
  //     await db.collection("entries").doc(id).update(entry);
  //     return "Successfully edited details!";
  //   } on FirebaseException catch (e) {
  //     return "Failed with error '${e.code}: ${e.message}";
  //   }
  // }
}
