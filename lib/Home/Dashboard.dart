import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:google_api_availability/google_api_availability.dart';

import 'package:git_example/Home/MovieCard.dart';
import 'package:git_example/Home/TrendingCard.dart';
import 'package:git_example/utils/Colors.dart';

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  String? userName;
  bool isLoading = true;
  int _currentCarouselIndex = 0;
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  bool _isGooglePlayServicesAvailable = false;

  @override
  void initState() {
    super.initState();
    checkGooglePlayServices();
    fetchUserName();

    // Show animated dialog on page load after fetching remote config
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchAndShowDialog();
    });
  }

  Future<void> checkGooglePlayServices() async {
    try {
      GooglePlayServicesAvailability availability =
          await GoogleApiAvailability.instance.checkGooglePlayServicesAvailability();
      setState(() {
        _isGooglePlayServicesAvailable = availability == GooglePlayServicesAvailability.success;
      });
      if (!_isGooglePlayServicesAvailable) {
        print('Google Play Services not available: $availability');
      } else {
        print('Google Play Services available');
      }
    } catch (e) {
      print('Error checking Google Play Services: $e');
      setState(() {
        _isGooglePlayServicesAvailable = false;
      });
    }
  }

  Future<void> initializeRemoteConfig() async {
    if (!_isGooglePlayServicesAvailable) {
      print('Skipping Remote Config initialization due to unavailable Google Play Services');
      return;
    }
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 0), // Set to 0 for testing
      ));
      await _remoteConfig.setDefaults({
        'dialog_message': 'New Movies Uploaded on 4 June Be Ready!',
        'dialog_date': '4 June',
        'show_dialog': true,
      });
      bool activated = await _remoteConfig.fetchAndActivate();
      print('Remote Config fetch and activate: ${activated ? "Success" : "No new data"}');
      
      // Log fetched values for debugging
      print('Fetched dialog_message: ${_remoteConfig.getString('dialog_message')}');
      print('Fetched dialog_date: ${_remoteConfig.getString('dialog_date')}');
      print('Fetched show_dialog: ${_remoteConfig.getBool('show_dialog')}');
    } catch (e) {
      print('Error initializing Remote Config: $e');
    }
  }

  Future<void> fetchAndShowDialog() async {
    if (!_isGooglePlayServicesAvailable) {
      print('Showing fallback dialog due to unavailable Google Play Services');
      showAnimatedDialog(
          context, 'New Movies Uploaded on 4 June Be Ready!', '4 June');
      return;
    }
    try {
      await initializeRemoteConfig();
      bool showDialog = _remoteConfig.getBool('show_dialog');
      print('Show dialog: $showDialog');
      if (showDialog) {
        String message = _remoteConfig.getString('dialog_message');
        String date = _remoteConfig.getString('dialog_date');
        print('Displaying dialog with message: $message, date: $date');
        showAnimatedDialog(context, message, date);
      } else {
        print('Dialog not shown as show_dialog is false');
      }
    } catch (e) {
      print('Error fetching dialog config: $e');
      // Fallback to default message
      showAnimatedDialog(
          context, 'New Movies Uploaded on 4 June Be Ready!', '4 June');
    }
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
      print("	Error fetching user data: $e");
      setState(() {
        userName = 'Guest';
        isLoading = false;
      });
    }
  }

  final List<Map<String, dynamic>> carouselItems = [
    {
      'image': 'assets/images/Alladin.png',
      'title': 'Aladdin',
      'year': '2019',
    },
    {
      'image': 'assets/images/jw3.png',
      'title': 'John Wick 3',
      'year': '2019',
    },
    {
      'image': 'assets/images/logan.jpg',
      'title': 'Logan',
      'year': '2017',
    },
    {
      'image': 'assets/images/cwar.png',
      'title': 'Captain America : Civil War',
      'year': '2016',
    },
  ];

  void showAnimatedDialog(BuildContext context, String message, String date) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Notice",
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "🎬 $message\nBe Ready!",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("OK"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsForApp.blackPrimary,
      appBar: AppBar(
        backgroundColor: AppColorsForApp.blackPrimary,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: CircleAvatar(
            radius: 16,
            backgroundColor: AppColorsForApp.textDisabled,
            child: const Icon(Icons.person,
                color: AppColorsForApp.textPrimary, size: 20),
          ),
        ),
        title: Text(
          'Welcome back, ${userName ?? "Guest"}',
          style: const TextStyle(
            color: AppColorsForApp.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search,
                color: AppColorsForApp.textPrimary, size: 24),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications,
                color: AppColorsForApp.textPrimary, size: 24),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 250,
              child: Stack(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 250,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      viewportFraction: 1.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentCarouselIndex = index;
                        });
                      },
                    ),
                    items: carouselItems.map((item) {
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(item['image']),
                            fit: BoxFit.cover,
                            opacity: 0.7,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'],
                                  style: const TextStyle(
                                    color: AppColorsForApp.textPrimary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  item['year'],
                                  style: TextStyle(
                                    color: AppColorsForApp.textPrimary
                                        .withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: carouselItems.asMap().entries.map((entry) {
                          int index = entry.key;
                          return Container(
                            width: _currentCarouselIndex == index ? 10 : 8,
                            height: _currentCarouselIndex == index ? 10 : 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentCarouselIndex == index
                                  ? AppColorsForApp.bluePrimary
                                  : AppColorsForApp.textDisabled,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Continue Watching',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColorsForApp.textPrimary,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,
                      size: 20, color: AppColorsForApp.textPrimary),
                ],
              ),
            ),
            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  MovieCard(
                    title: 'John Wick 3',
                    duration: '1h 2m',
                    imageUrl: 'assets/images/JWcover.png',
                  ),
                  MovieCard(
                    title: 'Logan',
                    duration: '1h 22m',
                    imageUrl: 'assets/images/LoganCover.png',
                  ),
                  MovieCard(
                    title: 'Lost City',
                    duration: '1h 22m',
                    imageUrl: 'assets/images/LostCityCover.jpg',
                  ),
                  MovieCard(
                    title: 'Chaava',
                    duration: '1h 12m',
                    imageUrl: 'assets/images/ChaavaPoster.jpg',
                  ),
                  MovieCard(
                    title: 'Avatar',
                    duration: '1h 22m',
                    imageUrl: 'assets/images/avatarCover.png',
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                'Trending',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColorsForApp.textPrimary,
                ),
              ),
            ),
            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  TrendingMovieCard(
                    title: 'Lost City',
                    imageUrl: 'assets/images/lostCity.jpg',
                  ),
                  TrendingMovieCard(
                    title: 'Captain America',
                    imageUrl: 'assets/images/cwar.png',
                  ),
                  TrendingMovieCard(
                    title: 'Logan',
                    imageUrl: 'assets/images/logan.jpg',
                  ),
                  TrendingMovieCard(
                    title: 'Chaava',
                    imageUrl: 'assets/images/chaava.png',
                  ),
                  TrendingMovieCard(
                    title: 'Captain America',
                    imageUrl: 'assets/images/cwar.png',
                  ),
                  TrendingMovieCard(
                    title: 'Captain America',
                    imageUrl: 'assets/images/cwar.png',
                  ),
                ],
              ),
            ),
          ],
            ),
      ),
    );
  }
}