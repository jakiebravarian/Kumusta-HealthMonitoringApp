// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_app/providers/admin_provider.dart';
import 'package:project_app/screens/Admin_Homepage.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:project_app/providers/auth_provider.dart';
import 'package:project_app/providers/entry_provider.dart';
import 'package:project_app/providers/user_provider.dart';

import 'package:project_app/screens/Homepage.dart';
import 'package:project_app/screens/user_signUp/page1.dart';
import 'package:project_app/screens/admin_signup.dart';

import '../models/user_model.dart';

class LoginPage extends StatefulWidget {
  static const routename = '/login2';
  final String? userType;

  const LoginPage({super.key, this.userType});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    final formKey = GlobalKey<FormState>();
    late String errorCode;
    String user = widget.userType.toString();

    final displayImage = SizedBox(
        width: 227,
        child: Image.asset(
          'assets/images/Lifesavers Hand.png',
          fit: BoxFit.fitWidth,
        ));

    final email = TextFormField(
        key: const Key('emailField'),
        controller: emailController,
        decoration: const InputDecoration(
          hintText: "Email",
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email.';
          } else if (!EmailValidator.validate(value)) {
            return 'Invalid email address.';
          }
        });

    final password = TextFormField(
        key: const Key('pwField'),
        controller: passwordController,
        obscureText: true,
        decoration: const InputDecoration(
          hintText: 'Password',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password.';
          } else if (value.toString().length < 6) {
            return 'Invalid password';
          }
        });

    final loginButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF432C81),
        minimumSize: const Size(327, 42),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          errorCode = await context.read<AuthProvider>().signIn(
                emailController.text.trim(),
                passwordController.text.trim(),
              );
          if (errorCode == 'unknown') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor:
                    Color(0xFFFFB9B9), // Set the background color to FFB9B9
                content: Text(
                  'User does not exist',
                  style: GoogleFonts.raleway(
                    textStyle: TextStyle(
                      color: Color(0xFFEB5858), // Set the text color to EB5858
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ),
            );
          } else {
            // if (context.mounted) Navigator.pop(context);

            context.read<AuthProvider>().fetchAuthentication();
            context.read<UserProvider>().fetchUser(errorCode);
            context.read<EntryProvider>().fetchData(errorCode);
            // Stream<QuerySnapshot> userInfoStream =
            //     context.watch<UserProvider>().userStream;
            // UserModel user = UserModel.fromJson(
            //     snapshot.data?.docs[0].data() as Map<String, dynamic>);

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const Homepage(),
              ),
            );
          }
        }
      },
      child: Text(
        "Login",
        style: GoogleFonts.raleway(
            textStyle: const TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 16,
                fontWeight: FontWeight.w600)),
      ),
    );

    final signUp = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account?",
            style: GoogleFonts.raleway(
                textStyle: const TextStyle(
                    color: Color(0xFF82799D),
                    fontSize: 14,
                    fontWeight: FontWeight.w500))),
        TextButton(
            onPressed: () {
              if (user == "Admin" || user == "Employee") {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AdminSignupPage(),
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
            child: Text("Sign Up",
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                        color: Color(0xFF432C81),
                        fontSize: 14,
                        fontWeight: FontWeight.w500))))
      ],
    );

    final backButton = IconButton(
      onPressed: () async {
        Navigator.pop(context);
      },
      icon: const Icon(
        Icons.arrow_back_rounded,
        color: Color(0xFFA095C1),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 40.0, right: 40.0),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [backButton],
              ),
              Text("Welcome Back!",
                  style: GoogleFonts.raleway(
                      textStyle: const TextStyle(
                          color: Color(0xFF432C81),
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -1))),
              const SizedBox(
                height: 24,
              ),
              displayImage,
              const SizedBox(
                height: 24,
              ),
              email,
              const SizedBox(
                height: 16,
              ),
              password,
              const SizedBox(
                height: 24,
              ),
              loginButton,
              signUp
            ],
          ),
        ),
      ),
    );
  }
}
