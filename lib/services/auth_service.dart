import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  AuthService(this._firebaseAuth);
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  Future<String?> signIn({String? email, String? password}) async {
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
    _firebaseAuth.signInAnonymously();
  }

  void signOut() {
    _firebaseAuth.signOut();
  }
}
