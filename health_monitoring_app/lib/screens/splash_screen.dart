import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:project_app/screens/welcome.dart';

class SplashScreen extends StatefulWidget {
  static const routename = '/';

  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Welcome())));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
          body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Kumusta",
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                        color: Color(0xFF56428F),
                        fontSize: 56.0,
                        fontWeight: FontWeight.w900))),
            SizedBox(
                width: 269,
                child: Image.asset(
                  'assets/images/The Lifesavers Hand and bone.png',
                  fit: BoxFit.fitWidth,
                ))
          ],
        ),
      )),
    );
  }
}
