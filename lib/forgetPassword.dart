import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newsweather_app/signIn.dart';
import 'package:newsweather_app/signUp.dart';

class Forgetpassword extends StatefulWidget {
  Forgetpassword({super.key});

  @override
  State<Forgetpassword> createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword> {
  TextEditingController emailcontroller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> forgetPassword() async {
    String email = emailcontroller.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter your email")),
      );
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password reset link sent! Check your email.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Forget Password"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 35),
            Text(
              "Enter your email:",
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(20),
              ),
              width: 300,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: emailcontroller,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter your email",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.secondary),
              ),
              onPressed: () {
                forgetPassword();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignInScreen()));
                ;
              },
              child: Text(
                "Send Reset Link",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
