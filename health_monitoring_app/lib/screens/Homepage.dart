// ignore_for_file: use_build_context_synchronously

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import 'package:project_app/providers/user_provider.dart';
import 'package:project_app/screens/Entry.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';

import '../providers/auth_provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  static String? userID;
  @override
  Widget build(BuildContext context) {
    final addEntryButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const HealthEntry(),
            ),
          );
        },
        child: const Text('Add Entry', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text("Homepage"),
        ),
        body: SingleChildScrollView(
          child: Column(children: [addEntryButton]),
        ));
  }
}
