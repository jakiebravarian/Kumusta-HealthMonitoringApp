import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthAPI {
  static final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<User?> getUser() {
    return auth.authStateChanges();
  }

  User? _currentUser;
  User? get getCurrentUser => _currentUser;

  // static String? _userIDLoggedIn;
  // String? get currentlyLoggedIn => _userIDLoggedIn;

  Future<String> signIn(String email, String password) async {
    UserCredential credential;
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      //let's print the object returned by signInWithEmailAndPassword
      //you can use this object to get the user's id, email, etc.
      _currentUser = auth.currentUser;
      print(credential.user?.uid);
      return credential.user!.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //possible to return something more useful
        //than just print an error message to improve UI/UX
        print('No user found for that email.');
        return e.code;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return e.code;
      }
    }
    return "";
  }

  Future<String> signUp(String email, String password) async {
    UserCredential credential;
    try {
      credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      //let's print the object returned by signInWithEmailAndPassword
      //you can use this object to get the user's id, email, etc.\
      print(credential);
      return credential.user!.uid;
    } on FirebaseAuthException catch (e) {
      //possible to return something more useful
      //than just print an error message to improve UI/UX
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return "email-already-in-use";
      }
    } catch (e) {
      print(e);
    }
    return "";
  }

  Future<void> signOut() async {
    auth.signOut();
  }
}
