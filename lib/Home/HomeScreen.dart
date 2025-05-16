import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:git_example/Home/Dashboard.dart';
import 'package:git_example/Home/Profile.dart';
import 'package:git_example/Home/Profile/EditProfile.dart';
import 'package:git_example/VideoStreaming.dart';
import 'package:git_example/utils/Colors.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  String? userName;
  bool isLoading = true;
  int _currentNavIndex = 0;
  int _currentCarouselIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        setState(() {
          userName = userDoc['name'];
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        userName = 'Guest';
        isLoading = false;
      });
    }
  }

  // List of screens for navigation
  final List<Widget> _screens = [
    const HomeScreenContent(),
    VideoStreamingScreen(),
    EditProfilePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsForApp.blackPrimary,
      body: IndexedStack(
        index: _currentNavIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColorsForApp.blackPrimary, // Changed to bluePrimary
        selectedItemColor: AppColorsForApp.blueDark, // Changed to white for contrast
        unselectedItemColor: AppColorsForApp.textDisabled,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 24),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videocam, size: 24),
            label: 'Streaming',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit, size: 24),
            label: 'Edit Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 24),
            label: 'Profile',
          ),
        ],
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
        },
      ),
    );
  }
}