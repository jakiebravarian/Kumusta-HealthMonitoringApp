import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:project_app/screens/user_signUp/page1.1.dart';
import 'package:project_app/screens/user_signUp/page2.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../providers/user_provider.dart';

class UserSignupPage1 extends StatefulWidget {
  const UserSignupPage1({super.key});
  @override
  _UserSignupPageState1 createState() => _UserSignupPageState1();
}

class _UserSignupPageState1 extends State<UserSignupPage1> {
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController usernameController = TextEditingController();

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

    final nextButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            context
                .read<UserProvider>()
                .setUserInfo1(nameController.text, usernameController.text);

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const UserSignupPage11(),
              ),
            );
          }
        },
        child: const Text('Next', style: TextStyle(color: Colors.white)),
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
                "Basic Information",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
              formFieldBuilder(nameController, "Name", "name"),
              formFieldBuilder(usernameController, "Username", "username"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [backButton, nextButton],
              )
            ],
          ),
        ),
      ),
    );
  }
}
