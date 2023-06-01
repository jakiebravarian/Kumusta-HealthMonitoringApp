import 'dart:js';

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
    return Scaffold(
        body: Center(
            child: Column(
      children: [
        Text("${widget.user.name}"),
        OutlinedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRCodeGenerator(user: widget.user),
                  ));
            },
            child: Text("Generate QR Code")),
        OutlinedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ));
              context.read<AuthProvider>().signOut();
            },
            child: Text("Log Out")),
      ],
    )));
  }
}
