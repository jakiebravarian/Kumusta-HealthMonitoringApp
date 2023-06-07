import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_app/providers/entry_provider.dart';
import 'package:provider/provider.dart';
import 'package:project_app/models/entry_model.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});
  @override
  RequestsPageState createState() => RequestsPageState();
}

class RequestsPageState extends State<RequestsPage> {
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
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data?.docs.length,
            itemBuilder: ((context, index) {
              Entry entry = Entry.fromJson(
                  snapshot.data?.docs[index].data() as Map<String, dynamic>);
              entry.id = snapshot.data?.docs[index].id;

              return Container(
                  height: 150,
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
                            Text("${entry.submittedBy}",
                                style: GoogleFonts.raleway(
                                    textStyle: const TextStyle(
                                        color: Color(0xFF432C81),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: -0.5))),
                            const SizedBox(
                              height: 4,
                            ),
                            Text("Entry id: ${entry.id}",
                                style: GoogleFonts.raleway(
                                    textStyle: const TextStyle(
                                        color: Color(0xFF432C81),
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w400))),
                            Text("Reason: ${entry.editReason}",
                                style: GoogleFonts.raleway(
                                    textStyle: const TextStyle(
                                        color: Color(0xFF432C81),
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w400))),
                            Wrap(
                              children: [
                                OutlinedButton(
                                    onPressed: () {
                                      context
                                          .read<EntryProvider>()
                                          .toggleIsEditApproved(entry.id, true);
                                      context
                                          .read<EntryProvider>()
                                          .toggleforEditApproval(
                                              entry.id, false);
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
                                    child: Text("Approve",
                                        style: GoogleFonts.raleway(
                                            textStyle: const TextStyle(
                                                color: Color(0xFF432C81),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400)))),
                                const SizedBox(width: 4),
                                OutlinedButton(
                                    onPressed: () {
                                      context
                                          .read<EntryProvider>()
                                          .toggleIsEditApproved(
                                              entry.id, false);
                                      context
                                          .read<EntryProvider>()
                                          .toggleforEditApproval(
                                              entry.id, false);
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
                                    child: Text("Reject",
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
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data?.docs.length,
            itemBuilder: ((context, index) {
              Entry entry = Entry.fromJson(
                  snapshot.data?.docs[index].data() as Map<String, dynamic>);

              entry.id = snapshot.data?.docs[index].id;

              return Container(
                  height: 150,
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
                            Text("${entry.submittedBy}",
                                style: GoogleFonts.raleway(
                                    textStyle: const TextStyle(
                                        color: Color(0xFF432C81),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: -0.5))),
                            const SizedBox(
                              height: 4,
                            ),
                            Text("Entry id: ${entry.id}",
                                style: GoogleFonts.raleway(
                                    textStyle: const TextStyle(
                                        color: Color(0xFF432C81),
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w400))),
                            Text("Reason: ${entry.deleteReason}",
                                style: GoogleFonts.raleway(
                                    textStyle: const TextStyle(
                                        color: Color(0xFF432C81),
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w400))),
                            Wrap(
                              children: [
                                OutlinedButton(
                                    onPressed: () {
                                      context
                                          .read<EntryProvider>()
                                          .toggleIsDeleteApproved(
                                              entry.id, true);
                                      context
                                          .read<EntryProvider>()
                                          .toggleforDeleteApproval(
                                              entry.id, false);
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
                                    child: Text("Approve",
                                        style: GoogleFonts.raleway(
                                            textStyle: const TextStyle(
                                                color: Color(0xFF432C81),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400)))),
                                const SizedBox(width: 4),
                                OutlinedButton(
                                    onPressed: () {
                                      context
                                          .read<EntryProvider>()
                                          .toggleIsDeleteApproved(
                                              entry.id, false);
                                      context
                                          .read<EntryProvider>()
                                          .toggleforDeleteApproval(
                                              entry.id, false);
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
                                    child: Text("Reject",
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
            }),
          );
        });

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
        // appBar: AppBar(
        //   title: const Text("Quarantined Students"),
        // ),
        body: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              children: [
                backButton,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text("🔔  Student’s Request ",
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
                Container(
                    height: 56,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 2, horizontal: 16.0),
                    child: Card(
                        color: const Color(0xFFEDECF4),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16.0),
                            child: Text("Pending Edit Requests",
                                style: GoogleFonts.raleway(
                                    textStyle: const TextStyle(
                                        color: Color(0xFF432C81),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -0.5)))))),
                // Container(Cachild: Text("Edit Request")),
                editRequestListBuilder,
                Container(
                    height: 56,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 2, horizontal: 16.0),
                    child: Card(
                        color: const Color(0xFFEDECF4),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16.0),
                            child: Text("Pending Delete Requests",
                                style: GoogleFonts.raleway(
                                    textStyle: const TextStyle(
                                        color: Color(0xFF432C81),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -0.5)))))),
                deleteRequestListBuilder,
              ],
            )));
  }
}
