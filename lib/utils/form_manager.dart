import 'package:flutter/cupertino.dart';

class FormManager extends ChangeNotifier {
  String loginErrorText = "";
  String singUpErrorText = "";

  void setLoginError(dynamic result) {
    if (result is String) {
      if (result == "invalid-email") {
        loginErrorText = "Please enter a valid email";
      } else if (result == "user-not-found") {
        loginErrorText = "There is no user with this information";
      } else if (result == "wrong-password") {
        loginErrorText = "Please check your password and try again.";
      } else {
        loginErrorText = "";
      }
      notifyListeners();
    }
  }

  void setSigUpError(dynamic result) {
    if (result is String) {
      if (result == "invalid-email") {
        singUpErrorText = "Please enter a valid email";
      } else if (result == "wrong-password") {
        singUpErrorText = "Please check your password and try again.";
      } else if (result == "email-already-in-use") {
        singUpErrorText = "There is already a user with that email.";
      } else if (result == "weak-password") {
        singUpErrorText = "Password should be longer than 6 characters.";
      } else {
        singUpErrorText = "";
      }
      notifyListeners();
    }
  }
}
