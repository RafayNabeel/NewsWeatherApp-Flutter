import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:newsweather_app/forYouPage.dart';
import 'package:newsweather_app/forgetPassword.dart';
import 'package:newsweather_app/signUp.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    clientId:
        "605410622339-ios-0763b00fae4e2b0e7c54b6.apps.googleusercontent.com", // iOS Client ID
  );

  // Google Sign-In Method
  // Future<User?> signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     if (googleUser == null) return null; // User canceled sign-in

  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     final OAuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     UserCredential userCredential =
  //         await _auth.signInWithCredential(credential);

  //     return userCredential.user;
  //   } catch (e) {
  //     print("Error signing in with Google: $e");
  //     return null;
  //   }
  // }

  Future<void> resetPassword() async {
    // Add your reset password logic here
  }

  // Sign-Out Method
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Email TextField
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // Password TextField
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            // Sign In Button (Email/Password)
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.secondary)),
              onPressed: () async {
                try {
                  UserCredential userCredential =
                      await _auth.signInWithEmailAndPassword(
                    email: _emailController.text.toString(),
                    password: _passwordController.text.toString(),
                  );
                  print("Signed in with Email: ${userCredential.user?.email}");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Foryoupage()),
                  );
                } catch (e) {
                  print("Error signing in with email: $e");
                  // Display error to the user
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Sign In Error"),
                      content:
                          Text("Failed to sign in with email and password."),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("OK"),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text(
                'Sign In',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
            SizedBox(height: 10),
            // Register Now Button
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.secondary)),
              onPressed: () {
                // Navigate to Registration screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Signup()),
                );
              },
              child: Text(
                'Register Now',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Google Sign In Button
            ElevatedButton.icon(
              onPressed: () {
                // Add your Google Sign-In logic here
                print("forget");
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Forgetpassword(),
                    ));
                // User? user = await signInWithGoogle();
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.secondary)),
              icon: Icon(Icons.password_sharp),
              label: Text(
                'Reset password',
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
