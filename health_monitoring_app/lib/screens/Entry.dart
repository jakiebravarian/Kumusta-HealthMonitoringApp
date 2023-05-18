import 'package:flutter/material.dart';

class Entry extends StatefulWidget {
  static const routename = '/addEntry';

  const Entry({super.key});

  @override
  HealthEntry createState() => HealthEntry();
}

class HealthEntry extends State<Entry> {
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Georgia',
        brightness: Brightness.dark,
      ),
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Health Entry"),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            subheading("Symptoms"),
            for (var checkbox in checkboxBuilder()) checkbox,
          ]),
        ),
      ),
    );
  }

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

  List<Widget> checkboxBuilder() {
    List<Widget> checkboxes = [];
    _illness.forEach((key, value) {
      checkboxes.add(checkbox(key, value));
    });
    return checkboxes;
  }

  Widget checkbox(key, value) => CheckboxListTile(
        value: value,
        onChanged: (bool? value) {
          setState(() {
            value = value!;
            _illness[key] = value!;
            print(_illness);
          });
        },
        title: Text(key),
      );
}
