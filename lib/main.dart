import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/pages/Authentication/login.dart';
import 'package:todo_app/pages/Authentication/sign_up.dart';
import 'package:todo_app/pages/add_page.dart';
import 'package:todo_app/pages/home_page.dart';
import 'package:todo_app/pages/splash_page.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options:DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     home: SplashPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
