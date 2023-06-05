// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../models/log_model.dart';
import '../models/user_model.dart';
import '../providers/log_provider.dart';

class AllStudentsLogs extends StatefulWidget {
  const AllStudentsLogs({Key? key}) : super(key: key);

  @override
  AllStudentsPageState createState() => AllStudentsPageState();
}

class AllStudentsPageState extends State<AllStudentsLogs> {
  TextEditingController searchController = TextEditingController();
  List<UserModel> users = [];
  List<Log> filteredUsers = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> allUserStream =
        context.watch<UserProvider>().allUserStream;
    Stream<QuerySnapshot> allUsers =
        context.watch<LogsProvider>().allUserStream;

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
        // filteredUsers = updatedUsers;
      });
    });

    StreamBuilder allLogsListBuilder = StreamBuilder(
      stream: allUsers,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error encountered! ${snapshot.error}"),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting ||
            users.isEmpty) {
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
            Log user = Log.fromJson(
                snapshot.data?.docs[index].data() as Map<String, dynamic>);

            // user.uid = snaRpshot.data?.docs[index].id;

            int milliseconds = int.parse(user.date!);
            DateTime currentDate =
                DateTime.fromMillisecondsSinceEpoch(milliseconds);

            String dayOfWeek = DateFormat('EEEE').format(currentDate);
            String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

            return ListTile(
              title: Text(dayOfWeek),
              subtitle: Wrap(
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.deepPurple.shade200,
                          borderRadius: BorderRadius.circular(20)),
                      child: Text("${user.uid}")),
                  Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 89, 39, 169),
                          borderRadius: BorderRadius.circular(20)),
                      child: Text("$formattedDate")),
                ],
              ),
            );
          }),
        );
      },
    );

    return Scaffold(
        appBar: AppBar(
          title: const Text("All Student Logs"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              allLogsListBuilder,
            ],
          ),
        ));
  }
}
