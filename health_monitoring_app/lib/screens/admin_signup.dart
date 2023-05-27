// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF432C81),
          minimumSize: const Size(327, 42),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
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
        child: Text(
          "Sign Up",
          style: GoogleFonts.raleway(
              textStyle: const TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
        ),
      ),
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
              Text(
                "Create an Account",
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                        color: Color(0xFF432C81),
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1)),
              ),
              const SizedBox(
                height: 32,
              ),
              formFieldBuilder(nameController, "Full Name", "name"),
              const SizedBox(
                height: 16,
              ),
              formFieldBuilder(
                  empNoController, "Employee No.", "employee number"),
              const SizedBox(
                height: 16,
              ),
              formFieldBuilder(positionController, "Position", "position"),
              const SizedBox(
                height: 16,
              ),
              formFieldBuilder(homeUnitController, "Home Unit", "home unit"),
              const SizedBox(
                height: 16,
              ),
              email,
              const SizedBox(
                height: 16,
              ),
              password,
              const SizedBox(
                height: 24,
              ),
              signupButton,
            ],
          ),
        ),
      ),
    );
  }
}
