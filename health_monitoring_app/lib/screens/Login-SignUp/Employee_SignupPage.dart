// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:project_app/models/user_model.dart';
import 'package:project_app/providers/user_provider.dart';
import 'package:project_app/screens/Login-SignUp/user_signUp/page2.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeeSignupPage extends StatefulWidget {
  const EmployeeSignupPage({super.key});
  @override
  EmployeeSignupPageState createState() => EmployeeSignupPageState();
}

class EmployeeSignupPageState extends State<EmployeeSignupPage> {
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
          return null;
        },
      ));
    }

    final nextButton = Padding(
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
            UserModel? admin = context.read<UserProvider>().getUser;
            admin?.email = emailController.text;
            admin?.name = nameController.text;
            admin?.empno = empNoController.text;
            admin?.position = positionController.text;
            admin?.homeUnit = homeUnitController.text;
            admin?.usertype = "Employee";
            admin?.isAdmin = false;
            admin?.isQuarantined = false;
            admin?.isUnderMonitoring = false;

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const UserSignupPage2(),
              ),
            );
          }
        },
        child: Text('Next',
            style: GoogleFonts.raleway(
                textStyle: const TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 16,
                    fontWeight: FontWeight.w600))),
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
              nextButton,
            ],
          ),
        ),
      ),
    );
  }
}
