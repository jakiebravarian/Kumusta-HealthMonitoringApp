// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:project_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';

class UnderMonitoringStudentsPage extends StatefulWidget {
  const UnderMonitoringStudentsPage({super.key});
  @override
  UnderMonitoringStudentsPageState createState() =>
      UnderMonitoringStudentsPageState();
}

class UnderMonitoringStudentsPageState
    extends State<UnderMonitoringStudentsPage> {
  TextEditingController searchController = TextEditingController();
  List<UserModel> users = [];
  List<UserModel> filteredUsers = [];
  StreamSubscription<Object>? myStreamSubscription;

  @override
  void dispose() {
    myStreamSubscription?.cancel();
    myStreamSubscription = null;

    // Dispose or remove other listeners/references...

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> allUserStream =
        context.read<UserProvider>().allUserStream;

    myStreamSubscription = allUserStream.listen((QuerySnapshot snapshot) {
      List<UserModel> updatedUsers = [];

      // Iterate over the documents in the snapshot and convert them to UserModels
      for (var doc in snapshot.docs) {
        UserModel user = UserModel.fromJson(doc.data() as Map<String, dynamic>);

        updatedUsers.add(user);
      }

      // Update the users list and filteredUsers list
      if (mounted) {
        setState(() {
          users = updatedUsers;
          filteredUsers = updatedUsers;
        });
      }
    });

    void filterUsers(String query) {
      if (mounted) {
        setState(() {
          filteredUsers = users
              .where((user) =>
                  user.name!.toLowerCase().contains(query.toLowerCase()) ||
                  user.stdnum!.contains(query) ||
                  user.college!.toLowerCase().contains(query.toLowerCase()) ||
                  user.course!.toLowerCase().contains(query.toLowerCase()) ||
                  user.email!.toLowerCase().contains(query.toLowerCase()))
              .toList();
        });
      }
    }

    final backButton = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: IconButton(
            onPressed: () async {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFFA095C1),
            ),
          ),
        )
      ],
    );

    searchEngine() {
      return Column(
        children: [
          backButton,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text("🏠  Under Monitoring Students",
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
                'assets/images/Lifesavers Waiting.png',
                fit: BoxFit.fitWidth,
              )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                filterUsers(value);
              },
              decoration: const InputDecoration(
                hintText: 'Search Under Monitoring',
              ),
            ),
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredUsers.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final user = filteredUsers[index];
              return Container(
                  height: 120,
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 16.0),
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(
                            color: Color(0xFF432C81), width: 1)),
                    elevation: 4,
                    shadowColor: Colors.black87,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 16),
                        SizedBox(
                            width: 90,
                            child: Image.asset(
                              'assets/images/Lifesavers Avatar.png',
                              fit: BoxFit.fitWidth,
                            )),
                        const SizedBox(width: 16),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${user.name}",
                                style: GoogleFonts.raleway(
                                    textStyle: const TextStyle(
                                        color: Color(0xFF432C81),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: -0.5))),
                            const SizedBox(
                              height: 4,
                            ),
                            Wrap(
                              children: [
                                OutlinedButton(
                                    onPressed: () {
                                      context
                                          .read<UserProvider>()
                                          .editUnderMonitoringStatus(
                                              user.id, false);
                                    },
                                    style: OutlinedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF89CB87),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        side: const BorderSide(
                                            color: Color(0xFF432C81),
                                            width: 1)),
                                    child: Text("End Monitoring",
                                        style: GoogleFonts.raleway(
                                            textStyle: const TextStyle(
                                                color: Color(0xFF432C81),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400)))),
                                const SizedBox(width: 4),
                                OutlinedButton(
                                    onPressed: () {
                                      context
                                          .read<UserProvider>()
                                          .editUnderMonitoringStatus(
                                              user.id, false);
                                      context
                                          .read<UserProvider>()
                                          .editQuarantineStatus(user.id, true);
                                    },
                                    style: OutlinedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFEB5858),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        side: const BorderSide(
                                            color: Color(0xFF432C81),
                                            width: 1)),
                                    child: Text("Quarantine",
                                        style: GoogleFonts.raleway(
                                            textStyle: const TextStyle(
                                                color: Color(0xFF432C81),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400))))
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ));
            },
          ),
        ],
      );
    }

    return Scaffold(
        body: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              children: [
                searchEngine(),
              ],
            )));
  }
}
