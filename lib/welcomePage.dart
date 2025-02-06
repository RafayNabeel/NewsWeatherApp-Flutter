import 'package:flutter/material.dart';
import 'package:newsweather_app/signUp.dart';

class Welcomepage extends StatelessWidget {
  const Welcomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2249D4), Color(0xFFE9EEFA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        top: true,
        bottom: false,
        child: Scaffold(
            // appBar: AppBar(
            //   toolbarHeight: 0,
            //   backgroundColor: Colors.transparent,
            // ),
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      child: Container(
                        height: 24,
                        width: 200,
                      ),
                    ),
                  ],
                ),
                Container(
                  color: Colors.blueAccent,
                  height: 400,
                  width: double.infinity,
                  child: Image.asset(
                    "lib/images/welcomeImage.png",
                  ),
                  alignment: AlignmentDirectional.topStart,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(32, 35, 31, 52),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Get The Latest News and Updates ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10,
                          width: 80,
                        ),
                        Text(
                          '''From Politics to Entertainment: Your One-Stop Source for Comprehensive Coverage of the Latest News and    Developments Across the Glob will be right on your hand''',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Signup(),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF416BD6),
                              borderRadius: BorderRadius.circular(128),
                            ),
                            height: 55,
                            width: 200,
                            child: Center(
                              child: Text(
                                "Explore ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Your content
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
