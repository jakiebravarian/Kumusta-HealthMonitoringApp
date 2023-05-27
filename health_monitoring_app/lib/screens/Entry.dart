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
  // static final Map<String, bool> _illness = {
  //   "Fever (37.8 C and above)": false,
  //   "Feeling feverish": false,
  //   "Muscle or joint pains": false,
  //   "Cough": false,
  //   "Colds": false,
  //   "Sore throat": false,
  //   "Difficulty of breathing": false,
  //   "Diarrhea": false,
  //   "Loss of taste": false,
  //   "Loss of smell": false
  // };

  var underMonitoringGroupValue;
  var exposedGroupValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var symptoms = context.watch<EntryProvider>().symptoms;
    final formKey = GlobalKey<FormState>();

    // GridView.builder(
    //   shrinkWrap: true,
    //   padding: const EdgeInsets.symmetric(horizontal: 30),
    //   itemCount: 4,
    //   itemBuilder: (ctx, i) {
    //     return Card(
    //       child: Container(
    //         height: 290,
    //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
    //         margin: EdgeInsets.all(5),
    //         padding: EdgeInsets.all(5),
    //         child: Stack(
    //           children: [
    //             Column(
    //               crossAxisAlignment: CrossAxisAlignment.stretch,
    //               children: [
    //                 Expanded(
    //                   child: Image.network(
    //                     'https://tech.pelmorex.com/wp-content/uploads/2020/10/flutter.png',
    //                     fit: BoxFit.fill,
    //                   ),
    //                 ),
    //                 const Text(
    //                   'Title',
    //                   style: TextStyle(
    //                     fontSize: 18,
    //                     fontWeight: FontWeight.bold,
    //                   ),
    //                 ),
    //                 Row(
    //                   children: const [
    //                     Text(
    //                       'Subtitle',
    //                       style: TextStyle(
    //                         fontWeight: FontWeight.bold,
    //                         fontSize: 15,
    //                       ),
    //                     ),
    //                   ],
    //                 )
    //               ],
    //             ),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisCount: 2,
    //     childAspectRatio: 1.0,
    //     crossAxisSpacing: 0.0,
    //     mainAxisSpacing: 5,
    //     mainAxisExtent: 264,
    //   ),
    // );

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
          if (value)
            color = Colors.purple.shade200;
          else
            color = Colors.purple.shade100;
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

    // Widget checkbox(key, value) => CheckboxListTile(
    //       value: value,
    //       onChanged: (bool? value) {
    //         context.read<EntryProvider>().changeValueInSymptoms(key, value);
    //         print(context.read<EntryProvider>().symptoms);
    //       },
    //       title: Text(key),
    //     );

    // checkboxBuilder() {
    //   return Consumer<EntryProvider>(builder: (context, provider, child) {
    //     List<Widget> checkboxes = [];
    //     Map<String, bool> symptoms = provider.symptoms;
    //     symptoms.forEach((key, value) {
    //       checkboxes.add(checkbox(key, value));
    //     });
    //     return Column(
    //       children: [
    //         for (var checkbox in checkboxes) checkbox,
    //       ],
    //     );
    //   });
    // }

    // underMonitoringRadioBuilder() {
    //   return Consumer<EntryProvider>(builder: (context, provider, child) {
    //     List radioList = [];
    //     Map<String, bool> choices = provider.monitoring;
    //     choices.forEach((key, val) {
    //       radioList.add(RadioListTile(
    //         activeColor: Colors.lightBlue,
    //         title: Text(key),
    //         value: key,
    //         groupValue: underMonitoringGroupValue,
    //         onChanged: (value) {
    //           underMonitoringGroupValue = value!;
    //           provider.toggleIsUnderMonitoring(underMonitoringGroupValue);

    //           print(provider.monitoring);
    //         },
    //       ));
    //     });
    //     return Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         for (var r in radioList) r,
    //       ],
    //     );
    //   });
    // }

    // exposureRadioBuilder() {
    //   return Consumer<EntryProvider>(builder: (context, provider, child) {
    //     List radioList = [];
    //     Map<String, bool> choices = provider.exp;
    //     choices.forEach((key, val) {
    //       radioList.add(RadioListTile(
    //         activeColor: Colors.lightBlue,
    //         title: Text(key),
    //         value: key,
    //         groupValue: exposedGroupValue,
    //         onChanged: (value) {
    //           exposedGroupValue = value!;
    //           provider.toggleIsExposed(exposedGroupValue);
    //           print(provider.exp);
    //         },
    //       ));
    //     });
    //     return Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         for (var r in radioList) r,
    //       ],
    //     );
    //   });
    // }

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
