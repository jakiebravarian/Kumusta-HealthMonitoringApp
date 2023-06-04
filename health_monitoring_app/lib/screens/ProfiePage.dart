import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_app/models/user_model.dart';
import 'package:project_app/providers/user_provider.dart';
import 'package:project_app/screens/QRCodeGenerator.dart';

import 'package:project_app/screens/login.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class ProfilePage extends StatefulWidget {
  final UserModel user;
  const ProfilePage({super.key, required this.user});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    OutlinedButton outlineButtonBuilder(key) => OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            side: const BorderSide(color: Color(0xFF432C81), width: 1)),
        child: Text(key,
            textAlign: TextAlign.center,
            style: GoogleFonts.raleway(
                textStyle: const TextStyle(
                    color: Color(0xFF432C81),
                    fontSize: 11,
                    fontWeight: FontWeight.w600))));

    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          const CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/images/Lifesavers Avatar.png'),
          ),
          const SizedBox(
            height: 20,
          ),
          Text("${widget.user.name}",
              style: GoogleFonts.raleway(
                  textStyle: const TextStyle(
                      color: Color(0xFF432C81),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.11))),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            widget.user.usertype == "Student"
                ? outlineButtonBuilder("Student")
                : (widget.user.usertype == "Admin"
                    ? outlineButtonBuilder("Admin")
                    : outlineButtonBuilder("Employee")),
            (widget.user.isUnderMonitoring!)
                ? outlineButtonBuilder("Under Monitoring")
                : Text(""),
            (widget.user.isQuarantined!)
                ? outlineButtonBuilder("Quarantined")
                : outlineButtonBuilder("Cleared"),
          ]),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 25, right: 25),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: OutlinedButton(
                  onPressed: () {
                    if (!widget.user.isQuarantined! &&
                        !widget.user.isUnderMonitoring!) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                QRCodeGenerator(user: widget.user),
                          ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Color.fromARGB(255, 212, 27, 27),
                          content: Text(
                              'Invalid credentials. Cannot generate QR Code')));
                    }
                  },
                  child: ListTile(
                    title: Text("Generate QR Code",
                        style: GoogleFonts.raleway(
                            textStyle: const TextStyle(
                                color: Color(0xFF82799D),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.11))),
                    leading: Icon(Icons.qr_code),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  )),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 25, right: 25),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ));
                    context.read<AuthProvider>().signOut();
                  },
                  child: ListTile(
                    title: Text("Log Out",
                        style: GoogleFonts.raleway(
                            textStyle: const TextStyle(
                                color: Color(0xFF82799D),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.11))),
                    leading: Icon(Icons.logout_rounded),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
