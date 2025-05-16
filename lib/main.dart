import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:git_example/Auth/SignIn.dart';
import 'package:git_example/Home/HomeScreen.dart';
import 'package:git_example/Home/Profile.dart';
import 'package:git_example/WelcomeScreen/WelcomeScreen.dart';
import 'package:git_example/utils/Colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flixora',
      theme: ThemeData(
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColorsForApp.blackPrimary, // This could override your color
    ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}
