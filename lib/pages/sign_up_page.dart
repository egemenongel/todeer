import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_deer/constants/form_constants.dart';
import 'package:to_deer/pages/login_page.dart';
import 'package:to_deer/services/auth_service.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({
    Key? key,
    this.toggleCallback,
  }) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final VoidCallback? toggleCallback;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    validator: (val) =>
                        val!.isEmpty ? "Please enter your email" : null,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.account_circle_rounded),
                        labelText: "E-mail",
                        border: formFieldBorder()),
                  ),
                  const SizedBox(height: 15.0),
                  TextFormField(
                    controller: passwordController,
                    validator: (val) =>
                        val!.isEmpty ? "Please enter your password" : null,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.vpn_key_rounded),
                        labelText: "Password",
                        border: formFieldBorder()),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<AuthService>().signUp(
                        email: emailController.text,
                        password: passwordController.text);
                  }
                },
                child: const Text("Sign Up")),
            //Error box
            const SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                const Expanded(
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1,
                    indent: 15,
                    endIndent: 5,
                  ),
                ),
                Text(
                  "OR",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                const Expanded(
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1,
                    indent: 5,
                    endIndent: 15,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: toggleCallback,
              child: const Text("LOGIN"),
            )
            //Snackbar -> succesfully created
          ],
        ),
      ),
    );
  }
}
