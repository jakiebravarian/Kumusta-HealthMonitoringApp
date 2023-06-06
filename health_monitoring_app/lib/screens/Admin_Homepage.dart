// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project_app/models/entry_model.dart';
import 'package:project_app/providers/entry_provider.dart';

import 'package:project_app/providers/user_provider.dart';
import 'package:project_app/screens/AllStudentsPage.dart';
import 'package:project_app/screens/EditEntry.dart';
import 'package:project_app/screens/Entry.dart';
import 'package:project_app/screens/UnderMonitoringStudentsPage.dart';
import 'package:project_app/screens/login.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';

import '../providers/auth_provider.dart';
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
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Stream<User?> userStream = context.watch<AuthProvider>().userStream;
    Stream<QuerySnapshot> allUserStream =
        context.watch<UserProvider>().allUserStream;

    StreamBuilder allUsersListBuilder = StreamBuilder(
        stream: allUserStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text("No Entries Found"),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data?.docs.length,
            itemBuilder: ((context, index) {
              UserModel user = UserModel.fromJson(
                  snapshot.data?.docs[index].data() as Map<String, dynamic>);

              user.id = snapshot.data?.docs[index].id;

              return ListTile(
                title: Text("${user.name}"),
                subtitle: Wrap(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.deepPurple.shade200,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text("${user.college}")),
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.deepPurple.shade200,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text("${user.course}")),
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.deepPurple.shade200,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text("${user.email}")),
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.deepPurple.shade200,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text("Is quarantined: ${user.isQuarantined}"))
                  ],
                ),
              );
            }),
          );
        });

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

    return StreamBuilder(
        stream: userStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return const LoginPage();
          }
          // if user is logged in, display the scaffold containing the streambuilder for the todos

          return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30)),
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
                                outlinedButtonBuilder(
                                    "View All\nStudents\n", "all"),
                                outlinedButtonBuilder(
                                    "Students' Requests\n", "request"),
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

          // StreamBuilder(
          //     stream: userStream,
          //     builder: (context, snapshot) {
          //       if (snapshot.hasError) {
          //         return Center(
          //           child: Text("Error encountered! ${snapshot.error}"),
          //         );
          //       } else if (snapshot.connectionState == ConnectionState.waiting) {
          //         return const Center(
          //           child: CircularProgressIndicator(),
          //         );
          //       } else if (!snapshot.hasData) {
          //         return const LoginPage();
          //       }
          //       // if user is logged in, display the scaffold containing the streambuilder for the todos

          //       return Scaffold(
          //         appBar: AppBar(
          //           title: const Text("UPLB's stat"),
          //         ),
          //         drawer: Drawer(
          //           child: ListView(
          //             // Important: Remove any padding from the ListView.
          //             padding: EdgeInsets.zero,
          //             children: [
          //               DrawerHeader(
          //                 decoration: BoxDecoration(
          //                   color: Colors.green.shade100,
          //                 ),
          //                 child: const Text('Profile'),
          //               ),
          //               ListTile(
          //                   //tileColor: Colors.white,
          //                   leading: const Icon(
          //                     Icons.book_outlined,
          //                   ),
          //                   title: const Text('Profile'),
          //                   onTap: () {}),
          //               ListTile(
          //                 leading: const Icon(Icons.person_rounded),
          //                 title: const Text('Sign out'),
          //                 onTap: () {
          //                   Navigator.push(
          //                       context,
          //                       MaterialPageRoute(
          //                         builder: (context) => const LoginPage(),
          //                       ));
          //                   context.read<AuthProvider>().signOut();
          //                 },
          //               ),
          //             ],
          //           ),
          //         ),
          //         body: Column(children: [
          //           outlinedButtonBuilder("View All Students", "all"),
          //           outlinedButtonBuilder("View Quarantined Students", "quarantined"),
          //           outlinedButtonBuilder(
          //               "View Under Monitoring Students", "monitoring"),
          //           outlinedButtonBuilder("View Students Requests", "request"),
          //         ]),
          //         // floatingActionButton: FloatingActionButton(
          //         //     backgroundColor: const Color(0xFFFEC62F),
          //         //     onPressed: () {
          //         //       context.read<EntryProvider>().resetSymptomsMap();
          //         //       Navigator.of(context).push(
          //         //         MaterialPageRoute(
          //         //           builder: (context) => const HealthEntry(),
          //         //         ),
          //         //       );
          //         //     },
          //         //     child: const Icon(
          //         //       Icons.add,
          //         //       color: Color(0xFF432C81),
          //         //     )),
          //       );
          //     });
        });
  }
}
