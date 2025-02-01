import 'dart:async';

import 'package:flutter/material.dart';
import 'package:newsweather_app/forYouPage.dart';

import 'package:newsweather_app/welcomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  Future<void> loginStatus() async {
    final SharedPreferences prefer = await SharedPreferences.getInstance();
    bool loggedIn = prefer.getBool('isLoggedIn') ?? false;

    prefer.getString("fullName");

    Timer(Duration(seconds: 4), () {
      if (loggedIn) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Foryoupage()));
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Welcomepage(),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Image.asset("lib/images/splashLogo.png"),
      ),
    );
  }
}
