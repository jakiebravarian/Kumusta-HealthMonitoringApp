import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpLogin extends StatefulWidget {
  static const routename = '/signup-login2';
  final String? userType;

  const SignUpLogin({super.key, this.userType});

  @override
  SignUpLoginState createState() => SignUpLoginState();
}

class SignUpLoginState extends State<SignUpLogin> {
  @override
  void initState() {
    super.initState();
  }

  userChecker(user) {
    if (user == "Employee") {
      return ('assets/images/Lifesavers Bust-2.png');
    } else if (user == "Admin") {
      return ('assets/images/Lifesavers Bust-1.png');
    } else {
      return ('assets/images/Lifesavers Bust.png');
    }
  }

  displayImage(user) {
    return SizedBox(
        width: 285,
        child: Image.asset(
          userChecker(user),
          fit: BoxFit.fitWidth,
        ));
  }

  appName(user) {
    return Column(
      children: [
        Text("Kumusta",
            style: GoogleFonts.raleway(
                textStyle: const TextStyle(
                    color: Color(0xFF432C81),
                    fontSize: 20,
                    fontWeight: FontWeight.w700))),
        const SizedBox(
          height: 8,
        ),
        Text(user,
            style: GoogleFonts.raleway(
                textStyle: const TextStyle(
                    color: Color(0xFF432C81),
                    fontSize: 32,
                    fontWeight: FontWeight.w700)))
      ],
    );
  }

  final signUpButton = TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xFF432C81),
        minimumSize: const Size(327, 42),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(
        "Sign Up",
        style: GoogleFonts.raleway(
            textStyle: const TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 16,
                fontWeight: FontWeight.w600)),
      ));

  final loginButton = OutlinedButton(
      style: OutlinedButton.styleFrom(
          minimumSize: const Size(327, 42),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          side: const BorderSide(color: Color(0xFF432C81), width: 1)),
      onPressed: () async {},
      child: Text(
        "Login",
        style: GoogleFonts.raleway(
            textStyle: const TextStyle(
                color: Color(0xFF432C81),
                fontSize: 16,
                fontWeight: FontWeight.w600)),
      ));

  @override
  Widget build(BuildContext context) {
    String user = widget.userType.toString();
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
          body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            appName(user),
            const SizedBox(
              height: 40,
            ),
            displayImage(user),
            const SizedBox(
              height: 96,
            ),
            signUpButton,
            const SizedBox(
              height: 16,
            ),
            loginButton
          ],
        ),
      )),
    );
  }
}
