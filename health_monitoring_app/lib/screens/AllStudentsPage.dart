// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';

class AllStudentsPage extends StatefulWidget {
  const AllStudentsPage({super.key});
  @override
  AllStudentsPageState createState() => AllStudentsPageState();
}

class AllStudentsPageState extends State<AllStudentsPage> {
  TextEditingController searchController = TextEditingController();
  List<UserModel> users = [];
  List<UserModel> filteredUsers = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                user.name!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }

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

    return Scaffold(
        appBar: AppBar(
          title: const Text("All Students"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              allUsersListBuilder,
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
                    title: Text(user.name!),
                  );
                },
              ),
            ],
          ),
        ));
  }
}
