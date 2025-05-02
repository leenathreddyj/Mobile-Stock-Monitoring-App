import 'dart:developer';                    // for log()
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUp(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      log('Sign‑up error', error: e, stackTrace: e.stackTrace);
      rethrow;                               // keeps original stack trace
    }
  }

  Future<User?> logIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      log('Log‑in error', error: e, stackTrace: e.stackTrace);
      rethrow;
    }
  }

  Future<void> logOut() => _auth.signOut();
}
