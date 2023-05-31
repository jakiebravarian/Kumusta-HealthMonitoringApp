import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:project_app/providers/user_provider.dart';

import 'package:project_app/screens/user_signUp/page3.dart';

import '../../models/user_model.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String illnessChecker(key) {
      if (key == "Hypertension") {
        return ('assets/images/The Lifesavers Blood bag.png');
      } else if (key == "Diabetes") {
        return ('assets/images/The Lifesavers Vaccine.png');
      } else if (key == "Tuberculosis") {
        return ('assets/images/The Lifesavers Lungs.png');
      } else if (key == "Cancer") {
        return ('assets/images/The Lifesavers Medication.png');
      } else if (key == "Kidney Disease") {
        return ('assets/images/Lifesavers Kidneys.png');
      } else if (key == "Cardiac Disease") {
        return ('assets/images/Lifesavers Heart.png');
      } else if (key == "Autoimmune Disease") {
        return ('assets/images/The Lifesavers Virus 1.png');
      } else {
        return ('assets/images/The Lifesavers Pills.png');
      }
    }

    OutlinedButton outlineButtonBuilderForIllness(key, color, textColor) =>
        OutlinedButton(
            onPressed: () {
              context.read<UserProvider>().changeValueInPreexistingIllness(key);
            },
            style: OutlinedButton.styleFrom(
                shadowColor: Colors.black87,
                elevation: 4,
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: color, width: 1)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(key,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                        textStyle: TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -.5))),
                SizedBox(
                    width: 55,
                    child: Image.asset(
                      illnessChecker(key),
                      fit: BoxFit.fitWidth,
                    ))
              ],
            ));

    OutlinedButton outlineButtonBuilderForAllergies(key, color, textColor) =>
        OutlinedButton(
            onPressed: () {
              context.read<UserProvider>().changeValueInAllergies(key);
            },
            style: OutlinedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                side: const BorderSide(color: Color(0xFF432C81), width: 1)),
            child: Text(key,
                textAlign: TextAlign.center,
                style: GoogleFonts.raleway(
                    textStyle: TextStyle(
                        color: textColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w600))));

    preIllnessSelectorBuilder() {
      return Consumer<UserProvider>(builder: (context, provider, child) {
        List<Widget> choices = [];

        Map<String, bool> preIllness = provider.preExistingIllness;

        preIllness.forEach((key, value) {
          Color color;
          Color textColor;
          if (value) {
            color = const Color(0xFF432C81);
            textColor = Colors.white;
          } else {
            color = Colors.white;
            textColor = const Color(0xFF432C81);
          }
          choices.add(outlineButtonBuilderForIllness(key, color, textColor));
        });
        return GridView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 10,
              crossAxisSpacing: 11,
              crossAxisCount: 2,
              childAspectRatio: (1 / .55),
            ),
            itemCount: 8,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 1, horizontal: 1),
                  child: choices[index]);
            });
      });
    }

    allergiesSelectorBuilder() {
      return Consumer<UserProvider>(builder: (context, provider, child) {
        List<Widget> choices = [];

        Map<String, bool> allergies = provider.allergies;

        allergies.forEach((key, value) {
          Color color;
          Color textColor;
          if (value) {
            color = const Color(0xFF432C81);
            textColor = Colors.white;
          } else {
            color = Colors.white;
            textColor = const Color(0xFF432C81);
          }
          choices.add(outlineButtonBuilderForAllergies(key, color, textColor));
        });
        return GridView.builder(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: (1 / .4),
            ),
            itemCount: 5,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                  padding: const EdgeInsets.all(5), child: choices[index]);
            });
      });
    }

    final nextButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF432C81),
            minimumSize: const Size(150, 42),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        onPressed: () {
          var listOfPreexistingIllness = [];
          var listOfAllergies = [];
          var preIllness = context.read<UserProvider>().preExistingIllness;
          var allergies = context.read<UserProvider>().allergies;
          preIllness.forEach((key, value) {
            if (value == true) {
              listOfPreexistingIllness.add(key);
            }
          });

          allergies.forEach((key, value) {
            if (value == true) {
              listOfAllergies.add(key);
            }
          });

          context
              .read<UserProvider>()
              .setUserInfo2(listOfPreexistingIllness, listOfAllergies);

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const UserSignupPage3(),
            ),
          );
        },
        child: Text("Next",
            style: GoogleFonts.raleway(
                textStyle: const TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 16,
                    fontWeight: FontWeight.w600))),
      ),
    );

    final backButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            minimumSize: const Size(150, 42),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            side: const BorderSide(color: Color(0xFF432C81), width: 1)),
        onPressed: () async {
          Navigator.pop(context);
        },
        child: Text('Back',
            style: GoogleFonts.raleway(
                textStyle: const TextStyle(
                    color: Color(0xFF432C81),
                    fontSize: 16,
                    fontWeight: FontWeight.w600))),
      ),
    );

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Center(
                child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
                child: Column(
                  children: [
                    Text("👋 Hi ${context.read<UserProvider>().getUser?.name}!",
                        style: GoogleFonts.raleway(
                            textStyle: const TextStyle(
                                color: Color(0xFF432C81),
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5))),
                    Text("Kindly select any pre existing illness you have",
                        style: GoogleFonts.raleway(
                            textStyle: const TextStyle(
                                color: Color(0xFF82799D),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.11))),
                  ],
                )),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: const Color(0xFFEDECF4),
              ),
              child: Column(
                children: [
                  preIllnessSelectorBuilder(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      shadowColor: Colors.black87,
                      child: Column(children: [
                        const SizedBox(height: 14),
                        Text("Allergies",
                            style: GoogleFonts.raleway(
                                textStyle: const TextStyle(
                                    color: Color(0xFF432C81),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.11))),
                        allergiesSelectorBuilder(),
                      ]),
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [backButton, nextButton])
                ],
              ),
            )
          ],
        ))));
  }
}
