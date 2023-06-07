import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../../models/log_model.dart';
import '../../models/user_model.dart';
import '../../providers/log_provider.dart';

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

  UserModel? getStudentUID(String uid) {
    UserModel? matchingUser = users.firstWhere((user) => user.uid == uid,
        orElse: () => UserModel(id: '', name: 'Unknown'));

    return matchingUser;
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

    allUsers.listen((QuerySnapshot snapshot) {
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

            user.uid = snapshot.data?.docs[index].id;

            // int milliseconds = int.parse(user.date!);
            // DateTime currentDate =
            //     DateTime.fromMillisecondsSinceEpoch(milliseconds);

            // Parse the date string
            DateTime date = DateTime.parse(user.date!);

            // Format the day of the week (e.g., Monday, Tuesday)
            String dayOfWeek = DateFormat('EEEE').format(date);
            String month = DateFormat('MMMM').format(date);

            String day = DateFormat('dd').format(date);
            UserModel? Name = getStudentUID(user.uid!);

            return Container(
              height: 125,
              padding:
                  const EdgeInsets.symmetric(vertical: 2, horizontal: 16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Color(0xFF432C81), width: 1),
                    borderRadius: BorderRadius.circular(15)),
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                      title: Text(
                        dayOfWeek,
                        style: GoogleFonts.raleway(
                            textStyle: const TextStyle(
                                color: Color(0xFF432C81),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.5)),
                      ),
                      subtitle: Wrap(
                        children: [
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                  color: const Color(0xFF432C81),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(Name!.name ?? "Unknown",
                                  style: GoogleFonts.raleway(
                                      textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400)))),
                          const SizedBox(
                            width: 4,
                          ),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                  color: const Color(0xFF432C81),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text("$month $day",
                                  style: GoogleFonts.raleway(
                                      textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400))))
                        ],
                      ),
                      trailing: IconButton(
                          icon: const Icon(
                              IconData(0xe1b9, fontFamily: 'MaterialIcons')),
                          tooltip: 'Delete Log',
                          onPressed: () {
                            context.read<LogsProvider>().deleteEntry(user.uid!);
                          })),
                ),
              ),
            );
          }),
        );
      },
    );

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

    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          backButton,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text("🔔  Student Logs",
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
                'assets/images/The Lifesavers Telemedicine.png',
                fit: BoxFit.fitWidth,
              )),
          allLogsListBuilder,
        ],
      ),
    ));
  }
}
