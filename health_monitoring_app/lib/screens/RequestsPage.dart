import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_app/providers/entry_provider.dart';
import 'package:project_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../models/entry_model.dart';
import '../models/user_model.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});
  @override
  RequestsPageState createState() => RequestsPageState();
}

class RequestsPageState extends State<RequestsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> editRequestStream =
        context.watch<EntryProvider>().streamOfEntriesRequestingForEdit;

    Stream<QuerySnapshot> deleteRequestStream =
        context.watch<EntryProvider>().streamOfEntriesRequestingForDelete;

    StreamBuilder editRequestListBuilder = StreamBuilder(
        stream: editRequestStream,
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

              entry.id = snapshot.data?.docs[index].id;

              return ListTile(
                title: Text("${entry.submittedBy}"),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Student Number: ${entry.stdnum}"),
                          Text("Entry id: ${entry.id}"),
                          Text("Reason: ${entry.editReason}"),
                        ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                            onPressed: () {
                              context
                                  .read<EntryProvider>()
                                  .toggleIsEditApproved(entry.id, true);
                              context
                                  .read<EntryProvider>()
                                  .toggleforEditApproval(entry.id, false);
                            },
                            child: Text("Approve")),
                        OutlinedButton(
                            onPressed: () {
                              context
                                  .read<EntryProvider>()
                                  .toggleIsEditApproved(entry.id, false);
                              context
                                  .read<EntryProvider>()
                                  .toggleforEditApproval(entry.id, false);
                            },
                            child: Text("Reject"))
                      ],
                    )
                  ],
                ),
              );
              // return ListTile(
              //   title: Text("${entry.id}"),
              //   subtitle: Row(
              //     children: [
              //       Text(entry.editReason!),
              //       OutlinedButton(
              //           onPressed: () {
              //             context
              //                 .read<EntryProvider>()
              //                 .toggleIsEditApproved(entry.id, true);
              //             context
              //                 .read<EntryProvider>()
              //                 .toggleforEditApproval(entry.id, false);
              //           },
              //           child: Text("Approve")),
              //       OutlinedButton(
              //           onPressed: () {
              //             context
              //                 .read<EntryProvider>()
              //                 .toggleIsEditApproved(entry.id, false);
              //             context
              //                 .read<EntryProvider>()
              //                 .toggleforEditApproval(entry.id, false);
              //           },
              //           child: Text("Reject"))
              //     ],
              //   ),
              // );
            }),
          );
        });

    StreamBuilder deleteRequestListBuilder = StreamBuilder(
        stream: deleteRequestStream,
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

              entry.id = snapshot.data?.docs[index].id;

              return ListTile(
                title: Text("${entry.submittedBy}"),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Student Number: ${entry.stdnum}"),
                          Text("Entry id: ${entry.id}"),
                          Text("Reason: ${entry.deleteReason}"),
                        ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                            onPressed: () {
                              context
                                  .read<EntryProvider>()
                                  .toggleIsDeleteApproved(entry.id, true);
                              context
                                  .read<EntryProvider>()
                                  .toggleforDeleteApproval(entry.id, false);
                            },
                            child: Text("Approve")),
                        OutlinedButton(
                            onPressed: () {
                              context
                                  .read<EntryProvider>()
                                  .toggleIsDeleteApproved(entry.id, false);
                              context
                                  .read<EntryProvider>()
                                  .toggleforDeleteApproval(entry.id, false);
                            },
                            child: Text("Reject"))
                      ],
                    )
                  ],
                ),
              );
            }),
          );
        });

    return Scaffold(
        appBar: AppBar(
          title: const Text("Quarantined Students"),
        ),
        body: Column(
          children: [
            Text("Edit Request"),
            editRequestListBuilder,
            Text("Delete Requests"),
            deleteRequestListBuilder,
          ],
        ));
  }
}
