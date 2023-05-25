// ignore_for_file: use_build_context_synchronously

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_app/screens/Entry.dart';
import 'package:project_app/screens/user_signUp/page1.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'admin_signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
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
          if (errorCode == 'user-not-found') {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red.shade900,
                content: const Text('User not found.')));
          } else if (errorCode == 'wrong-password') {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red.shade900,
                content: const Text('Email and password does not match.')));
          } else if (errorCode == 'successful') {
            // if (context.mounted) Navigator.pop(context);

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const HealthEntry(),
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

    final signUpButtonForUser = Padding(
      key: const Key('userSignUpButton'),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const UserSignupPage1(),
            ),
          );
        },
        child: const Text('Sign Up as User',
            style: TextStyle(color: Colors.white)),
      ),
    );

    final signUpButtonForAdmin = Padding(
      key: const Key('adminSignUpButton'),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AdminSignupPage(),
            ),
          );
        },
        child: const Text('Sign Up as Admin',
            style: TextStyle(color: Colors.white)),
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
            onPressed: () {},
            child: Text("Sign Up",
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                        color: Color(0xFF432C81),
                        fontSize: 14,
                        fontWeight: FontWeight.w500))))
      ],
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
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     signUpButtonForUser,
              //     signUpButtonForAdmin,
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
