import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:project_app/screens/admin_signup.dart';
import 'package:project_app/screens/login.dart';
import 'package:project_app/screens/user_signUp/page1.dart';
import 'Employee_Homepage.dart';
import 'Employee_SignupPage.dart';

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
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5))),
        const SizedBox(
          height: 8,
        ),
        Text(user,
            style: GoogleFonts.raleway(
                textStyle: const TextStyle(
                    color: Color(0xFF432C81),
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1)))
      ],
    );
  }

  signUpButton(context, user) {
    return TextButton(
        onPressed: () {
          if (user == "Admin") {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AdminSignupPage(),
              ),
            );
          }
          if (user == "Employee") {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const EmployeeSignupPage(),
              ),
            );
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const UserSignupPage1(),
              ),
            );
          }
        },
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
  }

  loginButton(context, user) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            minimumSize: const Size(327, 42),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            side: const BorderSide(color: Color(0xFF432C81), width: 1)),
        onPressed: () {
          Navigator.pushNamed(context, LoginPage.routename, arguments: user);
        },
        child: Text(
          "Login",
          style: GoogleFonts.raleway(
              textStyle: const TextStyle(
                  color: Color(0xFF432C81),
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
        ));
  }

  @override
  Widget build(BuildContext context) {
    String user = widget.userType.toString();
    print(user);
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
            signUpButton(context, user),
            const SizedBox(
              height: 16,
            ),
            loginButton(context, user)
          ],
        ),
      )),
    );
  }
}
