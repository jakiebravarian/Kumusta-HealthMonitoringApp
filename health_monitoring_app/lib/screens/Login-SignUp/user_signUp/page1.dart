import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:project_app/providers/user_provider.dart';

import 'package:project_app/screens/Login-SignUp/user_signUp/page1.1.dart';

import '../../../models/user_model.dart';

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
        style: GoogleFonts.raleway(
            textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.5)),
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
            UserModel? user = context.read<UserProvider>().getUser;
            user?.name = nameController.text;
            user?.username = usernameController.text;

            // context
            //     .read<UserProvider>()
            //     .setUserInfo1(nameController.text, usernameController.text);

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const UserSignupPage11(),
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
                Text("Basic Information",
                    style: GoogleFonts.raleway(
                        textStyle: const TextStyle(
                            color: Color(0xFF432C81),
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -1))),
                const SizedBox(
                  height: 32,
                ),
                formFieldBuilder(nameController, "Full name", "name"),
                const SizedBox(
                  height: 16,
                ),
                formFieldBuilder(usernameController, "Username", "username"),
                const SizedBox(
                  height: 16,
                ),
                nextButton
              ],
            ),
          ),
        ));
  }
}
