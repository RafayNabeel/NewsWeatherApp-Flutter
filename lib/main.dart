import 'package:flutter/material.dart';
import 'package:newsweather_app/Themes/darkMode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:newsweather_app/firebase_options.dart';
import 'package:newsweather_app/signIn.dart';
import 'package:newsweather_app/splashScreen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignInScreen(),
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
    );
  }
}
