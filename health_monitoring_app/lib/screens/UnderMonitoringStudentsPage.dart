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

              return ListTile(
                title: Text("${user.name}"),
                subtitle: Wrap(
                  children: [
                    OutlinedButton(
                        onPressed: () {
                          context
                              .read<UserProvider>()
                              .editUnderMonitoringStatus(user.id, false);
                        },
                        child: Text("End Monitoring")),
                    OutlinedButton(
                        onPressed: () {
                          context
                              .read<UserProvider>()
                              .editUnderMonitoringStatus(user.id, false);
                          context
                              .read<UserProvider>()
                              .editQuarantineStatus(user.id, true);
                        },
                        child: Text("Quarantine"))
                  ],
                ),
              );
            }),
          );
        });

    return Scaffold(
        appBar: AppBar(
          title: const Text("Under Monitoring Students"),
        ),
        body: Column(
          children: [
            quarantinedListBuilder,
          ],
        ));
  }
}
