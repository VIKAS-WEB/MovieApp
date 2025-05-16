import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:git_example/Auth/SignIn.dart';
import 'package:git_example/utils/Colors.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _loading = false;
  String? _error;

  Future<void> _registerUser() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim());

      User? user = userCredential.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Registered Successfully"),
            backgroundColor: AppColorsForApp.bluePrimary,
          ),
        );

        Navigator.pushReplacement(
          context, 
          CupertinoPageRoute(builder: (_) => const SignIn()),
        );
      }
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
                  'Register to Flixora',
                  style: TextStyle(
                    fontSize: 28, 
                    fontWeight: FontWeight.bold, 
                    color: AppColorsForApp.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Create your account to continue watching.',
                  style: TextStyle(
                    fontSize: 16, 
                    color: AppColorsForApp.textSecondary,
                  ),
                ),
                const SizedBox(height: 30),

                Text(
                  'Name', 
                  style: TextStyle(
                    fontSize: 16, 
                    color: AppColorsForApp.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _nameController,
                  decoration: _inputDecoration('Mr. Alex Smith'),
                  style: TextStyle(color: AppColorsForApp.textPrimary),
                ),
                const SizedBox(height: 20),

                Text(
                  'Email', 
                  style: TextStyle(
                    fontSize: 16, 
                    color: AppColorsForApp.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  decoration: _inputDecoration('alex.smith@gmail.com'),
                  style: TextStyle(color: AppColorsForApp.textPrimary),
                ),
                const SizedBox(height: 20),

                Text(
                  'Password', 
                  style: TextStyle(
                    fontSize: 16, 
                    color: AppColorsForApp.textSecondary,
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
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ],

                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _registerUser,
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
                            'Sign Up', 
                            style: TextStyle(
                              fontSize: 18, 
                              color: AppColorsForApp.textPrimary,
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
                        CupertinoPageRoute(builder: (context) => const SignIn()),
                      );
                    },
                    child: Text(
                      'Already a user? Sign In',
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}