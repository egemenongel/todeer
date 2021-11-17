import 'package:flutter/cupertino.dart';

class FormManager extends ChangeNotifier {
  String loginErrorText = "";
  String errorText(String error) {
    loginErrorText = error;
    notifyListeners();
    return loginErrorText;
  }

  void errorSetter(dynamic result) {
    String error = "";
    if (result is String) {
      if (result == "invalid-email") {
        error = "Please enter a valid email";
      } else if (result == "user-not-found") {
        error = "There is no user with this information";
      } else if (result == "wrong-password") {
        error = "Please check your password and try again.";
      } else {
        error = "";
      }

      errorText(error);
    } else {
      errorText("");
    }
  }
}
