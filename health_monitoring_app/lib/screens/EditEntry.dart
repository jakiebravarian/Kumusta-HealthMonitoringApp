import 'package:flutter/material.dart';
import 'package:project_app/models/entry_model.dart';
import 'package:project_app/providers/entry_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../providers/user_provider.dart';

class EditHealthEntry extends StatefulWidget {
  static const routename = '/addEntry';

  const EditHealthEntry({super.key});

  @override
  EditHealthEntryState createState() => EditHealthEntryState();
}

class EditHealthEntryState extends State<EditHealthEntry> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    OutlinedButton outlineButtonBuilderForSymptoms(key, color, textColor) =>
        OutlinedButton(
            onPressed: () {
              context.read<EntryProvider>().changeValueInSymptoms(key);
            },
            style: OutlinedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                side: const BorderSide(color: Color(0xFF432C81), width: 1)),
            child: Text(key,
                textAlign: TextAlign.center,
                style: GoogleFonts.raleway(
                    textStyle: TextStyle(
                        color: textColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600))));

    symptomsSelectorBuilder() {
      return Consumer<EntryProvider>(builder: (context, provider, child) {
        List<Widget> choices = [];

        Map<String, bool> symptoms = provider.symptoms;

        symptoms.forEach((key, value) {
          Color color;
          Color textColor;
          if (value) {
            color = const Color(0xFF432C81);
            textColor = Colors.white;
          } else {
            color = Colors.white;
            textColor = const Color(0xFF432C81);
          }
          choices.add(outlineButtonBuilderForSymptoms(key, color, textColor));
        });

        return Wrap(
          children: [
            for (var choice in choices)
              Padding(
                padding: const EdgeInsets.only(right: 4, top: 5),
                child: choice,
              )
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
        child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                minimumSize: const Size(250, 42),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                side: const BorderSide(color: Color(0xFF432C81), width: 1)),
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

              context.read<EntryProvider>().editEntry(entry!);

              context.read<EntryProvider>().resetSymptomsMap();
              context
                  .read<EntryProvider>()
                  .toggleIsEditApproved(entry.id, false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor:
                      Color(0xFF89CB87), // Set the background color to 89CB87
                  content: Text(
                    'Entry is edited.',
                    style: GoogleFonts.raleway(
                      textStyle: TextStyle(
                        color:
                            Color(0xFF347C32), // Set the text color to 347C32
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ),
              );
              Navigator.pop(context);
            },
            child: Text(
              "EDIT ENTRY",
              style: GoogleFonts.raleway(
                  textStyle: const TextStyle(
                      color: Color(0xFF432C81),
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
            )));

    final backButton = IconButton(
      onPressed: () async {
        Navigator.pop(context);
      },
      icon: const Icon(
        Icons.arrow_back_rounded,
        color: Color(0xFFA095C1),
      ),
    );

    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: backButton,
                  ),
                ),
                ListTile(
                  title: Text("<👋> Today",
                      style: GoogleFonts.raleway(
                          textStyle: const TextStyle(
                              color: Color(0xFF432C81),
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5))),
                  subtitle: Text("Today's Entry",
                      style: GoogleFonts.raleway(
                          textStyle: const TextStyle(
                              color: Color(0xFF82799D),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.11))),
                ),

                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    color: Color.fromARGB(255, 249, 247, 255),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    shadowColor: Colors.black87,
                    child: Column(children: [
                      SizedBox(
                        height: 14,
                        width: MediaQuery.of(context).size.width,
                      ),
                      Text("How are you feeling today?",
                          style: GoogleFonts.raleway(
                              textStyle: const TextStyle(
                                  color: Color(0xFF432C81),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.11))),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: symptomsSelectorBuilder(),
                      ),
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    color: Color.fromARGB(255, 249, 247, 255),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    shadowColor: Colors.black87,
                    child: Column(children: [
                      SizedBox(
                          height: 14, width: MediaQuery.of(context).size.width),
                      Text("Have you been exposed to any COVID-19 patients?",
                          style: GoogleFonts.raleway(
                              textStyle: const TextStyle(
                                  color: Color(0xFF432C81),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.11))),
                      exposeSwitch,
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    color: Color.fromARGB(255, 249, 247, 255),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    shadowColor: Colors.black87,
                    child: Column(children: [
                      SizedBox(
                          height: 14, width: MediaQuery.of(context).size.width),
                      Text("Are you waiting for RT-PCR results?",
                          style: GoogleFonts.raleway(
                              textStyle: const TextStyle(
                                  color: Color(0xFF432C81),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.11))),
                      underMonitoringSwitch,
                    ]),
                  ),
                ),

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
            ),
          )),
        ),
      ),
    );
  }
}

//     final submitButton = Padding(
//       padding: const EdgeInsets.symmetric(vertical: 16.0),
//       child: ElevatedButton(
//         onPressed: () async {
//           Entry? entry = context.read<EntryProvider>().getEntry;
//           entry?.userID = context.read<EntryProvider>().uid;
//           DateTime curDate = DateTime.now();
//           entry?.date = curDate.millisecondsSinceEpoch;
//           entry?.isApproved = false;
//           entry?.isExposed = context.read<EntryProvider>().isExposed;
//           entry?.isUnderMonitoring =
//               context.read<EntryProvider>().isUnderMonitoring;

//           List<String> symptomsList = [];
//           Map<String, dynamic> symptomsMap =
//               context.read<EntryProvider>().symptoms;
//           symptomsMap.forEach((key, value) {
//             if (value == true) symptomsList.add(key);
//           });

//           entry?.symptoms = symptomsList;

//           context.read<EntryProvider>().editEntry(entry!);

//           context.read<EntryProvider>().resetSymptomsMap();
//           context.read<EntryProvider>().toggleIsEditApproved(entry.id, false);
//           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//               backgroundColor: Color.fromARGB(255, 126, 231, 45),
//               content: Text('Entry is edited.')));
//           Navigator.pop(context);
//         },
//         child: const Text('Edit entry', style: TextStyle(color: Colors.white)),
//       ),
//     );

//     return MaterialApp(
//       title: 'Flutter Demo',
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text("Health Entry"),
//         ),
//         body: Form(
//           key: formKey,
//           child: Center(
//             child: SingleChildScrollView(
//                 child: Column(
//               children: [
//                 Text("How are you feeling today?"),
//                 selectorBuilder(),
//                 Text("Have you been exposed to any COVID-19 patients?"),
//                 exposeSwitch,
//                 Text("Are you waiting for RT-PCR results?"),
//                 underMonitoringSwitch,
//                 submitButton,
//               ],
//             )),
//           ),
//         ),
//       ),
//     );
//   }
// }
