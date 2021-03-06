import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_deer/core/extension/context_extension.dart';
import 'package:provider/provider.dart';
import 'package:to_deer/features/services/auth_service.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width / 2,
      child: Drawer(
          child: Container(
        color: context.colors.secondaryVariant,
        child: ListView(
          children: [
            ListTile(
              title: CircleAvatar(
                child: const Icon(
                  Icons.person,
                ),
                backgroundColor: context.colors.primary,
              ),
            ),
            ListTile(
              title: Text(
                FirebaseAuth.instance.currentUser!.email ??
                    "You logged in as guest",
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              title: IconButton(
                  onPressed: () => context.read<AuthService>().signOut(),
                  icon: const Icon(
                    Icons.power_settings_new,
                    color: Colors.white,
                  )),
            )
          ],
        ),
      )),
    );
  }
}
