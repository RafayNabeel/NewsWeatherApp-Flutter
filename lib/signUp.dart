import 'package:flutter/material.dart';
import 'package:newsweather_app/forYouPage.dart';
import 'package:newsweather_app/signIn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  final String fullNameKey = 'fullName';
  final String emailKey = 'email';
  final String cityKey = 'city';
  final String passwordKey = 'password';

  bool isLoading = false;
  bool isVerifying = false;
  User? currentUser;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    cityController.dispose();
    super.dispose();
  }

  Future<void> writeUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(fullNameKey, nameController.text);
    await prefs.setString(emailKey, emailController.text);
    await prefs.setString(cityKey, cityController.text);
    await prefs.setString(passwordKey, passController.text);
    await prefs.setBool('isLoggedIn', true);
  }


  Future <void> resetPassword() async {

      // User user = user.zZz

  }

  Future<void> signUp() async {
    if (emailController.text.isEmpty || passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );

      currentUser = userCredential.user;
      if (currentUser != null && !currentUser!.emailVerified) {
        await currentUser!.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "A verification email has been sent! Please verify your email.")),
        );

        setState(() {
          isVerifying = true;
        });

        checkEmailVerification();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to sign up: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void checkEmailVerification() async {
    while (currentUser != null && !currentUser!.emailVerified) {
      await Future.delayed(Duration(seconds: 3));
      await currentUser!.reload();
      currentUser = _auth.currentUser;

      if (currentUser!.emailVerified) {
        setState(() {
          isVerifying = false;
        });

        await writeUserData();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email verified! Redirecting...")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Foryoupage()),
        );
        return;
      }
    }
  }

  void refreshVerificationStatus() async {
    if (currentUser != null) {
      await currentUser!.reload();
      currentUser = _auth.currentUser;

      if (currentUser!.emailVerified) {
        setState(() {
          isVerifying = false;
        });

        await writeUserData();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email verified! Redirecting...")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Foryoupage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("Email not verified yet. Please check again later.")),
        );
      }
    }
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
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: signUp,
            icon: Icon(
              Icons.done,
              size: 35,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  buildTextField(nameController, "Enter your name"),
                  SizedBox(height: 20),
                  buildTextField(emailController, "Enter your email"),
                  SizedBox(height: 20),
                  buildTextField(passController, "Enter your password",
                      obscureText: true),
                  SizedBox(height: 20),
                  buildTextField(cityController, "Enter your city"),
                  SizedBox(height: 35),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.secondary),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInScreen()));
                    },
                    child: Text(
                      "Already have an account?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ),
                  if (isVerifying) ...[
                    SizedBox(height: 20),
                    Text(
                      "Waiting for email verification...",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: refreshVerificationStatus,
                      child: Text("Refresh Verification Status"),
                    ),
                  ]
                ],
              ),
            ),
    );
  }

  Widget buildTextField(TextEditingController controller, String hintText,
      {bool obscureText = false}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(20),
      ),
      height: 70,
      width: double.infinity,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontSize: 20,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
