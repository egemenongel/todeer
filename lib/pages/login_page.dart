import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_deer/services/auth_service.dart';

class LoginPage extends StatelessWidget {
  LoginPage({
    Key? key,
  }) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                  ),
                  TextFormField(
                    controller: passwordController,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
                onPressed: () {
                  context.read<AuthService>().signIn(
                      email: emailController.text,
                      password: passwordController.text);
                },
                child: const Text("Login")),
          ],
        ),
      ),
    );
  }
}
