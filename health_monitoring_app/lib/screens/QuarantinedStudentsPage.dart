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
import '../providers/log_provider.dart';

class QuarantinedStudentsPage extends StatefulWidget {
  const QuarantinedStudentsPage({super.key});
  @override
  QuarantinedStudentsPageState createState() => QuarantinedStudentsPageState();
}

class QuarantinedStudentsPageState extends State<QuarantinedStudentsPage> {
  TextEditingController searchController = TextEditingController();
  List<UserModel> users = [];
  List<UserModel> filteredUsers = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> aallUserStream =
        context.watch<LogsProvider>().allUserStream;
    Stream<QuerySnapshot> allUserStream =
        context.watch<UserProvider>().allUserStream;

    allUserStream.listen((QuerySnapshot snapshot) {
      List<UserModel> updatedUsers = [];

      // Iterate over the documents in the snapshot and convert them to UserModels
      for (var doc in snapshot.docs) {
        UserModel user = UserModel.fromJson(doc.data() as Map<String, dynamic>);

        updatedUsers.add(user);
      }

      // Update the users list and filteredUsers list
      setState(() {
        users = updatedUsers;
        filteredUsers = updatedUsers;
      });
    });

    void filterUsers(String query) {
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

    searchEngine() {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                filterUsers(value);
              },
              decoration: const InputDecoration(
                labelText: 'Search',
              ),
            ),
          ),
          ListView.builder(
            itemCount: filteredUsers.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final user = filteredUsers[index];
              return ListTile(
                title: Text("${user.name}"),
                subtitle: Wrap(
                  children: [
                    OutlinedButton(
                        onPressed: () {
                          context
                              .read<UserProvider>()
                              .editQuarantineStatus(user.id, false);
                        },
                        child: Text("Remove"))
                  ],
                ),
              );

              // ListTile(
              //   title: Text(user.name!),
              //   subtitle: Text(user.stdnum!),
              //   onTap: () {
              //     print("User's profile");
              //   },
              // );
            },
          ),
        ],
      );
    }

    // StreamBuilder quarantinedListBuilder = StreamBuilder(
    //     stream: allUserStream,
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
    //         return const Center(
    //           child: Text("No Entries Found"),
    //         );
    //       }

    //       return ListView.builder(
    //         shrinkWrap: true,
    //         itemCount: snapshot.data?.docs.length,
    //         itemBuilder: ((context, index) {
    //           UserModel user = UserModel.fromJson(
    //               snapshot.data?.docs[index].data() as Map<String, dynamic>);

    //           user.id = snapshot.data?.docs[index].id;

    //           return ListTile(
    //             title: Text("${user.name}"),
    //             subtitle: Wrap(
    //               children: [
    //                 OutlinedButton(
    //                     onPressed: () {
    //                       context
    //                           .read<UserProvider>()
    //                           .editQuarantineStatus(user.id, false);
    //                     },
    //                     child: Text("Remove"))
    //               ],
    //             ),
    //           );
    //         }),
    //       );
    //     });

    return Scaffold(
        appBar: AppBar(
          title: const Text("Quarantined Students"),
        ),
        body: Column(
          children: [
            searchEngine(),
          ],
        ));
  }
}
