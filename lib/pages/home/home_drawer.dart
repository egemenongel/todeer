import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_deer/services/auth_service.dart';
import 'package:to_deer/services/size_helper.dart';
import 'package:provider/provider.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: displayWidth(context) / 3,
      child: Drawer(
          child: Container(
        color: Colors.indigoAccent,
        child: ListView(
          children: [
            const ListTile(
              title: CircleAvatar(
                child: Icon(
                  Icons.person,
                ),
              ),
            ),
            ListTile(
              title: Text(
                "${FirebaseAuth.instance.currentUser!.email}",
                style: const TextStyle(
                  fontSize: 10.0,
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
