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
import 'package:project_app/screens/EditEntry.dart';
import 'package:project_app/screens/Entry.dart';
import 'package:project_app/screens/login.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';

import '../providers/auth_provider.dart';

class UnderMonitoringStudentsPage extends StatefulWidget {
  const UnderMonitoringStudentsPage({super.key});
  @override
  UnderMonitoringStudentsPageState createState() =>
      UnderMonitoringStudentsPageState();
}

class UnderMonitoringStudentsPageState
    extends State<UnderMonitoringStudentsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> allUserStream =
        context.watch<UserProvider>().allUserStream;

    StreamBuilder quarantinedListBuilder = StreamBuilder(
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

              return Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF432C81), width: 1),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 73,
                        child: Image.asset(
                          'assets/images/Lifesavers Avatar.png',
                          fit: BoxFit.fitWidth,
                        )),
                    const SizedBox(
                      width: 16,
                    ),
                    Wrap(spacing: -8, direction: Axis.vertical, children: [
                      Text("${user.name}"),
                      Wrap(spacing: 4, children: [
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: Color(0xFF89CB87),
                                minimumSize: const Size(90, 24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                side: const BorderSide(
                                    color: Color(0xFF432C81), width: 1)),
                            onPressed: () {
                              context
                                  .read<UserProvider>()
                                  .editUnderMonitoringStatus(user.id, false);
                            },
                            child: Text("End Monitoring",
                                style: GoogleFonts.raleway(
                                    textStyle: const TextStyle(
                                        color: Color(0xFF432C81),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400)))),
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: Color(0xFFEB5858),
                                minimumSize: const Size(90, 24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                side: const BorderSide(
                                    color: Color(0xFF432C81), width: 1)),
                            onPressed: () {
                              context
                                  .read<UserProvider>()
                                  .editUnderMonitoringStatus(user.id, false);
                              context
                                  .read<UserProvider>()
                                  .editQuarantineStatus(user.id, true);
                            },
                            child: Text("Quarantine",
                                style: GoogleFonts.raleway(
                                    textStyle: const TextStyle(
                                        color: Color(0xFF432C81),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400))))
                      ])
                    ])
                  ],
                ),
              );
            }),
          );
        });

    return Scaffold(
        body: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 54, 0, 0),
                      child: IconButton(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Color(0xFFA095C1),
                        ),
                      ))
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                        child: Text("🏠  Under Monitored Students",
                            style: GoogleFonts.raleway(
                                textStyle: const TextStyle(
                                    color: Color(0xFF432C81),
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.5)))),
                  ],
                ),
                SizedBox(
                    width: 198,
                    child: Image.asset(
                      'assets/images/Lifesavers Waiting.png',
                      fit: BoxFit.fitWidth,
                    )),
                quarantinedListBuilder,
              ],
            )));
  }
}
