import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_example/Auth/SignUp.dart';
import 'package:git_example/Home/HomeScreen.dart';
import 'package:git_example/utils/Colors.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _signInUser() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Login Successful"),
          backgroundColor: AppColorsForApp.bluePrimary,
        ),
      );

      Navigator.pushReplacement(
        context, 
        CupertinoPageRoute(builder: (context) => const Homescreen()),
      );

    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = e.message;
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsForApp.blackPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: AppColorsForApp.textPrimary),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 30),
                Text(
                  'Login to Flixora',
                  style: TextStyle(
                    fontSize: 28, 
                    fontWeight: FontWeight.bold, 
                    color: AppColorsForApp.textPrimary
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Please enter your details.',
                  style: TextStyle(
                    fontSize: 16, 
                    color: AppColorsForApp.textSecondary
                  ),
                ),
                const SizedBox(height: 30),

                Text(
                  'Email', 
                  style: TextStyle(
                    fontSize: 16, 
                    color: AppColorsForApp.textSecondary
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  decoration: _inputDecoration('devinrohan@gmail.com'),
                  style: TextStyle(color: AppColorsForApp.textPrimary),
                ),
                const SizedBox(height: 20),

                Text(
                  'Password', 
                  style: TextStyle(
                    fontSize: 16, 
                    color: AppColorsForApp.textSecondary
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: _inputDecoration('••••••••'),
                  style: TextStyle(color: AppColorsForApp.textPrimary),
                ),

                if (_error != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    _error!, 
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ],

                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _signInUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColorsForApp.bluePrimary,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                      shadowColor: AppColorsForApp.bluePrimaryWithOpacity(0.3),
                    ),
                    child: _loading
                        ? CircularProgressIndicator(
                            color: AppColorsForApp.textPrimary,
                          )
                        : Text(
                            'Login', 
                            style: TextStyle(
                              fontSize: 18, 
                              color: AppColorsForApp.textPrimary
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => const SignUp()),
                      );
                    },
                    child: Text(
                      'New user? Sign up',
                      style: TextStyle(
                        fontSize: 14, 
                        color: AppColorsForApp.blueLight,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: AppColorsForApp.blackSecondary,
      hintText: hint,
      hintStyle: TextStyle(color: AppColorsForApp.textDisabled),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: AppColorsForApp.bluePrimary,
          width: 1.5,
        ),
      ),
    );
  }
}