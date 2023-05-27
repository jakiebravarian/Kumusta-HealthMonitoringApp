// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_app/models/entry_model.dart';
import 'package:project_app/providers/entry_provider.dart';

import 'package:project_app/providers/user_provider.dart';
import 'package:project_app/screens/Entry.dart';
import 'package:project_app/screens/login.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';

import '../providers/auth_provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Stream<QuerySnapshot> entryStream =
    //     context.watch<EntryProvider>().entriesData;

    Stream<QuerySnapshot> entryStream =
        context.watch<EntryProvider>().entriesData;
    Stream<QuerySnapshot> userInfoStream =
        context.watch<UserProvider>().userStream;
    Stream<User?> userStream = context.watch<AuthProvider>().userStream;

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

          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data?.docs.length,
            itemBuilder: ((context, index) {
              Entry entry = Entry.fromJson(
                  snapshot.data?.docs[index].data() as Map<String, dynamic>);

              // String formattedDate = DateFormat.yMMMEd().format(now);
              // DateTime formattedDate = DateTime.parse(entry.date!);

              entry.id = snapshot.data?.docs[index].id;
              return Dismissible(
                key: Key(entry.id.toString()),
                background: Container(
                  color: Colors.red,
                  child: const Icon(Icons.delete),
                ),
                child: ListTile(
                  title: Text("Entry: ${entry.date}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          // FriendsDetails.friend = FriendsData(
                          //     id: data.id,
                          //     name: data.name,
                          //     nickname: data.nickname,
                          //     age: data.age,
                          //     relstatus: data.relstatus,
                          //     happinessLevel: data.happinessLevel,
                          //     superpower: data.superpower,
                          //     motto: data.motto);

                          // Navigator.pushNamed(context, Details.routename);
                        },
                        icon: const Icon(Icons.info_outline_rounded),
                      ),
                      IconButton(
                        onPressed: () {
                          // EditSlambookForms.friendsInitData = FriendsData(
                          //     id: data.id,
                          //     name: data.name,
                          //     nickname: data.nickname,
                          //     age: data.age,
                          //     relstatus: data.relstatus,
                          //     happinessLevel: data.happinessLevel,
                          //     superpower: data.superpower,
                          //     motto: data.motto);

                          // Navigator.pushNamed(
                          //     context, SlambookEdit.routename);
                        },
                        icon: const Icon(Icons.create_outlined),
                      ),
                      IconButton(
                        onPressed: () {
                          // context.read<FriendsProvider>().deleteTodo(data.id);
                        },
                        icon: const Icon(Icons.delete_outlined),
                      )
                    ],
                  ),
                ),
              );
            }),
          );
        });

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

          UserModel user = UserModel.fromJson(
              snapshot.data?.docs[0].data() as Map<String, dynamic>);
          return Column(
            children: <Widget>[
              Text("Hello ${user.name}"),
              Expanded(
                child: entriesListBuilder,
              )
            ],
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

          return Scaffold(
            appBar: AppBar(
              title: const Text("Homepage"),
            ),
            drawer: Drawer(
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                    ),
                    child: const Text('Profile'),
                  ),
                  ListTile(
                      //tileColor: Colors.white,
                      leading: const Icon(
                        Icons.book_outlined,
                      ),
                      title: const Text('Profile'),
                      onTap: () {}),
                  ListTile(
                    leading: const Icon(Icons.person_rounded),
                    title: const Text('Sign out'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ));
                      context.read<AuthProvider>().signOut();
                    },
                  ),
                ],
              ),
            ),
            body: userStreamBuilder,
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const HealthEntry(),
                    ),
                  );
                },
                child: Icon(Icons.add)),
          );
        });
  }
}
  // Scaffold displayScaffold(
  //     BuildContext context, Stream<QuerySnapshot<Object?>> todosStream) {
  //   return Scaffold(
  //     drawer: Drawer(
  //         child: ListView(padding: EdgeInsets.zero, children: [
  //       ListTile(
  //         title: const Text('Details'),
  //         onTap: () {
  //           // Navigator.push(
  //           //     context,
  //           //     MaterialPageRoute(
  //           //         builder: (context) => const UserDetailsPage()));
  //         },
  //       ),
  //       ListTile(
  //         title: const Text('Logout'),
  //         onTap: () {
  //           context.read<AuthProvider>().signOut();
  //           Navigator.pop(context);
  //         },
  //       ),
  //     ])),
  //     appBar: AppBar(
  //       title: Text("Todo"),
  //     ),
  //     body: StreamBuilder(
  //       stream: todosStream,
  //       builder: (context, snapshot) {
  //         if (snapshot.hasError) {
  //           return Center(
  //             child: Text("Error encountered! ${snapshot.error}"),
  //           );
  //         } else if (snapshot.connectionState == ConnectionState.waiting) {
  //           return Center(
  //             child: CircularProgressIndicator(),
  //           );
  //         } else if (!snapshot.hasData) {
  //           return Center(
  //             child: Text("No Todos Found"),
  //           );
  //         }

  //         return entriesList
  //       }),
  //     floatingActionButton: FloatingActionButton(
  //         onPressed: () {
  //           Navigator.of(context).push(
  //             MaterialPageRoute(
  //               builder: (context) => const HealthEntry(),
  //             ),
  //           );
  //         },
  //         child: Icon(Icons.add)),


      // SingleChildScrollView(
      //   child: Column(children: [entriesListBuilder, addEntryButton]),
      // );