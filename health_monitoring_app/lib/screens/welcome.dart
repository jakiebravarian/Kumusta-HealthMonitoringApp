import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Welcome extends StatefulWidget {
  static const routename = '/';

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
      theme: _buildTheme(Brightness.light),
      // theme: ThemeData(),
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

ThemeData _buildTheme(brightness) {
  var baseTheme = ThemeData(brightness: brightness);
  return baseTheme.copyWith(
      primaryColor: const Color(0xFF432C81),
      textTheme: TextTheme(
          displayLarge: GoogleFonts.raleway(
              textStyle: const TextStyle(
                  color: Color(0xFF432C81),
                  fontSize: 56.0,
                  fontWeight: FontWeight.w700))));
}
