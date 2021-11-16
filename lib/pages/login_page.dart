import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_deer/constants/form_constants.dart';
import 'package:to_deer/services/auth_service.dart';

class LoginPage extends StatelessWidget {
  LoginPage({
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
            Row(
              children: [
                const SizedBox(
                  width: 65,
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        var currentUser = await context
                            .read<AuthService>()
                            .signIn(
                                email: emailController.text,
                                password: passwordController.text);
                      }
                    },
                    child: const Text("Login")),
                const SizedBox(
                  width: 65,
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthService>().signInAnon();
                  },
                  child: const Text("Continue as guest"),
                )
              ],
            ),
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
              child: const Text("Sign Up"),
            )
          ],
        ),
      ),
    );
  }
}
