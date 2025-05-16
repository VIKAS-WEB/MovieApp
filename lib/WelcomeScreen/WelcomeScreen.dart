import 'package:flutter/material.dart';
import 'package:git_example/Auth/SignIn.dart';
import 'package:git_example/Auth/SignUp.dart';
import 'package:git_example/Home/HomeScreen.dart';
import 'package:git_example/utils/Colors.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Precache images
    precacheImage(const AssetImage('assets/images/lostCity.jpg'), context);
    precacheImage(const AssetImage('assets/images/Alladin.png'), context);
    precacheImage(const AssetImage('assets/images/jw3.png'), context);
    precacheImage(const AssetImage('assets/images/cnt.png'), context);
    precacheImage(const AssetImage('assets/images/logan.jpg'), context);
    precacheImage(const AssetImage('assets/images/cwar.png'), context);
    precacheImage(const AssetImage('assets/images/chaava.png'), context);
    precacheImage(const AssetImage('assets/images/Avatar.png'), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColorsForApp.blackPrimary,
                  AppColorsForApp.blackSecondary,
                ],
              ),
            ),
            child: Opacity(
              opacity: 0.2,
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  Image.asset('assets/images/lostCity.jpg', fit: BoxFit.cover),
                  Image.asset('assets/images/Alladin.png', fit: BoxFit.cover),
                  Image.asset('assets/images/jw3.png', fit: BoxFit.cover),
                  Image.asset('assets/images/cnt.png', fit: BoxFit.cover),
                  Image.asset('assets/images/logan.jpg', fit: BoxFit.cover),
                  Image.asset('assets/images/cwar.png', fit: BoxFit.cover),
                  Image.asset('assets/images/chaava.png', fit: BoxFit.cover),
                  Image.asset('assets/images/Avatar.png', fit: BoxFit.cover),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColorsForApp.textPrimary,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Image.asset('assets/images/logo.png', fit: BoxFit.cover,)),
                      ),
                      SizedBox(width: 10,),
                      Text(
                        'Flixora',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColorsForApp.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      const Text(
                        'Your Gateway to the Greatest Shows & Movies',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColorsForApp.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Discover an endless library of must-watch movies and series, curated just for you, anytime, anywhere.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColorsForApp.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignIn()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColorsForApp.bluePrimary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 120,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                          shadowColor: AppColorsForApp.bluePrimaryWithOpacity(0.5),
                        ),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 18, 
                            color: AppColorsForApp.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                              color: AppColorsForApp.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUp(),
                                ),
                              );
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: AppColorsForApp.blueLight,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}