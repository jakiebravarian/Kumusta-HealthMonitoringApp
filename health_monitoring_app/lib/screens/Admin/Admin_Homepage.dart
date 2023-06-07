// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_app/providers/entry_provider.dart';

import 'package:project_app/providers/user_provider.dart';
import 'package:project_app/screens/Admin/AllStudentsPage.dart';
import 'package:project_app/screens/Admin/UnderMonitoringStudentsPage.dart';
import 'package:provider/provider.dart';

import 'QuarantinedStudentsPage.dart';
import 'RequestsPage.dart';

class AdminHomepage extends StatefulWidget {
  const AdminHomepage({super.key});
  @override
  AdminHomepageState createState() => AdminHomepageState();
}

class AdminHomepageState extends State<AdminHomepage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String purposeChecker(key) {
      if (key == "all") {
        return ("🔍");
      } else if (key == "quarantined") {
        return ("😷");
      } else if (key == "monitoring") {
        return ("🏠");
      } else {
        return ("🔔");
      }
    }

    outlinedButtonBuilder(title, purpose) {
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          child: (OutlinedButton(
              onPressed: () {
                if (purpose == "all") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AllStudentsPage(),
                      ));
                  context.read<UserProvider>().fetchAllUsers();
                } else if (purpose == "quarantined") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QuarantinedStudentsPage(),
                      ));
                  context.read<UserProvider>().fetchQuarantinedUsers();
                } else if (purpose == "monitoring") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const UnderMonitoringStudentsPage(),
                      ));
                  context.read<UserProvider>().fetchUnderMonitoringUsers();
                } else if (purpose == "request") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RequestsPage(),
                      ));
                }
                context.read<EntryProvider>().fetchEntriesRequestingForEdit();
                context.read<EntryProvider>().fetchEntriesRequestingForDelete();
                // context.read<UserProvider>().changeValueInPreexistingIllness(key);
              },
              style: OutlinedButton.styleFrom(
                  shadowColor: Colors.black87,
                  fixedSize: const Size(166, 160),
                  elevation: 4,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: Colors.purple.shade100, width: 1)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.raleway(
                          textStyle: const TextStyle(
                              color: Color(0xFF432C81),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -.5))),
                  Text(purposeChecker(purpose),
                      style: GoogleFonts.raleway(
                          textStyle: const TextStyle(
                        color: Color(0xFF432C81),
                        fontSize: 50,
                        fontWeight: FontWeight.w500,
                      ))),
                ],
              ))));
    }

    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 56, 0, 0),
            child: Text("🔍 UPLB's Stat",
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                        color: Color(0xFF432C81),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5))),
          )
        ],
      ),
      SizedBox(
          width: 198,
          child: Image.asset(
            'assets/images/Lifesavers Organs.png',
            fit: BoxFit.fitWidth,
          )),
      Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            color: Color(0xFFEDECF4),
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  height: 24,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      outlinedButtonBuilder("View All\nStudents\n", "all"),
                      outlinedButtonBuilder("Students' Requests\n", "request"),
                    ]),
                const SizedBox(
                  height: 16,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      outlinedButtonBuilder(
                          "Quarantined Students\n", "quarantined"),
                      outlinedButtonBuilder(
                          "Under Monitoring Students\n", "monitoring")
                    ]),
                const SizedBox(
                  height: 24,
                ),
              ]))
    ]);
  }
}
