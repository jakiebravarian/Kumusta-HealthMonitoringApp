// ignore_for_file: use_build_context_synchronously

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import 'package:project_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';

import '../providers/auth_provider.dart';

class UserSignupPage extends StatefulWidget {
  const UserSignupPage({super.key});
  @override
  _UserSignupPageState createState() => _UserSignupPageState();
}

class _UserSignupPageState extends State<UserSignupPage> {
  List<String> collegeList = <String>[
    'College of Arts and Sciences(CAS)',
    'College of Economics and Management (CEM)',
    'College of Engineering and Agro-Industrial Technology (CEAT)',
    'College of Forestry and Natural Resources (CFNR)',
    'College of Human Ecology (CHE)',
    'College of Public Affairs and Development (CPAf)',
    'College of Veterinary Medicine (CVM)',
    'Graduate School (GS)',
    'School of Environmental Science and Management (SESAM)'
  ];

  late String chosenCollege;

  @override
  void initState() {
    // TODO: implement initState
    chosenCollege = collegeList.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController usernameController = TextEditingController();
    TextEditingController stdNumController = TextEditingController();

    TextEditingController courseController = TextEditingController();

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
          if (chosenCollege == "Select college") {}
          if (formKey.currentState!.validate()) {
            User temp = User(
              email: emailController.text,
              name: nameController.text,
              username: usernameController.text,
              course: courseController.text,
              stdnum: stdNumController.text,
            );
            context.read<UserProvider>().addUser(temp);

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

    final dropDownCollege = DropdownButton<String>(
      value: chosenCollege,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      underline: Container(
        height: 2,
        color: Color.fromARGB(255, 0, 0, 0),
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          chosenCollege = value!;
        });
      },
      isExpanded: true,
      items: collegeList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
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
              formFieldBuilder(usernameController, "Username", "username"),
              dropDownCollege,
              formFieldBuilder(courseController,
                  "Course (ex. BS Computer Science)", "course"),
              formFieldBuilder(
                  stdNumController, "Student Number", "student number"),
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
