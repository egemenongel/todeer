import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_deer/models/user.dart';
import 'package:to_deer/services/database_service.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  AuthService(this._firebaseAuth);
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  UserModel? _userFromFirebase(User? user) {
    return user != null ? UserModel(uid: user.uid, email: user.email) : null;
  }

  Future<dynamic> signUp({String? email, String? password}) async {
    try {
      UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email!, password: password!);
      User? user = credential.user;

      await DatabaseService(uid: user!.uid).updateUserData(email);
      return _userFromFirebase(user);
    } on FirebaseAuthException catch (e) {
      return e.code.toString();
    }
  }

  Future<dynamic> signIn({String? email, String? password}) async {
    try {
      UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email!, password: password!);
      User? user = credential.user;
      return _userFromFirebase(user);
    } on FirebaseAuthException catch (e) {
      return e.code.toString();
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
