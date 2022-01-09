import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_deer/core/theme/app_theme.dart';
import 'package:to_deer/features/services/auth_service.dart';

import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:to_deer/features/utils/auth_wrapper.dart';
import 'package:to_deer/features/utils/form_manager.dart';
import 'package:to_deer/features/utils/task_list_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => FormManager(),
      ),
      ChangeNotifierProvider(
        create: (_) => TaskListManager(),
      ),
      Provider<AuthService>(
        create: (_) => AuthService(FirebaseAuth.instance),
      ),
      StreamProvider(
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: null),
    ],
    child: MyApp(),
  ));
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            builder: (context, child) => MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            ),
            title: 'ToDeer',
            theme: appTheme,
            home: const AuthWrapper(),
            debugShowCheckedModeBanner: false,
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
