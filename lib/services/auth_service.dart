import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  AuthService(this._firebaseAuth);
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String?> signUp({String? email, String? password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email!, password: password!);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      return e.code;
    }
  }

  Future signIn({String? email, String? password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email!, password: password!);
      print(_firebaseAuth.currentUser!.uid);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      return e.code;
    }
  }

  Future signInAnon() async {
    try {
      await _firebaseAuth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }

  void signOut() async {
    await _firebaseAuth.signOut();
  }
}
