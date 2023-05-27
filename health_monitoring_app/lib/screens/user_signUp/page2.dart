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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // gridBuilder() {
    //   return Consumer<UserProvider>(builder: (context, provider, child) {
    //     var illnesses = provider.preExistingIllness;
    //     return GridView.builder(
    //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //             crossAxisCount: 2),
    //         itemCount: 8,
    //         shrinkWrap: true,
    //         itemBuilder: (BuildContext context, int index) {
    //           return Card(
    //             color: Colors.purple.shade100,
    //             child: Text(illnesses.keys.first),
    //           );
    //         });
    //   });
    // }

    OutlinedButton outlineButtonBuilderForIllness(key, color) => OutlinedButton(
        onPressed: () {
          context.read<UserProvider>().changeValueInPreexistingIllness(key);
        },
        child: Text(key),
        style: OutlinedButton.styleFrom(
          backgroundColor: color,
        ));

    OutlinedButton outlineButtonBuilderForAllergies(key, color) =>
        OutlinedButton(
            onPressed: () {
              context.read<UserProvider>().changeValueInAllergies(key);
            },
            child: Text(key),
            style: OutlinedButton.styleFrom(
              backgroundColor: color,
            ));

    preIllnessSelectorBuilder() {
      return Consumer<UserProvider>(builder: (context, provider, child) {
        List<Widget> choices = [];

        Map<String, bool> preIllness = provider.preExistingIllness;

        preIllness.forEach((key, value) {
          Color color;
          if (value) {
            color = Colors.purple.shade200;
          } else {
            color = Colors.purple.shade100;
          }
          choices.add(outlineButtonBuilderForIllness(key, color));
        });
        return Container(
          width: 400.0,
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: 8,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                    padding: EdgeInsets.all(5), child: choices[index]);
              }),
        );
      });
    }

    allergiesSelectorBuilder() {
      return Consumer<UserProvider>(builder: (context, provider, child) {
        List<Widget> choices = [];

        Map<String, bool> allergies = provider.allergies;

        allergies.forEach((key, value) {
          Color color;
          if (value) {
            color = Colors.purple.shade200;
          } else {
            color = Colors.purple.shade100;
          }
          choices.add(outlineButtonBuilderForAllergies(key, color));
        });
        return Container(
          width: 400.0,
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4),
              itemCount: 5,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                    padding: EdgeInsets.all(5), child: choices[index]);
              }),
        );
      });
    }

    final nextButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
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

          preIllness.forEach((key, value) {
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
        body: SingleChildScrollView(
            child: Center(
                child: Column(
          children: [
            Text("Hi ${context.read<UserProvider>().getUser?.name}"),
            Text("Kindly select preexisting illnesses."),
            preIllnessSelectorBuilder(),
            Text("Allergies"),
            allergiesSelectorBuilder(),
            backButton,
            nextButton
          ],
        ))));
  }
}
