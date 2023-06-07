import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:project_app/screens/Login-SignUp/login.dart';

class DoneSignup extends StatefulWidget {
  static const routename = '/done-signup';

  const DoneSignup({super.key});

  @override
  DoneSignupState createState() => DoneSignupState();
}

class DoneSignupState extends State<DoneSignup> {
  @override
  void initState() {
    super.initState();
  }

  displayImage() {
    return SizedBox(
        width: 285,
        child: Image.asset(
          'assets/images/The Lifesavers Using Computer.png',
          fit: BoxFit.fitWidth,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final backButton = IconButton(
      onPressed: () async {
        Navigator.pop(context);
      },
      icon: const Icon(
        Icons.arrow_back_rounded,
        color: Color(0xFFA095C1),
      ),
    );

    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
          body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [backButton],
            ),
            displayImage(),
            const SizedBox(
              height: 16,
            ),
            Text("Thank you for submitting!",
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                        color: Color(0xFF432C81),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5))),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                child: Text("Go back to Login",
                    style: GoogleFonts.raleway(
                        textStyle: const TextStyle(
                            color: Color(0xFFA095C1),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.5))))
          ],
        ),
      )),
    );
  }
}
