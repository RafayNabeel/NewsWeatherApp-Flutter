import 'package:flutter/material.dart';
import 'package:newsweather_app/forYouPage.dart'; // Ensure this file contains the definition of Foryoupage class
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});
  @override
  State<Signup> createState() => _SignupState();
}

FirebaseAuth _auth = FirebaseAuth.instance; // creatig an instance of firebase

class _SignupState extends State<Signup> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  final String fullNameKey = 'fullName';
  final String emailKey = 'email';
  final String cityKey = 'city';
  final String passwordKey = 'password';

  Future<void> writeUserData() async {
    final SharedPreferences prefrnc = await SharedPreferences.getInstance();

    await prefrnc.setString(fullNameKey, nameController.text);
    await prefrnc.setString(emailKey, emailController.text);
    await prefrnc.setString(cityKey, cityController.text);
    await prefrnc.setString(passwordKey, passController.text);

    await prefrnc.setBool('isLoggedIn', true); // log in flag
  }

  Future<void> readAndPrintUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? fullName = prefs.getString('fullName');
    String? email = prefs.getString('email');
    String? city = prefs.getString('city');
    String? password = prefs.getString('password');

    print("Reading Saved User Data:");

    print("Full Name: $fullName");
    print("Email: $email");
    print("City: $city");
    print("Password: $password");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,

      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: 35,
              fontWeight: FontWeight.bold),
        ),
        // actions Button -> will complete sign Up
        actions: [
          IconButton(
            onPressed: () {
              writeUserData();
              readAndPrintUserData();
              _auth.createUserWithEmailAndPassword(
                  email: emailController.text.toString(), password: passController.text.toString());
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Foryoupage(
                      // userName: nameController.text,
                      ),
                ),
              );
            },
            icon: Icon(
              Icons.done,
              size: 35,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      // body
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(20)),
                height: 70,
                width: 350,
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Enter your name",
                    hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontSize: 20),
                    border: InputBorder.none,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(20)),
                height: 70,
                width: 350,
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Enter your email",
                    hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontSize: 20),
                    border: InputBorder.none,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(20)),
                height: 70,
                width: 350,
                child: TextField(
                  controller: passController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Enter your password",
                    hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontSize: 20),
                    border: InputBorder.none,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(20)),
                height: 70,
                width: 350,
                child: TextField(
                  controller: cityController,
                  decoration: InputDecoration(
                    hintText: "Enter your city",
                    hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontSize: 20),
                    border: InputBorder.none,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
