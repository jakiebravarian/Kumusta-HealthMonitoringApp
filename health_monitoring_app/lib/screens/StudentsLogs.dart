import 'dart:math';

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

  UserModel? getStudentUID(String uid) {
    UserModel? matchingUser = users.firstWhere((user) => user.uid == uid,
        orElse: () => UserModel(id: '', name: 'Unknown'));

    return matchingUser;
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> allUserStream =
        context.watch<UserProvider>().allUserLogStream;

    Stream<QuerySnapshot> allUsers = context.watch<LogsProvider>().logStream;

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

            return ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: ListTile(
                onTap: () {},
                trailing: IconButton(
                    icon: const Icon(
                        IconData(0xe1b9, fontFamily: 'MaterialIcons')),
                    tooltip: 'Delete Log',
                    onPressed: () {
                      context.read<LogsProvider>().deleteEntry(user.uid!);
                    }),
                hoverColor: Color.fromARGB(255, 98, 122, 188),
                shape: null,
                title: Text(
                  dayOfWeek,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 87, 231, 65),
                      decorationColor: Color.fromARGB(255, 255, 191, 0),
                      wordSpacing: 10,
                      height: 5,
                      fontSize: 10),
                ),
                subtitle: Wrap(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 171, 197, 176),
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(Name!.name ?? "Unknown")),
                    Row(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Color.fromARGB(255, 138, 214, 148),
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(month)),
                        Container(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 171, 197, 176),
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(day)),
                      ],
                    ),
                  ],
                ),
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


// import 'dart:math';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:project_app/providers/user_provider.dart';
// import 'package:provider/provider.dart';
// import '../models/log_model.dart';
// import '../models/user_model.dart';
// import '../providers/log_provider.dart';

// class AllStudentsLogs extends StatefulWidget {
//   const AllStudentsLogs({Key? key}) : super(key: key);

//   @override
//   AllStudentsPageState createState() => AllStudentsPageState();
// }

// class AllStudentsPageState extends State<AllStudentsLogs> {
//   TextEditingController searchController = TextEditingController();
//   List<UserModel> users = [];
//   List<Log> filteredUsers = [];

//   @override
//   void initState() {
//     super.initState();
//   }

//   UserModel? getStudentUID(String uid) {
//     UserModel? matchingUser = users.firstWhere(
//         (user) => user.id == uid || user.id == uid,
//         orElse: () => UserModel(id: '', name: 'Unknown'));

//     return matchingUser;
//   }

//   @override
//   Widget build(BuildContext context) {
//     Stream<QuerySnapshot> allUserLogStream =
//         context.watch<UserProvider>().allUserLogStream;

//     Stream<QuerySnapshot> allLogs = context.watch<LogsProvider>().logStream;

// //     allUserLogStream.listen((QuerySnapshot snapshot) {
// //       List<UserModel> updatedUsers = [];

// //       // Iterate over the documents in the snapshot and convert them to UserModels
// //       for (var doc in snapshot.docs) {
// //         UserModel user = UserModel.fromJson(doc.data() as Map<String, dynamic>);

// //         updatedUsers.add(user);
// //       }

// //       filteredUsers = updatedUsers;
// //     });

//     allUserLogStream.listen((QuerySnapshot snapshot) {
//       List<UserModel> updatedUsers = [];

//       // Iterate over the documents in the snapshot and convert them to UserModels
//       for (var doc in snapshot.docs) {
//         UserModel user = UserModel.fromJson(doc.data() as Map<String, dynamic>);

//         updatedUsers.add(user);
//       }

//       // Update the users list and filteredUsers list

//       users = updatedUsers;
//       // filteredUsers = updatedUsers;
//     });

//     // allLogs.listen((QuerySnapshot snapshot) {
//     //   List<UserModel> updatedUsers = [];

//     //   // Iterate over the documents in the snapshot and convert them to UserModels
//     //   for (var doc in snapshot.docs) {
//     //     UserModel user = UserModel.fromJson(doc.data() as Map<String, dynamic>);

//     //     updatedUsers.add(user);
//     //   }

//     //   // Update the users list and filteredUsers list
//     //   setState(() {
//     //     users = updatedUsers;
//     //     // filteredUsers = updatedUsers;
//     //   });
//     // });

//     StreamBuilder allLogsListBuilder = StreamBuilder(
//       stream: allLogs,
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Center(
//             child: Text("Error encountered! ${snapshot.error}"),
//           );
//         } else if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         } else if (!snapshot.hasData) {
//           return const Center(
//             child: Text("No Entries Found"),
//           );
//         }

//         return ListView.builder(
//           shrinkWrap: true,
//           itemCount: snapshot.data?.docs.length,
//           itemBuilder: ((context, index) {
//             Log user = Log.fromJson(
//                 snapshot.data?.docs[index].data() as Map<String, dynamic>);

//             // user = snapshot.data?.docs[index];

//             // int milliseconds = int.parse(user.date!);
//             // DateTime currentDate =
//             //     DateTime.fromMillisecondsSinceEpoch(milliseconds);

//             // Parse the date string
//             DateTime date = DateTime.parse(user.date!);

//             // Format the day of the week (e.g., Monday, Tuesday)
//             String dayOfWeek = DateFormat('EEEE').format(date);
//             String month = DateFormat('MMMM').format(date);

//             String day = DateFormat('dd').format(date);
//             UserModel? name = getStudentUID(user.uid!);

//             return ClipRRect(
//               borderRadius: BorderRadius.circular(10.0),
//               child: ListTile(
//                 onTap: () {},
//                 trailing: IconButton(
//                     icon: const Icon(
//                         IconData(0xe1b9, fontFamily: 'MaterialIcons')),
//                     tooltip: 'Delete Log',
//                     onPressed: () {
//                       context.read<LogsProvider>().deleteEntry(user.uid!);
//                     }),
//                 hoverColor: Color.fromARGB(255, 98, 122, 188),
//                 shape: null,
//                 title: Text(
//                   dayOfWeek,
//                   style: const TextStyle(
//                       color: Color.fromARGB(255, 87, 231, 65),
//                       decorationColor: Color.fromARGB(255, 255, 191, 0),
//                       wordSpacing: 10,
//                       height: 5,
//                       fontSize: 10),
//                 ),
//                 subtitle: Wrap(
//                   children: [
//                     Container(
//                         decoration: BoxDecoration(
//                             color: Color.fromARGB(255, 171, 197, 176),
//                             borderRadius: BorderRadius.circular(20)),
//                         child: Text("Unknown")),
//                     Row(
//                       children: [
//                         Container(
//                             decoration: BoxDecoration(
//                                 shape: BoxShape.rectangle,
//                                 color: Color.fromARGB(255, 138, 214, 148),
//                                 borderRadius: BorderRadius.circular(20)),
//                             child: Text(month)),
//                         Container(
//                             decoration: BoxDecoration(
//                                 color: Color.fromARGB(255, 171, 197, 176),
//                                 borderRadius: BorderRadius.circular(20)),
//                             child: Text(day)),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }),
//         );
//       },
//     );

//     return Scaffold(
//         appBar: AppBar(
//           title: const Text("All Student Logs"),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               allLogsListBuilder,
//             ],
//           ),
//         ));
//   }
// }













// // import 'dart:math';

// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:intl/intl.dart';
// // import 'package:project_app/providers/user_provider.dart';
// // import 'package:provider/provider.dart';
// // import '../models/log_model.dart';
// // import '../models/user_model.dart';
// // import '../providers/log_provider.dart';
// // import 'login.dart';

// // class AllStudentsBuildingLogs extends StatefulWidget {
// //   const AllStudentsBuildingLogs({Key? key}) : super(key: key);

// //   @override
// //   AllStudentsBuildingLogsState createState() => AllStudentsBuildingLogsState();
// // }

// // class AllStudentsBuildingLogsState extends State<AllStudentsBuildingLogs> {
// //   TextEditingController searchController = TextEditingController();
// //   // List<UserModel> users = [];
// //   List<UserModel> filteredUsers = [];
// //   List<Log> filteredLogs = [];

// //   // List<Log> logs = [];
// //   // List<Log> filteredlogs = [];

// //   @override
// //   void initState() {
// //     super.initState();
// //   }

// //   // List<Map<UserModel, Log>> getStudentWithLogs() {
// //   //   List<Map<UserModel, Log>> mergedCollection = [];
// //   //   for (var user in users) {
// //   //     for (var log in logs) {
// //   //       if (user.uid == log.uid) mergedCollection.add({user: log});
// //   //     }
// //   //   }
// //   //   return mergedCollection;
// //   // }

// //   @override
// //   Widget build(BuildContext context) {
// //     Stream<QuerySnapshot> allUserLogStream =
// //         context.watch<UserProvider>().allUserLogStream;

// //     Stream<QuerySnapshot> allLogs = context.watch<LogsProvider>().logStream;

// //     allUserLogStream.listen((QuerySnapshot snapshot) {
// //       List<UserModel> updatedUsers = [];

// //       // Iterate over the documents in the snapshot and convert them to UserModels
// //       for (var doc in snapshot.docs) {
// //         UserModel user = UserModel.fromJson(doc.data() as Map<String, dynamic>);

// //         updatedUsers.add(user);
// //       }

// //       filteredUsers = updatedUsers;
// //     });

// //     allLogs.listen((QuerySnapshot snapshot) {
// //       List<Log> updatedLogs = [];

// //       // Iterate over the documents in the snapshot and convert them to UserModels
// //       for (var doc in snapshot.docs) {
// //         Log user = Log.fromJson(doc.data() as Map<String, dynamic>);

// //         updatedLogs.add(user);
// //       }

// //       filteredLogs = updatedLogs;
// //     });

// //     OutlinedButton outlineButtonBuilder(key) => OutlinedButton(
// //         onPressed: () {},
// //         style: OutlinedButton.styleFrom(
// //             backgroundColor: Colors.white,
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(40),
// //             ),
// //             side: const BorderSide(color: Color(0xFF432C81), width: 1)),
// //         child: Text(key,
// //             textAlign: TextAlign.center,
// //             style: GoogleFonts.raleway(
// //                 textStyle: const TextStyle(
// //                     color: Color(0xFF432C81),
// //                     fontSize: 11,
// //                     fontWeight: FontWeight.w600))));

// //     StreamBuilder allLogsListBuilder = StreamBuilder(
// //       stream: allLogs,
// //       builder: (context, snapshot) {
// //         if (snapshot.hasError) {
// //           return Center(
// //             child: Text("Error encountered! ${snapshot.error}"),
// //           );
// //         } else if (snapshot.connectionState == ConnectionState.waiting) {
// //           return const Center(
// //             child: CircularProgressIndicator(),
// //           );
// //         } else if (!snapshot.hasData) {
// //           return const Center(
// //             child: Text("No Entries Found"),
// //           );
// //         }

// //         return ListView.builder(
// //             shrinkWrap: true,
// //             itemCount: snapshot.data?.docs.length,
// //             itemBuilder: ((context, index) {
// //               Log log = Log.fromJson(
// //                   snapshot.data?.docs[index].data() as Map<String, dynamic>);

// //               return StreamBuilder(
// //                   stream: allUserLogStream,
// //                   builder: (context, snapshot) {
// //                     if (snapshot.hasError) {
// //                       return Center(
// //                         child: Text("Error encountered! ${snapshot.error}"),
// //                       );
// //                     } else if (snapshot.connectionState ==
// //                         ConnectionState.waiting) {
// //                       return const Center(
// //                         child: CircularProgressIndicator(),
// //                       );
// //                     } else if (!snapshot.hasData) {
// //                       return const LoginPage();
// //                     }
// //                     // if user is logged in, display the scaffold containing the streambuilder for the todos

// //                     return ListView.builder(
// //                         shrinkWrap: true,
// //                         itemCount: snapshot.data?.docs.length,
// //                         itemBuilder: ((context, index) {
// //                           UserModel? userModel = UserModel();
// //                           for (var u in filteredUsers) {
// //                             if (log.uid == u.id) {
// //                               userModel = u;
// //                             }
// //                           }

// //                           print(userModel?.name);

// //                           return Container(
// //                             height: 125,
// //                             child: Card(
// //                               shape: RoundedRectangleBorder(
// //                                   borderRadius: BorderRadius.circular(15)),
// //                               color: const Color.fromARGB(255, 255, 255, 255),
// //                               child: Padding(
// //                                 padding: const EdgeInsets.all(8.0),
// //                                 child: ListTile(
// //                                   title: Text("${userModel?.name}",
// //                                       style: GoogleFonts.raleway(
// //                                           textStyle: const TextStyle(
// //                                               color: Color(0xFF432C81),
// //                                               fontSize: 16,
// //                                               fontWeight: FontWeight.bold,
// //                                               letterSpacing: -0.11))),
// //                                   subtitle: outlineButtonBuilder(log.date),
// //                                   trailing: IconButton(
// //                                     onPressed: () {},
// //                                     icon: const Icon(Icons.delete,
// //                                         color: Color.fromARGB(255, 0, 0, 0)),
// //                                   ),
// //                                 ),
// //                               ),
// //                             ),
// //                           );
// //                         }));
// //                   });
// //             }));
// //       },
// //     );

// //     return SingleChildScrollView(
// //       child: Column(
// //         children: [
// //           allLogsListBuilder,
// //         ],
// //       ),
// //     );
// //   }
// // }
