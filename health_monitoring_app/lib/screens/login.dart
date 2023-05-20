import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:project_app/screens/Entry.dart';
import 'package:project_app/screens/user_signUp/page1.dart';
import 'package:project_app/screens/user_signup.dart';
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

    final loginButton = Padding(
      key: const Key('loginButton'),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            errorCode = await context.read<AuthProvider>().signIn(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );
            if (errorCode == 'user-not-found') {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red.shade900,
                  content: Text('User not found.')));
            } else if (errorCode == 'wrong-password') {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red.shade900,
                  content: Text('Email and password does not match.')));
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
        child: const Text('Log In', style: TextStyle(color: Colors.white)),
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 40.0, right: 40.0),
            children: <Widget>[
              const Text(
                "Login",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
              email,
              password,
              loginButton,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  signUpButtonForUser,
                  signUpButtonForAdmin,
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
