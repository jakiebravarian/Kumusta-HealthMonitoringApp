// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:project_app/models/admin_model.dart';
import 'package:provider/provider.dart';

import '../providers/admin_provider.dart';
import '../providers/auth_provider.dart';
import 'package:email_validator/email_validator.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    // TextEditingController firstnameController = TextEditingController();
    // TextEditingController lastnameController = TextEditingController();

    TextEditingController nameController = TextEditingController();
    TextEditingController empNoController = TextEditingController();
    TextEditingController positionController = TextEditingController();
    TextEditingController homeUnitController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    final name = TextFormField(
      controller: nameController,
      decoration: const InputDecoration(
        hintText: "First Name",
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your firstname.';
        }
      },
    );

    final empNumber = TextFormField(
      controller: empNoController,
      decoration: const InputDecoration(
        hintText: "Employee Number",
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your employee number.';
        }
      },
    );

    final positionField = TextFormField(
      controller: positionController,
      decoration: const InputDecoration(
        hintText: "Position",
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your position.';
        }
      },
    );

    final homeUnitField = TextFormField(
      controller: homeUnitController,
      decoration: const InputDecoration(
        hintText: "Home Unit",
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your home unit.';
        }
      },
    );

    final email = TextFormField(
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
      },
    );

    final password = TextFormField(
      controller: passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: 'Password',
      ),
      validator: (value) {
        if (value.toString().length < 7) {
          return 'Password should have minimum of 6 characters.';
        }
      },
    );

    final signupButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            Admin temp = Admin(
              email: emailController.text,
              name: nameController.text,
              empNo: int.parse(empNoController.text),
              position: positionController.text,
              homeUnit: homeUnitController.text,
            );
            context.read<AdminProvider>().addAdmin(temp);

            await context
                .read<AuthProvider>()
                .signUp(emailController.text, passwordController.text);

            if (context.mounted) Navigator.pop(context);
          }
        },
        child: const Text('Sign up', style: TextStyle(color: Colors.white)),
      ),
    );

    final backButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          Navigator.pop(context);
        },
        child: const Text('Back', style: TextStyle(color: Colors.white)),
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
                "Sign Up",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
              name,
              empNumber,
              positionField,
              homeUnitField,
              email,
              password,
              signupButton,
              backButton
            ],
          ),
        ),
      ),
    );
  }
}
