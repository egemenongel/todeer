import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_deer/pages/authenticate/login_page.dart';
import 'package:to_deer/pages/authenticate/sign_up_page.dart';
import 'package:to_deer/pages/home/home_page.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool showLogin = true;
  void toggle() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();
    if (user != null) {
      return HomePage();
    }
    if (showLogin) {
      return LoginPage(toggleCallback: toggle);
    } else {
      return SignUpPage(toggleCallback: toggle);
    }
  }
}
