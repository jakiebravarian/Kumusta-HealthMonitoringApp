// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project_app/models/entry_model.dart';
import 'package:project_app/providers/entry_provider.dart';

import 'package:project_app/providers/user_provider.dart';
import 'package:project_app/screens/Admin/Admin_Homepage.dart';
import 'package:project_app/screens/Student/EditEntry.dart';
import 'package:project_app/screens/Student/Entry.dart';
import 'package:project_app/screens/Student/ProfiePage.dart';
import 'package:project_app/screens/Employee/QRCodeScanner.dart';
import 'package:project_app/screens/Employee/StudentsLogs.dart';
import 'package:project_app/screens/Login-SignUp/login.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';

import '../../providers/auth_provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  UserModel? user;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> entryStream =
        context.watch<EntryProvider>().entriesData;
    Stream<QuerySnapshot> userInfoStream =
        context.watch<UserProvider>().userStream;
    Stream<User?> userStream = context.watch<AuthProvider>().userStream;
    TextEditingController messageContoller = TextEditingController();

    UserModel? user;

    final addEntryButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const HealthEntry(),
            ),
          );
        },
        child: const Text('Add Entry', style: TextStyle(color: Colors.white)),
      ),
    );

    void showInputDialog(entry, reason) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          String userInput = '';

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  20), // Set the border radius for rounded corners
            ),
            title: Text(
              'Reason for ${reason}',
              style: GoogleFonts.raleway(
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF432C81),
                  letterSpacing: -0.5,
                ),
              ),
            ),
            content: TextField(
              controller: messageContoller,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text(
                  'Cancel',
                  style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF432C81),
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Perform the action with the user input
                  // For example, you can print it to the console
                  if (reason == "editing") {
                    context
                        .read<EntryProvider>()
                        .toggleforEditApproval(entry.id, true);
                    context
                        .read<EntryProvider>()
                        .editApprovalReason(entry.id, messageContoller.text);
                  } else if (reason == "deleting") {
                    context
                        .read<EntryProvider>()
                        .toggleforDeleteApproval(entry.id, true);
                    context
                        .read<EntryProvider>()
                        .deleteApprovalReason(entry.id, messageContoller.text);
                  }

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: const Color(
                          0xFF432C81), // Set the background color to EDECF4
                      content: Text(
                        'Request sent.',
                        style: GoogleFonts.raleway(
                          textStyle: const TextStyle(
                            color: Color(
                                0xFFEDECF4), // Set the text color to 432C81
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: Text(
                  'Send Request',
                  style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF432C81),
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    trailingEditButton(entry) {
      if (entry.isEditApproved || user?.usertype == "Admin") {
        return IconButton(
          onPressed: () {
            context.read<EntryProvider>().setEntry(entry);
            context.read<EntryProvider>().resetSymptomsMap();
            entry.symptoms?.forEach((element) {
              context.read<EntryProvider>().changeValueInSymptoms(element);
            });

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const EditHealthEntry(),
              ),
            );
          },
          icon: Icon(Icons.edit_note, color: Colors.green.shade600),
        );
      } else {
        return IconButton(
          onPressed: () {
            showInputDialog(entry, "editing");
          },
          icon: Icon(Icons.edit_note, color: Colors.grey.shade600),
        );
      }
    }

    trailingDeleteButton(entry) {
      if (entry.isDeleteApproved || user?.usertype == "Admin") {
        return IconButton(
          onPressed: () {
            context.read<EntryProvider>().setEntry(entry);
            context.read<EntryProvider>().deleteEntry();
          },
          icon: Icon(
            Icons.delete,
            color: Colors.red.shade600,
            size: 20,
          ),
        );
      } else {
        return IconButton(
          onPressed: () {
            showInputDialog(entry, "deleting");
          },
          icon: Icon(Icons.delete, color: Colors.grey.shade600, size: 20),
        );
      }
    }

    OutlinedButton outlineButtonBuilder(key) => OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            side: const BorderSide(color: Color(0xFF432C81), width: 1)),
        child: Text(key,
            textAlign: TextAlign.center,
            style: GoogleFonts.raleway(
                textStyle: const TextStyle(
                    color: Color(0xFF432C81),
                    fontSize: 11,
                    fontWeight: FontWeight.w600))));

    StreamBuilder entriesListBuilder = StreamBuilder(
        stream: entryStream,
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

          var entriesList = [];
          for (var doc in snapshot.data?.docs) {
            entriesList.add(Entry.fromJson(doc.data() as Map<String, dynamic>));
          }

          entriesList.sort((a, b) => a.date.compareTo(b.date));

          return ListView.builder(
            shrinkWrap: true,
            itemCount: entriesList.length,
            itemBuilder: ((context, index) {
              Entry entry = entriesList[index];

              String formattedDate = DateFormat.yMMMEd().format(
                  DateTime.fromMicrosecondsSinceEpoch(entry.date! * 1000));

              return Container(
                height: 125,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                        title: (index == 0)
                            ? Text("Today",
                                style: GoogleFonts.raleway(
                                    textStyle: const TextStyle(
                                        color: Color(0xFF432C81),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: -0.11)))
                            : Text(formattedDate,
                                style: GoogleFonts.raleway(
                                    textStyle: const TextStyle(
                                        color: Color(0xFF432C81),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: -0.11))),
                        subtitle: Wrap(
                          children: [
                            if (entry.symptoms!.isEmpty)
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: outlineButtonBuilder("No Symptoms"),
                              ),
                            for (var symptom in entry.symptoms!)
                              Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: outlineButtonBuilder(symptom)),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            trailingEditButton(entry),
                            trailingDeleteButton(entry)
                          ],
                        )),
                  ),
                ),
              );
            }),
          );
        });

    displayImage() {
      return SizedBox(
          width: 285,
          child: Image.asset(
            'assets/images/The Lifesavers Front Desk.png',
            fit: BoxFit.fitWidth,
          ));
    }

    StreamBuilder userStreamBuilder = StreamBuilder(
        stream: userInfoStream,
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

          user = UserModel.fromJson(
              snapshot.data?.docs[0].data() as Map<String, dynamic>);
          context.read<UserProvider>().setUser(user!);
          if (user?.usertype == "Admin") {
            int selectedIndex = context.watch<EntryProvider>().currentIndex;
            return Scaffold(
              body: (selectedIndex == 2)
                  ? ProfilePage(user: user!)
                  : (selectedIndex == 1)
                      ? Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 20,
                            ),
                            Text("Hello, ${user?.name}",
                                style: GoogleFonts.raleway(
                                    textStyle: const TextStyle(
                                        color: Color(0xFF432C81),
                                        fontSize: 32,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -1))),
                            Text("Welcome Back!",
                                style: GoogleFonts.raleway(
                                    textStyle: const TextStyle(
                                        color: Color(0xFF82799D),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: -0.11))),
                            displayImage(),
                            Expanded(
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.deepPurple.shade50,
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, top: 20),
                                    child: entriesListBuilder,
                                  )),
                            )
                          ],
                        )
                      : AdminHomepage(),
              bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.auto_awesome_mosaic_rounded),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_rounded),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_rounded),
                    label: '',
                  ),
                ],
                currentIndex: context.read<EntryProvider>().currentIndex,
                onTap: (index) =>
                    {context.read<EntryProvider>().setIndex(index)},
              ),
              floatingActionButton: FloatingActionButton(
                  backgroundColor: const Color(0xFFFEC62F),
                  onPressed: () {
                    context.read<EntryProvider>().resetSymptomsMap();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const HealthEntry(),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.add,
                    color: Color(0xFF432C81),
                  )),
            );
          } else if (user?.usertype == "Employee") {
            // context.read<EntryProvider>().fetchData(user?.uid);
            int selectedIndex = context.watch<EntryProvider>().currentIndex;
            return Scaffold(
              body: (selectedIndex == 3)
                  ? ProfilePage(user: user!)
                  : (selectedIndex == 1)
                      ? const QRViewExample()
                      : (selectedIndex == 2)
                          ? Column(
                              children: <Widget>[
                                const SizedBox(
                                  height: 20,
                                ),
                                Text("Hello, ${user?.name}",
                                    style: GoogleFonts.raleway(
                                        textStyle: const TextStyle(
                                            color: Color(0xFF432C81),
                                            fontSize: 32,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: -1))),
                                Text("Welcome Back!",
                                    style: GoogleFonts.raleway(
                                        textStyle: const TextStyle(
                                            color: Color(0xFF82799D),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: -0.11))),
                                displayImage(),
                                Expanded(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.deepPurple.shade50,
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15))),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20, top: 20),
                                        child: entriesListBuilder,
                                      )),
                                )
                              ],
                            )
                          : const AllStudentsLogs(),
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: Colors.deepPurple.shade50,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.list_alt),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.qr_code_scanner),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: "",
                  ),
                ],
                currentIndex: context.read<EntryProvider>().currentIndex,
                selectedItemColor: Color(0xFF82799D),
                onTap: (index) {
                  context.read<EntryProvider>().setIndex(index);
                },
              ),
              floatingActionButton: FloatingActionButton(
                  backgroundColor: const Color(0xFFFEC62F),
                  onPressed: () {
                    context.read<EntryProvider>().resetSymptomsMap();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const HealthEntry(),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.add,
                    color: Color(0xFF432C81),
                  )),
            );
          }
          int selectedIndex = context.watch<EntryProvider>().currentIndex;
          return Scaffold(
            body: (selectedIndex == 1)
                ? ProfilePage(user: user!)
                : Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 20,
                      ),
                      Text("Hello, ${user?.name}",
                          style: GoogleFonts.raleway(
                              textStyle: const TextStyle(
                                  color: Color(0xFF432C81),
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -1))),
                      Text("Welcome Back!",
                          style: GoogleFonts.raleway(
                              textStyle: const TextStyle(
                                  color: Color(0xFF82799D),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.11))),
                      displayImage(),
                      Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.deepPurple.shade50,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15))),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20),
                              child: entriesListBuilder,
                            )),
                      )
                    ],
                  ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.deepPurple.shade50,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "",
                ),
              ],
              currentIndex: context.read<EntryProvider>().currentIndex,
              selectedItemColor: Color(0xFF82799D),
              onTap: (index) {
                context.read<EntryProvider>().setIndex(index);
              },
            ),
            floatingActionButton: FloatingActionButton(
                backgroundColor: const Color(0xFFFEC62F),
                onPressed: () {
                  context.read<EntryProvider>().resetSymptomsMap();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const HealthEntry(),
                    ),
                  );
                },
                child: const Icon(
                  Icons.add,
                  color: Color(0xFF432C81),
                )),
          );
        });

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

          return userStreamBuilder;
        });
  }
}
