import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<UserCredential?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred;
    } catch (e) {
      log("Error during registration: $e");
      return null; // Return null if something goes wrong
    }
  }

  Future<UserCredential?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred;
    } catch (e) {
      // Handle specific Firebase exceptions
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            log("No user found for that email.");
            return null;
          case 'wrong-password':
            log("Wrong password provided for that user.");
            return null;
          default:
            log("Error: ${e.message}");
            return null; // Handle other errors
        }
      } else {
        log("Something went wrong: $e");
        return null; // Fallback for other exceptions
      }
    }
  }

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log("Error during sign out: $e");
    }
  }
}
