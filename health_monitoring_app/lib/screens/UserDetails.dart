import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_app/models/user_model.dart';
import 'package:project_app/providers/user_provider.dart';
import 'package:project_app/screens/login.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'QRCodeScanner.dart';

class UserDetails extends StatefulWidget {
  final UserModel? user;
  const UserDetails({super.key, required this.user});

  @override
  UserDetailsState createState() => UserDetailsState();
}

class UserDetailsState extends State<UserDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
        body: Center(
      child: Column(
        children: [
          SizedBox(height: 6),
          const SizedBox(
            height: 100,
          ),
          const CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/images/Lifesavers Avatar.png'),
          ),
          const SizedBox(
            height: 20,
          ),
          Text("${widget.user?.name}",
              style: GoogleFonts.raleway(
                  textStyle: const TextStyle(
                      color: Color(0xFF432C81),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.11))),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            widget.user?.usertype == "Student"
                ? outlineButtonBuilder("Student")
                : (widget.user?.usertype == "Admin"
                    ? outlineButtonBuilder("Admin")
                    : outlineButtonBuilder("Employee")),
            (widget.user!.isUnderMonitoring!)
                ? outlineButtonBuilder("Under Monitoring")
                : (widget.user!.isQuarantined!)
                    ? outlineButtonBuilder("Quarantined")
                    : outlineButtonBuilder("Cleared"),
          ]),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 25, right: 25),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: OutlinedButton(
                  onPressed: () {},
                  child: ListTile(
                    title: Text("Delete User",
                        style: GoogleFonts.raleway(
                            textStyle: const TextStyle(
                                color: Color(0xFF82799D),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.11))),
                    leading: Icon(Icons.delete),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  )),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 25, right: 25),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirm Action'),
                          content: Text(
                              'Are you sure you want to elevate User ${widget.user?.name} to Admin?'),
                          actions: <Widget>[
                            OutlinedButton(
                              child: Text('Confirm'),
                              onPressed: () {
                                context
                                    .read<UserProvider>()
                                    .editUserType(widget.user?.id, "Admin");
                                Navigator.of(context).pop();
                              },
                            ),
                            OutlinedButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: ListTile(
                    title: Text("Elevate to Admin",
                        style: GoogleFonts.raleway(
                            textStyle: const TextStyle(
                                color: Color(0xFF82799D),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.11))),
                    leading: Icon(Icons.logout_rounded),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  )),
            ),
          ),
        ],
      ),
    ));
  }
}
