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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var symptoms = context.watch<EntryProvider>().symptoms;
    final formKey = GlobalKey<FormState>();

    // Widget subheading(text) => Align(
    //       alignment: Alignment.topLeft,
    //       child: Padding(
    //         padding: const EdgeInsets.all(15),
    //         child: Text(
    //           text,
    //           style: const TextStyle(fontSize: 18),
    //         ),
    //       ),
    //     );

    OutlinedButton outlineButtonBuilder(key, color) => OutlinedButton(
        onPressed: () {
          context.read<EntryProvider>().changeValueInSymptoms(key);
        },
        child: Text(key),
        style: OutlinedButton.styleFrom(
          backgroundColor: color,
        ));

    selectorBuilder() {
      return Consumer<EntryProvider>(builder: (context, provider, child) {
        List<Widget> choices = [];

        Map<String, bool> symptoms = provider.symptoms;

        symptoms.forEach((key, value) {
          Color color;
          if (value) {
            color = Colors.purple.shade200;
          } else {
            color = Colors.purple.shade100;
          }
          choices.add(outlineButtonBuilder(key, color));
        });
        return Column(
          children: [
            for (var choice in choices) choice,
          ],
        );
      });
    }

    var exposeSwitch =
        Consumer<EntryProvider>(builder: (context, provider, child) {
      return Switch(
        value: provider.isExposed,
        activeColor: Color.fromARGB(255, 211, 147, 231),
        onChanged: (bool value) {
          provider.toggleIsExposed();
        },
      );
    });

    var underMonitoringSwitch =
        Consumer<EntryProvider>(builder: (context, provider, child) {
      return Switch(
        value: provider.isUnderMonitoring,
        activeColor: Color.fromARGB(255, 211, 147, 231),
        onChanged: (bool value) {
          provider.toggleIsUnderMonitoring();
        },
      );
    });

    final submitButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          Entry? entry = context.read<EntryProvider>().getEntry;
          entry?.userID = context.read<EntryProvider>().uid;
          DateTime curDate = DateTime.now();
          entry?.date = curDate.millisecondsSinceEpoch;
          entry?.isApproved = false;
          entry?.isExposed = context.read<EntryProvider>().isExposed;
          entry?.isUnderMonitoring =
              context.read<EntryProvider>().isUnderMonitoring;

          List<String> symptomsList = [];
          Map<String, dynamic> symptomsMap =
              context.read<EntryProvider>().symptoms;
          symptomsMap.forEach((key, value) {
            if (value == true) symptomsList.add(key);
          });

          entry?.symptoms = symptomsList;
          entry?.isEditApproved = false;
          entry?.isDeleteApproved = false;
          context.read<EntryProvider>().addEntry(entry!);
          context.read<EntryProvider>().resetSymptomsMap();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Color.fromARGB(255, 126, 231, 45),
              content: Text('New entry is added.')));
          Navigator.pop(context);
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
                Text("How are you feeling today?"),
                selectorBuilder(),
                Text("Have you been exposed to any COVID-19 patients?"),
                exposeSwitch,
                Text("Are you waiting for RT-PCR results?"),
                underMonitoringSwitch,
                submitButton,
                // const Text(
                //   "Coronavirus Symptom Monitoring Form",
                //   textAlign: TextAlign.center,
                //   style: TextStyle(fontSize: 25),
                // ),
                // subheading("Do you have any of the following symptoms?"),
                // checkboxBuilder(),
                // subheading(
                //     "Have you been in contact with anyone in the last 14 days who is experiencing these symptoms?"),
                // underMonitoringRadioBuilder(),
                // subheading(
                //     "Have you been in contact with anyone who tested positive for COVID-19?"),
                // exposureRadioBuilder(),
                // submitButton,
              ],
            )),
          ),
        ),
      ),
    );
  }
}
