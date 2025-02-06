import 'package:flutter/material.dart';
import 'package:newsweather_app/components/bottomNavBar.dart';
import 'package:newsweather_app/forYouPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;

  Future<Map<String, String>> getUserData() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String name = preferences.getString('fullName') ?? '';
    String email = preferences.getString('email') ?? '';
    String location = preferences.getString('city') ?? 'Unknown Location';
    return {'name': name, 'email': email, 'location': location};
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });

      // Optionally, save the image path to SharedPreferences
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      await preferences.setString('profileImagePath', pickedFile.path);
    }
  }

  Future<void> _loadSavedImage() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String? imagePath = preferences.getString('profileImagePath');
    if (imagePath != null) {
      setState(() {
        _profileImage = File(imagePath);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSavedImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile Page',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Foryoupage()),
            );
          },
          icon: Icon(
            Icons.arrow_back_ios_new_sharp,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      ),
      body: FutureBuilder<Map<String, String>>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error loading profile data",
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            );
          } else {
            final data = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Picture
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : NetworkImage(
                              'https://via.placeholder.com/150',
                            ) as ImageProvider,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      child: _profileImage == null
                          ? Icon(
                              Icons.camera_alt,
                              size: 30,
                              color: Theme.of(context).colorScheme.onSecondary,
                            )
                          : null,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Name
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    child: ListTile(
                      leading: Icon(Icons.person,
                          color: Theme.of(context).colorScheme.primary),
                      title: Text(
                        data['name']!,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Email
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    child: ListTile(
                      leading: Icon(Icons.email,
                          color: Theme.of(context).colorScheme.primary),
                      title: Text(
                        data['email']!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Location
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    child: ListTile(
                      leading: Icon(Icons.location_on,
                          color: Theme.of(context).colorScheme.primary),
                      title: Text(
                        data['location']!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }
}
