import 'package:flutter/material.dart';

class Welcomescreen extends StatefulWidget {
  const Welcomescreen({super.key});

  @override
  State<Welcomescreen> createState() => _WelcomescreenState();
}

class _WelcomescreenState extends State<Welcomescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        title: Text(
          'Movie App',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black38,
      ),
      body: Center(
        child: Text('Welcome TO Movie App'),
      ),
    );
  }
}
