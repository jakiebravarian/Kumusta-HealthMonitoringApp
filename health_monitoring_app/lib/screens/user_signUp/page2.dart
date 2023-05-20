import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:project_app/screens/user_signUp/page3.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../providers/user_provider.dart';

class UserSignupPage2 extends StatefulWidget {
  const UserSignupPage2({super.key});
  @override
  _UserSignupPageState2 createState() => _UserSignupPageState2();
}

class _UserSignupPageState2 extends State<UserSignupPage2> {
  List<String>? listOfIllnesses;

  @override
  void initState() {
    // TODO: implement initState
    listOfIllnesses = [];
    super.initState();
  }

  static final Map<String, bool> _preExistingIllness = {
    "Fever (37.8 C and above)": false,
    "Feeling feverish": false,
    "Muscle or joint pains": false,
    "Cough": false,
    "Colds": false,
    "Sore throat": false,
    "Difficulty of breathing": false,
    "Diarrhea": false,
    "Loss of taste": false,
    "Loss of smell": false
  };

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    Widget checkbox(key, value) => CheckboxListTile(
          value: value,
          onChanged: (bool? value) {
            setState(() {
              value = value!;
              _preExistingIllness[key] = value!;
            });
            print(_preExistingIllness);
          },
          title: Text(key),
        );

    List<Widget> checkboxBuilder() {
      List<Widget> checkboxes = [];
      _preExistingIllness.forEach((key, value) {
        checkboxes.add(checkbox(key, value));
      });
      return checkboxes;
    }

    final nextButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          _preExistingIllness.forEach((key, value) {
            if (value == true) {
              listOfIllnesses?.add(key);
            }
          });
          context.read<UserProvider>().setUserInfo2(listOfIllnesses);

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const UserSignupPage3(),
            ),
          );
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
                "Do you have any medical issues?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
              for (var checkbox in checkboxBuilder()) checkbox,
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
