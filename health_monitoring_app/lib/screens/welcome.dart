import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_app/screens/signup_login.dart';

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

  final appLogo = SizedBox(
      width: 165,
      child: Image.asset(
        'assets/images/The Lifesavers Hand and bone.png',
        fit: BoxFit.fitWidth,
      ));

  final appName = Text("Kumusta",
      style: GoogleFonts.raleway(
          textStyle: const TextStyle(
              color: Color(0xFF432C81),
              fontSize: 32,
              fontWeight: FontWeight.w700)));

  final appDescription = Padding(
    padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
    child: Text(
        "Revolutionizing Wellness with our Smart Health Monitoring App, Empowering UPLB Students to Thrive in Mind, Body, and Academics.",
        textAlign: TextAlign.center,
        style: GoogleFonts.raleway(
            textStyle: const TextStyle(
                color: Color(0xFF82799D),
                fontSize: 16,
                fontWeight: FontWeight.w500))),
  );

  studentButton(context) {
    return TextButton(
        onPressed: () {
          Navigator.pushNamed(context, SignUpLogin.routename,
              arguments: "Student");
        },
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFF432C81),
          minimumSize: const Size(236, 42),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          "Student",
          style: GoogleFonts.raleway(
              textStyle: const TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
        ));
  }

  adminButton(context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            minimumSize: const Size(236, 42),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            side: const BorderSide(color: Color(0xFF432C81), width: 1)),
        onPressed: () {
          Navigator.pushNamed(context, SignUpLogin.routename,
              arguments: "Admin");
        },
        child: Text(
          "Admin",
          style: GoogleFonts.raleway(
              textStyle: const TextStyle(
                  color: Color(0xFF2635B7),
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
        ));
  }

  employeeButton(context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            minimumSize: const Size(236, 42),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            side: const BorderSide(color: Color(0xFF432C81), width: 1)),
        onPressed: () {
          Navigator.pushNamed(context, SignUpLogin.routename,
              arguments: "Employee");
        },
        child: Text(
          "Employee",
          style: GoogleFonts.raleway(
              textStyle: const TextStyle(
                  color: Color(0xFF2635B7),
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
        ));
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
            appLogo,
            const SizedBox(
              height: 32,
            ),
            appName,
            appDescription,
            const SizedBox(
              height: 64,
            ),
            studentButton(context),
            const SizedBox(
              height: 16,
            ),
            adminButton(context),
            const SizedBox(
              height: 16,
            ),
            employeeButton(context)
          ],
        ),
      )),
    );
  }
}
