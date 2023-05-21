import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_app/models/entry_model.dart';
import 'package:project_app/providers/entry_provider.dart';
import 'package:project_app/screens/Homepage.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class HealthEntry extends StatefulWidget {
  static const routename = '/addEntry';

  const HealthEntry({super.key});

  @override
  HealthEntryState createState() => HealthEntryState();
}

class HealthEntryState extends State<HealthEntry> {
  static final Map<String, bool> _illness = {
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

  var underMonitoringGroupValue;
  var exposedGroupValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    Widget subheading(text) => Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              text,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        );

    Widget checkbox(key, value) => CheckboxListTile(
          value: value,
          onChanged: (bool? value) {
            context.read<EntryProvider>().changeValueInSymptoms(key, value);
            print(context.read<EntryProvider>().symptoms);
          },
          title: Text(key),
        );

    checkboxBuilder() {
      return Consumer<EntryProvider>(builder: (context, provider, child) {
        List<Widget> checkboxes = [];
        Map<String, bool> symptoms = provider.symptoms;
        symptoms.forEach((key, value) {
          checkboxes.add(checkbox(key, value));
        });
        return Column(
          children: [
            for (var checkbox in checkboxes) checkbox,
          ],
        );
      });
    }

    underMonitoringRadioBuilder() {
      return Consumer<EntryProvider>(builder: (context, provider, child) {
        List radioList = [];
        Map<String, bool> choices = provider.monitoring;
        choices.forEach((key, val) {
          radioList.add(RadioListTile(
            activeColor: Colors.lightBlue,
            title: Text(key),
            value: key,
            groupValue: underMonitoringGroupValue,
            onChanged: (value) {
              underMonitoringGroupValue = value!;
              provider.toggleIsUnderMonitoring(underMonitoringGroupValue);

              print(provider.monitoring);
            },
          ));
        });
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var r in radioList) r,
          ],
        );
      });
    }

    exposureRadioBuilder() {
      return Consumer<EntryProvider>(builder: (context, provider, child) {
        List radioList = [];
        Map<String, bool> choices = provider.exp;
        choices.forEach((key, val) {
          radioList.add(RadioListTile(
            activeColor: Colors.lightBlue,
            title: Text(key),
            value: key,
            groupValue: exposedGroupValue,
            onChanged: (value) {
              exposedGroupValue = value!;
              provider.toggleIsExposed(exposedGroupValue);
              print(provider.exp);
            },
          ));
        });
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var r in radioList) r,
          ],
        );
      });
    }

    final submitButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          if (exposedGroupValue == null || underMonitoringGroupValue == null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red.shade900,
                content: Text('Fill out the required sections.')));
          } else {
            Entry? entry = context.read<EntryProvider>().getEntry;
            entry?.userID = context.read<EntryProvider>().uid;
            entry?.date = DateTime.now().toString();
            entry?.isApproved = false;
            if (context.read<EntryProvider>().monitoring["Yes"] == true) {
              entry?.isUnderMonitoring = true;
            } else {
              entry?.isUnderMonitoring = false;
            }

            if (context.read<EntryProvider>().exp["Yes"] == true) {
              entry?.isExposed = true;
            } else {
              entry?.isExposed = false;
            }

            List<String> symptomsList = [];
            Map<String, dynamic> symptomsMap =
                context.read<EntryProvider>().symptoms;
            symptomsMap.forEach((key, value) {
              if (value == true) symptomsList.add(key);
            });

            entry?.symptoms = symptomsList;

            context.read<EntryProvider>().addEntry(entry!);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Color.fromARGB(255, 126, 231, 45),
                content: Text('New entry is added.')));
            Navigator.pop(context);
          }

          // if (formKey.currentState!.validate()) {
          //   context.read<UserProvider>().setUserInfo3(emailController.text);
          //   User? temp = context.read<UserProvider>().getUser;
          //   temp?.isAdmin = false;
          //   temp?.isQuarantined = false;
          //   temp?.isUnderMonitoring = false;
          //   String uid = await context
          //       .read<AuthProvider>()
          //       .signUp(emailController.text, passwordController.text);
          //   temp?.userID = uid;
          //   context.read<UserProvider>().addUser(temp!);

          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => const Homepage(),
          //     ),
          //   );
          // }
        },
        child: const Text('Submit', style: TextStyle(color: Colors.white)),
      ),
    );

    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Health Entry"),
        ),
        body: Form(
          key: formKey,
          child: Center(
            child: SingleChildScrollView(
                child: Column(
              children: [
                const Text(
                  "Coronavirus Symptom Monitoring Form",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25),
                ),
                subheading("Do you have any of the following symptoms?"),
                checkboxBuilder(),
                subheading(
                    "Have you been in contact with anyone in the last 14 days who is experiencing these symptoms?"),
                underMonitoringRadioBuilder(),
                subheading(
                    "Have you been in contact with anyone who tested positive for COVID-19?"),
                exposureRadioBuilder(),
                submitButton,
              ],
            )),
          ),
        ),
      ),
    );
  }
}
