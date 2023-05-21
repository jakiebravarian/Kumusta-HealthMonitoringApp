import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:project_app/screens/user_signUp/page2.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../providers/user_provider.dart';

class UserSignupPage11 extends StatefulWidget {
  const UserSignupPage11({super.key});
  @override
  _UserSignupPageState11 createState() => _UserSignupPageState11();
}

class _UserSignupPageState11 extends State<UserSignupPage11> {
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

    final nextButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            context.read<UserProvider>().setUserInfo11(
                chosenCollege, courseController.text, stdNumController.text);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const UserSignupPage2(),
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
                "Student Information",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
              dropDownCollege,
              formFieldBuilder(courseController,
                  "Course (ex. BS Computer Science)", "course"),
              formFieldBuilder(
                  stdNumController, "Student Number", "student number"),
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
