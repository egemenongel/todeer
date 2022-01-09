import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_deer/pages/home/home_page.dart';

class EmailVerificationPage extends StatefulWidget {
  EmailVerificationPage({
    Key? key,
    this.uid,
    this.email,
  }) : super(key: key);
  String? uid;
  String? email;
  @override
  _EmailVerificationState createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerificationPage> {
  @override
  bool _isCreatingLink = false;
  void initState() {
    super.initState();

    //STREAM TO CHECK VERIFICATION ALL THE TIME?
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();
    if (user!.emailVerified) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              child: Text(
                  "Email verification is sent to this adress:${widget.email}")),
        ],
      ),
    ));
  }
}
