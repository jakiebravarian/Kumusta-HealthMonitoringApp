import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Welcome extends StatefulWidget {
  static const routename = '/welcome';

  const Welcome({super.key});

  @override
  WelcomeState createState() => WelcomeState();
}

class WelcomeState extends State<Welcome> {
  @override
  void initState() {
    super.initState();
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
            Text("Hatdog",
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                        color: Color(0xFF56428F),
                        fontSize: 56.0,
                        fontWeight: FontWeight.w900))),
          ],
        ),
      )),
    );
  }
}
