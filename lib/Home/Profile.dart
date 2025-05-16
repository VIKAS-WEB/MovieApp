import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  Uint8List? _webImage;
  String? _errorMessage;
  String? _profileImageUrl;
  String username = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      setState(() {
        _profileImageUrl = userDoc['profile_images'];
        username = userDoc['name'] ?? "User";
        email = userDoc['email'] ?? "user@example.com";
      });
    } catch (e) {
      print("Failed to load profile: $e");
    }
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Upload from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickAndUploadImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickAndUploadImage(ImageSource.camera);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickAndUploadImage(ImageSource source) async {
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        setState(() {
          _errorMessage = 'User not authenticated';
        });
        return;
      }

      String uid = FirebaseAuth.instance.currentUser!.uid;
      Reference storageRef =
          FirebaseStorage.instance.ref().child('profile_images/$uid.jpg');
      print('Storage Reference Path: ${storageRef.fullPath}');

      if (kIsWeb) {
        FilePickerResult? result =
            await FilePicker.platform.pickFiles(type: FileType.image);
        if (result != null && result.files.single.bytes != null) {
          Uint8List fileBytes = result.files.single.bytes!;
          print('Uploading image for web user: $uid');
          UploadTask uploadTask = storageRef.putData(fileBytes);
          TaskSnapshot snapshot = await uploadTask;
          String downloadUrl = await snapshot.ref.getDownloadURL();
          print('Download URL: $downloadUrl');
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .update({'profile_images': downloadUrl});

          setState(() {
            _webImage = fileBytes;
            _profileImageUrl = downloadUrl;
            _errorMessage = null;
          });
        } else {
          setState(() {
            _errorMessage = 'No image selected';
          });
        }
      } else {
        final pickedFile =
            await ImagePicker().pickImage(source: source, imageQuality: 70);
        if (pickedFile != null) {
          File imageFile = File(pickedFile.path);
          print('Uploading image for mobile user: $uid');
          UploadTask uploadTask = storageRef.putFile(imageFile);
          TaskSnapshot snapshot = await uploadTask;
          String downloadUrl = await snapshot.ref.getDownloadURL();
          print('Download URL: $downloadUrl');
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .update({'profile_images': downloadUrl});

          setState(() {
            _image = imageFile;
            _profileImageUrl = downloadUrl;
            _errorMessage = null;
          });
        } else {
          setState(() {
            _errorMessage = 'No image selected';
          });
        }
      }
    } catch (e, stackTrace) {
      print('Image upload failed: $e');
      print('Stack trace: $stackTrace');
      setState(() {
        _errorMessage = 'Image upload failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue[200],
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : _webImage != null
                            ? MemoryImage(_webImage!)
                            : _profileImageUrl != null
                                ? NetworkImage(_profileImageUrl!)
                                : null,
                    child: (_image == null &&
                            _webImage == null &&
                            _profileImageUrl == null)
                        ? const Icon(Icons.person, size: 60, color: Colors.white)
                        : null,
                  ),
                  GestureDetector(
                    onTap: _showImageSourceOptions,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt, size: 20),
                    ),
                  ),
                ],
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(_errorMessage!,
                      style: const TextStyle(color: Colors.red)),
                ),
              const SizedBox(height: 16),
              Text(
                username,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                height: 40,
                child: OutlinedButton(
                  onPressed: () {
                    // Navigator.push(context, CupertinoPageRoute(builder: (_) => EditProfilePage()));
                  },
                  child: const Text("Edit Profile",
                      style: TextStyle(color: Colors.white)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 2,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.credit_card),
                      title: const Text("My Subscription"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text("Parental Controls"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.ad_units),
                      title: const Text("Linked Devices"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.subscriptions),
                      title: const Text("My Watch History"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.privacy_tip),
                      title: const Text("Privacy Policy"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.headphones),
                      title: const Text("Contact Us"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.delete),
                      title: const Text("Delete Account"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}