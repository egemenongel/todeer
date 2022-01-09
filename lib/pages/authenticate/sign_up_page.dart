import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_deer/core/contants/form_constants.dart';
import 'package:to_deer/core/extension/context_extension.dart';
import 'package:to_deer/services/auth_service.dart';
import 'package:to_deer/utils/form_manager.dart';

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
        body: SingleChildScrollView(
      child: Container(
        height: context.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xff050952),
            Color(0xff09119E),
          ]),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Image.asset(
              "images/icons/24.png",
              color: Colors.white,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    validator: (val) =>
                        val!.isEmpty ? "Please enter your email" : null,
                    decoration: InputDecoration(
                        filled: true,
                        prefixIcon: const Icon(Icons.account_circle_rounded),
                        labelText: "E-mail",
                        border: FormConstants.authFormBorder()),
                  ),
                  const SizedBox(height: 15.0),
                  TextFormField(
                    controller: passwordController,
                    validator: (val) =>
                        val!.isEmpty ? "Please enter your password" : null,
                    decoration: InputDecoration(
                        filled: true,
                        prefixIcon: const Icon(Icons.vpn_key_rounded),
                        labelText: "Password",
                        border: FormConstants.authFormBorder()),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    var result = await context.read<AuthService>().signUp(
                        email: emailController.text,
                        password: passwordController.text);
                    context.read<FormManager>().setSigUpError(result);
                  }
                },
                child: const Text("Sign Up")),
            const SizedBox(
              height: 5.0,
            ),
            Consumer<FormManager>(builder: (_, formManager, __) {
              return Text(
                formManager.singUpErrorText,
                style: const TextStyle(
                  color: Colors.red,
                ),
              );
            }),
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
    ));
  }
}
