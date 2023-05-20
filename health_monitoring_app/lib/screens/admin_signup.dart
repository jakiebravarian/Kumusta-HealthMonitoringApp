// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:project_app/models/admin_model.dart';
import 'package:provider/provider.dart';

import '../providers/admin_provider.dart';
import '../providers/auth_provider.dart';
import 'package:email_validator/email_validator.dart';

class AdminSignupPage extends StatefulWidget {
  const AdminSignupPage({super.key});
  @override
  _AdminSignupPageState createState() => _AdminSignupPageState();
}

class _AdminSignupPageState extends State<AdminSignupPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController empNoController = TextEditingController();
    TextEditingController positionController = TextEditingController();
    TextEditingController homeUnitController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    TextFormField formFieldBuilder(controller, hintText, placeholder) {
      return (TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $placeholder.';
          }
        },
      ));
    }

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
          } else if (value.toString().length <= 6) {
            return 'Weak password';
          }
        });

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
              formFieldBuilder(nameController, "Name", "name"),
              formFieldBuilder(
                  empNoController, "Employee number", "employee number"),
              formFieldBuilder(positionController, "Position", "position"),
              formFieldBuilder(homeUnitController, "Home Unit", "home unit"),
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
