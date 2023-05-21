import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:project_app/screens/Entry.dart';
import 'package:project_app/screens/Homepage.dart';
import 'package:provider/provider.dart';

import '../../models/entry_model.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';

class UserSignupPage3 extends StatefulWidget {
  const UserSignupPage3({super.key});
  @override
  _UserSignupPageState3 createState() => _UserSignupPageState3();
}

class _UserSignupPageState3 extends State<UserSignupPage3> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

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

    final submitButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            context.read<UserProvider>().setUserInfo3(emailController.text);
            User? temp = context.read<UserProvider>().getUser;
            temp?.isAdmin = false;
            temp?.isQuarantined = false;
            temp?.isUnderMonitoring = false;
            String uid = await context
                .read<AuthProvider>()
                .signUp(emailController.text, passwordController.text);
            temp?.userID = uid;
            context.read<UserProvider>().addUser(temp!);

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const Homepage(),
              ),
            );
          }
        },
        child: const Text('Submit', style: TextStyle(color: Colors.white)),
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
              email,
              password,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [backButton, submitButton],
              )
            ],
          ),
        ),
      ),
    );
  }
}
