import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    'College of Arts and Sciences (CAS)',
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
            context.read<UserProvider>().setUserInfo11(
                chosenCollege, courseController.text, stdNumController.text);
            context.read<UserProvider>().reset();
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

    final backButton = IconButton(
      onPressed: () async {
        Navigator.pop(context);
      },
      icon: const Icon(
        Icons.arrow_back_rounded,
        color: Color(0xFFA095C1),
      ),
    );

    final dropDownCollege = InputDecorator(
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Color(0xFFEDECF4)),
              borderRadius: BorderRadius.circular(16))),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: chosenCollege,
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFA095C1)),
          elevation: 16,
          style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          onChanged: (String? value) {
            setState(() {
              chosenCollege = value!;
            });
          },
          isExpanded: true,
          items: collegeList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value,
                  style: GoogleFonts.raleway(
                      textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.5))),
            );
          }).toList(),
        ),
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
                "Student Information",
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
              dropDownCollege,
              const SizedBox(
                height: 16,
              ),
              formFieldBuilder(courseController,
                  "Course (ex. BS Computer Science)", "course"),
              const SizedBox(
                height: 16,
              ),
              formFieldBuilder(
                  stdNumController, "Student Number", "student number"),
              const SizedBox(
                height: 16,
              ),
              nextButton
            ],
          ),
        ),
      ),
    );
  }
}
