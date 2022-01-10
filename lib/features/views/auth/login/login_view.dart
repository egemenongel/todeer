import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_deer/core/components/buttons/white_elevated_button.dart';
import 'package:to_deer/core/contants/form_constants.dart';
import 'package:to_deer/core/extension/context_extension.dart';
import 'package:to_deer/features/services/auth_service.dart';
import 'package:to_deer/features/utils/form_manager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
    this.toggleCallback,
  }) : super(key: key);
  final VoidCallback? toggleCallback;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: context.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xffAC2216),
                Color(0xffCA6357),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Expanded(
                flex: 11,
                child: buildLogo(),
              ),
              const Spacer(
                flex: 2,
              ),
              Expanded(
                flex: 7,
                child: buildForm(),
              ),
              Expanded(
                flex: 4,
                child: buildLoginButtons(context),
              ),
              Expanded(
                flex: 2,
                child: buildErrorText(),
              ),
              Expanded(
                child: buildDivider(context),
              ),
              Expanded(
                flex: 2,
                child: buildSignUpButton(context),
              ),
              const Spacer(
                flex: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  SafeArea buildLogo() {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            context.normalRadius,
          ),
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
        child: Image.asset(
          "images/icons/ToDeer.png",
          color: context.colors.secondary,
        ),
      ),
    );
  }

  Form buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            validator: (val) => val!.isEmpty ? "Please enter your email" : null,
            decoration: InputDecoration(
              filled: true,
              prefixIcon: const Icon(
                Icons.account_circle_rounded,
              ),
              labelText: "E-mail",
              border: FormConstants.authFormBorder(),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                borderSide: BorderSide(
                  color: Color(0xffB9584F),
                ),
              ),
              focusedBorder: FormConstants.authFormBorder(),
            ),
            textInputAction: TextInputAction.next,
          ),
          const Spacer(),
          TextFormField(
            controller: passwordController,
            validator: (val) =>
                val!.isEmpty ? "Please enter your password" : null,
            decoration: InputDecoration(
              filled: true,
              prefixIcon: const Icon(
                Icons.vpn_key_rounded,
              ),
              labelText: "Password",
              border: FormConstants.authFormBorder(),
              enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  borderSide: BorderSide(
                    color: Color(0xffB9584F),
                  )),
              focusedBorder: FormConstants.authFormBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Row buildLoginButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              var result = await context.read<AuthService>().signIn(
                  email: emailController.text,
                  password: passwordController.text);
              context.read<FormManager>().setLoginError(result);
            }
          },
          child: const Text("Login"),
        ),
        WhiteElevatedButton(
          onPressed: () {
            context.read<AuthService>().signInAnon();
          },
          child: const Text("Login as Guest"),
        )
      ],
    );
  }

  Consumer<FormManager> buildErrorText() {
    return Consumer<FormManager>(
      builder: (_, formManager, __) {
        return Text(
          formManager.loginErrorText,
        );
      },
    );
  }

  Row buildDivider(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: context.colors.secondary,
            thickness: 1,
            indent: 15,
            endIndent: 5,
          ),
        ),
        Text(
          "OR",
          style: TextStyle(
            color: context.colors.onPrimary,
          ),
        ),
        Expanded(
          child: Divider(
            color: context.colors.secondary,
            thickness: 1,
            indent: 5,
            endIndent: 15,
          ),
        ),
      ],
    );
  }

  TextButton buildSignUpButton(BuildContext context) {
    return TextButton(
      onPressed: widget.toggleCallback,
      child: Text(
        "Sign Up",
        style: TextStyle(color: context.colors.secondary),
      ),
    );
  }
}
